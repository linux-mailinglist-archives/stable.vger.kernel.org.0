Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 668BE10BCCF
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbfK0VYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:24:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732066AbfK0VDm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:03:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B12A21771;
        Wed, 27 Nov 2019 21:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888621;
        bh=QiUo4hDo6X9EO6O8FE6TbEIZnyPD3uwyPo97cTDFrBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0J5jtBVVd8EMz4EvcZMxYuL83WaNn1iScTXloH3q+yt1nOeDNogBQxlXOtHcgAIy
         +7gl83itFHBwNmk332PePYiAgCnJldgdLXHIvyteN8LpNrEpZiRi/0X0pAKKEQiyG0
         1za9Me2iisDXT2Z7NrWjBKla6I9kz0Xu1oWXiFVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 206/306] soc: bcm: brcmstb: Fix re-entry point with a THUMB2_KERNEL
Date:   Wed, 27 Nov 2019 21:30:56 +0100
Message-Id: <20191127203130.187488359@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



