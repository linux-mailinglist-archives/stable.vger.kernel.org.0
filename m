Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE25224492
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 21:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgGQTtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 15:49:35 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42782 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728022AbgGQTte (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 15:49:34 -0400
Date:   Fri, 17 Jul 2020 19:49:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595015372;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ArSLmInG26ymDEujZq9Witdg6jO9R+3pS4sirlxlKjk=;
        b=jBrFuyLN4VhUIxGQnuzCaCkDqiQiKB2ZE/hahXzK6CxelNm3ftcgeOMAFkhqcu204909Nk
        ZsBrzR+tqLsbVIT8gzdHERo+TaEMXGfqtwsAPbAPN2noEU5ag25XpJ5tlMz3W0XzjPS0Km
        9KXGPOmgjYaQlv2j4YkNDTmFgFy7YM+DDRYajv9EiflP+hOSyJiqCDjOGxcnHJF0uMK/Nx
        h3wBYVQgGT+MyzZw9VBCiZt6o0/kj+rHjKCQPovipyVxwj4N3I3VKj7s11xWGQW0k4AaTU
        igQ0xgjVyiUnXP8KONK0MZJLda8U+EDWpc67RfO/VSHvtuqkBj5JRS/rT2vX+A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595015372;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ArSLmInG26ymDEujZq9Witdg6jO9R+3pS4sirlxlKjk=;
        b=LeunsxNdNep+yWBKbEGuxsc4IcbpBh03R02dJoWQzKvnMnMd7CXZk9WvUVnzLZWuAELASa
        C8leRBk46OpUSvBQ==
From:   "tip-bot2 for Frederic Weisbecker" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] timer: Fix wheel index calculation on last level
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200717140551.29076-2-frederic@kernel.org>
References: <20200717140551.29076-2-frederic@kernel.org>
MIME-Version: 1.0
Message-ID: <159501537091.4006.13327108405728570679.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     e2a71bdea81690b6ef11f4368261ec6f5b6891aa
Gitweb:        https://git.kernel.org/tip/e2a71bdea81690b6ef11f4368261ec6f5b6891aa
Author:        Frederic Weisbecker <frederic@kernel.org>
AuthorDate:    Fri, 17 Jul 2020 16:05:40 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Fri, 17 Jul 2020 21:44:05 +02:00

timer: Fix wheel index calculation on last level

When an expiration delta falls into the last level of the wheel, that delta
has be compared against the maximum possible delay and reduced to fit in if
necessary.

However instead of comparing the delta against the maximum, the code
compares the actual expiry against the maximum. Then instead of fixing the
delta to fit in, it sets the maximum delta as the expiry value.

This can result in various undesired outcomes, the worst possible one
being a timer expiring 15 days ahead to fire immediately.

Fixes: 500462a9de65 ("timers: Switch to a non-cascading wheel")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200717140551.29076-2-frederic@kernel.org

---
 kernel/time/timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 9a838d3..df1ff80 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -521,8 +521,8 @@ static int calc_wheel_index(unsigned long expires, unsigned long clk)
 		 * Force expire obscene large timeouts to expire at the
 		 * capacity limit of the wheel.
 		 */
-		if (expires >= WHEEL_TIMEOUT_CUTOFF)
-			expires = WHEEL_TIMEOUT_MAX;
+		if (delta >= WHEEL_TIMEOUT_CUTOFF)
+			expires = clk + WHEEL_TIMEOUT_MAX;
 
 		idx = calc_index(expires, LVL_DEPTH - 1);
 	}
