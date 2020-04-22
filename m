Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DC61B4214
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgDVK5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:57:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726858AbgDVKE5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:04:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 863562077D;
        Wed, 22 Apr 2020 10:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549897;
        bh=PkqY5os02qCbo/HNGnzajYh6FNoNP4kntucX+B0/Sm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sRaLGGyqhY99cIdvjF2TEfU2Is97iFFp+gEcCSiUiW/hyg4mvh76V2495TqDX5PJa
         h1tmXf3lgRQqygIHqs6cKPNYfbXA92t1SGPRn/eSQO1wTo6EKs2CE1bAeZR8VkqhMh
         KH6vqLpQFXD7N+acOV16CtRCnLMTs3kJtXjNaGZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 4.9 049/125] rtc: omap: Use define directive for PIN_CONFIG_ACTIVE_HIGH
Date:   Wed, 22 Apr 2020 11:56:06 +0200
Message-Id: <20200422095041.465091661@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit c50156526a2f7176b50134e3e5fb108ba09791b2 upstream.

Clang warns when one enumerated type is implicitly converted to another:

drivers/rtc/rtc-omap.c:574:21: warning: implicit conversion from
enumeration type 'enum rtc_pin_config_param' to different enumeration
type 'enum pin_config_param' [-Wenum-conversion]
        {"ti,active-high", PIN_CONFIG_ACTIVE_HIGH, 0},
        ~                  ^~~~~~~~~~~~~~~~~~~~~~
drivers/rtc/rtc-omap.c:579:12: warning: implicit conversion from
enumeration type 'enum rtc_pin_config_param' to different enumeration
type 'enum pin_config_param' [-Wenum-conversion]
        PCONFDUMP(PIN_CONFIG_ACTIVE_HIGH, "input active high", NULL, false),
        ~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./include/linux/pinctrl/pinconf-generic.h:163:11: note: expanded from
macro 'PCONFDUMP'
        .param = a, .display = b, .format = c, .has_arg = d     \
                 ^
2 warnings generated.

It is expected that pinctrl drivers can extend pin_config_param because
of the gap between PIN_CONFIG_END and PIN_CONFIG_MAX so this conversion
isn't an issue. Most drivers that take advantage of this define the
PIN_CONFIG variables as constants, rather than enumerated values. Do the
same thing here so that Clang no longer warns.

Link: https://github.com/ClangBuiltLinux/linux/issues/144
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-omap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -559,9 +559,7 @@ static const struct pinctrl_ops rtc_pinc
 	.dt_free_map = pinconf_generic_dt_free_map,
 };
 
-enum rtc_pin_config_param {
-	PIN_CONFIG_ACTIVE_HIGH = PIN_CONFIG_END + 1,
-};
+#define PIN_CONFIG_ACTIVE_HIGH		(PIN_CONFIG_END + 1)
 
 static const struct pinconf_generic_params rtc_params[] = {
 	{"ti,active-high", PIN_CONFIG_ACTIVE_HIGH, 0},


