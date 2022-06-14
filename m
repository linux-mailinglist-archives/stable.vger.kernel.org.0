Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414D554A49D
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352185AbiFNCIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352070AbiFNCHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:07:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBCB3525D;
        Mon, 13 Jun 2022 19:05:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A9CF60B6B;
        Tue, 14 Jun 2022 02:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B32C385A2;
        Tue, 14 Jun 2022 02:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172351;
        bh=ICic1qXwWEd4zC1JtT68D1retDf0Hs635HoT4ecNCuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IYhS5gpxvnWzLHikSHMAkDPp14pIWkv1plEnbzQOJkIGyeMyNBodYoQn25YimO92N
         ubUxQqKroZZC/W13wMHWLw5+d4cAqFphiYRohKXoEjNt8cHHa53Pe5wHfjsn8Svf/2
         ZvNXXwG3HBiNhbfQehmF4hHtdE/JWo4JAFz98JqkOy+pwTSKlpEWyiEvavumOr5AI+
         gMnjRjDXEPyYEKYXaYPAHHyEzZ+cH7KXK2GXzW858Q56PTvyXb7oCEp9K5dk3V8wbV
         RoKvYKFGHr/C9QzojeOrsK8GhvLxd4aVnBGwFG1yKXd7Jn3SgLC2jN0hYjO6VYuePn
         Q/ngrsJgGdHaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org
Subject: [PATCH AUTOSEL 5.18 41/47] random: credit cpu and bootloader seeds by default
Date:   Mon, 13 Jun 2022 22:04:34 -0400
Message-Id: <20220614020441.1098348-41-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020441.1098348-1-sashal@kernel.org>
References: <20220614020441.1098348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 846bb97e131d7938847963cca00657c995b1fce1 ]

This commit changes the default Kconfig values of RANDOM_TRUST_CPU and
RANDOM_TRUST_BOOTLOADER to be Y by default. It does not change any
existing configs or change any kernel behavior. The reason for this is
several fold.

As background, I recently had an email thread with the kernel
maintainers of Fedora/RHEL, Debian, Ubuntu, Gentoo, Arch, NixOS, Alpine,
SUSE, and Void as recipients. I noted that some distros trust RDRAND,
some trust EFI, and some trust both, and I asked why or why not. There
wasn't really much of a "debate" but rather an interesting discussion of
what the historical reasons have been for this, and it came up that some
distros just missed the introduction of the bootloader Kconfig knob,
while another didn't want to enable it until there was a boot time
switch to turn it off for more concerned users (which has since been
added). The result of the rather uneventful discussion is that every
major Linux distro enables these two options by default.

While I didn't have really too strong of an opinion going into this
thread -- and I mostly wanted to learn what the distros' thinking was
one way or another -- ultimately I think their choice was a decent
enough one for a default option (which can be disabled at boot time).
I'll try to summarize the pros and cons:

Pros:

- The RNG machinery gets initialized super quickly, and there's no
  messing around with subsequent blocking behavior.

- The bootloader mechanism is used by kexec in order for the prior
  kernel to initialize the RNG of the next kernel, which increases
  the entropy available to early boot daemons of the next kernel.

- Previous objections related to backdoors centered around
  Dual_EC_DRBG-like kleptographic systems, in which observing some
  amount of the output stream enables an adversary holding the right key
  to determine the entire output stream.

  This used to be a partially justified concern, because RDRAND output
  was mixed into the output stream in varying ways, some of which may
  have lacked pre-image resistance (e.g. XOR or an LFSR).

  But this is no longer the case. Now, all usage of RDRAND and
  bootloader seeds go through a cryptographic hash function. This means
  that the CPU would have to compute a hash pre-image, which is not
  considered to be feasible (otherwise the hash function would be
  terribly broken).

- More generally, if the CPU is backdoored, the RNG is probably not the
  realistic vector of choice for an attacker.

- These CPU or bootloader seeds are far from being the only source of
  entropy. Rather, there is generally a pretty huge amount of entropy,
  not all of which is credited, especially on CPUs that support
  instructions like RDRAND. In other words, assuming RDRAND outputs all
  zeros, an attacker would *still* have to accurately model every single
  other entropy source also in use.

- The RNG now reseeds itself quite rapidly during boot, starting at 2
  seconds, then 4, then 8, then 16, and so forth, so that other sources
  of entropy get used without much delay.

- Paranoid users can set random.trust_{cpu,bootloader}=no in the kernel
  command line, and paranoid system builders can set the Kconfig options
  to N, so there's no reduction or restriction of optionality.

- It's a practical default.

- All the distros have it set this way. Microsoft and Apple trust it
  too. Bandwagon.

Cons:

- RDRAND *could* still be backdoored with something like a fixed key or
  limited space serial number seed or another indexable scheme like
  that. (However, it's hard to imagine threat models where the CPU is
  backdoored like this, yet people are still okay making *any*
  computations with it or connecting it to networks, etc.)

- RDRAND *could* be defective, rather than backdoored, and produce
  garbage that is in one way or another insufficient for crypto.

- Suggesting a *reduction* in paranoia, as this commit effectively does,
  may cause some to question my personal integrity as a "security
  person".

- Bootloader seeds and RDRAND are generally very difficult if not all
  together impossible to audit.

Keep in mind that this doesn't actually change any behavior. This
is just a change in the default Kconfig value. The distros already are
shipping kernels that set things this way.

Ard made an additional argument in [1]:

    We're at the mercy of firmware and micro-architecture anyway, given
    that we are also relying on it to ensure that every instruction in
    the kernel's executable image has been faithfully copied to memory,
    and that the CPU implements those instructions as documented. So I
    don't think firmware or ISA bugs related to RNGs deserve special
    treatment - if they are broken, we should quirk around them like we
    usually do. So enabling these by default is a step in the right
    direction IMHO.

In [2], Phil pointed out that having this disabled masked a bug that CI
otherwise would have caught:

    A clean 5.15.45 boots cleanly, whereas a downstream kernel shows the
    static key warning (but it does go on to boot). The significant
    difference is that our defconfigs set CONFIG_RANDOM_TRUST_BOOTLOADER=y
    defining that on top of multi_v7_defconfig demonstrates the issue on
    a clean 5.15.45. Conversely, not setting that option in a
    downstream kernel build avoids the warning

[1] https://lore.kernel.org/lkml/CAMj1kXGi+ieviFjXv9zQBSaGyyzeGW_VpMpTLJK8PJb2QHEQ-w@mail.gmail.com/
[2] https://lore.kernel.org/lkml/c47c42e3-1d56-5859-a6ad-976a1a3381c6@raspberrypi.com/

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/Kconfig | 50 +++++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 55f48375e3fe..d454428f4981 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -428,28 +428,40 @@ config ADI
 	  driver include crash and makedumpfile.
 
 config RANDOM_TRUST_CPU
-	bool "Trust the CPU manufacturer to initialize Linux's CRNG"
+	bool "Initialize RNG using CPU RNG instructions"
+	default y
 	depends on ARCH_RANDOM
-	default n
 	help
-	Assume that CPU manufacturer (e.g., Intel or AMD for RDSEED or
-	RDRAND, IBM for the S390 and Power PC architectures) is trustworthy
-	for the purposes of initializing Linux's CRNG.  Since this is not
-	something that can be independently audited, this amounts to trusting
-	that CPU manufacturer (perhaps with the insistence or mandate
-	of a Nation State's intelligence or law enforcement agencies)
-	has not installed a hidden back door to compromise the CPU's
-	random number generation facilities. This can also be configured
-	at boot with "random.trust_cpu=on/off".
+	  Initialize the RNG using random numbers supplied by the CPU's
+	  RNG instructions (e.g. RDRAND), if supported and available. These
+	  random numbers are never used directly, but are rather hashed into
+	  the main input pool, and this happens regardless of whether or not
+	  this option is enabled. Instead, this option controls whether the
+	  they are credited and hence can initialize the RNG. Additionally,
+	  other sources of randomness are always used, regardless of this
+	  setting.  Enabling this implies trusting that the CPU can supply high
+	  quality and non-backdoored random numbers.
+
+	  Say Y here unless you have reason to mistrust your CPU or believe
+	  its RNG facilities may be faulty. This may also be configured at
+	  boot time with "random.trust_cpu=on/off".
 
 config RANDOM_TRUST_BOOTLOADER
-	bool "Trust the bootloader to initialize Linux's CRNG"
-	help
-	Some bootloaders can provide entropy to increase the kernel's initial
-	device randomness. Say Y here to assume the entropy provided by the
-	booloader is trustworthy so it will be added to the kernel's entropy
-	pool. Otherwise, say N here so it will be regarded as device input that
-	only mixes the entropy pool. This can also be configured at boot with
-	"random.trust_bootloader=on/off".
+	bool "Initialize RNG using bootloader-supplied seed"
+	default y
+	help
+	  Initialize the RNG using a seed supplied by the bootloader or boot
+	  environment (e.g. EFI or a bootloader-generated device tree). This
+	  seed is not used directly, but is rather hashed into the main input
+	  pool, and this happens regardless of whether or not this option is
+	  enabled. Instead, this option controls whether the seed is credited
+	  and hence can initialize the RNG. Additionally, other sources of
+	  randomness are always used, regardless of this setting. Enabling
+	  this implies trusting that the bootloader can supply high quality and
+	  non-backdoored seeds.
+
+	  Say Y here unless you have reason to mistrust your bootloader or
+	  believe its RNG facilities may be faulty. This may also be configured
+	  at boot time with "random.trust_bootloader=on/off".
 
 endmenu
-- 
2.35.1

