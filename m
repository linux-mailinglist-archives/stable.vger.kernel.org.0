Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06725583EF
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbiFWRjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234468AbiFWRhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:37:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7905FCC;
        Thu, 23 Jun 2022 10:06:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70518B82490;
        Thu, 23 Jun 2022 17:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EE9C341C5;
        Thu, 23 Jun 2022 17:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004016;
        bh=oC7uE7Rw1Ghn9TivFSc7Wmcc7UL8WyT0zdSQsUCYZZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xjHKe2Y5Tn2FTuRVhYTVuMVw2dw2nGMdUcsyOwBQb3OJFLbm54Hifb24Kv4vpR0HA
         2RwfK0B5Pd7AOLQrZDZVdCZZfIe20jtIEHlgRf6ukDsjnNO2GdJc7Llg6dw8NK6XLq
         iX68TS2GCs7/R5q9A3umQC8dLB6zk5BwZcZ1osoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Max Filippov <jcmvbkbc@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 161/237] xtensa: use fallback for random_get_entropy() instead of zero
Date:   Thu, 23 Jun 2022 18:43:15 +0200
Message-Id: <20220623164347.786826028@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit e10e2f58030c5c211d49042a8c2a1b93d40b2ffb upstream.

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
Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/include/asm/timex.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/xtensa/include/asm/timex.h
+++ b/arch/xtensa/include/asm/timex.h
@@ -30,10 +30,6 @@
 
 extern unsigned long ccount_freq;
 
-typedef unsigned long long cycles_t;
-
-#define get_cycles()	(0)
-
 void local_timer_setup(unsigned cpu);
 
 /*
@@ -69,4 +65,6 @@ static inline void set_linux_timer (unsi
 	WSR_CCOMPARE(LINUX_TIMER, ccompare);
 }
 
+#include <asm-generic/timex.h>
+
 #endif	/* _XTENSA_TIMEX_H */


