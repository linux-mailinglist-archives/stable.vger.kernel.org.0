Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 340DD167635
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732152AbgBUIKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:10:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732453AbgBUIKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:10:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9D5B2467A;
        Fri, 21 Feb 2020 08:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272606;
        bh=zAa2uEgQbd2JoS7G+0gTzPTd/qwhQJyo3d9rW0gWzZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wD2gk7MZ0czIIWe4Gt4Brt5+8BCFNRGvufSKY8srUv3Y7GRwm4pxskOoPcM8losn3
         185xnGNDAPmYjPGoZIQxhag7VJi4TJEIJ/l+xw0o404vMB6vH9mm7GkrcGknEFMMTo
         4cK0YCNM7jdLlQEzvl4dN9/VPoQZMUBXHP853QyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sekhar Nori <nsekhar@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 206/344] clocksource: davinci: only enable clockevents once tim34 is initialized
Date:   Fri, 21 Feb 2020 08:40:05 +0100
Message-Id: <20200221072407.818746259@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

[ Upstream commit cea931c25104e6bddc42eb067f58193f355dbdd7 ]

The DM365 platform has a strange quirk (only present when using ancient
u-boot - mainline u-boot v2013.01 and later works fine) where if we
enable the second half of the timer in periodic mode before we do its
initialization - the time won't start flowing and we can't boot.

When using more recent u-boot, we can enable the timer, then reinitialize
it and all works fine.

To work around this issue only enable clockevents once tim34 is
initialized i.e. move clockevents_config_and_register() below tim34
initialization.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-davinci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/timer-davinci.c b/drivers/clocksource/timer-davinci.c
index 62745c9620498..e421946a91c5a 100644
--- a/drivers/clocksource/timer-davinci.c
+++ b/drivers/clocksource/timer-davinci.c
@@ -302,10 +302,6 @@ int __init davinci_timer_register(struct clk *clk,
 		return rv;
 	}
 
-	clockevents_config_and_register(&clockevent->dev, tick_rate,
-					DAVINCI_TIMER_MIN_DELTA,
-					DAVINCI_TIMER_MAX_DELTA);
-
 	davinci_clocksource.dev.rating = 300;
 	davinci_clocksource.dev.read = davinci_clocksource_read;
 	davinci_clocksource.dev.mask =
@@ -323,6 +319,10 @@ int __init davinci_timer_register(struct clk *clk,
 		davinci_clocksource_init_tim34(base);
 	}
 
+	clockevents_config_and_register(&clockevent->dev, tick_rate,
+					DAVINCI_TIMER_MIN_DELTA,
+					DAVINCI_TIMER_MAX_DELTA);
+
 	rv = clocksource_register_hz(&davinci_clocksource.dev, tick_rate);
 	if (rv) {
 		pr_err("Unable to register clocksource");
-- 
2.20.1



