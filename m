Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD89535C0E
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 10:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243176AbiE0Iwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 04:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350054AbiE0IwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:52:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9A258399;
        Fri, 27 May 2022 01:51:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0585361D3D;
        Fri, 27 May 2022 08:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF19EC385A9;
        Fri, 27 May 2022 08:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641516;
        bh=YAaAnfdN5DGX6izEPZPLbxRmKyDvGykDk8xyS2lO+OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zY2bBCbGCyhfJoVq74PmU19U68SprSNk+ldoQrkp6Jg4haYSFLRQRaiGQgZbNtbEi
         4dID7qfJ+0hd1Oks7zAQWpu6LNwmK4zBixv0MuKnohMQ2rZqPKrR515SNF3AnvPpPp
         f/kfAWkAABr4rEts9O5i5aYkzLv5bIpZqLSQ+1Ic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.18 14/47] arm: use fallback for random_get_entropy() instead of zero
Date:   Fri, 27 May 2022 10:49:54 +0200
Message-Id: <20220527084803.662215479@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084801.223648383@linuxfoundation.org>
References: <20220527084801.223648383@linuxfoundation.org>
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

commit ff8a8f59c99f6a7c656387addc4d9f2247d75077 upstream.

In the event that random_get_entropy() can't access a cycle counter or
similar, falling back to returning 0 is really not the best we can do.
Instead, at least calling random_get_entropy_fallback() would be
preferable, because that always needs to return _something_, even
falling back to jiffies eventually. It's not as though
random_get_entropy_fallback() is super high precision or guaranteed to
be entropic, but basically anything that's not zero all the time is
better than returning zero all the time.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/timex.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/include/asm/timex.h
+++ b/arch/arm/include/asm/timex.h
@@ -11,5 +11,6 @@
 
 typedef unsigned long cycles_t;
 #define get_cycles()	({ cycles_t c; read_current_timer(&c) ? 0 : c; })
+#define random_get_entropy() (((unsigned long)get_cycles()) ?: random_get_entropy_fallback())
 
 #endif


