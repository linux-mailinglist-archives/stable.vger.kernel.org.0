Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150DB289C84
	for <lists+stable@lfdr.de>; Sat, 10 Oct 2020 01:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728586AbgJIX6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 19:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728484AbgJIX4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 19:56:06 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE71FC0613D5
        for <stable@vger.kernel.org>; Fri,  9 Oct 2020 16:56:05 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id e22so15504996ejr.4
        for <stable@vger.kernel.org>; Fri, 09 Oct 2020 16:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IPdxDQlENWSfpPb8m9w3VUBFTBbLxzL+QHT5Q7alVxQ=;
        b=fQdIh4djnuSGMfj9MCXUJcK54rVHbGql/S9bIo7zmGk9Re0VAHTGytb0ofHe8mw6Ax
         xRgaVCL7B7U4Zt6fw9jgw660MQP2zNBp+7O9/qYsD6usesAohUkrI/kueIKcNUKfH9vz
         Ka1y4WgPbRZjyp5O86H9w09HZZXp53fDg6UOzktbTln2uzRsx0T9lDud9lxkiiOtG7Nw
         Qe9F8VwfMB4e/E+eE5/z+Wsy9to7HVVe796FQqczGtKybt4WYf8Wirpi7YmfmWumsy/0
         xeYi7voQwgnBTRbSVBfcmvd4/JIAVha3hk3waHsIl/aDmXZ1om3ycqWnnvQc4Y7ov8ks
         NYlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IPdxDQlENWSfpPb8m9w3VUBFTBbLxzL+QHT5Q7alVxQ=;
        b=dUlgzGg8xPDZ8SdaUNB5p7Rs40ZzlZsVrpTTT9GabWNO+3s5NPkuUmEzExRXcl6PxU
         +VX4cki45vhHL4nEOdjCf2jn1NF8trNmpKBqft6Zr8GiD83CdWoyNFlDVf4yG9rZlqqY
         BCIQKqVvVfF6W4TsIyG/8VXbvx2+bVzZvwi2HkZlJYVZ3W6dAKy7MTVbyypsQJ1JHQNa
         ptAIXFddH62ipygUcTEUX0ymn35DCt8wXe0Z+mhPFIe9ktbu00j3NuQ926BQeZNrf0Lm
         Kw24VnCAv9oqENcZW1EzTBgM0iM3Db00C6DxCem2sy/ehqClbxZWxJEWdRD6o8XEXDr0
         WVBQ==
X-Gm-Message-State: AOAM532eQbMCfuMfhnw4vyY0i/28f5OVxWuj+B6jqLmQmHeUuP6MX2c9
        gDT4+K/j+0dSkV1LYKeJFUWvRFE+ObBDgYtMymd2uA==
X-Google-Smtp-Source: ABdhPJwqk+RVMoDkKaaEGsG8HZa5eoeMNPMDOI2JXZqb17BCRC3S4AOUoW9xsq+Qq2lMMjnQhm2GKqi+W4Z2+M/alLE=
X-Received: by 2002:a17:906:c007:: with SMTP id e7mr16875732ejz.55.1602287764312;
 Fri, 09 Oct 2020 16:56:04 -0700 (PDT)
MIME-Version: 1.0
References: <20201009232455.4054810-1-tkjos@google.com>
In-Reply-To: <20201009232455.4054810-1-tkjos@google.com>
From:   Todd Kjos <tkjos@google.com>
Date:   Fri, 9 Oct 2020 16:55:52 -0700
Message-ID: <CAHRSSEwtW7xKAA=qAmZpHvkdaVvz=cAPwF+8NUUE51+p4tgNBg@mail.gmail.com>
Subject: Re: [PATCH] binder: fix UAF when releasing todo list
To:     Todd Kjos <tkjos@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Brauner <christian@brauner.io>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martijn Coenen <maco@google.com>
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Android Kernel Team <kernel-team@android.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 9, 2020 at 4:24 PM Todd Kjos <tkjos@google.com> wrote:
>
> When releasing a thread todo list when tearing down
> a binder_proc, the following race was possible which
> could result in a use-after-free:
>
> 1.  Thread 1: enter binder_release_work from binder_thread_release
> 2.  Thread 2: binder_update_ref_for_handle() -> binder_dec_node_ilocked()
> 3.  Thread 2: dec nodeA --> 0 (will free node)
> 4.  Thread 1: ACQ inner_proc_lock
> 5.  Thread 2: block on inner_proc_lock
> 6.  Thread 1: dequeue work (BINDER_WORK_NODE, part of nodeA)
> 7.  Thread 1: REL inner_proc_lock
> 8.  Thread 2: ACQ inner_proc_lock
> 9.  Thread 2: todo list cleanup, but work was already dequeued
> 10. Thread 2: free node
> 11. Thread 2: REL inner_proc_lock
> 12. Thread 1: deref w->type (UAF)
>
> The problem was that for a BINDER_WORK_NODE, the binder_work element
> must not be accessed after releasing the inner_proc_lock while
> processing the todo list elements since another thread might be
> handling a deref on the node containing the binder_work element
> leading to the node being freed.
>
> Signed-off-by: Todd Kjos <tkjos@google.com>

Cc: <stable@vger.kernel.org> # 4.14, 4.19, 5.4, 5.8

> ---
>  drivers/android/binder.c | 35 ++++++++++-------------------------
>  1 file changed, 10 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> index f936530a19b0..e8a1db4a86ed 100644
> --- a/drivers/android/binder.c
> +++ b/drivers/android/binder.c
> @@ -223,7 +223,7 @@ static struct binder_transaction_log_entry *binder_transaction_log_add(
>  struct binder_work {
>         struct list_head entry;
>
> -       enum {
> +       enum binder_work_type {
>                 BINDER_WORK_TRANSACTION = 1,
>                 BINDER_WORK_TRANSACTION_COMPLETE,
>                 BINDER_WORK_RETURN_ERROR,
> @@ -885,27 +885,6 @@ static struct binder_work *binder_dequeue_work_head_ilocked(
>         return w;
>  }
>
> -/**
> - * binder_dequeue_work_head() - Dequeues the item at head of list
> - * @proc:         binder_proc associated with list
> - * @list:         list to dequeue head
> - *
> - * Removes the head of the list if there are items on the list
> - *
> - * Return: pointer dequeued binder_work, NULL if list was empty
> - */
> -static struct binder_work *binder_dequeue_work_head(
> -                                       struct binder_proc *proc,
> -                                       struct list_head *list)
> -{
> -       struct binder_work *w;
> -
> -       binder_inner_proc_lock(proc);
> -       w = binder_dequeue_work_head_ilocked(list);
> -       binder_inner_proc_unlock(proc);
> -       return w;
> -}
> -
>  static void
>  binder_defer_work(struct binder_proc *proc, enum binder_deferred_state defer);
>  static void binder_free_thread(struct binder_thread *thread);
> @@ -4587,13 +4566,17 @@ static void binder_release_work(struct binder_proc *proc,
>                                 struct list_head *list)
>  {
>         struct binder_work *w;
> +       enum binder_work_type wtype;
>
>         while (1) {
> -               w = binder_dequeue_work_head(proc, list);
> +               binder_inner_proc_lock(proc);
> +               w = binder_dequeue_work_head_ilocked(list);
> +               wtype = w ? w->type : 0;
> +               binder_inner_proc_unlock(proc);
>                 if (!w)
>                         return;
>
> -               switch (w->type) {
> +               switch (wtype) {
>                 case BINDER_WORK_TRANSACTION: {
>                         struct binder_transaction *t;
>
> @@ -4627,9 +4610,11 @@ static void binder_release_work(struct binder_proc *proc,
>                         kfree(death);
>                         binder_stats_deleted(BINDER_STAT_DEATH);
>                 } break;
> +               case BINDER_WORK_NODE:
> +                       break;
>                 default:
>                         pr_err("unexpected work type, %d, not freed\n",
> -                              w->type);
> +                              wtype);
>                         break;
>                 }
>         }
> --
> 2.28.0.1011.ga647a8990f-goog
>
