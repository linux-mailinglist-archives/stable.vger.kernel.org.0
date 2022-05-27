Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B0E5360F1
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352023AbiE0L6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353396AbiE0L41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:56:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2907325F0;
        Fri, 27 May 2022 04:51:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D31EC61DD0;
        Fri, 27 May 2022 11:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC964C34100;
        Fri, 27 May 2022 11:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652303;
        bh=Trgz+USAQPCv1R/UHnPbOXYDe7Kd+M22X+yARLpqOVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SbKuxwP7lJ8nLu9afhLF6Ww0tKr5uEjj7RXJeUuF6hXwsCSJLuBcEjqtKRwSItLh+
         TIJcQVeD5OkhEFGdUXA3As7M0xqXl17YE+V5wiJI/TWCRW5HZw3Qr/Eqx2bRfgnaC4
         7WZisMvJCvtgMYZxtnbb/YNiJihAXwY/5Mz3PKk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 116/145] um: use fallback for random_get_entropy() instead of zero
Date:   Fri, 27 May 2022 10:50:17 +0200
Message-Id: <20220527084904.555889326@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 9f13fb0cd11ed2327abff69f6501a2c124c88b5a upstream.

In the event that random_get_entropy() can't access a cycle counter or
similar, falling back to returning 0 is really not the best we can do.
Instead, at least calling random_get_entropy_fallback() would be
preferable, because that always needs to return _something_, even
falling back to jiffies eventually. It's not as though
random_get_entropy_fallback() is super high precision or guaranteed to
be entropic, but basically anything that's not zero all the time is
better than returning zero all the time.

This is accomplished by just including the asm-generic code like on
other architectures, which means we can get rid of the empty stub
function here.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/include/asm/timex.h |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/arch/um/include/asm/timex.h
+++ b/arch/um/include/asm/timex.h
@@ -2,13 +2,8 @@
 #ifndef __UM_TIMEX_H
 #define __UM_TIMEX_H
 
-typedef unsigned long cycles_t;
-
-static inline cycles_t get_cycles (void)
-{
-	return 0;
-}
-
 #define CLOCK_TICK_RATE (HZ)
 
+#include <asm-generic/timex.h>
+
 #endif


