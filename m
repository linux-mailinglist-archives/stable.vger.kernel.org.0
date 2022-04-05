Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E5F4F2B31
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239499AbiDEJKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244208AbiDEIvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:51:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D97AD9F;
        Tue,  5 Apr 2022 01:40:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B58BE61504;
        Tue,  5 Apr 2022 08:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2610C385A3;
        Tue,  5 Apr 2022 08:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147983;
        bh=gXaSowdSzdHDz/SLK+lkSj4IXT9ETjfxO2NaDq+DOw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ulth/KkgmWAQtgbCc/yLqjDYcM/uXNybGqOAVTfU5NTWKAcDpGr6/J8UTNnkQ8ZW5
         xNIK8N3hqKiZFs+NJjdIqgesbbvCUz6j+lFjEwbJKzqw0GhEJ09S70UuDYhdon5BQl
         sRtVFZDq1KIO99P3fDpc+ThsHa+mSIjfWtz1SCrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hector Martin <marcan@marcan.st>, Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.16 0193/1017] brcmfmac: pcie: Replace brcmf_pcie_copy_mem_todev with memcpy_toio
Date:   Tue,  5 Apr 2022 09:18:26 +0200
Message-Id: <20220405070359.972866303@linuxfoundation.org>
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

From: Hector Martin <marcan@marcan.st>

commit 9466987f246758eb7e9071ae58005253f631271e upstream.

The alignment check was wrong (e.g. & 4 instead of & 3), and the logic
was also inefficient if the length was not a multiple of 4, since it
would needlessly fall back to copying the entire buffer bytewise.

We already have a perfectly good memcpy_toio function, so just call that
instead of rolling our own copy logic here. brcmf_pcie_init_ringbuffers
was already using it anyway.

Fixes: 9e37f045d5e7 ("brcmfmac: Adding PCIe bus layer support.")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220131160713.245637-6-marcan@marcan.st
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c |   48 +---------------
 1 file changed, 4 insertions(+), 44 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -12,6 +12,7 @@
 #include <linux/interrupt.h>
 #include <linux/bcma/bcma.h>
 #include <linux/sched.h>
+#include <linux/io.h>
 #include <asm/unaligned.h>
 
 #include <soc.h>
@@ -455,47 +456,6 @@ brcmf_pcie_write_ram32(struct brcmf_pcie
 
 
 static void
-brcmf_pcie_copy_mem_todev(struct brcmf_pciedev_info *devinfo, u32 mem_offset,
-			  void *srcaddr, u32 len)
-{
-	void __iomem *address = devinfo->tcm + mem_offset;
-	__le32 *src32;
-	__le16 *src16;
-	u8 *src8;
-
-	if (((ulong)address & 4) || ((ulong)srcaddr & 4) || (len & 4)) {
-		if (((ulong)address & 2) || ((ulong)srcaddr & 2) || (len & 2)) {
-			src8 = (u8 *)srcaddr;
-			while (len) {
-				iowrite8(*src8, address);
-				address++;
-				src8++;
-				len--;
-			}
-		} else {
-			len = len / 2;
-			src16 = (__le16 *)srcaddr;
-			while (len) {
-				iowrite16(le16_to_cpu(*src16), address);
-				address += 2;
-				src16++;
-				len--;
-			}
-		}
-	} else {
-		len = len / 4;
-		src32 = (__le32 *)srcaddr;
-		while (len) {
-			iowrite32(le32_to_cpu(*src32), address);
-			address += 4;
-			src32++;
-			len--;
-		}
-	}
-}
-
-
-static void
 brcmf_pcie_copy_dev_tomem(struct brcmf_pciedev_info *devinfo, u32 mem_offset,
 			  void *dstaddr, u32 len)
 {
@@ -1570,8 +1530,8 @@ static int brcmf_pcie_download_fw_nvram(
 		return err;
 
 	brcmf_dbg(PCIE, "Download FW %s\n", devinfo->fw_name);
-	brcmf_pcie_copy_mem_todev(devinfo, devinfo->ci->rambase,
-				  (void *)fw->data, fw->size);
+	memcpy_toio(devinfo->tcm + devinfo->ci->rambase,
+		    (void *)fw->data, fw->size);
 
 	resetintr = get_unaligned_le32(fw->data);
 	release_firmware(fw);
@@ -1585,7 +1545,7 @@ static int brcmf_pcie_download_fw_nvram(
 		brcmf_dbg(PCIE, "Download NVRAM %s\n", devinfo->nvram_name);
 		address = devinfo->ci->rambase + devinfo->ci->ramsize -
 			  nvram_len;
-		brcmf_pcie_copy_mem_todev(devinfo, address, nvram, nvram_len);
+		memcpy_toio(devinfo->tcm + address, nvram, nvram_len);
 		brcmf_fw_nvram_free(nvram);
 	} else {
 		brcmf_dbg(PCIE, "No matching NVRAM file found %s\n",


