Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B82D1E2735
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 18:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgEZQiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 12:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728339AbgEZQiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 12:38:17 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19E6C03E96E
        for <stable@vger.kernel.org>; Tue, 26 May 2020 09:38:16 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id p30so10292770pgl.11
        for <stable@vger.kernel.org>; Tue, 26 May 2020 09:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bhl2UOIY4OsE6svto3/aMcCQxQAAGmGUt7Z/dDdHwgQ=;
        b=k8W8Gk5W79jL71x4Db6tC32LoN6tLeF2cWKPofBk6MQZHqZ+DVReHkEgXOdpD8U1+E
         QishTLwEIZx4P48VIYZGEyBLnP0yv5X4BHP6VUSrP4q/ehBudtDacM2/DZiC7ZTU2F53
         XkHk5ce+t2gaqjUfdUy1GC1bxmKV2jKmlRhiE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bhl2UOIY4OsE6svto3/aMcCQxQAAGmGUt7Z/dDdHwgQ=;
        b=IJlyphm88pdwEmLCdqkemJ8uO2JY9qIsZWY1UQrSRsUAWkCsXXZODZ3PjfXFMvvJfQ
         jRoUaP7y4neX42m8ZDtmtnxRD4DBMeg9QtJIGQknesznlX3rfT8SVAqNuP7OvlYvcd2t
         mn3CUQQPw7HTviL0+cuj/AX1dDbLZb/3bY1SZqzl+cJAwI6MEmiGHE3wYbrKXOrILia3
         6MDR6TuxWjC1L40kQ5+wh64+5wS81EAm/23nefdpBHi6OPCtQbxjf2QXWM3yx/Ll6yYq
         i2rPqT+8VMQjGUhwqjHKBocjNKtE6HAwrDmitGw9fYbmaPGnlQ2WdM8J6UZZT7VsaCfU
         qgfw==
X-Gm-Message-State: AOAM5302WZxOLu2OV2LSSL+JCQAoukdvfY/ZfFQLY8Anrcl+QQEJahvD
        SRMa1QUTnMDS7f6+fnVgokuXKg==
X-Google-Smtp-Source: ABdhPJySu98Q8YTkcdzj0kW5rhz9kbIzAe19Hvm2Y7yxT0uL5KHG5sOgIN5LUU2lavt8W2YvXm+n4w==
X-Received: by 2002:a63:f703:: with SMTP id x3mr1867522pgh.11.1590511096425;
        Tue, 26 May 2020 09:38:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w7sm66767pfu.117.2020.05.26.09.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 09:38:15 -0700 (PDT)
Date:   Tue, 26 May 2020 09:38:14 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Andi Kleen <andi@firstfloor.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        Andi Kleen <ak@linux.intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1] x86: Pin cr4 FSGSBASE
Message-ID: <202005260935.EB11D3EB7@keescook>
References: <20200526052848.605423-1-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526052848.605423-1-andi@firstfloor.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 10:28:48PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Since there seem to be kernel modules floating around that set
> FSGSBASE incorrectly, prevent this in the CR4 pinning. Currently
> CR4 pinning just checks that bits are set, this also checks
> that the FSGSBASE bit is not set, and if it is clears it again.
> 
> Note this patch will need to be undone when the full FSGSBASE
> patches are merged. But it's a reasonable solution for v5.2+
> stable at least. Sadly the older kernels don't have the necessary
> infrastructure for this (although a simpler version of this
> could be added there too)
> 
> Cc: stable@vger.kernel.org # v5.2+
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/common.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index bed0cb83fe24..1f5b7871ae9a 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -385,6 +385,11 @@ void native_write_cr4(unsigned long val)
>  		/* Warn after we've set the missing bits. */
>  		WARN_ONCE(bits_missing, "CR4 bits went missing: %lx!?\n",
>  			  bits_missing);
> +		if (val & X86_CR4_FSGSBASE) {
> +			WARN_ONCE(1, "CR4 unexpectedly set FSGSBASE!?\n");
> +			val &= ~X86_CR4_FSGSBASE;
> +			goto set_register;
> +		}
>  	}
>  }
>  EXPORT_SYMBOL(native_write_cr4);
> -- 
> 2.25.4
> 

And if this is going to be more permanent, we can separate the mask
(untested):


diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index bed0cb83fe24..ead64f7420a5 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -347,6 +347,8 @@ static __always_inline void setup_umip(struct cpuinfo_x86 *c)
 	cr4_clear_bits(X86_CR4_UMIP);
 }
 
+static const unsigned long cr4_pinned_mask =
+	X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP | X86_CR4_FSGSBASE;
 static DEFINE_STATIC_KEY_FALSE_RO(cr_pinning);
 static unsigned long cr4_pinned_bits __ro_after_init;
 
@@ -371,20 +373,20 @@ EXPORT_SYMBOL(native_write_cr0);
 
 void native_write_cr4(unsigned long val)
 {
-	unsigned long bits_missing = 0;
+	unsigned long bits_changed = 0;
 
 set_register:
 	asm volatile("mov %0,%%cr4": "+r" (val), "+m" (cr4_pinned_bits));
 
 	if (static_branch_likely(&cr_pinning)) {
-		if (unlikely((val & cr4_pinned_bits) != cr4_pinned_bits)) {
-			bits_missing = ~val & cr4_pinned_bits;
-			val |= bits_missing;
+		if (unlikely((val & cr4_pinned_mask) != cr4_pinned_bits)) {
+			bits_changed = ~val & cr4_pinned_mask;
+			val = (val & ~cr4_pinned_mask) | cr4_pinned_bits;
 			goto set_register;
 		}
 		/* Warn after we've set the missing bits. */
-		WARN_ONCE(bits_missing, "CR4 bits went missing: %lx!?\n",
-			  bits_missing);
+		WARN_ONCE(bits_changed, "pinned CR4 bits changed: %lx!?\n",
+			  bits_changed);
 	}
 }
 EXPORT_SYMBOL(native_write_cr4);
@@ -396,7 +398,7 @@ void cr4_init(void)
 	if (boot_cpu_has(X86_FEATURE_PCID))
 		cr4 |= X86_CR4_PCIDE;
 	if (static_branch_likely(&cr_pinning))
-		cr4 |= cr4_pinned_bits;
+		cr4 = (cr4 & ~cr4_pinned_mask) | cr4_pinned_bits;
 
 	__write_cr4(cr4);
 
@@ -411,10 +413,7 @@ void cr4_init(void)
  */
 static void __init setup_cr_pinning(void)
 {
-	unsigned long mask;
-
-	mask = (X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP);
-	cr4_pinned_bits = this_cpu_read(cpu_tlbstate.cr4) & mask;
+	cr4_pinned_bits = this_cpu_read(cpu_tlbstate.cr4) & cr4_pinned_mask;
 	static_key_enable(&cr_pinning.key);
 }
 

-- 
Kees Cook
