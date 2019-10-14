Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C419D6744
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 18:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbfJNQ0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 12:26:55 -0400
Received: from foss.arm.com ([217.140.110.172]:48408 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbfJNQ0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 12:26:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF9C828;
        Mon, 14 Oct 2019 09:26:54 -0700 (PDT)
Received: from arrakis.emea.arm.com (arrakis.cambridge.arm.com [10.1.196.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9621A3F718;
        Mon, 14 Oct 2019 09:26:53 -0700 (PDT)
Date:   Mon, 14 Oct 2019 17:26:51 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     Jan Stancek <jstancek@redhat.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        CKI Project <cki-project@redhat.com>,
        LTP List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Will Deacon <will@kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.4.0-rc2-d6c2c23.cki (stable-next)
Message-ID: <20191014162651.GF19200@arrakis.emea.arm.com>
References: <cki.B4A567748F.PFM8G4WKXI@redhat.com>
 <805988176.6044584.1571038139105.JavaMail.zimbra@redhat.com>
 <CAAeHK+zxFWvCOgTYrMuD-oHJAFMn5DVYmQ6-RvU8NrapSz01mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAeHK+zxFWvCOgTYrMuD-oHJAFMn5DVYmQ6-RvU8NrapSz01mQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ Will

On Mon, Oct 14, 2019 at 02:54:17PM +0200, Andrey Konovalov wrote:
> On Mon, Oct 14, 2019 at 9:29 AM Jan Stancek <jstancek@redhat.com> wrote:
> > > We ran automated tests on a recent commit from this kernel tree:
> > >
> > >        Kernel repo:
> > >        git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux-stable.git
> > >             Commit: d6c2c23a29f4 - Merge branch 'stable-next' of
> > >             ssh://chubbybox:/home/sasha/data/next into stable-next
> > >
> > > The results of these automated tests are provided below.
> > >
> > >     Overall result: FAILED (see details below)
> > >              Merge: OK
> > >            Compile: OK
> > >              Tests: FAILED
> > >
> > > All kernel binaries, config files, and logs are available for download here:
> > >
> > >   https://artifacts.cki-project.org/pipelines/223563
> > >
> > > One or more kernel tests failed:
> > >
> > >     aarch64:
> > >       ❌ LTP: openposix test suite
> > >
> >
> > Test [1] is passing value close to LONG_MAX, which on arm64 is now treated as tagged userspace ptr:
> >   057d3389108e ("mm: untag user pointers passed to memory syscalls")
> >
> > And now seems to hit overflow check after sign extension (EINVAL).
> > Test should probably find different way to choose invalid pointer.
> >
> > [1] https://github.com/linux-test-project/ltp/blob/master/testcases/open_posix_testsuite/conformance/interfaces/mlock/8-1.c
> 
> Per Documentation/arm64/tagged-address-abi.rst we now have:
> 
> User addresses not accessed by the kernel but used for address space
> management (e.g. ``mmap()``, ``mprotect()``, ``madvise()``). The use
> of valid tagged pointers in this context is always allowed.
> 
> However this breaks the test above.

So the problem is that user space passes a 0x7fff_ffff_ffff_f000 start
address and untagged_addr sign-extends it to 0xffff_ffff_ffff_f000. The
subsequent check in apply_vma_lock_flags() finds that start+PAGE_SIZE is
smaller than start, hence -EINVAL instead of -ENOMEM.

> What do you think we should do here?

It is an ABI break as the man page clearly states that the above case
should return -ENOMEM. The options I see:

1. Revert commit 057d3389108e and try again to document that the memory
   syscalls do not support tagged pointers

2. Change untagged_addr() to only 0-extend from bit 55 or leave the
   tag unchanged if bit 55 is 1. We could mask out the tag (0 rather
   than sign-extend) but if we had an mlock test passing ULONG_MASK,
   then we get -ENOMEM instead of -EINVAL

3. Make untagged_addr() depend on the TIF_TAGGED_ADDR bit and we only
   break the ABI for applications opting in to this new ABI. We did look
   at this but the ptrace(PEEK/POKE_DATA) needs a bit more thinking on
   whether we check the ptrace'd process or the debugger flags

4. Leave things as they are, consider the address space 56-bit and
   change the test to not use LONG_MAX on arm64. This needs to be passed
   by the sparc guys since they probably have a similar issue

It's slightly annoying to find this now. We did run (part of) LTP but I
guess we never run the POSIX conformance tests.

My preference is 2 with a quick attempt below. This basically means
clear the tag if it resembles a valid (tagged) user pointer, otherwise
don't touch it (bit 55 set always means an invalid user pointer). Not
sure how the generated code will look like but we could probably do
something better in assembly directly.

---------8<-------------------------------
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index b61b50bf68b1..6b36d080a633 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -215,12 +215,15 @@ static inline unsigned long kaslr_offset(void)
  * up with a tagged userland pointer. Clear the tag to get a sane pointer to
  * pass on to access_ok(), for instance.
  */
-#define untagged_addr(addr)	\
+#define __untagged_addr(addr)	\
 	((__force __typeof__(addr))sign_extend64((__force u64)(addr), 55))
 
+#define untagged_addr(addr)	\
+	((__force u64)(addr) & BIT(55) ? (addr) : __untagged_addr(addr))
+
 #ifdef CONFIG_KASAN_SW_TAGS
 #define __tag_shifted(tag)	((u64)(tag) << 56)
-#define __tag_reset(addr)	untagged_addr(addr)
+#define __tag_reset(addr)	__untagged_addr(addr)
 #define __tag_get(addr)		(__u8)((u64)(addr) >> 56)
 #else
 #define __tag_shifted(tag)	0UL

-- 
Catalin
