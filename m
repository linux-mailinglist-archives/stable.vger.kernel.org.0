Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52FA91623E6
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 10:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgBRJvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 04:51:20 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:37407 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbgBRJvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 04:51:20 -0500
Received: by mail-oi1-f193.google.com with SMTP id q84so19517910oic.4;
        Tue, 18 Feb 2020 01:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q9Gjsa9/6oGNsmYc7mbK5lPLpQ29U355T0PNctFAqho=;
        b=ILRl5+Z37yt15KdT1A/JmocBYVojPW5PE+ZcxVtcZpp4nIous5aDE2OrHWsZDC6DQ3
         4w8vopfFKPCoMBVRfNmwcbTmLmOXWDV5ywkykHwrtTk9rpisKmcvOR+G5xvXODqG9NU1
         LjiRxCo5LF1sMD/fqFoUUKNdGibD15ea9FWpmQd0G/EDDGDNDIqumdgRojo6xLUksi89
         kl7xri3Xrz/yq8iXD9MpweMnmPNsgeTwe+anwQP6LWuhujeK2N/9Y6t5FQtSSJ78OSmZ
         mJAurtcLw1JSZJGu4RZMiGslNNkhfDna0d6xUGsv1JR1uU/bjtaZzMfGjdMFyzQFEmZT
         Ma5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q9Gjsa9/6oGNsmYc7mbK5lPLpQ29U355T0PNctFAqho=;
        b=ERQJkVrYGK0x00Ywf39uw6zRPJFPsYF2txcHtTHXIXpF3kRnViu5+rVLMAEZNtsVLj
         e7LKFm2f6Qwjs3k1E9+OoMZ8WaAzRGXE0QSkg8yljHCLLYmGS5bI5IPZjuOwkGl0699o
         POdMq5UDZz53G6NEOhuscongy/+JCdJhMIGWyEFXHxSvsev+uwBLLoKmxW6scBxtJm9B
         E7QCEyTOlhbCd5LrX6JeDcAKGF3OI/NfwU36Llu0UP+TX1TWfvYqPBWkuQguvpQLRaP1
         +5SlSFu3saeIoCUO1mkTIP/Ig0INkcpguy/iQErHd/xBWmVjQv3eOQsIfIELBG2sqcVI
         C9ow==
X-Gm-Message-State: APjAAAUbitDFMV1RE8jMRqK4Hm+a07FnozRVBRSLaaaImAxuGlfF4L7p
        3vhH7mrybIJ+bAbcRfkLpmjaxV4GgPvIO1xERco=
X-Google-Smtp-Source: APXvYqwSavxzRZ2fGIAGXgm8oh56+Me5dFAMDc8QcynngkHmiOevf5w8qgaQekBX/t7xMSRuGhTIDcb4Vz1AS4bUNOQ=
X-Received: by 2002:aca:cd46:: with SMTP id d67mr696104oig.156.1582019477230;
 Tue, 18 Feb 2020 01:51:17 -0800 (PST)
MIME-Version: 1.0
References: <20200214154854.6746-1-sashal@kernel.org> <20200214154854.6746-542-sashal@kernel.org>
In-Reply-To: <20200214154854.6746-542-sashal@kernel.org>
From:   Andrei Vagin <avagin@gmail.com>
Date:   Tue, 18 Feb 2020 01:51:06 -0800
Message-ID: <CANaxB-zjYecWpjMoX6dXY3B5HtVu8+G9npRnaX2FnTvp9XucTw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.5 542/542] pipe: use exclusive waits when
 reading or writing
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Linus,

This patch breaks one of CRIU tests. Here is a small reproducer:
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main()
{
  int p[2];
  pid_t p1, p2;
  int status;

  if (pipe(p) == -1)
    return 1;

  p1 = fork();
  if (p1 == 0) {
    close(p[1]);
    read(p[0], &status, sizeof(status));
    return 0;
  }
  p2 = fork();
  if (p2 == 0) {
    close(p[1]);
    read(p[0], &status, sizeof(status));
    return 0;
  }
  sleep(1);
  close(p[1]);
  wait(&status);
  wait(&status);

  return 0;
}

Here are two readers which are waiting for data but only one of them
will be woken up after closing the last writer.

The quick fix looks like this:

diff --git a/fs/pipe.c b/fs/pipe.c
index 5a34d6c22d4c..deaf67239a18 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -412,7 +412,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
                wake_up_interruptible_sync_poll(&pipe->wr_wait,
EPOLLOUT | EPOLLWRNORM);
                kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
        }
-       if (wake_next_reader)
+       if (!pipe->writers || wake_next_reader)
                wake_up_interruptible_sync_poll(&pipe->rd_wait,
EPOLLIN | EPOLLRDNORM);
        if (ret > 0)
                file_accessed(filp);

I've checked that it fixes the issue, but It is too late today to read
this code carefully, so I could skip something.

Thanks,
Andrei

On Fri, Feb 14, 2020 at 8:03 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Linus Torvalds <torvalds@linux-foundation.org>
>
> [ Upstream commit 0ddad21d3e99c743a3aa473121dc5561679e26bb ]
>
> This makes the pipe code use separate wait-queues and exclusive waiting
> for readers and writers, avoiding a nasty thundering herd problem when
> there are lots of readers waiting for data on a pipe (or, less commonly,
> lots of writers waiting for a pipe to have space).
>
> While this isn't a common occurrence in the traditional "use a pipe as a
> data transport" case, where you typically only have a single reader and
> a single writer process, there is one common special case: using a pipe
> as a source of "locking tokens" rather than for data communication.
>
> In particular, the GNU make jobserver code ends up using a pipe as a way
> to limit parallelism, where each job consumes a token by reading a byte
> from the jobserver pipe, and releases the token by writing a byte back
> to the pipe.
>
> This pattern is fairly traditional on Unix, and works very well, but
> will waste a lot of time waking up a lot of processes when only a single
> reader needs to be woken up when a writer releases a new token.
>
> A simplified test-case of just this pipe interaction is to create 64
> processes, and then pass a single token around between them (this
> test-case also intentionally passes another token that gets ignored to
> test the "wake up next" logic too, in case anybody wonders about it):
>
>     #include <unistd.h>
>
>     int main(int argc, char **argv)
>     {
>         int fd[2], counters[2];
>
>         pipe(fd);
>         counters[0] = 0;
>         counters[1] = -1;
>         write(fd[1], counters, sizeof(counters));
>
>         /* 64 processes */
>         fork(); fork(); fork(); fork(); fork(); fork();
>
>         do {
>                 int i;
>                 read(fd[0], &i, sizeof(i));
>                 if (i < 0)
>                         continue;
>                 counters[0] = i+1;
>                 write(fd[1], counters, (1+(i & 1)) *sizeof(int));
>         } while (counters[0] < 1000000);
>         return 0;
>     }
>
> and in a perfect world, passing that token around should only cause one
> context switch per transfer, when the writer of a token causes a
> directed wakeup of just a single reader.
>
> But with the "writer wakes all readers" model we traditionally had, on
> my test box the above case causes more than an order of magnitude more
> scheduling: instead of the expected ~1M context switches, "perf stat"
> shows
>
>         231,852.37 msec task-clock                #   15.857 CPUs utilized
>         11,250,961      context-switches          #    0.049 M/sec
>            616,304      cpu-migrations            #    0.003 M/sec
>              1,648      page-faults               #    0.007 K/sec
>  1,097,903,998,514      cycles                    #    4.735 GHz
>    120,781,778,352      instructions              #    0.11  insn per cycle
>     27,997,056,043      branches                  #  120.754 M/sec
>        283,581,233      branch-misses             #    1.01% of all branches
>
>       14.621273891 seconds time elapsed
>
>        0.018243000 seconds user
>        3.611468000 seconds sys
>
> before this commit.
>
> After this commit, I get
>
>           5,229.55 msec task-clock                #    3.072 CPUs utilized
>          1,212,233      context-switches          #    0.232 M/sec
>            103,951      cpu-migrations            #    0.020 M/sec
>              1,328      page-faults               #    0.254 K/sec
>     21,307,456,166      cycles                    #    4.074 GHz
>     12,947,819,999      instructions              #    0.61  insn per cycle
>      2,881,985,678      branches                  #  551.096 M/sec
>         64,267,015      branch-misses             #    2.23% of all branches
>
>        1.702148350 seconds time elapsed
>
>        0.004868000 seconds user
>        0.110786000 seconds sys
>
> instead. Much better.
>
> [ Note! This kernel improvement seems to be very good at triggering a
>   race condition in the make jobserver (in GNU make 4.2.1) for me. It's
>   a long known bug that was fixed back in June 2017 by GNU make commit
>   b552b0525198 ("[SV 51159] Use a non-blocking read with pselect to
>   avoid hangs.").
>
>   But there wasn't a new release of GNU make until 4.3 on Jan 19 2020,
>   so a number of distributions may still have the buggy version. Some
>   have backported the fix to their 4.2.1 release, though, and even
>   without the fix it's quite timing-dependent whether the bug actually
>   is hit. ]
>
> Josh Triplett says:
>  "I've been hammering on your pipe fix patch (switching to exclusive
>   wait queues) for a month or so, on several different systems, and I've
>   run into no issues with it. The patch *substantially* improves
>   parallel build times on large (~100 CPU) systems, both with parallel
>   make and with other things that use make's pipe-based jobserver.
>
>   All current distributions (including stable and long-term stable
>   distributions) have versions of GNU make that no longer have the
>   jobserver bug"
>
> Tested-by: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/coredump.c             |  4 +--
>  fs/pipe.c                 | 67 +++++++++++++++++++++++++--------------
>  fs/splice.c               |  8 ++---
>  include/linux/pipe_fs_i.h |  2 +-
>  4 files changed, 51 insertions(+), 30 deletions(-)
>
> diff --git a/fs/coredump.c b/fs/coredump.c
> index b1ea7dfbd1494..f8296a82d01df 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -517,7 +517,7 @@ static void wait_for_dump_helpers(struct file *file)
>         pipe_lock(pipe);
>         pipe->readers++;
>         pipe->writers--;
> -       wake_up_interruptible_sync(&pipe->wait);
> +       wake_up_interruptible_sync(&pipe->rd_wait);
>         kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>         pipe_unlock(pipe);
>
> @@ -525,7 +525,7 @@ static void wait_for_dump_helpers(struct file *file)
>          * We actually want wait_event_freezable() but then we need
>          * to clear TIF_SIGPENDING and improve dump_interrupted().
>          */
> -       wait_event_interruptible(pipe->wait, pipe->readers == 1);
> +       wait_event_interruptible(pipe->rd_wait, pipe->readers == 1);
>
>         pipe_lock(pipe);
>         pipe->readers--;
> diff --git a/fs/pipe.c b/fs/pipe.c
> index 57502c3c0fba1..5a34d6c22d4ce 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -108,16 +108,19 @@ void pipe_double_lock(struct pipe_inode_info *pipe1,
>  /* Drop the inode semaphore and wait for a pipe event, atomically */
>  void pipe_wait(struct pipe_inode_info *pipe)
>  {
> -       DEFINE_WAIT(wait);
> +       DEFINE_WAIT(rdwait);
> +       DEFINE_WAIT(wrwait);
>
>         /*
>          * Pipes are system-local resources, so sleeping on them
>          * is considered a noninteractive wait:
>          */
> -       prepare_to_wait(&pipe->wait, &wait, TASK_INTERRUPTIBLE);
> +       prepare_to_wait(&pipe->rd_wait, &rdwait, TASK_INTERRUPTIBLE);
> +       prepare_to_wait(&pipe->wr_wait, &wrwait, TASK_INTERRUPTIBLE);
>         pipe_unlock(pipe);
>         schedule();
> -       finish_wait(&pipe->wait, &wait);
> +       finish_wait(&pipe->rd_wait, &rdwait);
> +       finish_wait(&pipe->wr_wait, &wrwait);
>         pipe_lock(pipe);
>  }
>
> @@ -286,7 +289,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
>         size_t total_len = iov_iter_count(to);
>         struct file *filp = iocb->ki_filp;
>         struct pipe_inode_info *pipe = filp->private_data;
> -       bool was_full;
> +       bool was_full, wake_next_reader = false;
>         ssize_t ret;
>
>         /* Null read succeeds. */
> @@ -344,10 +347,10 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
>
>                         if (!buf->len) {
>                                 pipe_buf_release(pipe, buf);
> -                               spin_lock_irq(&pipe->wait.lock);
> +                               spin_lock_irq(&pipe->rd_wait.lock);
>                                 tail++;
>                                 pipe->tail = tail;
> -                               spin_unlock_irq(&pipe->wait.lock);
> +                               spin_unlock_irq(&pipe->rd_wait.lock);
>                         }
>                         total_len -= chars;
>                         if (!total_len)
> @@ -384,7 +387,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
>                  * no data.
>                  */
>                 if (unlikely(was_full)) {
> -                       wake_up_interruptible_sync_poll(&pipe->wait, EPOLLOUT | EPOLLWRNORM);
> +                       wake_up_interruptible_sync_poll(&pipe->wr_wait, EPOLLOUT | EPOLLWRNORM);
>                         kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
>                 }
>
> @@ -394,18 +397,23 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
>                  * since we've done any required wakeups and there's no need
>                  * to mark anything accessed. And we've dropped the lock.
>                  */
> -               if (wait_event_interruptible(pipe->wait, pipe_readable(pipe)) < 0)
> +               if (wait_event_interruptible_exclusive(pipe->rd_wait, pipe_readable(pipe)) < 0)
>                         return -ERESTARTSYS;
>
>                 __pipe_lock(pipe);
>                 was_full = pipe_full(pipe->head, pipe->tail, pipe->max_usage);
> +               wake_next_reader = true;
>         }
> +       if (pipe_empty(pipe->head, pipe->tail))
> +               wake_next_reader = false;
>         __pipe_unlock(pipe);
>
>         if (was_full) {
> -               wake_up_interruptible_sync_poll(&pipe->wait, EPOLLOUT | EPOLLWRNORM);
> +               wake_up_interruptible_sync_poll(&pipe->wr_wait, EPOLLOUT | EPOLLWRNORM);
>                 kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
>         }
> +       if (wake_next_reader)
> +               wake_up_interruptible_sync_poll(&pipe->rd_wait, EPOLLIN | EPOLLRDNORM);
>         if (ret > 0)
>                 file_accessed(filp);
>         return ret;
> @@ -437,6 +445,7 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
>         size_t total_len = iov_iter_count(from);
>         ssize_t chars;
>         bool was_empty = false;
> +       bool wake_next_writer = false;
>
>         /* Null write succeeds. */
>         if (unlikely(total_len == 0))
> @@ -515,16 +524,16 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
>                          * it, either the reader will consume it or it'll still
>                          * be there for the next write.
>                          */
> -                       spin_lock_irq(&pipe->wait.lock);
> +                       spin_lock_irq(&pipe->rd_wait.lock);
>
>                         head = pipe->head;
>                         if (pipe_full(head, pipe->tail, pipe->max_usage)) {
> -                               spin_unlock_irq(&pipe->wait.lock);
> +                               spin_unlock_irq(&pipe->rd_wait.lock);
>                                 continue;
>                         }
>
>                         pipe->head = head + 1;
> -                       spin_unlock_irq(&pipe->wait.lock);
> +                       spin_unlock_irq(&pipe->rd_wait.lock);
>
>                         /* Insert it into the buffer array */
>                         buf = &pipe->bufs[head & mask];
> @@ -576,14 +585,17 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
>                  */
>                 __pipe_unlock(pipe);
>                 if (was_empty) {
> -                       wake_up_interruptible_sync_poll(&pipe->wait, EPOLLIN | EPOLLRDNORM);
> +                       wake_up_interruptible_sync_poll(&pipe->rd_wait, EPOLLIN | EPOLLRDNORM);
>                         kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>                 }
> -               wait_event_interruptible(pipe->wait, pipe_writable(pipe));
> +               wait_event_interruptible_exclusive(pipe->wr_wait, pipe_writable(pipe));
>                 __pipe_lock(pipe);
>                 was_empty = pipe_empty(pipe->head, pipe->tail);
> +               wake_next_writer = true;
>         }
>  out:
> +       if (pipe_full(pipe->head, pipe->tail, pipe->max_usage))
> +               wake_next_writer = false;
>         __pipe_unlock(pipe);
>
>         /*
> @@ -596,9 +608,11 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
>          * wake up pending jobs
>          */
>         if (was_empty) {
> -               wake_up_interruptible_sync_poll(&pipe->wait, EPOLLIN | EPOLLRDNORM);
> +               wake_up_interruptible_sync_poll(&pipe->rd_wait, EPOLLIN | EPOLLRDNORM);
>                 kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>         }
> +       if (wake_next_writer)
> +               wake_up_interruptible_sync_poll(&pipe->wr_wait, EPOLLOUT | EPOLLWRNORM);
>         if (ret > 0 && sb_start_write_trylock(file_inode(filp)->i_sb)) {
>                 int err = file_update_time(filp);
>                 if (err)
> @@ -642,12 +656,15 @@ pipe_poll(struct file *filp, poll_table *wait)
>         unsigned int head, tail;
>
>         /*
> -        * Reading only -- no need for acquiring the semaphore.
> +        * Reading pipe state only -- no need for acquiring the semaphore.
>          *
>          * But because this is racy, the code has to add the
>          * entry to the poll table _first_ ..
>          */
> -       poll_wait(filp, &pipe->wait, wait);
> +       if (filp->f_mode & FMODE_READ)
> +               poll_wait(filp, &pipe->rd_wait, wait);
> +       if (filp->f_mode & FMODE_WRITE)
> +               poll_wait(filp, &pipe->wr_wait, wait);
>
>         /*
>          * .. and only then can you do the racy tests. That way,
> @@ -706,7 +723,8 @@ pipe_release(struct inode *inode, struct file *file)
>                 pipe->writers--;
>
>         if (pipe->readers || pipe->writers) {
> -               wake_up_interruptible_sync_poll(&pipe->wait, EPOLLIN | EPOLLOUT | EPOLLRDNORM | EPOLLWRNORM | EPOLLERR | EPOLLHUP);
> +               wake_up_interruptible_sync_poll(&pipe->rd_wait, EPOLLIN | EPOLLRDNORM | EPOLLERR | EPOLLHUP);
> +               wake_up_interruptible_sync_poll(&pipe->wr_wait, EPOLLOUT | EPOLLWRNORM | EPOLLERR | EPOLLHUP);
>                 kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>                 kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
>         }
> @@ -789,7 +807,8 @@ struct pipe_inode_info *alloc_pipe_info(void)
>                              GFP_KERNEL_ACCOUNT);
>
>         if (pipe->bufs) {
> -               init_waitqueue_head(&pipe->wait);
> +               init_waitqueue_head(&pipe->rd_wait);
> +               init_waitqueue_head(&pipe->wr_wait);
>                 pipe->r_counter = pipe->w_counter = 1;
>                 pipe->max_usage = pipe_bufs;
>                 pipe->ring_size = pipe_bufs;
> @@ -1007,7 +1026,8 @@ static int wait_for_partner(struct pipe_inode_info *pipe, unsigned int *cnt)
>
>  static void wake_up_partner(struct pipe_inode_info *pipe)
>  {
> -       wake_up_interruptible(&pipe->wait);
> +       wake_up_interruptible(&pipe->rd_wait);
> +       wake_up_interruptible(&pipe->wr_wait);
>  }
>
>  static int fifo_open(struct inode *inode, struct file *filp)
> @@ -1118,13 +1138,13 @@ static int fifo_open(struct inode *inode, struct file *filp)
>
>  err_rd:
>         if (!--pipe->readers)
> -               wake_up_interruptible(&pipe->wait);
> +               wake_up_interruptible(&pipe->wr_wait);
>         ret = -ERESTARTSYS;
>         goto err;
>
>  err_wr:
>         if (!--pipe->writers)
> -               wake_up_interruptible(&pipe->wait);
> +               wake_up_interruptible(&pipe->rd_wait);
>         ret = -ERESTARTSYS;
>         goto err;
>
> @@ -1251,7 +1271,8 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
>         pipe->max_usage = nr_slots;
>         pipe->tail = tail;
>         pipe->head = head;
> -       wake_up_interruptible_all(&pipe->wait);
> +       wake_up_interruptible_all(&pipe->rd_wait);
> +       wake_up_interruptible_all(&pipe->wr_wait);
>         return pipe->max_usage * PAGE_SIZE;
>
>  out_revert_acct:
> diff --git a/fs/splice.c b/fs/splice.c
> index 3009652a41c85..d671936d0aad6 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -165,8 +165,8 @@ static const struct pipe_buf_operations user_page_pipe_buf_ops = {
>  static void wakeup_pipe_readers(struct pipe_inode_info *pipe)
>  {
>         smp_mb();
> -       if (waitqueue_active(&pipe->wait))
> -               wake_up_interruptible(&pipe->wait);
> +       if (waitqueue_active(&pipe->rd_wait))
> +               wake_up_interruptible(&pipe->rd_wait);
>         kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>  }
>
> @@ -462,8 +462,8 @@ static int pipe_to_sendpage(struct pipe_inode_info *pipe,
>  static void wakeup_pipe_writers(struct pipe_inode_info *pipe)
>  {
>         smp_mb();
> -       if (waitqueue_active(&pipe->wait))
> -               wake_up_interruptible(&pipe->wait);
> +       if (waitqueue_active(&pipe->wr_wait))
> +               wake_up_interruptible(&pipe->wr_wait);
>         kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
>  }
>
> diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
> index dbcfa68923842..d5765039652a5 100644
> --- a/include/linux/pipe_fs_i.h
> +++ b/include/linux/pipe_fs_i.h
> @@ -47,7 +47,7 @@ struct pipe_buffer {
>   **/
>  struct pipe_inode_info {
>         struct mutex mutex;
> -       wait_queue_head_t wait;
> +       wait_queue_head_t rd_wait, wr_wait;
>         unsigned int head;
>         unsigned int tail;
>         unsigned int max_usage;
> --
> 2.20.1
>
