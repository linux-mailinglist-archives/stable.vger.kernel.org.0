Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E9CFF274
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbfKPQS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:18:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728709AbfKPPqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:21 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B326B2077B;
        Sat, 16 Nov 2019 15:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919180;
        bh=QiUo4hDo6X9EO6O8FE6TbEIZnyPD3uwyPo97cTDFrBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vC6VTyyG2Qw+2GoDa17D6gdw12GtBRfinrLHL/mrxRS2RSRQjfyU3TZj+woOjnL1w
         K28K67FFx22nq+/u6xusIMzLAFdyxAFev5iYc7tIm3FKU0URfRV+1k0kGVqvfX0kRJ
         +xwa3CksimpfX0xlz0m+IlRqBFrtAiBwb1DMyagA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 189/237] soc: bcm: brcmstb: Fix re-entry point with a THUMB2_KERNEL
Date:   Sat, 16 Nov 2019 10:40:24 -0500
Message-Id: <20191116154113.7417-189-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit fb14ada11d62fb849fc357a25ef8016ba438ba10 ]

When the kernel is built with CONFIG_THUMB2_KERNEL we would set the
kernel's resume entry point to be a function that is already built as
Thumb-2 code while the boot agent doing the resume is in ARM mode, so
this does not work. There is a header label defined: cpu_resume_arm
which we can use to do the switching for us.

Fixes: 0b741b8234c8 ("soc: bcm: brcmstb: Add support for S2/S3/S5 suspend states (ARM)")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/bcm/brcmstb/pm/pm-arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/bcm/brcmstb/pm/pm-arm.c b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
index a5577dd5eb087..8ee06347447c0 100644
--- a/drivers/soc/bcm/brcmstb/pm/pm-arm.c
+++ b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
@@ -404,7 +404,7 @@ noinline int brcmstb_pm_s3_finish(void)
 {
 	struct brcmstb_s3_params *params = ctrl.s3_params;
 	dma_addr_t params_pa = ctrl.s3_params_pa;
-	phys_addr_t reentry = virt_to_phys(&cpu_resume);
+	phys_addr_t reentry = virt_to_phys(&cpu_resume_arm);
 	enum bsp_initiate_command cmd;
 	u32 flags;
 
-- 
2.20.1

