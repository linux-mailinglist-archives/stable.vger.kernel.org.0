Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF84A343D
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 11:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfH3JlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 05:41:15 -0400
Received: from foss.arm.com ([217.140.110.172]:57372 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727800AbfH3JlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Aug 2019 05:41:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 40F76344;
        Fri, 30 Aug 2019 02:41:14 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E080A3F718;
        Fri, 30 Aug 2019 02:41:12 -0700 (PDT)
Date:   Fri, 30 Aug 2019 10:41:10 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH ARM64 v4.4 V3 09/44] mm/kasan: add API to check memory
 regions
Message-ID: <20190830094110.GI46475@lakrids.cambridge.arm.com>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
 <ea16af1feddcaa85dc5369c79f78c00256c698cd.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea16af1feddcaa85dc5369c79f78c00256c698cd.1567077734.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 05:03:54PM +0530, Viresh Kumar wrote:
> From: Andrey Ryabinin <aryabinin@virtuozzo.com>
> 
> commit 64f8ebaf115bcddc4aaa902f981c57ba6506bc42 upstream.
> 
> Memory access coded in an assembly won't be seen by KASAN as a compiler
> can instrument only C code.  Add kasan_check_[read,write]() API which is
> going to be used to check a certain memory range.
> 
> Link: http://lkml.kernel.org/r/1462538722-1574-3-git-send-email-aryabinin@virtuozzo.com
> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Acked-by: Alexander Potapenko <glider@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [ v4.4: Fixed MAINTAINERS conflict and added whole kasan entry. Drop 4th
> 	argument to check_memory_region(). ]
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Reviewed-by: Mark Rutland <mark.rutland@arm.com> [v4.4 backport]

Mark.

> ---
>  MAINTAINERS                  | 14 ++++++++++++++
>  include/linux/kasan-checks.h | 12 ++++++++++++
>  mm/kasan/kasan.c             | 12 ++++++++++++
>  3 files changed, 38 insertions(+)
>  create mode 100644 include/linux/kasan-checks.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f4d4a5544dc1..2a8826732967 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5982,6 +5982,20 @@ S:	Maintained
>  F:	Documentation/hwmon/k8temp
>  F:	drivers/hwmon/k8temp.c
>  
> +KASAN
> +M:	Andrey Ryabinin <aryabinin@virtuozzo.com>
> +R:	Alexander Potapenko <glider@google.com>
> +R:	Dmitry Vyukov <dvyukov@google.com>
> +L:	kasan-dev@googlegroups.com
> +S:	Maintained
> +F:	arch/*/include/asm/kasan.h
> +F:	arch/*/mm/kasan_init*
> +F:	Documentation/kasan.txt
> +F:	include/linux/kasan*.h
> +F:	lib/test_kasan.c
> +F:	mm/kasan/
> +F:	scripts/Makefile.kasan
> +
>  KCONFIG
>  M:	"Yann E. MORIN" <yann.morin.1998@free.fr>
>  L:	linux-kbuild@vger.kernel.org
> diff --git a/include/linux/kasan-checks.h b/include/linux/kasan-checks.h
> new file mode 100644
> index 000000000000..b7f8aced7870
> --- /dev/null
> +++ b/include/linux/kasan-checks.h
> @@ -0,0 +1,12 @@
> +#ifndef _LINUX_KASAN_CHECKS_H
> +#define _LINUX_KASAN_CHECKS_H
> +
> +#ifdef CONFIG_KASAN
> +void kasan_check_read(const void *p, unsigned int size);
> +void kasan_check_write(const void *p, unsigned int size);
> +#else
> +static inline void kasan_check_read(const void *p, unsigned int size) { }
> +static inline void kasan_check_write(const void *p, unsigned int size) { }
> +#endif
> +
> +#endif
> diff --git a/mm/kasan/kasan.c b/mm/kasan/kasan.c
> index b7397b459960..1cdcab0c976a 100644
> --- a/mm/kasan/kasan.c
> +++ b/mm/kasan/kasan.c
> @@ -274,6 +274,18 @@ static __always_inline void check_memory_region(unsigned long addr,
>  void __asan_loadN(unsigned long addr, size_t size);
>  void __asan_storeN(unsigned long addr, size_t size);
>  
> +void kasan_check_read(const void *p, unsigned int size)
> +{
> +	check_memory_region((unsigned long)p, size, false);
> +}
> +EXPORT_SYMBOL(kasan_check_read);
> +
> +void kasan_check_write(const void *p, unsigned int size)
> +{
> +	check_memory_region((unsigned long)p, size, true);
> +}
> +EXPORT_SYMBOL(kasan_check_write);
> +
>  #undef memset
>  void *memset(void *addr, int c, size_t len)
>  {
> -- 
> 2.21.0.rc0.269.g1a574e7a288b
> 
