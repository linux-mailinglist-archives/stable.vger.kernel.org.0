Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D30536025
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244236AbiE0Lq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352095AbiE0LpW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:45:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CCF140868;
        Fri, 27 May 2022 04:41:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E0DD61D46;
        Fri, 27 May 2022 11:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEC0C385A9;
        Fri, 27 May 2022 11:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651716;
        bh=YVFCm9IvwmgkDNWZPZYSkH8bYCAZpNilJPeiWNu6Xuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJa0bnddslGgrff/oR3XdFvx18vcwFhEHGEjrGcL3j9vikd7djdrXtCHhoLu4R+YO
         vFvET2O+j0tldo+yu1VsqZRnRAcIFPKBdP1P9zyXXOba1aR8Bsph8rJKtV+9RaMSns
         ZSd3m50ompDFxeVjMAAPlwSztBrR9rbVKwwHO5q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 075/111] m68k: use fallback for random_get_entropy() instead of zero
Date:   Fri, 27 May 2022 10:49:47 +0200
Message-Id: <20220527084830.091696429@linuxfoundation.org>
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

commit 0f392c95391f2d708b12971a07edaa7973f9eece upstream.

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
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/m68k/include/asm/timex.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/m68k/include/asm/timex.h
+++ b/arch/m68k/include/asm/timex.h
@@ -35,7 +35,7 @@ static inline unsigned long random_get_e
 {
 	if (mach_random_get_entropy)
 		return mach_random_get_entropy();
-	return 0;
+	return random_get_entropy_fallback();
 }
 #define random_get_entropy	random_get_entropy
 


