Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BC52041D3
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 22:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgFVUTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 16:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728795AbgFVUTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 16:19:02 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6E7C061573
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 13:19:01 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n24so19356016ejd.0
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 13:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KPToc3YBMAKu4Sqe1+lHQgmg7EgNUpmHiaB33zpdCKg=;
        b=RFzR7n+EukCyGRIl5ZH607BxuvZz9EIxV/PcrSwnjOoXGP7LL4QjI+qNPkJcvM6I1F
         +N9N+qCcBwoQNl/C9n6P59foBIW2m/iHabsK/YdRHmyRAbktBgfMbk/GAO6jxlz0anhX
         um+KG8Bm50oo/3iGTiIre1OvTa16PfHFj+eCQlOdYYCLzI+UnfBhDhp4k2CU30F9WHb2
         5VJ4h/fGIJ9K9mZsyBl0YkMq+y1jv2UdbluBX5Q7HmcGWEakEMTQP1joQnclIULu4Wtv
         yToNGVe7DLTrGkXJ2U36D0o60FtxUTV112jghkGLbXONZ3rTxiipA8ScRsezBt4oQbRM
         2Ktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KPToc3YBMAKu4Sqe1+lHQgmg7EgNUpmHiaB33zpdCKg=;
        b=VzP5uHVku1HdCr57pm9ltva1oz5wXh9DVA0hw8QCYUwJKNuEWhnGJ/Dbfj/5t8miM/
         X0cixykNNJgOV50dVaw2jvnbhIn9+X2bdujRiTkZ4oa2QPcBTjz3DnuLn/9omgMDKzad
         i/MJAmXG1sdNy2eJRRLuZDA96p+TSTb6jSOTGMVKqNIt07TIF8+3FNhNhplLMg+Ydp1L
         cT919Khjszw4XeKnyCTCGzDrKqahAnVBpGBPWDojIcNs41Mv2ya4BhtqTu1/wBA2Bje+
         ky3Ch+toiVBTlNMgokyieAJPA3qV05Mchyc+Q6BIa7rB2mWoHXbWvgF3jQLNyhQS1oHA
         eLkA==
X-Gm-Message-State: AOAM533FdBA+noHOiTfkgOsIU2bTMJIdlo8x0xp4puh7zCm0/jYAbF/M
        YJbx/oA9Gy7eYx8BVzYZpZ9pBWNCkQQ98RunR4Qi6g==
X-Google-Smtp-Source: ABdhPJyEjZBpXe2Z+1r2XCfvhXjpGrnv0VLgfmHd97Bn40DjEQCJ+RtVxug+FXeaJbVKVXFde4ulV23N9aUH9P4ABRI=
X-Received: by 2002:a17:906:69c3:: with SMTP id g3mr18232972ejs.47.1592857139968;
 Mon, 22 Jun 2020 13:18:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200622200715.114382-1-tkjos@google.com> <20200622200955.unq7elx2ry2vrnfe@wittgenstein>
In-Reply-To: <20200622200955.unq7elx2ry2vrnfe@wittgenstein>
From:   Todd Kjos <tkjos@google.com>
Date:   Mon, 22 Jun 2020 13:18:47 -0700
Message-ID: <CAHRSSExVfUhkXzhuEUvUP-CTwSE7ExWwYCL8K_N+YABW9C1BzQ@mail.gmail.com>
Subject: Re: [PATCH] binder: fix null deref of proc->context
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Brauner <christian@brauner.io>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martijn Coenen <maco@google.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Android Kernel Team <kernel-team@android.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 1:09 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Mon, Jun 22, 2020 at 01:07:15PM -0700, Todd Kjos wrote:
> > The binder driver makes the assumption proc->context pointer is invariant after
> > initialization (as documented in the kerneldoc header for struct proc).
> > However, in commit f0fe2c0f050d ("binder: prevent UAF for binderfs devices II")
> > proc->context is set to NULL during binder_deferred_release().
> >
> > Another proc was in the middle of setting up a transaction to the dying
> > process and crashed on a NULL pointer deref on "context" which is a local
> > set to &proc->context:
> >
> >     new_ref->data.desc = (node == context->binder_context_mgr_node) ? 0 : 1;
> >
> > Here's the stack:
> >
> > [ 5237.855435] Call trace:
> > [ 5237.855441] binder_get_ref_for_node_olocked+0x100/0x2ec
> > [ 5237.855446] binder_inc_ref_for_node+0x140/0x280
> > [ 5237.855451] binder_translate_binder+0x1d0/0x388
> > [ 5237.855456] binder_transaction+0x2228/0x3730
> > [ 5237.855461] binder_thread_write+0x640/0x25bc
> > [ 5237.855466] binder_ioctl_write_read+0xb0/0x464
> > [ 5237.855471] binder_ioctl+0x30c/0x96c
> > [ 5237.855477] do_vfs_ioctl+0x3e0/0x700
> > [ 5237.855482] __arm64_sys_ioctl+0x78/0xa4
> > [ 5237.855488] el0_svc_common+0xb4/0x194
> > [ 5237.855493] el0_svc_handler+0x74/0x98
> > [ 5237.855497] el0_svc+0x8/0xc
> >
> > The fix is to move the kfree of the binder_device to binder_free_proc()
> > so the binder_device is freed when we know there are no references
> > remaining on the binder_proc.
> >
> > Fixes: f0fe2c0f050d ("binder: prevent UAF for binderfs devices II")
> > Signed-off-by: Todd Kjos <tkjos@google.com>

Forgot to include stable. The issue was introduced in 5.6, so fix needed in 5.7.
Cc: stable@vger.kernel.org # 5.7


>
>
> Thanks, looks good to me!
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
>
> Christian
>
> > ---
> >  drivers/android/binder.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> > index e47c8a4c83db..f50c5f182bb5 100644
> > --- a/drivers/android/binder.c
> > +++ b/drivers/android/binder.c
> > @@ -4686,8 +4686,15 @@ static struct binder_thread *binder_get_thread(struct binder_proc *proc)
> >
> >  static void binder_free_proc(struct binder_proc *proc)
> >  {
> > +     struct binder_device *device;
> > +
> >       BUG_ON(!list_empty(&proc->todo));
> >       BUG_ON(!list_empty(&proc->delivered_death));
> > +     device = container_of(proc->context, struct binder_device, context);
> > +     if (refcount_dec_and_test(&device->ref)) {
> > +             kfree(proc->context->name);
> > +             kfree(device);
> > +     }
> >       binder_alloc_deferred_release(&proc->alloc);
> >       put_task_struct(proc->tsk);
> >       binder_stats_deleted(BINDER_STAT_PROC);
> > @@ -5406,7 +5413,6 @@ static int binder_node_release(struct binder_node *node, int refs)
> >  static void binder_deferred_release(struct binder_proc *proc)
> >  {
> >       struct binder_context *context = proc->context;
> > -     struct binder_device *device;
> >       struct rb_node *n;
> >       int threads, nodes, incoming_refs, outgoing_refs, active_transactions;
> >
> > @@ -5423,12 +5429,6 @@ static void binder_deferred_release(struct binder_proc *proc)
> >               context->binder_context_mgr_node = NULL;
> >       }
> >       mutex_unlock(&context->context_mgr_node_lock);
> > -     device = container_of(proc->context, struct binder_device, context);
> > -     if (refcount_dec_and_test(&device->ref)) {
> > -             kfree(context->name);
> > -             kfree(device);
> > -     }
> > -     proc->context = NULL;
> >       binder_inner_proc_lock(proc);
> >       /*
> >        * Make sure proc stays alive after we
> > --
> > 2.27.0.111.gc72c7da667-goog
> >
