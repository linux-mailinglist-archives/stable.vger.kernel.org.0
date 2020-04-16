Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837EC1ACC13
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895586AbgDPPyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896173AbgDPNaI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:30:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47AC520767;
        Thu, 16 Apr 2020 13:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043807;
        bh=WkXY0LvbZ6B5eSUJfLAJMi3CfuZU3QVoW7/wf+YKG74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1c2LXcp1Ng7mV9vzz3cVz8k9hkgww1cwksoqBLVpCRLS8D7SZ7qVvv/arBP5rJx6
         bRFV1UB9y45PRu34+IZxHfNNbEaEGdH0OsyLNLoswZen9vTNEro6EftQgBfZa6iYcR
         8TKAtZuY6PRdAUUyVghIVMPipPTcN7L/c/4BFm5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 4.19 107/146] rtc: omap: Use define directive for PIN_CONFIG_ACTIVE_HIGH
Date:   Thu, 16 Apr 2020 15:24:08 +0200
Message-Id: <20200416131257.326103788@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
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
@@ -561,9 +561,7 @@ static const struct pinctrl_ops rtc_pinc
 	.dt_free_map = pinconf_generic_dt_free_map,
 };
 
-enum rtc_pin_config_param {
-	PIN_CONFIG_ACTIVE_HIGH = PIN_CONFIG_END + 1,
-};
+#define PIN_CONFIG_ACTIVE_HIGH		(PIN_CONFIG_END + 1)
 
 static const struct pinconf_generic_params rtc_params[] = {
 	{"ti,active-high", PIN_CONFIG_ACTIVE_HIGH, 0},


