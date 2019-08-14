Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFFE8D914
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729449AbfHNRF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729443AbfHNRF2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:05:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C8212173B;
        Wed, 14 Aug 2019 17:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802327;
        bh=hmSajdmKr2B6HT2ANTVnU2oQwelq7dK2who+JUuB7mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joQy/Pe/M0PWQ4qu0AfztENq7UsktiMG1RZeKcJO/5lAogDxBVjTevHzf4TWNxvG9
         sooKaZSVj1QkHiHKOEvJwKzCYHmAWSpoR9u63tVlW6HYkGquNfVuxT0SP7dphngvZQ
         5umjNNSh81Y7m/ExQwg0xH4jnhQ7EcE/NXeu3aZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Oliver OHalloran" <oohall@gmail.com>,
        Vaibhav Jain <vaibhav@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 082/144] powerpc/papr_scm: Force a scm-unbind if initial scm-bind fails
Date:   Wed, 14 Aug 2019 19:00:38 +0200
Message-Id: <20190814165803.298596347@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3a855b7ac7d5021674aa3e1cc9d3bfd6b604e9c0 ]

In some cases initial bind of scm memory for an lpar can fail if
previously it wasn't released using a scm-unbind hcall. This situation
can arise due to panic of the previous kernel or forced lpar
fadump. In such cases the H_SCM_BIND_MEM return a H_OVERLAP error.

To mitigate such cases the patch updates papr_scm_probe() to force a
call to drc_pmem_unbind() in case the initial bind of scm memory fails
with EBUSY error. In case scm-bind operation again fails after the
forced scm-unbind then we follow the existing error path. We also
update drc_pmem_bind() to handle the H_OVERLAP error returned by phyp
and indicate it as a EBUSY error back to the caller.

Suggested-by: "Oliver O'Halloran" <oohall@gmail.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Reviewed-by: Oliver O'Halloran <oohall@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190629160610.23402-4-vaibhav@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/papr_scm.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index 96c53b23e58f9..dad9825e40874 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -42,8 +42,9 @@ struct papr_scm_priv {
 static int drc_pmem_bind(struct papr_scm_priv *p)
 {
 	unsigned long ret[PLPAR_HCALL_BUFSIZE];
-	uint64_t rc, token;
 	uint64_t saved = 0;
+	uint64_t token;
+	int64_t rc;
 
 	/*
 	 * When the hypervisor cannot map all the requested memory in a single
@@ -63,6 +64,10 @@ static int drc_pmem_bind(struct papr_scm_priv *p)
 	} while (rc == H_BUSY);
 
 	if (rc) {
+		/* H_OVERLAP needs a separate error path */
+		if (rc == H_OVERLAP)
+			return -EBUSY;
+
 		dev_err(&p->pdev->dev, "bind err: %lld\n", rc);
 		return -ENXIO;
 	}
@@ -316,6 +321,14 @@ static int papr_scm_probe(struct platform_device *pdev)
 
 	/* request the hypervisor to bind this region to somewhere in memory */
 	rc = drc_pmem_bind(p);
+
+	/* If phyp says drc memory still bound then force unbound and retry */
+	if (rc == -EBUSY) {
+		dev_warn(&pdev->dev, "Retrying bind after unbinding\n");
+		drc_pmem_unbind(p);
+		rc = drc_pmem_bind(p);
+	}
+
 	if (rc)
 		goto err;
 
-- 
2.20.1



