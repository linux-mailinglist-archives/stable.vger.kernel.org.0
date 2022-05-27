Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D4553603C
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346604AbiE0LsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351958AbiE0LrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:47:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F5F13B8CA;
        Fri, 27 May 2022 04:43:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13C83B824CA;
        Fri, 27 May 2022 11:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581DEC385A9;
        Fri, 27 May 2022 11:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651796;
        bh=sbrL44tMkKlNhB/ubeCGu9MeR5vV2zIzvhWF5VTfUMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qRhV7yFks5LvkB90XxA4dn4OQUE+RoiBEBi74xflfL7dSiYQ37HeXbIa/uAUhAjrL
         6K+xjyFFjYrsX7yRtBpLbsHFFgkQPpAxUB5UB/w6wz5jEhv0zmEJmqdUYQRmXcal1i
         lFZigYWygmiaZwBZ4+HkDA8poUagIzoDHbgbPS2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 082/111] sparc: use fallback for random_get_entropy() instead of zero
Date:   Fri, 27 May 2022 10:49:54 +0200
Message-Id: <20220527084831.068127467@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084819.133490171@linuxfoundation.org>
References: <20220527084819.133490171@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit ac9756c79797bb98972736b13cfb239fd2cffb79 upstream.

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
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/asm/timex_32.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/sparc/include/asm/timex_32.h
+++ b/arch/sparc/include/asm/timex_32.h
@@ -9,8 +9,6 @@
 
 #define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
 
-/* XXX Maybe do something better at some point... -DaveM */
-typedef unsigned long cycles_t;
-#define get_cycles()	(0)
+#include <asm-generic/timex.h>
 
 #endif


