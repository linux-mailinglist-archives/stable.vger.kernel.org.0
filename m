Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FA640C575
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 14:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237489AbhIOMnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 08:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237485AbhIOMnl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 08:43:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6977261101;
        Wed, 15 Sep 2021 12:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631709743;
        bh=odTKiLmAlay1/S4qvTRCdyPc4HEMBg14RhGw2ni2wog=;
        h=Subject:To:Cc:From:Date:From;
        b=zxdz+i1nHHKf3Caio564HO2/bw4sqBd4SCkC2/07YUAVmiU7Of/DIhHSAY67APLsu
         3zDAP0QGF56cO78U6jUV9qWKShLkV+kkrPiah/90xP71zBCg4bCdUW4QWprqOxlM86
         ZQ6fU9oTEuP/85BMo+Hs/sT7y1hFUBXYimBel95M=
Subject: FAILED: patch "[PATCH] pinctrl: ingenic: Fix incorrect pull up/down info" failed to apply to 4.19-stable tree
To:     paul@crapouillou.net, linus.walleij@linaro.org,
        stable@vger.kernel.org, zhouyanjie@wanyeetech.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Sep 2021 14:42:12 +0200
Message-ID: <163170973224419@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d5e931403942b3af39212960c2592b5ba741b2bf Mon Sep 17 00:00:00 2001
From: Paul Cercueil <paul@crapouillou.net>
Date: Sat, 17 Jul 2021 18:48:34 +0100
Subject: [PATCH] pinctrl: ingenic: Fix incorrect pull up/down info
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fix the pull up/down info for both the JZ4760 and JZ4770 SoCs, as the
previous values sometimes contradicted what's written in the programming
manual.

Fixes: b5c23aa46537 ("pinctrl: add a pinctrl driver for the Ingenic jz47xx SoCs")
Cc: <stable@vger.kernel.org> # v4.12
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Tested-by: 周琰杰 (Zhou Yanjie)<zhouyanjie@wanyeetech.com>
Link: https://lore.kernel.org/r/20210717174836.14776-1-paul@crapouillou.net
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index cd296d98548d..5a602e6479b9 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -744,7 +744,7 @@ static const struct ingenic_chip_info jz4755_chip_info = {
 };
 
 static const u32 jz4760_pull_ups[6] = {
-	0xffffffff, 0xfffcf3ff, 0xffffffff, 0xffffcfff, 0xfffffb7c, 0xfffff00f,
+	0xffffffff, 0xfffcf3ff, 0xffffffff, 0xffffcfff, 0xfffffb7c, 0x0000000f,
 };
 
 static const u32 jz4760_pull_downs[6] = {
@@ -1092,11 +1092,11 @@ static const struct ingenic_chip_info jz4760_chip_info = {
 };
 
 static const u32 jz4770_pull_ups[6] = {
-	0x3fffffff, 0xfff0030c, 0xffffffff, 0xffff4fff, 0xfffffb7c, 0xffa7f00f,
+	0x3fffffff, 0xfff0f3fc, 0xffffffff, 0xffff4fff, 0xfffffb7c, 0x0024f00f,
 };
 
 static const u32 jz4770_pull_downs[6] = {
-	0x00000000, 0x000f0c03, 0x00000000, 0x0000b000, 0x00000483, 0x00580ff0,
+	0x00000000, 0x000f0c03, 0x00000000, 0x0000b000, 0x00000483, 0x005b0ff0,
 };
 
 static int jz4770_uart0_data_pins[] = { 0xa0, 0xa3, };

