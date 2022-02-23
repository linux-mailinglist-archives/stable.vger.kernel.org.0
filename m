Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E974F4C1C27
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 20:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbiBWTaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 14:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239342AbiBWTaN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 14:30:13 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1607147AE7
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 11:29:45 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id ev16-20020a17090aead000b001bc3835fea8so3992582pjb.0
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 11:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rcZtDDDiBwFJfxUmlCOz3RDMEXHNKOOpzN1iEr3gL5U=;
        b=QWBzyrjZbDyYSLOvasncoWEYru0Moni/yVGRO01JjZbgsx9D2Olu/maNAtD0effRNG
         wNYTVyenRE2iN8/gxF8zvDFIp1czImRucV3q+rH/Db4mDxfkNsMa5DdPNA12q8f3hQw0
         CGhSrzqNOX9eTGM8sUUHgDxFqNl+jJQdeU/Ko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rcZtDDDiBwFJfxUmlCOz3RDMEXHNKOOpzN1iEr3gL5U=;
        b=UHCp41ylHM2RjGH/2ZJPJcxgxSHcsFh1kPFcyZgoNIRmRVe+TuFStdgMA0KpGr0Olr
         l3bHpT/FmafraVZJ9FnYQDLcupnkZ5GXejsim1/s/F9NulWsbZ8vhIno0XPo6F32TOZz
         JBAo4ati4nQRVs2LmYHK/qAK+Zyly53xvnsrq61B5WCapW2KK/JsQnE778IgU5tOcJEc
         GdvDoicucAa7e8VuZnTnwoTC5t+U+ny8Xj274vIATK5zjdjeFV1NjL08FvMGtTN7c1ud
         hyb38EWhVZmfOOohT+NPlK6RFOUsRQ+Q2WE4GSoNcJG5q+tkbnchiP24/aXcSdAwGEKQ
         jkfA==
X-Gm-Message-State: AOAM531SYJBsAxz/3D4c3Re4BgX5QLHcdsn49yyhknKOJlBy4LN5F5qk
        xXhqDJQ6heX8l2I54lf6JVu1XA==
X-Google-Smtp-Source: ABdhPJxlXjAtTppGbdCoaBZt4izIbAhB7dGQ5TNK+YADNjZYa3D+4W9K2F3X6jY0EE0TLHnQMMfldA==
X-Received: by 2002:a17:902:ab12:b0:14f:ce60:2ae4 with SMTP id ik18-20020a170902ab1200b0014fce602ae4mr1048141plb.87.1645644584562;
        Wed, 23 Feb 2022 11:29:44 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id on17sm246496pjb.40.2022.02.23.11.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 11:29:44 -0800 (PST)
Date:   Wed, 23 Feb 2022 11:29:43 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jann Horn <jannh@google.com>
Cc:     Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] pstore: Don't use semaphores in always-atomic-context
 code
Message-ID: <202202231128.E7445769AD@keescook>
References: <20220218181950.1438236-1-jannh@google.com>
 <8D85619E-99BD-4DB5-BDDB-A205B057C910@chromium.org>
 <CAG48ez0UJDBzoaB4=c0Uju6L-eZvhWMdnzAp8N3QfeERbzYv2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0UJDBzoaB4=c0Uju6L-eZvhWMdnzAp8N3QfeERbzYv2w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 23, 2022 at 06:50:52PM +0100, Jann Horn wrote:
> On Wed, Feb 23, 2022 at 8:50 AM Kees Cook <keescook@chromium.org> wrote:
> > On February 18, 2022 10:19:50 AM PST, Jann Horn <jannh@google.com> wrote:
> > >pstore_dump() is *always* invoked in atomic context (nowadays in an RCU
> > >read-side critical section, before that under a spinlock).
> > >It doesn't make sense to try to use semaphores here.
> >
> > Ah, very nice. Thanks for the analysis!
> >
> > >[...]
> > >-static bool pstore_cannot_wait(enum kmsg_dump_reason reason)
> > >+bool pstore_cannot_block_path(enum kmsg_dump_reason reason)
> >
> > Why the rename,
> 
> That's one of the parts of commit ea84b580b955 that I included in the
> revert. "wait" in the name is not accurate, since "wait" in the kernel
> normally refers to scheduling away until some condition is fulfilled.
> (Though I guess "block" also isn't the best name either... idk.) The
> place where we might want to have different behavior depending on
> whether we're handling a kernel crash are spinlocks; during a kernel
> crash, we shouldn't deadlock on them, but otherwise, AFAIK it's fine
> to block on them.

Gotcha. I'm find to avoid "wait"; I was just curious why it was
changing, but I see now.

> 
> > extern, and EXPORT? This appears to still only have the same single caller?
> 
> Also part of the revert. I figured it might make sense to also revert
> that part because:
> 
> With this commit applied, the EFI code will always take the "nonblock"
> path for now, but that's kinda suboptimal; on some platforms the
> "blocking" path uses a semaphore, so we really can't take that, but on
> x86 it uses a spinlock, which we could block on if we're not oopsing.
> We could avoid needlessly losing non-crash dmesg dumps there; I don't
> know whether we care about that though.
> 
> So I figured that we might want to start adding new callers to this
> later on. But if you want, I'll remove that part of the revert and
> resend?

Yeah, let's just keep this static -- there's no reason to export it.

> 
> > > [...]
> > >-                      pr_err("dump skipped in %s path: may corrupt error record\n",
> > >-                              in_nmi() ? "NMI" : why);
> > >-                      return;
> > >-              }
> > >-              if (down_interruptible(&psinfo->buf_lock)) {
> > >-                      pr_err("could not grab semaphore?!\n");
> > >+      if (pstore_cannot_block_path(reason)) {
> > >+              if (!spin_trylock_irqsave(&psinfo->buf_lock, flags)) {
> > >+                      pr_err("dump skipped in %s path because of concurrent dump\n"
> > >+                                     , in_nmi() ? "NMI" : why);
> >
> > The pr_err had the comma following the format string moved,
> 
> Ah, whoops, that was also part of the revert, but I guess I should
> have left that part out...
> 
> > and the note about corruption removed. Is that no longer accurate?
> 
> There should be no more corruption since commit 959217c84c27 ("pstore:
> Actually give up during locking failure") - if we're bailing out, we
> can't be causing corruption, I believe?

Yeah, agreed. String content change is fine, the weird leading comma I'd
like to do without. :)

Thanks!

-- 
Kees Cook
