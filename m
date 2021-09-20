Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36AA41213C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357169AbhITSDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:03:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356705AbhITSBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:01:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF0536322E;
        Mon, 20 Sep 2021 17:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158165;
        bh=GU2Z7/AwJSTTaqUDY2O7hlm3FYTmsB1TFalm7Ie9rF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+g2Iti7LS0SevDU8pGW7iBNqji/94u7crHO1KERoQ39KR4yYgeaqKuTZG6JNKpLk
         0r5vhSbJFMtGbZaSr7bzxmd/roKivSqgDVNCPHn5ewkmKCAvYvJ4ZPQ914aW0KSziL
         EHB6dSFbh0/KlQYG3lIsCh1HnJOSXgpQ0f5aBWEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20 ?= 
        <zhouyanjie@wanyeetech.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 013/260] pinctrl: ingenic: Fix incorrect pull up/down info
Date:   Mon, 20 Sep 2021 18:40:31 +0200
Message-Id: <20210920163931.572972960@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit d5e931403942b3af39212960c2592b5ba741b2bf upstream.

Fix the pull up/down info for both the JZ4760 and JZ4770 SoCs, as the
previous values sometimes contradicted what's written in the programming
manual.

Fixes: b5c23aa46537 ("pinctrl: add a pinctrl driver for the Ingenic jz47xx SoCs")
Cc: <stable@vger.kernel.org> # v4.12
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Tested-by: 周琰杰 (Zhou Yanjie)<zhouyanjie@wanyeetech.com>
Link: https://lore.kernel.org/r/20210717174836.14776-1-paul@crapouillou.net
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-ingenic.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -348,7 +348,7 @@ static const struct ingenic_chip_info jz
 };
 
 static const u32 jz4760_pull_ups[6] = {
-	0xffffffff, 0xfffcf3ff, 0xffffffff, 0xffffcfff, 0xfffffb7c, 0xfffff00f,
+	0xffffffff, 0xfffcf3ff, 0xffffffff, 0xffffcfff, 0xfffffb7c, 0x0000000f,
 };
 
 static const u32 jz4760_pull_downs[6] = {
@@ -611,11 +611,11 @@ static const struct ingenic_chip_info jz
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


