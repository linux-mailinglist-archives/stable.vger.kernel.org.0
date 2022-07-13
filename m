Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D037572FE3
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 10:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbiGMIAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 04:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234828AbiGMIAj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 04:00:39 -0400
X-Greylist: delayed 1794 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 13 Jul 2022 01:00:37 PDT
Received: from www.kot-begemot.co.uk (ivanoab7.miniserver.com [37.128.132.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB5DDF63C
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 01:00:37 -0700 (PDT)
Received: from [192.168.18.6] (helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1oBWKY-0001wQ-OF; Wed, 13 Jul 2022 06:58:46 +0000
Received: from madding.kot-begemot.co.uk ([192.168.3.98])
        by jain.kot-begemot.co.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1oBWKQ-003MQa-My; Wed, 13 Jul 2022 07:58:40 +0100
Message-ID: <d20a629c-8c15-ca8a-c34a-c5c084dbee03@cambridgegreys.com>
Date:   Wed, 13 Jul 2022 07:58:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] um: seed rng using host OS rng
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-um@lists.infradead.org, linux-kernel@vger.kernel.org,
        johannes@sipsolutions.net
Cc:     stable@vger.kernel.org
References: <20220712232738.77737-1-Jason@zx2c4.com>
From:   Anton Ivanov <anton.ivanov@cambridgegreys.com>
Organization: Cambridge Greys
In-Reply-To: <20220712232738.77737-1-Jason@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/07/2022 00:27, Jason A. Donenfeld wrote:
> UML generally does not provide access to special CPU instructions like
> RDRAND, and execution tends to be rather deterministic, with no real
> hardware interrupts, making good randomness really very hard, if not
> all together impossible. Not only is this a security eyebrow raiser, but
> it's also quite annoying when trying to do various pieces of UML-based
> automation that takes a long time to boot, if ever.
> 
> Fix this by trivially calling getrandom() in the host and using that
> seed as "bootloader randomness", which initializes the rng immediately
> at UML boot.
> 
> The old behavior can be restored the same way as on any other arch, by
> way of CONFIG_TRUST_BOOTLOADER_RANDOMNESS=n or
> random.trust_bootloader=0. So seen from that perspective, this just
> makes UML act like other archs, which is positive in its own right.
> 
> Cc: stable@vger.kernel.org
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>   arch/um/include/shared/os.h | 7 +++++++
>   arch/um/kernel/um_arch.c    | 8 ++++++++
>   arch/um/os-Linux/util.c     | 6 ++++++
>   3 files changed, 21 insertions(+)
> 
> diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
> index fafde1d5416e..79644dd88d58 100644
> --- a/arch/um/include/shared/os.h
> +++ b/arch/um/include/shared/os.h
> @@ -11,6 +11,12 @@
>   #include <irq_user.h>
>   #include <longjmp.h>
>   #include <mm_id.h>
> +/* This is to get size_t */
> +#ifndef __UM_HOST__
> +#include <linux/types.h>
> +#else
> +#include <stddef.h>
> +#endif
>   
>   #define CATCH_EINTR(expr) while ((errno = 0, ((expr) < 0)) && (errno == EINTR))
>   
> @@ -243,6 +249,7 @@ extern void stack_protections(unsigned long address);
>   extern int raw(int fd);
>   extern void setup_machinename(char *machine_out);
>   extern void setup_hostinfo(char *buf, int len);
> +extern ssize_t os_getrandom(void *buf, size_t len, unsigned int flags);
>   extern void os_dump_core(void) __attribute__ ((noreturn));
>   extern void um_early_printk(const char *s, unsigned int n);
>   extern void os_fix_helper_signals(void);
> diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
> index 0760e24f2eba..74f3efd96bd4 100644
> --- a/arch/um/kernel/um_arch.c
> +++ b/arch/um/kernel/um_arch.c
> @@ -16,6 +16,7 @@
>   #include <linux/sched/task.h>
>   #include <linux/kmsg_dump.h>
>   #include <linux/suspend.h>
> +#include <linux/random.h>
>   
>   #include <asm/processor.h>
>   #include <asm/cpufeature.h>
> @@ -406,6 +407,8 @@ int __init __weak read_initrd(void)
>   
>   void __init setup_arch(char **cmdline_p)
>   {
> +	u8 rng_seed[32];
> +
>   	stack_protections((unsigned long) &init_thread_info);
>   	setup_physmem(uml_physmem, uml_reserved, physmem_size, highmem);
>   	mem_total_pages(physmem_size, iomem_size, highmem);
> @@ -416,6 +419,11 @@ void __init setup_arch(char **cmdline_p)
>   	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
>   	*cmdline_p = command_line;
>   	setup_hostinfo(host_info, sizeof host_info);
> +
> +	if (os_getrandom(rng_seed, sizeof(rng_seed), 0) == sizeof(rng_seed)) {
> +		add_bootloader_randomness(rng_seed, sizeof(rng_seed));
> +		memzero_explicit(rng_seed, sizeof(rng_seed));
> +	}
>   }
>   
>   void __init check_bugs(void)
> diff --git a/arch/um/os-Linux/util.c b/arch/um/os-Linux/util.c
> index 41297ec404bf..fc0f2a9dee5a 100644
> --- a/arch/um/os-Linux/util.c
> +++ b/arch/um/os-Linux/util.c
> @@ -14,6 +14,7 @@
>   #include <sys/wait.h>
>   #include <sys/mman.h>
>   #include <sys/utsname.h>
> +#include <sys/random.h>
>   #include <init.h>
>   #include <os.h>
>   
> @@ -96,6 +97,11 @@ static inline void __attribute__ ((noreturn)) uml_abort(void)
>   			exit(127);
>   }
>   
> +ssize_t os_getrandom(void *buf, size_t len, unsigned int flags)
> +{
> +	return getrandom(buf, len, flags);
> +}
> +
>   /*
>    * UML helper threads must not handle SIGWINCH/INT/TERM
>    */

I am probably missing something here.

IIRC UML RNG device reads directly from host.

If you are using UMLs own /dev/random you are effectively using the host 
one.

So unless I am mistaken, you need extra randomness only if you do not 
have UMLs /dev/random compiled in.

Apologies for possible duplicates - I initially did not reply-all by 
mistake.

-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661
https://www.cambridgegreys.com/
