Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A013664A4A
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbjAJSb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239316AbjAJSbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:31:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C492850E57
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:26:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B3732CE18E6
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2817C433EF;
        Tue, 10 Jan 2023 18:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375170;
        bh=CRY/T8PsxHx6HYu6Q95DGO5VlQ3cyv5vVESvY3rFo/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQS2Jy3R5cDoi6myCPi7cvLKjZ8jVllqQHohibEkvXzxDae/u5sbgHqbnZQU9XHSS
         EZTubUTsf4PZlG5H8LlpbM8eHsZ1C2NT9n6iLkmNoVeoild2WqV2DSjkvicq34kD2p
         VcCw9B5vei5bSrSN/7YsVAM9SgF9u3p75u9Xtv/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Linus Walleij <linus.walleij@linaro.org>,
        kernel test robot <lkp@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 070/290] ARM: ux500: do not directly dereference __iomem
Date:   Tue, 10 Jan 2023 19:02:42 +0100
Message-Id: <20230110180034.056330657@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 65b0e307a1a9193571db12910f382f84195a3d29 upstream.

Sparse reports that calling add_device_randomness() on `uid` is a
violation of address spaces. And indeed the next usage uses readl()
properly, but that was left out when passing it toadd_device_
randomness(). So instead copy the whole thing to the stack first.

Fixes: 4040d10a3d44 ("ARM: ux500: add DB serial number to entropy pool")
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/202210230819.loF90KDh-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://lore.kernel.org/r/20221108123755.207438-1-Jason@zx2c4.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/ux500/ux500-soc-id.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/soc/ux500/ux500-soc-id.c
+++ b/drivers/soc/ux500/ux500-soc-id.c
@@ -167,20 +167,18 @@ ATTRIBUTE_GROUPS(ux500_soc);
 static const char *db8500_read_soc_id(struct device_node *backupram)
 {
 	void __iomem *base;
-	void __iomem *uid;
 	const char *retstr;
+	u32 uid[5];
 
 	base = of_iomap(backupram, 0);
 	if (!base)
 		return NULL;
-	uid = base + 0x1fc0;
+	memcpy_fromio(uid, base + 0x1fc0, sizeof(uid));
 
 	/* Throw these device-specific numbers into the entropy pool */
-	add_device_randomness(uid, 0x14);
+	add_device_randomness(uid, sizeof(uid));
 	retstr = kasprintf(GFP_KERNEL, "%08x%08x%08x%08x%08x",
-			 readl((u32 *)uid+0),
-			 readl((u32 *)uid+1), readl((u32 *)uid+2),
-			 readl((u32 *)uid+3), readl((u32 *)uid+4));
+			   uid[0], uid[1], uid[2], uid[3], uid[4]);
 	iounmap(base);
 	return retstr;
 }


