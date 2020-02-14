Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C162B15EE8A
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbgBNRlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:41:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389740AbgBNQDq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:03:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19F8F24680;
        Fri, 14 Feb 2020 16:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696225;
        bh=a0X2ipw2Qqu/ELDpCnV/gIW9G1Svhjbq8TCP+jArWgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2jFasTf1e2yhO7O/P8sTi20E4RJv1/JcSxeDb5SH2Z+HeUdLVDibVxm3HdyJfHUT
         BjV4q7Qn81d+SaEZXjc2Q9WH1aAYqLS43ToekzFyoXquFDDoyWsmtrxPaETyuozFHH
         qHK7Akt9Yq8cjW8zjQvOAxXrXObuxPMZ8p6/tCag=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vaibhav Jain <vaibhav@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 088/459] powerpc/papr_scm: Fix leaking 'bus_desc.provider_name' in some paths
Date:   Fri, 14 Feb 2020 10:55:38 -0500
Message-Id: <20200214160149.11681-88-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vaibhav Jain <vaibhav@linux.ibm.com>

[ Upstream commit 5649607a8d0b0e019a4db14aab3de1e16c3a2b4f ]

String 'bus_desc.provider_name' allocated inside
papr_scm_nvdimm_init() will leaks in case call to
nvdimm_bus_register() fails or when papr_scm_remove() is called.

This minor patch ensures that 'bus_desc.provider_name' is freed in
error path for nvdimm_bus_register() as well as in papr_scm_remove().

Fixes: b5beae5e224f ("powerpc/pseries: Add driver for PAPR SCM regions")
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200122155140.120429-1-vaibhav@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/papr_scm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index ee07d0718bf1a..66fd517c48164 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -342,6 +342,7 @@ static int papr_scm_nvdimm_init(struct papr_scm_priv *p)
 	p->bus = nvdimm_bus_register(NULL, &p->bus_desc);
 	if (!p->bus) {
 		dev_err(dev, "Error creating nvdimm bus %pOF\n", p->dn);
+		kfree(p->bus_desc.provider_name);
 		return -ENXIO;
 	}
 
@@ -498,6 +499,7 @@ static int papr_scm_remove(struct platform_device *pdev)
 
 	nvdimm_bus_unregister(p->bus);
 	drc_pmem_unbind(p);
+	kfree(p->bus_desc.provider_name);
 	kfree(p);
 
 	return 0;
-- 
2.20.1

