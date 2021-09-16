Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7754C40E519
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349905AbhIPRH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:07:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349471AbhIPRFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:05:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 515E461B30;
        Thu, 16 Sep 2021 16:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810137;
        bh=z9UWIe0h1arWcJQZ3XEB/LMGrmp16FhSrvp1PuCqdhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdidYByPGTw0caWkTileMCzluYWECV/+8gInEhpd92j0eodOjoH8VfjOT4QhDcqzg
         STn2Ssvw8yODV9uLwCgQl1yCMlL75x/j8HEzJ+271LIUOijSWAt7MoJUekBWxO3YNJ
         EPwo5HytuGD9XuCDplM42wDh21E7U971bR+D8uGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20 ?= 
        <zhouyanjie@wanyeetech.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.14 031/432] pinctrl: ingenic: Fix incorrect pull up/down info
Date:   Thu, 16 Sep 2021 17:56:20 +0200
Message-Id: <20210916155811.874190087@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
@@ -710,7 +710,7 @@ static const struct ingenic_chip_info jz
 };
 
 static const u32 jz4760_pull_ups[6] = {
-	0xffffffff, 0xfffcf3ff, 0xffffffff, 0xffffcfff, 0xfffffb7c, 0xfffff00f,
+	0xffffffff, 0xfffcf3ff, 0xffffffff, 0xffffcfff, 0xfffffb7c, 0x0000000f,
 };
 
 static const u32 jz4760_pull_downs[6] = {
@@ -936,11 +936,11 @@ static const struct ingenic_chip_info jz
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


