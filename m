Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC27923CDB9
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 19:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgHERl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 13:41:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728920AbgHERkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 13:40:21 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F277E22D02;
        Wed,  5 Aug 2020 11:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596626401;
        bh=fXD2fR/RGwBYKiJMF1H9ViC4OoYV0aXNwZ09RnmahuI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y5HHTjlLlzfak9r9LcLb6wTR5NtiJUSKbCqxqk3VLQHkDClW3hNKZJT/6qd1uflgk
         P2EQc9cr6Vf/9hrbk0UMp32tAoWqeU+geilo+ZfFb47ws6HDoRp7KOOrx+iV/6gHCF
         +T5CsfMpupS3UjTlB3NWN02gyz02XSfyWSGshCKU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3HSh-0001Dy-5B; Wed, 05 Aug 2020 12:19:59 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 05 Aug 2020 12:19:58 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 5.7 000/121] 5.7.13-rc2 review
In-Reply-To: <20200805095439.GB1634853@kroah.com>
References: <20200804072435.385370289@linuxfoundation.org>
 <CA+G9fYs35Eiq1QFM0MOj6Y7gC=YKaiknCPgcJpJ5NMW4Y7qnYQ@mail.gmail.com>
 <20200804082130.GA1768075@kroah.com>
 <CAHk-=whJ=shbf-guMGZkGvxh9fVmbrvUuiWO48+PDFG7J9A9qw@mail.gmail.com>
 <c32ad2216ca3dd83d6d3d740512db9de@kernel.org>
 <20200805095439.GB1634853@kroah.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <813c64c8dbe037b9d84763f56c4dbb7d@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gregkh@linuxfoundation.org, torvalds@linux-foundation.org, naresh.kamboju@linaro.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org, stable@vger.kernel.org, arnd@arndb.de, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-05 10:54, Greg Kroah-Hartman wrote:
> On Tue, Aug 04, 2020 at 10:23:06PM +0100, Marc Zyngier wrote:
>> On 2020-08-04 19:33, Linus Torvalds wrote:
>> > On Tue, Aug 4, 2020 at 1:21 AM Greg Kroah-Hartman
>> > <gregkh@linuxfoundation.org> wrote:
>> > >
>> > > So Linus's tree is also broken here.
>> >
>> > No, there's 835d1c3a9879 ("arm64: Drop unnecessary include from
>> > asm/smp.h") upstream.
>> 
>> My bet is that Greg ended up with this patch backported to
>> 5.7, but doesn't have 62a679cb2825 ("arm64: simplify ptrauth
>> initialization") as the latter isn't a fix.
>> 
>> I don't think any of these two patches are worth backporting,
>> to be honest.
> 
> I didn't have either of those patches, so I can try applying them to 
> see
> if the build errors go away.  But if you don't think they should be
> applied, what should I do?
> 
> Here's what I did have queued up:
> 
> f227e3ec3b5c ("random32: update the net random state on interrupt and 
> activity")
> aa54ea903abb ("ARM: percpu.h: fix build error")
> 1c9df907da83 ("random: fix circular include dependency on arm64 after
> addition of percpu.h")
> 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy
> gcc plugin")
> c0842fbc1b18 ("random32: move the pseudo-random 32-bit definitions to
> prandom.h")

Not what I expected, then. I stand corrected.

> And that caused the builds to blow up.
> 
> So, what should I do here?

OK, this is getting hairy. I solved it by grabbing:

d0055da5266a ("arm64: remove ptrauth_keys_install_kernel sync arg")
62a679cb2825 ("arm64: simplify ptrauth initialization")

and at which point you might as well take 835d1c3a9879 despite
everything I said earlier. And backporting that further down the
line is fraught with danger.

I came up with yet another "quality" hack, which gets the job done,
see below. It is obviously much simpler, but also terribly ugly.

         M.

 From 34ee193a4a84718689cffd13f976b7f31e4c5ad4 Mon Sep 17 00:00:00 2001
 From: Marc Zyngier <maz@kernel.org>
Date: Wed, 5 Aug 2020 12:10:44 +0100
Subject: [PATCH] arm64: Workaround circular dependency in pointer_auth.h
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

With the backport of f227e3ec3b5c ("random32: update the net random
state on interrupt and activity") and its associated fixes, the
arm64 build explodes early:

In file included from ../include/linux/smp.h:67,
                  from ../include/linux/percpu.h:7,
                  from ../include/linux/prandom.h:12,
                  from ../include/linux/random.h:118,
                  from ../arch/arm64/include/asm/pointer_auth.h:6,
                  from ../arch/arm64/include/asm/processor.h:39,
                  from ../include/linux/mutex.h:19,
                  from ../include/linux/kernfs.h:12,
                  from ../include/linux/sysfs.h:16,
                  from ../include/linux/kobject.h:20,
                  from ../include/linux/of.h:17,
                  from ../include/linux/irqdomain.h:35,
                  from ../include/linux/acpi.h:13,
                  from ../include/acpi/apei.h:9,
                  from ../include/acpi/ghes.h:5,
                  from ../include/linux/arm_sdei.h:8,
                  from ../arch/arm64/kernel/asm-offsets.c:10:
../arch/arm64/include/asm/smp.h:100:29: error: field ‘ptrauth_key’ has
incomplete type

This is due to struct ptrauth_keys_kernel not being defined before
we transitively include asm/smp.h from linux/random.h.

Paper over it by moving the inclusion of linux/random.h *after* the
type has been defined.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
  arch/arm64/include/asm/pointer_auth.h | 8 +++++++-
  1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pointer_auth.h 
b/arch/arm64/include/asm/pointer_auth.h
index c6b4f0603024..be7f853738e6 100644
--- a/arch/arm64/include/asm/pointer_auth.h
+++ b/arch/arm64/include/asm/pointer_auth.h
@@ -3,7 +3,6 @@
  #define __ASM_POINTER_AUTH_H

  #include <linux/bitops.h>
-#include <linux/random.h>

  #include <asm/cpufeature.h>
  #include <asm/memory.h>
@@ -34,6 +33,13 @@ struct ptrauth_keys_kernel {
  	struct ptrauth_key apia;
  };

+/*
+ * Only include random.h once ptrauth_keys_* structures are defined
+ * to avoid yet another circular include hell (random.h * ends up
+ * including asm/smp.h, which requires ptrauth_keys_kernel).
+ */
+#include <linux/random.h>
+
  static inline void ptrauth_keys_init_user(struct ptrauth_keys_user 
*keys)
  {
  	if (system_supports_address_auth()) {
-- 
2.27.0


-- 
Jazz is not dead. It just smells funny...
