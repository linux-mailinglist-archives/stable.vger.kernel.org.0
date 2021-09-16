Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9E640E17E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242263AbhIPQaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241654AbhIPQ21 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:28:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AFA861351;
        Thu, 16 Sep 2021 16:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809085;
        bh=pTIOSYSSrv+8dmgfomR8eI6/xfAstEHMdPBwJYumySc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qsh2ygwP687QYzUd1p6P2h1OW8n/MwbC0fpf4aFFZ3aDnBbq8OqDpIYpN46EasEQ7
         Cf0NWCNhuYhqi11kwMGn67go4cb39hLx5M6CA6GZGOim8Ba8AFWuBtEB9F3GRb4Oar
         +4tnll2za0olxrBn/49cgbJ2HybLiraYSEKQn14M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20 ?= 
        <zhouyanjie@wanyeetech.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.13 025/380] pinctrl: ingenic: Fix bias config for X2000(E)
Date:   Thu, 16 Sep 2021 17:56:22 +0200
Message-Id: <20210916155804.826272348@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 7261851e938f4b0fe8c0f5a8e627ae90e1ba9875 upstream.

The ingenic_set_bias() function's "bias" argument is not a
"enum pin_config_param", so its value should not be compared against
values of that enum.

This should fix the bias config not working on the X2000(E) SoCs.

Fixes: 943e0da15370 ("pinctrl: Ingenic: Add pinctrl driver for X2000.")
Cc: <stable@vger.kernel.org> # v5.12
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Tested-by: 周琰杰 (Zhou Yanjie)<zhouyanjie@wanyeetech.com>
Link: https://lore.kernel.org/r/20210717174836.14776-2-paul@crapouillou.net
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-ingenic.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -3441,17 +3441,17 @@ static void ingenic_set_bias(struct inge
 {
 	if (jzpc->info->version >= ID_X2000) {
 		switch (bias) {
-		case PIN_CONFIG_BIAS_PULL_UP:
+		case GPIO_PULL_UP:
 			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPD, false);
 			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPU, true);
 			break;
 
-		case PIN_CONFIG_BIAS_PULL_DOWN:
+		case GPIO_PULL_DOWN:
 			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPU, false);
 			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPD, true);
 			break;
 
-		case PIN_CONFIG_BIAS_DISABLE:
+		case GPIO_PULL_DIS:
 		default:
 			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPU, false);
 			ingenic_config_pin(jzpc, pin, X2000_GPIO_PEPD, false);


