Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E38629BF67
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793770AbgJ0PIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:08:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793478AbgJ0PG0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:06:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74E7821D24;
        Tue, 27 Oct 2020 15:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811186;
        bh=kT2JPWJy0qrtJaLctf2sL37HNXT0xaHssLvW4BoHukY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gm++f6k4faNecSgpvYPaKSYVkRE7M0zP2CfMKUwVIKks7VLiQtgNnff9YVM/HL4wS
         svHY1wdmaQJuPbEc9CTgj1x7b/dLlqmNTDX9Ixzab7VNkdDKsEQd9LLsy7Kn0rq4oA
         QCBcXCcJscU7cDVfnRHjHcd6Rou/5kMoRzCn9o+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vaibhav Jain <vaibhav@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 403/633] powerpc/papr_scm: Add PAPR command family to pass-through command-set
Date:   Tue, 27 Oct 2020 14:52:26 +0100
Message-Id: <20201027135541.622795686@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vaibhav Jain <vaibhav@linux.ibm.com>

[ Upstream commit 13135b461cf205941308984bd3271ec7d403dc40 ]

Add NVDIMM_FAMILY_PAPR to the list of valid 'dimm_family_mask'
acceptable by papr_scm. This is needed as since commit
92fe2aa859f5 ("libnvdimm: Validate command family indices") libnvdimm
performs a validation of 'nd_cmd_pkg.nd_family' received as part of
ND_CMD_CALL processing to ensure only known command families can use
the general ND_CMD_CALL pass-through functionality.

Without this change the ND_CMD_CALL pass-through targeting
NVDIMM_FAMILY_PAPR error out with -EINVAL.

Fixes: 92fe2aa859f5 ("libnvdimm: Validate command family indices")
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200913211904.24472-1-vaibhav@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/papr_scm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index 9c569078a09fd..6c2c66450dac8 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -702,6 +702,9 @@ static int papr_scm_nvdimm_init(struct papr_scm_priv *p)
 	p->bus_desc.of_node = p->pdev->dev.of_node;
 	p->bus_desc.provider_name = kstrdup(p->pdev->name, GFP_KERNEL);
 
+	/* Set the dimm command family mask to accept PDSMs */
+	set_bit(NVDIMM_FAMILY_PAPR, &p->bus_desc.dimm_family_mask);
+
 	if (!p->bus_desc.provider_name)
 		return -ENOMEM;
 
-- 
2.25.1



