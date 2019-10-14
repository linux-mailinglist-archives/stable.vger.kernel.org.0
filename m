Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4F10D6B4B
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 23:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730307AbfJNVdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 17:33:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730005AbfJNVdi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 17:33:38 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 917022064A;
        Mon, 14 Oct 2019 21:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571088817;
        bh=RU9C4sDnF0DzAfRjChmMlyW9deizX3rAelGoB7ukjV4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ln+fhERIDjobXCjVUxVbjarnBIR49ECBsp7fdD9g0WDGfG3cXDOX5AFvKPdbip4OV
         bgzahTZp60/ihITmKxE840/M4aOcYSpDXDuyAJn0CRnzURt+XWwEzKacfSTMDao28z
         /ko89hw4LqVcXllRpogIMq778CvxudqWshKxzk/4=
Date:   Mon, 14 Oct 2019 22:33:32 +0100
From:   Will Deacon <will@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Andrey Konovalov <andreyknvl@google.com>,
        Jan Stancek <jstancek@redhat.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        CKI Project <cki-project@redhat.com>,
        LTP List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.4.0-rc2-d6c2c23.cki (stable-next)
Message-ID: <20191014213332.mmq7narumxtkqumt@willie-the-truck>
References: <cki.B4A567748F.PFM8G4WKXI@redhat.com>
 <805988176.6044584.1571038139105.JavaMail.zimbra@redhat.com>
 <CAAeHK+zxFWvCOgTYrMuD-oHJAFMn5DVYmQ6-RvU8NrapSz01mQ@mail.gmail.com>
 <20191014162651.GF19200@arrakis.emea.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191014162651.GF19200@arrakis.emea.arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 05:26:51PM +0100, Catalin Marinas wrote:
> On Mon, Oct 14, 2019 at 02:54:17PM +0200, Andrey Konovalov wrote:
> > On Mon, Oct 14, 2019 at 9:29 AM Jan Stancek <jstancek@redhat.com> wrote:
> > > > We ran automated tests on a recent commit from this kernel tree:
> > > >
> > > >        Kernel repo:
> > > >        git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux-stable.git
> > > >             Commit: d6c2c23a29f4 - Merge branch 'stable-next' of
> > > >             ssh://chubbybox:/home/sasha/data/next into stable-next
> > > >
> > > > The results of these automated tests are provided below.
> > > >
> > > >     Overall result: FAILED (see details below)
> > > >              Merge: OK
> > > >            Compile: OK
> > > >              Tests: FAILED
> > > >
> > > > All kernel binaries, config files, and logs are available for download here:
> > > >
> > > >   https://artifacts.cki-project.org/pipelines/223563
> > > >
> > > > One or more kernel tests failed:
> > > >
> > > >     aarch64:
> > > >       ❌ LTP: openposix test suite
> > > >
> > >
> > > Test [1] is passing value close to LONG_MAX, which on arm64 is now treated as tagged userspace ptr:
> > >   057d3389108e ("mm: untag user pointers passed to memory syscalls")
> > >
> > > And now seems to hit overflow check after sign extension (EINVAL).
> > > Test should probably find different way to choose invalid pointer.
> > >
> > > [1] https://github.com/linux-test-project/ltp/blob/master/testcases/open_posix_testsuite/conformance/interfaces/mlock/8-1.c
> > 
> > Per Documentation/arm64/tagged-address-abi.rst we now have:
> > 
> > User addresses not accessed by the kernel but used for address space
> > management (e.g. ``mmap()``, ``mprotect()``, ``madvise()``). The use
> > of valid tagged pointers in this context is always allowed.
> > 
> > However this breaks the test above.
> 
> So the problem is that user space passes a 0x7fff_ffff_ffff_f000 start
> address and untagged_addr sign-extends it to 0xffff_ffff_ffff_f000. The
> subsequent check in apply_vma_lock_flags() finds that start+PAGE_SIZE is
> smaller than start, hence -EINVAL instead of -ENOMEM.
> 
> > What do you think we should do here?
> 
> It is an ABI break as the man page clearly states that the above case
> should return -ENOMEM.

Although I agree with your analysis, I also thought that these sorts of
ABI breaks (changes in error codes) were unfortunately common so we
shouldn't throw the baby out with the bath water here.

> The options I see:
> 
> 1. Revert commit 057d3389108e and try again to document that the memory
>    syscalls do not support tagged pointers
> 
> 2. Change untagged_addr() to only 0-extend from bit 55 or leave the
>    tag unchanged if bit 55 is 1. We could mask out the tag (0 rather
>    than sign-extend) but if we had an mlock test passing ULONG_MASK,
>    then we get -ENOMEM instead of -EINVAL
> 
> 3. Make untagged_addr() depend on the TIF_TAGGED_ADDR bit and we only
>    break the ABI for applications opting in to this new ABI. We did look
>    at this but the ptrace(PEEK/POKE_DATA) needs a bit more thinking on
>    whether we check the ptrace'd process or the debugger flags
> 
> 4. Leave things as they are, consider the address space 56-bit and
>    change the test to not use LONG_MAX on arm64. This needs to be passed
>    by the sparc guys since they probably have a similar issue

I'm in favour of (2) or (4) as long as there's also an update to the docs.

> It's slightly annoying to find this now. We did run (part of) LTP but I
> guess we never run the POSIX conformance tests.

Yes, and this stuff was in linux-next for a while so it's worrying that
kernelci didn't spot it either. Hmm.

> My preference is 2 with a quick attempt below. This basically means
> clear the tag if it resembles a valid (tagged) user pointer, otherwise
> don't touch it (bit 55 set always means an invalid user pointer). Not
> sure how the generated code will look like but we could probably do
> something better in assembly directly.
> 
> ---------8<-------------------------------
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index b61b50bf68b1..6b36d080a633 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -215,12 +215,15 @@ static inline unsigned long kaslr_offset(void)
>   * up with a tagged userland pointer. Clear the tag to get a sane pointer to
>   * pass on to access_ok(), for instance.
>   */
> -#define untagged_addr(addr)	\
> +#define __untagged_addr(addr)	\
>  	((__force __typeof__(addr))sign_extend64((__force u64)(addr), 55))
>  
> +#define untagged_addr(addr)	\
> +	((__force u64)(addr) & BIT(55) ? (addr) : __untagged_addr(addr))

It would be nice not to resort to asm for this, but I think we can do a bit
better with something like the code below which just introduces an
additional AND instruction.

Will

--->8

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index b61b50bf68b1..c23c47360664 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -215,12 +215,18 @@ static inline unsigned long kaslr_offset(void)
  * up with a tagged userland pointer. Clear the tag to get a sane pointer to
  * pass on to access_ok(), for instance.
  */
-#define untagged_addr(addr)	\
+#define __untagged_addr(addr)	\
 	((__force __typeof__(addr))sign_extend64((__force u64)(addr), 55))
 
+#define untagged_addr(addr)	({					\
+	u64 __addr = (__force u64)addr;					\
+	__addr &= __untagged_addr(__addr);				\
+	(__force __typeof__(addr))__addr;				\
+})
+
 #ifdef CONFIG_KASAN_SW_TAGS
 #define __tag_shifted(tag)	((u64)(tag) << 56)
-#define __tag_reset(addr)	untagged_addr(addr)
+#define __tag_reset(addr)	__untagged_addr(addr)
 #define __tag_get(addr)		(__u8)((u64)(addr) >> 56)
 #else
 #define __tag_shifted(tag)	0UL
