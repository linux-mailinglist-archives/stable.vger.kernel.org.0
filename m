Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C10A5487D8
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383616AbiFMO0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383962AbiFMOYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:24:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC5747561;
        Mon, 13 Jun 2022 04:46:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF7A6B80D31;
        Mon, 13 Jun 2022 11:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55032C34114;
        Mon, 13 Jun 2022 11:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120763;
        bh=yDpd7oAWsynJGccSydOf6o7OH6T+QbeLge5NLgiCdfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+6/2Bp5Q4B0S4ChP9KokWakg/BN5iuJqcL6Zj6xtLgNfPX4mbUYjp6QgkHTFqbqr
         ldRzdM57mCkhL2b/qd8Y8ncll8OcZHLV0+cLJyUINzycyakS0C2ei6CL48rljNFxDI
         HwVI75x7O0KRxh1TS1uTMHWb/T6ot43zLBydT5Sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Saurabh Sengar <ssengar@linux.microsoft.com>,
        Dexuan Cui <decui@microsoft.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 149/298] video: fbdev: hyperv_fb: Allow resolutions with size > 64 MB for Gen1
Date:   Mon, 13 Jun 2022 12:10:43 +0200
Message-Id: <20220613094929.456327775@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saurabh Sengar <ssengar@linux.microsoft.com>

[ Upstream commit c4b4d7047f16a8d138ce76da65faefb7165736f2 ]

This patch fixes a bug where GEN1 VMs doesn't allow resolutions greater
than 64 MB size (eg 7680x4320). Unnecessary PCI check limits Gen1 VRAM
to legacy PCI BAR size only (ie 64MB). Thus any, resolution requesting
greater then 64MB (eg 7680x4320) would fail. MMIO region assigning this
memory shouldn't be limited by PCI bar size.

Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/hyperv_fb.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index c8e0ea27caf1..58c304a3b7c4 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -1009,7 +1009,6 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 	struct pci_dev *pdev  = NULL;
 	void __iomem *fb_virt;
 	int gen2vm = efi_enabled(EFI_BOOT);
-	resource_size_t pot_start, pot_end;
 	phys_addr_t paddr;
 	int ret;
 
@@ -1060,23 +1059,7 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 	dio_fb_size =
 		screen_width * screen_height * screen_depth / 8;
 
-	if (gen2vm) {
-		pot_start = 0;
-		pot_end = -1;
-	} else {
-		if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM) ||
-		    pci_resource_len(pdev, 0) < screen_fb_size) {
-			pr_err("Resource not available or (0x%lx < 0x%lx)\n",
-			       (unsigned long) pci_resource_len(pdev, 0),
-			       (unsigned long) screen_fb_size);
-			goto err1;
-		}
-
-		pot_end = pci_resource_end(pdev, 0);
-		pot_start = pot_end - screen_fb_size + 1;
-	}
-
-	ret = vmbus_allocate_mmio(&par->mem, hdev, pot_start, pot_end,
+	ret = vmbus_allocate_mmio(&par->mem, hdev, 0, -1,
 				  screen_fb_size, 0x100000, true);
 	if (ret != 0) {
 		pr_err("Unable to allocate framebuffer memory\n");
-- 
2.35.1



