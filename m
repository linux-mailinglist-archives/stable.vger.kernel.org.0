Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826FD4091C8
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244697AbhIMOFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244564AbhIMOCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:02:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8873361A40;
        Mon, 13 Sep 2021 13:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540311;
        bh=2OmvbGZlMhrYilSe7ReisZbrELo8gC59SS7fcTYuZ0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YGYyBUPiV7VdSdFLRtAdEtE+T237PxIrvykih4Zv6DoPsNmuuppg/4AW7n4mHqR8r
         lHI4q3m40PpEK9GNAMvlYkY9RyG11KyNh1UzIwe0QbqLXsTU2O4Z0aTicJpVBxfvEK
         0yKBxI2j0aAIyIZh2wVII91RX1rsThy14reqNxz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amireddy Mallikarjuna reddy 
        <mallikarjunax.reddy@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 141/300] leds: lgm-sso: Dont spam logs when probe is deferred
Date:   Mon, 13 Sep 2021 15:13:22 +0200
Message-Id: <20210913131114.164328225@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit 1ed4d05e0a0b23ba15e0affcff4008dd537ae3ee ]

When requesting GPIO line the probe can be deferred.
In such case don't spam logs with an error message.
This can be achieved by switching to dev_err_probe().

Fixes: c3987cd2bca3 ("leds: lgm: Add LED controller driver for LGM SoC")
Cc: Amireddy Mallikarjuna reddy <mallikarjunax.reddy@linux.intel.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/blink/leds-lgm-sso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/blink/leds-lgm-sso.c b/drivers/leds/blink/leds-lgm-sso.c
index 2dd285052c6a..6c0ffcaa6b5c 100644
--- a/drivers/leds/blink/leds-lgm-sso.c
+++ b/drivers/leds/blink/leds-lgm-sso.c
@@ -643,7 +643,7 @@ __sso_led_dt_parse(struct sso_led_priv *priv, struct fwnode_handle *fw_ssoled)
 							      fwnode_child,
 							      GPIOD_ASIS, NULL);
 		if (IS_ERR(led->gpiod)) {
-			dev_err(dev, "led: get gpio fail!\n");
+			dev_err_probe(dev, PTR_ERR(led->gpiod), "led: get gpio fail!\n");
 			goto __dt_err;
 		}
 
-- 
2.30.2



