Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB866536172
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350131AbiE0L5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353326AbiE0L4Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:56:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66AF2E3A;
        Fri, 27 May 2022 04:51:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0393961D56;
        Fri, 27 May 2022 11:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1235BC385A9;
        Fri, 27 May 2022 11:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652285;
        bh=YAaAnfdN5DGX6izEPZPLbxRmKyDvGykDk8xyS2lO+OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p43gYKIm1PJrHlis4nhMH4AWu+1/lAC3NqwiH1GRxGFFmEWPSTsKkLO9hSoEQ/E/U
         +vkJ1G4+kkx5hNvP8zX96zfDgJBZ0aG0NMJjWyHfPWCFP2GxmoQQ+SjIFXqgZ+jUtj
         ivQl63lvjkhL7M7/abgmOZraprIyGng3GTDRPPG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 113/145] arm: use fallback for random_get_entropy() instead of zero
Date:   Fri, 27 May 2022 10:50:14 +0200
Message-Id: <20220527084904.255902300@linuxfoundation.org>
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


