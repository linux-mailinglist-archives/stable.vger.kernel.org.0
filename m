Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5ABD4A7692
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 18:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346156AbiBBRMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 12:12:20 -0500
Received: from brightrain.aerifal.cx ([216.12.86.13]:60136 "EHLO
        brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346155AbiBBRMU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 12:12:20 -0500
Date:   Wed, 2 Feb 2022 12:12:19 -0500
From:   Rich Felker <dalias@libc.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Ariadne Conill <ariadne@dereferenced.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] exec: Force single empty string when argv is empty
Message-ID: <20220202171218.GQ7074@brightrain.aerifal.cx>
References: <20220201000947.2453721-1-keescook@chromium.org>
 <20220201145324.GA29634@brightrain.aerifal.cx>
 <1A24DA4E-2B15-4A95-B2A1-F5F963E0CD6F@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1A24DA4E-2B15-4A95-B2A1-F5F963E0CD6F@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 02, 2022 at 07:50:42AM -0800, Kees Cook wrote:
> 
> 
> On February 1, 2022 6:53:25 AM PST, Rich Felker <dalias@libc.org> wrote:
> >On Mon, Jan 31, 2022 at 04:09:47PM -0800, Kees Cook wrote:
> >> Quoting[1] Ariadne Conill:
> >> 
> >> "In several other operating systems, it is a hard requirement that the
> >> second argument to execve(2) be the name of a program, thus prohibiting
> >> a scenario where argc < 1. POSIX 2017 also recommends this behaviour,
> >> but it is not an explicit requirement[2]:
> >> 
> >>     The argument arg0 should point to a filename string that is
> >>     associated with the process being started by one of the exec
> >>     functions.
> >> ....
> >> Interestingly, Michael Kerrisk opened an issue about this in 2008[3],
> >> but there was no consensus to support fixing this issue then.
> >> Hopefully now that CVE-2021-4034 shows practical exploitative use[4]
> >> of this bug in a shellcode, we can reconsider.
> >> 
> >> This issue is being tracked in the KSPP issue tracker[5]."
> >> 
> >> While the initial code searches[6][7] turned up what appeared to be
> >> mostly corner case tests, trying to that just reject argv == NULL
> >> (or an immediately terminated pointer list) quickly started tripping[8]
> >> existing userspace programs.
> >> 
> >> The next best approach is forcing a single empty string into argv and
> >> adjusting argc to match. The number of programs depending on argc == 0
> >> seems a smaller set than those calling execve with a NULL argv.
> >> 
> >> Account for the additional stack space in bprm_stack_limits(). Inject an
> >> empty string when argc == 0 (and set argc = 1). Warn about the case so
> >> userspace has some notice about the change:
> >> 
> >>     process './argc0' launched './argc0' with NULL argv: empty string added
> >> 
> >> Additionally WARN() and reject NULL argv usage for kernel threads.
> >> 
> >> [1] https://lore.kernel.org/lkml/20220127000724.15106-1-ariadne@dereferenced.org/
> >> [2] https://pubs.opengroup.org/onlinepubs/9699919799/functions/exec.html
> >> [3] https://bugzilla.kernel.org/show_bug.cgi?id=8408
> >> [4] https://www.qualys.com/2022/01/25/cve-2021-4034/pwnkit.txt
> >> [5] https://github.com/KSPP/linux/issues/176
> >> [6] https://codesearch.debian.net/search?q=execve%5C+*%5C%28%5B%5E%2C%5D%2B%2C+*NULL&literal=0
> >> [7] https://codesearch.debian.net/search?q=execlp%3F%5Cs*%5C%28%5B%5E%2C%5D%2B%2C%5Cs*NULL&literal=0
> >> [8] https://lore.kernel.org/lkml/20220131144352.GE16385@xsang-OptiPlex-9020/
> >> 
> >> Reported-by: Ariadne Conill <ariadne@dereferenced.org>
> >> Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
> >> Cc: Matthew Wilcox <willy@infradead.org>
> >> Cc: Christian Brauner <brauner@kernel.org>
> >> Cc: Rich Felker <dalias@libc.org>
> >> Cc: Eric Biederman <ebiederm@xmission.com>
> >> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> >> Cc: linux-fsdevel@vger.kernel.org
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >> ---
> >>  fs/exec.c | 26 +++++++++++++++++++++++++-
> >>  1 file changed, 25 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/fs/exec.c b/fs/exec.c
> >> index 79f2c9483302..bbf3aadf7ce1 100644
> >> --- a/fs/exec.c
> >> +++ b/fs/exec.c
> >> @@ -495,8 +495,14 @@ static int bprm_stack_limits(struct linux_binprm *bprm)
> >>  	 * the stack. They aren't stored until much later when we can't
> >>  	 * signal to the parent that the child has run out of stack space.
> >>  	 * Instead, calculate it here so it's possible to fail gracefully.
> >> +	 *
> >> +	 * In the case of argc = 0, make sure there is space for adding a
> >> +	 * empty string (which will bump argc to 1), to ensure confused
> >> +	 * userspace programs don't start processing from argv[1], thinking
> >> +	 * argc can never be 0, to keep them from walking envp by accident.
> >> +	 * See do_execveat_common().
> >>  	 */
> >> -	ptr_size = (bprm->argc + bprm->envc) * sizeof(void *);
> >> +	ptr_size = (min(bprm->argc, 1) + bprm->envc) * sizeof(void *);
> >
> >From #musl:
> >
> ><mixi> kees: shouldn't the min(bprm->argc, 1) be max(...) in your patch?
> 
> Fix has already been sent, yup.
> 
> >I'm pretty sure without fixing that, you're introducing a giant vuln
> >here.
> 
> I wouldn't say "giant", but yes, it weakened a defense in depth for
> avoiding high stack utilization.

I thought it was deciding the amount of memory to allocate/reserve for
the arg slots, but based on the comment it looks like it's just a way
to fail early rather than making the new process image fault later if
they don't fit.

> > I believe this is the second time a patch attempting to fix this
> >non-vuln has proposed adding a new vuln...
> 
> Mistakes happen, and that's why there is review and testing. Thank
> you for being part of the review process! :)

I know, and I'm sorry for being a bit hostile over it, and for jumping
the gun about the severity. I just get frustrated when I see a rush to
make changes over an incidental part of a popularized vuln, with
disproportionate weight on "doing something" and not enough on being
careful.

Rich
