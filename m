Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0413B5581A1
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiFWRDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbiFWRDN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:03:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82D250E3C;
        Thu, 23 Jun 2022 09:54:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59CABB82493;
        Thu, 23 Jun 2022 16:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0FCC341C5;
        Thu, 23 Jun 2022 16:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003279;
        bh=Lsq0eKPBVfKBPWTnlRqD63GU+emiQfb0lgDGZ+bos/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dusmGuodjLMNSeV5//DYnPhpK4RQJ/IDmlFrcosLTVg/DimebmnZWxlppkPy73CbN
         M8Wmrs8VgRkuiyRAaQmXFnP+JBewLbPgpZM4N0oTPPf5RbzDXLMrDqSeJHklh9NtWo
         LQ/62+NoWRgT+4xzzwU5Y3vcN9WvCraNksjl5bhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Subject: [PATCH 4.9 188/264] x86/tsc: Use fallback for random_get_entropy() instead of zero
Date:   Thu, 23 Jun 2022 18:43:01 +0200
Message-Id: <20220623164349.387531048@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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

commit 3bd4abc07a267e6a8b33d7f8717136e18f921c53 upstream.

In the event that random_get_entropy() can't access a cycle counter or
similar, falling back to returning 0 is suboptimal. Instead, fallback
to calling random_get_entropy_fallback(), which isn't extremely high
precision or guaranteed to be entropic, but is certainly better than
returning zero all the time.

If CONFIG_X86_TSC=n, then it's possible for the kernel to run on systems
without RDTSC, such as 486 and certain 586, so the fallback code is only
required for that case.

As well, fix up both the new function and the get_cycles() function from
which it was derived to use cpu_feature_enabled() rather than
boot_cpu_has(), and use !IS_ENABLED() instead of #ifndef.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/timex.h |    9 +++++++++
 arch/x86/include/asm/tsc.h   |    7 +++----
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/timex.h
+++ b/arch/x86/include/asm/timex.h
@@ -4,6 +4,15 @@
 #include <asm/processor.h>
 #include <asm/tsc.h>
 
+static inline unsigned long random_get_entropy(void)
+{
+	if (!IS_ENABLED(CONFIG_X86_TSC) &&
+	    !cpu_feature_enabled(X86_FEATURE_TSC))
+		return random_get_entropy_fallback();
+	return rdtsc();
+}
+#define random_get_entropy random_get_entropy
+
 /* Assume we use the PIT time source for the clock tick */
 #define CLOCK_TICK_RATE		PIT_TICK_RATE
 
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -21,13 +21,12 @@ extern void disable_TSC(void);
 
 static inline cycles_t get_cycles(void)
 {
-#ifndef CONFIG_X86_TSC
-	if (!boot_cpu_has(X86_FEATURE_TSC))
+	if (!IS_ENABLED(CONFIG_X86_TSC) &&
+	    !cpu_feature_enabled(X86_FEATURE_TSC))
 		return 0;
-#endif
-
 	return rdtsc();
 }
+#define get_cycles get_cycles
 
 extern struct system_counterval_t convert_art_to_tsc(cycle_t art);
 


