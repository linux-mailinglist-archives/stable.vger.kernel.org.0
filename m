Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE024F2D80
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350514AbiDEJ6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344026AbiDEJQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:16:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5B71EED8;
        Tue,  5 Apr 2022 02:03:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0FEE61003;
        Tue,  5 Apr 2022 09:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF58BC385A1;
        Tue,  5 Apr 2022 09:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149423;
        bh=/vXsamBdSnO41BjFWNF63X0LjmmtbeaDPUrPjiNI93w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtYM2HmN25vmPdUgzWHPKq0m5bbYLsycqePUX8O4uKXiVPq6BPlYarFMSxirWb3/Y
         R1yr2gBhmE5y6O53O+nSTXUCMEiCuH6TiXjtc44S6XxurzoJNIqKvnLGTgNP6IIpwA
         jcAUZzrBwRP7t1H8gEN87ACK5ukvDIfsIukzGeEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        Fei Li <fei1.li@intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0708/1017] virt: acrn: fix a memory leak in acrn_dev_ioctl()
Date:   Tue,  5 Apr 2022 09:27:01 +0200
Message-Id: <20220405070415.286563038@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaolong Huang <butterflyhuangxx@gmail.com>

[ Upstream commit ecd1735f14d6ac868ae5d8b7a2bf193fa11f388b ]

The vm_param and cpu_regs need to be freed via kfree()
before return -EINVAL error.

Fixes: 9c5137aedd11 ("virt: acrn: Introduce VM management interfaces")
Fixes: 2ad2aaee1bc9 ("virt: acrn: Introduce an ioctl to set vCPU registers state")
Signed-off-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
Signed-off-by: Fei Li <fei1.li@intel.com>
Link: https://lore.kernel.org/r/20220308092047.1008409-1-butterflyhuangxx@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virt/acrn/hsm.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/virt/acrn/hsm.c b/drivers/virt/acrn/hsm.c
index 5419794fccf1..423ea888d79a 100644
--- a/drivers/virt/acrn/hsm.c
+++ b/drivers/virt/acrn/hsm.c
@@ -136,8 +136,10 @@ static long acrn_dev_ioctl(struct file *filp, unsigned int cmd,
 		if (IS_ERR(vm_param))
 			return PTR_ERR(vm_param);
 
-		if ((vm_param->reserved0 | vm_param->reserved1) != 0)
+		if ((vm_param->reserved0 | vm_param->reserved1) != 0) {
+			kfree(vm_param);
 			return -EINVAL;
+		}
 
 		vm = acrn_vm_create(vm, vm_param);
 		if (!vm) {
@@ -182,21 +184,29 @@ static long acrn_dev_ioctl(struct file *filp, unsigned int cmd,
 			return PTR_ERR(cpu_regs);
 
 		for (i = 0; i < ARRAY_SIZE(cpu_regs->reserved); i++)
-			if (cpu_regs->reserved[i])
+			if (cpu_regs->reserved[i]) {
+				kfree(cpu_regs);
 				return -EINVAL;
+			}
 
 		for (i = 0; i < ARRAY_SIZE(cpu_regs->vcpu_regs.reserved_32); i++)
-			if (cpu_regs->vcpu_regs.reserved_32[i])
+			if (cpu_regs->vcpu_regs.reserved_32[i]) {
+				kfree(cpu_regs);
 				return -EINVAL;
+			}
 
 		for (i = 0; i < ARRAY_SIZE(cpu_regs->vcpu_regs.reserved_64); i++)
-			if (cpu_regs->vcpu_regs.reserved_64[i])
+			if (cpu_regs->vcpu_regs.reserved_64[i]) {
+				kfree(cpu_regs);
 				return -EINVAL;
+			}
 
 		for (i = 0; i < ARRAY_SIZE(cpu_regs->vcpu_regs.gdt.reserved); i++)
 			if (cpu_regs->vcpu_regs.gdt.reserved[i] |
-			    cpu_regs->vcpu_regs.idt.reserved[i])
+			    cpu_regs->vcpu_regs.idt.reserved[i]) {
+				kfree(cpu_regs);
 				return -EINVAL;
+			}
 
 		ret = hcall_set_vcpu_regs(vm->vmid, virt_to_phys(cpu_regs));
 		if (ret < 0)
-- 
2.34.1



