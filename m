Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5129949A280
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365782AbiAXXvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1838697AbiAXWry (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:47:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8A8C058CB0;
        Mon, 24 Jan 2022 13:07:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E22F26131F;
        Mon, 24 Jan 2022 21:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF8CC340E5;
        Mon, 24 Jan 2022 21:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058420;
        bh=gpWjQ0VaBNniP4xA1fEF6HlyF6wN8PjRmBVxu/REmpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0mK114W1b0NCUzMHpDwjLB2BgwSWAP8xQvV1FtOUhmqfg7v002SUPhqTb6wNb1HSV
         qS7HQ7QSadMLYS5Gz1vTJ2MoBwP1/gkNumKF37tvEcuesGyYaKpI+WGEHsdMyfBqOk
         bgsKPDGM1mloBozLL536JLkL2nf23EfKVcKgm6Rc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Maddox <s.maddox@lantizia.me.uk>,
        Christian Lamparter <chunkeey@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0283/1039] ARM: dts: gemini: NAS4220-B: fis-index-block with 128 KiB sectors
Date:   Mon, 24 Jan 2022 19:34:32 +0100
Message-Id: <20220124184134.800970372@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

[ Upstream commit 4754eab7e5a78bdefe7a960c5c260c95ebbb5fa6 ]

Steven Maddox reported in the OpenWrt bugzilla, that his
RaidSonic IB-NAS4220-B was no longer booting with the new
OpenWrt 21.02 (uses linux 5.10's device-tree). However, it was
working with the previous OpenWrt 19.07 series (uses 4.14).

|[    5.548038] No RedBoot partition table detected in 30000000.flash
|[    5.618553] Searching for RedBoot partition table in 30000000.flash at offset 0x0
|[    5.739093] No RedBoot partition table detected in 30000000.flash
|...
|[    7.039504] Waiting for root device /dev/mtdblock3...

The provided bootlog shows that the RedBoot partition parser was
looking for the partition table "at offset 0x0". Which is strange
since the comment in the device-tree says it should be at 0xfe0000.

Further digging on the internet led to a review site that took
some useful PCB pictures of their review unit back in February 2009.
Their picture shows a Spansion S29GL128N11TFI01 flash chip.

>From Spansion's Datasheet:
"S29GL128N: One hundred twenty-eight 64 Kword (128 Kbyte) sectors"
Steven also provided a "cat /sys/class/mtd/mtd0/erasesize" from his
unit: "131072".

With the 128 KiB Sector/Erasesize in mind. This patch changes the
fis-index-block property to (0xfe0000 / 0x20000) = 0x7f.

Fixes: b5a923f8c739 ("ARM: dts: gemini: Switch to redboot partition parsing")
Reported-by: Steven Maddox <s.maddox@lantizia.me.uk>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Steven Maddox <s.maddox@lantizia.me.uk>
Link: https://lore.kernel.org/r/20211206004334.4169408-1-linus.walleij@linaro.org'
Bugzilla: https://bugs.openwrt.org/index.php?do=details&task_id=4137
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/gemini-nas4220b.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/gemini-nas4220b.dts b/arch/arm/boot/dts/gemini-nas4220b.dts
index 13112a8a5dd88..6544c730340fa 100644
--- a/arch/arm/boot/dts/gemini-nas4220b.dts
+++ b/arch/arm/boot/dts/gemini-nas4220b.dts
@@ -84,7 +84,7 @@
 			partitions {
 				compatible = "redboot-fis";
 				/* Eraseblock at 0xfe0000 */
-				fis-index-block = <0x1fc>;
+				fis-index-block = <0x7f>;
 			};
 		};
 
-- 
2.34.1



