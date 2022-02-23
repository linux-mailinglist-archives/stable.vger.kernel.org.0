Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30CB4C1A3A
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 18:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbiBWRvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 12:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240455AbiBWRvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 12:51:51 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E10615A
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 09:51:20 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id r20so25833182ljj.1
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 09:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RrdEVsjsD+nqXmQqBvUEIQg+R+7+UWVmueHZbvxi/fY=;
        b=HrqUskcTi7myVyE20lUHGxJ5Cbqhrcee6XGl5vkm8NnzpACCfPRFm/+h5jJFvLnJIH
         J09n5gnVJYBhqvTpCNt326dmBcHXVR9YUWVcgJOUx74XOdS76Di+Wn+9quQYy+pi6ymr
         AsBJ+RxttBSyKX71ZYQ6bNvnrcXsiJ1bMJZvziOq0mEDMa/C6SnANiHyPjCmlEDftBo/
         /dmao04eFUAwrM4TWxdQ2+Jv6uDUNIJ/Y7xhQ5+9z5AGuZ7My4MfYahlXf0wQULDAW0S
         WUl4lShCV5B1BEGM+itp8+KvXaDTINCwBbb3TuBr8OUEIxfhmCSDYRJNrwhzTrZlOXR8
         AoMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RrdEVsjsD+nqXmQqBvUEIQg+R+7+UWVmueHZbvxi/fY=;
        b=Fq11Zf3y5qgD36lj5itSLFqmgQUHHMy6IvnS6ocjU1xjNM9mJ/+gUUyutHdZ8UWZht
         NAaZzgHG0a1TnG2xr3bHBkJ8TTn0Rj+e24aaTU96QAtB9sn8rj50ae9AYAzXoxjmAR49
         2VqnxCDW0vwdoWrQYe06E0mRmH6hPu1rc2C+HKRQa7GpbYDER+vaXCLnICGxL9XNUJrh
         PO2gUtfSNwXw9PpMLfcPuAawrz9gDlOufST0hgQ8/dI5om9WTLuwnGEYHCTrJ2HdTcEM
         oRvliHauvrsgHf4KAHKijdAS/2JpRnobVDKTVx1/S0X7Dljl2VF7ogcc5NN6ILyP4oVY
         THzQ==
X-Gm-Message-State: AOAM530uSqdx3rqWLQtc4/KsEYasnEPkg6jlAmd12+A60K7HrUcKbNYf
        xZu/zvsuNHy3hLd/aabWcFWi85KkBHv60yfiVAByrw==
X-Google-Smtp-Source: ABdhPJyy2+PbEHWjK5m1pGy4RMoMiz8/1ddYOLWwa6WdZj216uctOj7fPykTeNcuWhj9vtR5ujN+1LSrAt9hQfe4l5g=
X-Received: by 2002:a2e:b78f:0:b0:246:6331:c1bc with SMTP id
 n15-20020a2eb78f000000b002466331c1bcmr378483ljo.188.1645638679148; Wed, 23
 Feb 2022 09:51:19 -0800 (PST)
MIME-Version: 1.0
References: <20220218181950.1438236-1-jannh@google.com> <8D85619E-99BD-4DB5-BDDB-A205B057C910@chromium.org>
In-Reply-To: <8D85619E-99BD-4DB5-BDDB-A205B057C910@chromium.org>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 23 Feb 2022 18:50:52 +0100
Message-ID: <CAG48ez0UJDBzoaB4=c0Uju6L-eZvhWMdnzAp8N3QfeERbzYv2w@mail.gmail.com>
Subject: Re: [PATCH v2] pstore: Don't use semaphores in always-atomic-context code
To:     Kees Cook <keescook@chromium.org>
Cc:     Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 23, 2022 at 8:50 AM Kees Cook <keescook@chromium.org> wrote:
> On February 18, 2022 10:19:50 AM PST, Jann Horn <jannh@google.com> wrote:
> >pstore_dump() is *always* invoked in atomic context (nowadays in an RCU
> >read-side critical section, before that under a spinlock).
> >It doesn't make sense to try to use semaphores here.
>
> Ah, very nice. Thanks for the analysis!
>
> >[...]
> >-static bool pstore_cannot_wait(enum kmsg_dump_reason reason)
> >+bool pstore_cannot_block_path(enum kmsg_dump_reason reason)
>
> Why the rename,

That's one of the parts of commit ea84b580b955 that I included in the
revert. "wait" in the name is not accurate, since "wait" in the kernel
normally refers to scheduling away until some condition is fulfilled.
(Though I guess "block" also isn't the best name either... idk.) The
place where we might want to have different behavior depending on
whether we're handling a kernel crash are spinlocks; during a kernel
crash, we shouldn't deadlock on them, but otherwise, AFAIK it's fine
to block on them.

> extern, and EXPORT? This appears to still only have the same single caller?

Also part of the revert. I figured it might make sense to also revert
that part because:

With this commit applied, the EFI code will always take the "nonblock"
path for now, but that's kinda suboptimal; on some platforms the
"blocking" path uses a semaphore, so we really can't take that, but on
x86 it uses a spinlock, which we could block on if we're not oopsing.
We could avoid needlessly losing non-crash dmesg dumps there; I don't
know whether we care about that though.

So I figured that we might want to start adding new callers to this
later on. But if you want, I'll remove that part of the revert and
resend?

> > [...]
> >-                      pr_err("dump skipped in %s path: may corrupt error record\n",
> >-                              in_nmi() ? "NMI" : why);
> >-                      return;
> >-              }
> >-              if (down_interruptible(&psinfo->buf_lock)) {
> >-                      pr_err("could not grab semaphore?!\n");
> >+      if (pstore_cannot_block_path(reason)) {
> >+              if (!spin_trylock_irqsave(&psinfo->buf_lock, flags)) {
> >+                      pr_err("dump skipped in %s path because of concurrent dump\n"
> >+                                     , in_nmi() ? "NMI" : why);
>
> The pr_err had the comma following the format string moved,

Ah, whoops, that was also part of the revert, but I guess I should
have left that part out...

> and the note about corruption removed. Is that no longer accurate?

There should be no more corruption since commit 959217c84c27 ("pstore:
Actually give up during locking failure") - if we're bailing out, we
can't be causing corruption, I believe?
