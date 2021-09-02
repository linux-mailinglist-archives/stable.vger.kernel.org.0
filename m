Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB8D3FF04B
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 17:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345838AbhIBPgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 11:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345788AbhIBPgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 11:36:47 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A703C061575
        for <stable@vger.kernel.org>; Thu,  2 Sep 2021 08:35:49 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id h1so4330964ljl.9
        for <stable@vger.kernel.org>; Thu, 02 Sep 2021 08:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gqsE0hcACBYtzOEUSRWmq502BlYXjpyMpHHF4zb++1Y=;
        b=YvMoLhTqope6Anvbg2E/49DdR0bfBTbd3WBFEpizcH0H43hqwki7cGgzsjtRtm+AoT
         38FGEfBZmCZH/fn2WSrE++8YwficAwTcjLRvKO3D6bSuwFqVx5xBEgPxK9YLo7hVU5rj
         dPqO+SLEHJoOqbsTFmWAXZ9/nLfrf980M/fNjCa6aDWHW3jRJis7MGBQyl0ZmGZ4Gnpg
         8LO/NCLH8ziH2DY+BmiRAIvw9INsp90XK5BE73m7OhmMpz2/99leispqO6agIGSvQtXh
         1qQ6+kgAfUZY0Do2zuglHu0P6NbjVln1NC3EVkF46q0Ufila1YAXVB5lZAvfabZFqDG5
         YACg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gqsE0hcACBYtzOEUSRWmq502BlYXjpyMpHHF4zb++1Y=;
        b=JzcFasJ340fHXlwUGHtcraJLy08vXMKQRRDumeM9l95WkzF8pUe2X+LX0MQq9nPiyH
         UQr4Jo0rlphDSa50CBQnMWRXcuZ+WsfvM/IeTND/3KxKRLRYMN0eQSt/nHxSKaVz9s74
         m2cEfUoDR438BjyqruGVQhnw7daSrL6Oj3I9E6YNO5ko3EISCWnZr5WZhB93xDv9PMeD
         1DgIbYLYyv6wyFzQyO3JT/vfqB92QRI6swwcVi8c6tVGj1rnwJE2zdnfyWzYgThT4Y4j
         oqJMEk/4WSHtmwjrgUaklbjUfxr5QvSeQJrGoACUsR38lrc5pJ4kB2DSuv0SFw+jQPxk
         0duA==
X-Gm-Message-State: AOAM533rUH5RJLoxpS7grGqThPtswlMovdFJOPwaaTBWFnuzsb7h68OA
        UmrTvTkM3CLbeW9fB/jLgN1E3Sdv3qn0SpCx5BARAg==
X-Google-Smtp-Source: ABdhPJzJ2ZXLD2ye7fiTVTjas7hr69B87RP5P3F3ORamACWW63F58/LqhV8yp2vp3VXog/b65mHOHs0VwizfSYBzHlQ=
X-Received: by 2002:a05:651c:118f:: with SMTP id w15mr3130589ljo.47.1630596947384;
 Thu, 02 Sep 2021 08:35:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210830195146.587206-1-tkjos@google.com> <CAB0TPYFmUgPTONABLTJAdonK7fY7oqURKCpLp1-WqHLtyen7Zw@mail.gmail.com>
In-Reply-To: <CAB0TPYFmUgPTONABLTJAdonK7fY7oqURKCpLp1-WqHLtyen7Zw@mail.gmail.com>
From:   Todd Kjos <tkjos@google.com>
Date:   Thu, 2 Sep 2021 08:35:35 -0700
Message-ID: <CAHRSSExONtUFu0Mb8uJeVKcyDYb8=1PO7a=aQ=DUEpA5kAcTQA@mail.gmail.com>
Subject: Re: [PATCH] binder: make sure fd closes complete
To:     Martijn Coenen <maco@android.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Christian Brauner <christian@brauner.io>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martijn Coenen <maco@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        kernel-team@android.com, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 31, 2021 at 12:24 AM Martijn Coenen <maco@android.com> wrote:
>
> On Mon, Aug 30, 2021 at 9:51 PM 'Todd Kjos' via kernel-team
> <kernel-team@android.com> wrote:
> >
> > During BC_FREE_BUFFER processing, the BINDER_TYPE_FDA object
> > cleanup may close 1 or more fds. The close operations are
> > completed using the task work mechanism -- which means the thread
> > needs to return to userspace or the file object may never be
> > dereferenced -- which can lead to hung processes.
> >
> > Force the binder thread back to userspace if an fd is closed during
> > BC_FREE_BUFFER handling.
> >
> > Signed-off-by: Todd Kjos <tkjos@google.com>
> Reviewed-by: Martijn Coenen <maco@android.com>

Please also add to stable releases 5.4 and later.

>
> > ---
> >  drivers/android/binder.c | 23 +++++++++++++++++------
> >  1 file changed, 17 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> > index bcec598b89f2..c2823f0d588f 100644
> > --- a/drivers/android/binder.c
> > +++ b/drivers/android/binder.c
> > @@ -1852,6 +1852,7 @@ static void binder_deferred_fd_close(int fd)
> >  }
> >
> >  static void binder_transaction_buffer_release(struct binder_proc *proc,
> > +                                             struct binder_thread *thread,
> >                                               struct binder_buffer *buffer,
> >                                               binder_size_t failed_at,
> >                                               bool is_failure)
> > @@ -2011,8 +2012,16 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
> >                                                 &proc->alloc, &fd, buffer,
> >                                                 offset, sizeof(fd));
> >                                 WARN_ON(err);
> > -                               if (!err)
> > +                               if (!err) {
> >                                         binder_deferred_fd_close(fd);
> > +                                       /*
> > +                                        * Need to make sure the thread goes
> > +                                        * back to userspace to complete the
> > +                                        * deferred close
> > +                                        */
> > +                                       if (thread)
> > +                                               thread->looper_need_return = true;
> > +                               }
> >                         }
> >                 } break;
> >                 default:
> > @@ -3105,7 +3114,7 @@ static void binder_transaction(struct binder_proc *proc,
> >  err_copy_data_failed:
> >         binder_free_txn_fixups(t);
> >         trace_binder_transaction_failed_buffer_release(t->buffer);
> > -       binder_transaction_buffer_release(target_proc, t->buffer,
> > +       binder_transaction_buffer_release(target_proc, NULL, t->buffer,
> >                                           buffer_offset, true);
> >         if (target_node)
> >                 binder_dec_node_tmpref(target_node);
> > @@ -3184,7 +3193,9 @@ static void binder_transaction(struct binder_proc *proc,
> >   * Cleanup buffer and free it.
> >   */
> >  static void
> > -binder_free_buf(struct binder_proc *proc, struct binder_buffer *buffer)
> > +binder_free_buf(struct binder_proc *proc,
> > +               struct binder_thread *thread,
> > +               struct binder_buffer *buffer)
> >  {
> >         binder_inner_proc_lock(proc);
> >         if (buffer->transaction) {
> > @@ -3212,7 +3223,7 @@ binder_free_buf(struct binder_proc *proc, struct binder_buffer *buffer)
> >                 binder_node_inner_unlock(buf_node);
> >         }
> >         trace_binder_transaction_buffer_release(buffer);
> > -       binder_transaction_buffer_release(proc, buffer, 0, false);
> > +       binder_transaction_buffer_release(proc, thread, buffer, 0, false);
> >         binder_alloc_free_buf(&proc->alloc, buffer);
> >  }
> >
> > @@ -3414,7 +3425,7 @@ static int binder_thread_write(struct binder_proc *proc,
> >                                      proc->pid, thread->pid, (u64)data_ptr,
> >                                      buffer->debug_id,
> >                                      buffer->transaction ? "active" : "finished");
> > -                       binder_free_buf(proc, buffer);
> > +                       binder_free_buf(proc, thread, buffer);
> >                         break;
> >                 }
> >
> > @@ -4107,7 +4118,7 @@ static int binder_thread_read(struct binder_proc *proc,
> >                         buffer->transaction = NULL;
> >                         binder_cleanup_transaction(t, "fd fixups failed",
> >                                                    BR_FAILED_REPLY);
> > -                       binder_free_buf(proc, buffer);
> > +                       binder_free_buf(proc, thread, buffer);
> >                         binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
> >                                      "%d:%d %stransaction %d fd fixups failed %d/%d, line %d\n",
> >                                      proc->pid, thread->pid,
> > --
> > 2.33.0.259.gc128427fd7-goog
> >
> >
