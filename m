Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277AA21CBA2
	for <lists+stable@lfdr.de>; Sun, 12 Jul 2020 23:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbgGLVun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 17:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729505AbgGLVun (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jul 2020 17:50:43 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B3DC08C5DB
        for <stable@vger.kernel.org>; Sun, 12 Jul 2020 14:50:43 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id o38so8611354qtf.6
        for <stable@vger.kernel.org>; Sun, 12 Jul 2020 14:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y0Y9Cg878pa612/SC58tikFh/oV/WVfZP31F8tnLOG0=;
        b=OOmgHlYgE7YnD046QRQELznkE+KLcSALex6ufH1VGqNd4C7sItpmSYOap5tQttlypc
         jdt6eIo0wKb5ZqE6muON5tsGF2EWAVW1crXJRyDGH0sJUS7gfqhgJ+Ajt8mBTt68XMJr
         JjrKt2czjqgs70T0mhnF8yH3naCPysmtTAk0c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y0Y9Cg878pa612/SC58tikFh/oV/WVfZP31F8tnLOG0=;
        b=L8OZkhgN0Trvui0NXvKhqR92gm5TjRaIiStD8kcOcZ/t2JdBkavqbcVP0Yy8JbtlY9
         r3kj3tj1vv55dbZjQNqZi+X8r9pouNa/PuDZYFGvkh21GhTLgi5C+YBfXFrzCpWEM7Zv
         K+UENlW+w0i+kLaoc36jo1+iDWiZ/wSL4RmSGI33NExLlRBeEDb2bayd/Ian3HuM1BZW
         DBDcUEhZZsqZIy9LMlR0C1xKoNNgdd1TnWLloTNAQewu9wr9IMsxlv7qKzJ90acxfoQ9
         0px6iTPAG1BGyv5FSkbP1VquwTF/b6/6hLUiK7/UPoow3dDLjTfu1oMguXJQwcQjdYX2
         oztA==
X-Gm-Message-State: AOAM533IoNRozddOLazlcCSWKFNqwlkdBL+cOtZdDWahPW+pR3E3Sb2t
        rkholHXsPtlkoEzzncuL5ZTs6Q==
X-Google-Smtp-Source: ABdhPJwlXOHXDmN+gWJ3YpyLEA5rsIV6twy1fVkifMEu75+iS99ioKgeA467G+sdg4i7myUitvTUXw==
X-Received: by 2002:ac8:c4e:: with SMTP id l14mr67127104qti.106.1594590642283;
        Sun, 12 Jul 2020 14:50:42 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:cad3:ffff:feb3:bd59])
        by smtp.gmail.com with ESMTPSA id p7sm16209284qki.61.2020.07.12.14.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 14:50:41 -0700 (PDT)
Date:   Sun, 12 Jul 2020 17:50:41 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>,
        lkft-triage@lists.linaro.org, Chris Down <chris@chrisdown.name>,
        Michel Lespinasse <walken@google.com>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Brian Geffon <bgeffon@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, pugaowei@gmail.com,
        Jerome Glisse <jglisse@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
Message-ID: <20200712215041.GA3644504@google.com>
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
 <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com>
 <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 09, 2020 at 10:22:21PM -0700, Linus Torvalds wrote:
> On Thu, Jul 9, 2020 at 9:29 PM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > Your patch applied and re-tested.
> > warning triggered 10 times.
> >
> > old: bfe00000-c0000000 new: bfa00000 (val: 7d530067)
> 
> Hmm.. It's not even the overlapping case, it's literally just "move
> exactly 2MB of page tables exactly one pmd down". Which should be the
> nice efficient case where we can do it without modifying the lower
> page tables at all, we just move the PMD entry.

Hi Linus,

I reproduced Naresh's issue on a 32-bit x86 machine and the below patch fixes it.
The issue is solely within execve() itself and the way it allocates/copies the
temporary stack.

It is actually indeed an overlapping case because the length of the
stack is big enough to cause overlap. The VMA grows quite a bit because of
all the page faults that happen due to the copy of the args/env. Then during
the move of overlapped region, it finds that a PMD is already allocated.

The below patch fixes it and is not warning anymore in 30 minutes of testing
so far.

Naresh, could you also test the below patch on your setup?

thanks,

 - Joel

---8<-----------------------

From: Joel Fernandes <joelaf@google.com>
Subject: [PATCH] fs/exec: Fix stack overlap issue during stack moving in i386

When running LTP's thp01 test, it is observed that a warning fires in
move_page_tables() because a PMD is already allocated.

This happens because there is an address space overlap between the
temporary stack created and the range it is being moved to when the
move_page_tables() is requested. During the move_page_tables() loop, it
picks the same valid PMD that was already allocated for the temporary
stack.  This loop requires the PMD to be new or it warns.  Making sure
the new location of the stack is non-overlapping with the old location
makes the warning go away.

Fixes: b6a2fea39318e ("mm: variable length argument support").
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 fs/exec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index e6e8a9a703278..a270205228a1a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -755,6 +755,10 @@ int setup_arg_pages(struct linux_binprm *bprm,
 
 	stack_shift = vma->vm_end - stack_top;
 
+	/* Ensure the temporary stack is shifted by atleast its size */
+	if (stack_shift < (vma->vm_end - vma->vm_start))
+		stack_shift = (vma->vm_end - vma->vm_start);
+
 	bprm->p -= stack_shift;
 	mm->arg_start = bprm->p;
 #endif
-- 
2.27.0.383.g050319c2ae-goog

