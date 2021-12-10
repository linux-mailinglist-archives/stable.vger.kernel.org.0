Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8697146FC4D
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 09:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhLJIK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 03:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235346AbhLJIKz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 03:10:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA013C061746;
        Fri, 10 Dec 2021 00:07:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5195B81A5C;
        Fri, 10 Dec 2021 08:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19450C00446;
        Fri, 10 Dec 2021 08:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639123638;
        bh=5g98btmYSOlVvmG806mysGe6yryN8kH9LMccgh5w4Xc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gz6QHSf3XKUXg8YpzZvY2bK6YDC5gdArBR0P5Wg9WlF22d9hRGwmMzBBedWiAFVwo
         YOKqpSVtl3a1V/rgBm0Fk94GVi/3DeM7d7hO/yLY9gi6ee5mocYZrajCVGkfqCe0bP
         hDlR6mY+FafirqJbmHMSz6qZ/iZKMF0bCw7u/DzP1ql34jkx7XMEB6FftjIdV0Kb2s
         CcB5cdaF4tTrZavTmgPdaVnlVByinKoS0sWEQYD82LMKiBvjQlHQ1zUAsovRzWBKxg
         4+kFRC7xHQHB4cZFk8xmVKDavxHvrj3w3F0A7/6Gg+1HMHdNuO3j9CWq+PSuzsFs5e
         mMOkGS+fLJQFA==
Date:   Fri, 10 Dec 2021 00:07:16 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Martijn Coenen <maco@android.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3 0/5] aio: fix use-after-free and missing wakeups
Message-ID: <YbMKtAjSJdXNTzOk@sol.localdomain>
References: <20211209010455.42744-1-ebiggers@kernel.org>
 <CAHk-=wjkXez+ugCbF3YpODQQS-g=-4poCwXaisLW4p2ZN_=hxw@mail.gmail.com>
 <4a472e72-d527-db79-d46e-efa9d4cad5bb@kernel.dk>
 <YbLhL8y/TR5H0MLe@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbLhL8y/TR5H0MLe@sol.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021 at 09:10:09PM -0800, Eric Biggers wrote:
> On Thu, Dec 09, 2021 at 02:46:45PM -0700, Jens Axboe wrote:
> > On 12/9/21 11:00 AM, Linus Torvalds wrote:
> > > On Wed, Dec 8, 2021 at 5:06 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > >>
> > >> Careful review is appreciated; the aio poll code is very hard to work
> > >> with, and it doesn't appear to have many tests.  I've verified that it
> > >> passes the libaio test suite, which provides some coverage of poll.
> > >>
> > >> Note, it looks like io_uring has the same bugs as aio poll.  I haven't
> > >> tried to fix io_uring.
> > > 
> > > I'm hoping Jens is looking at the io_ring case, but I'm also assuming
> > > that I'll just get a pull request for this at some point.
> > 
> > Yes, when I saw this original posting I did discuss it with Pavel as
> > well, and we agree that the same issue exists there. Which isn't too
> > surprising, as that's where the io_uring poll code from originally.
> > 
> > Eric, do you have a test case for this? aio is fine, we can convert it
> > to io_uring as well. Would be nice for both verifying the fix, but also
> > to carry in the io_uring regression tests for the future.
> 
> Well, the use-after-free bug is pretty hard to test for.  It only affects
> polling a binder fd or signalfd, so one of those has to be used.  Also, I
> haven't found a way to detect it other than the use-after-free itself, so
> effectively a kernel with KASAN enabled is needed.  But KASAN doesn't work with
> signalfd because the signalfd waitqueues are in an SLAB_TYPESAFE_BY_RCU slab, so
> binder is the only way to detect it without working around SLAB_TYPESAFE_BY_RCU,
> or patching the kernel to add log messages.  Also, aio supports inline
> completion which avoids the bug, so that needs to be worked around.
> 
> So the best I can do is provide a program that's pretty specific to aio, which
> causes KASAN to report a use-after-free if the kernel has CONFIG_KASAN and
> CONFIG_ANDROID_BINDER_IPC enabled.  Note, "normal" Linux distros don't have
> either option enabled.  I'm not sure that would be useful for you.
> 
> If you're also asking about the other bug (missed wakeups), i.e. the one that
> patch 4 in this series fixes, in theory that would be detectable without those
> dependencies.  It's still a race condition that depends on kernel implementation
> details, so it will be hard to test for too.  But I might have a go at writing a
> test for it anyway.
> 

Here's a regression test for the missed wakeups bug (patch 4).  It needs some
polishing, but it should be suitable for ltp or the libaio test suite.  (I'm not
sure which one of those to choose, as both have aio tests; if anyone has a
preference, please let me know.)

To be clear, this does *not* test for the use-after-free bug (patch 5).  As I
mentioned, as far as I know, a test for that would depend on both KASAN and
binder, making it harder to run.


// SPDX-License-Identifier: GPL-2.0-or-later
/*
 * Copyright 2021 Google LLC
 */
/*
 * Regression test for "aio: keep poll requests on waitqueue until completed".
 * This test verifies that aio poll (IOCB_CMD_POLL) doesn't miss any events.
 *
 * This test repeatedly does the following operations in parallel:
 *
 *      Thread 1: issue an aio poll for the read end of a pipe, and wait for it
 *                to complete
 *      Thread 2: spice some data to the pipe
 *      Thread 3: read from the pipe, then splice some more data to it
 *
 * The pipe will always end up with data, so the poll should always complete.
 *
 * With the bug, that didn't always happen, as the second splice sometimes
 * didn't cause a wake-up due to the waitqueue entry being temporarily removed,
 * as per the following buggy sequence of operations:
 *
 *      - Thread 1: add the poll waitqueue entry
 *      - Thread 2: first splice.  This calls the poll wakeup function,
 *                  which deletes the waitqueue entry [BUG!], then
 *                  schedules async completion work.
 *      - Thread 3: read from the pipe
 *      - kworker: see that the pipe isn't ready
 *      - Thread 3: splice some data to the pipe; waitqueue is empty.
 *      - kworker: re-add the waitqueue entry
 *
 * The reason we use splice() rather than write() is because we need something
 * that doesn't pass an event mask when waking up pollers.  splice() to a pipe
 * happens to meet that criteria, while write() to a pipe doesn't.
 */
#define _GNU_SOURCE
#include <fcntl.h>
#include <linux/aio_abi.h>
#include <poll.h>
#include <pthread.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/syscall.h>
#include <sys/wait.h>
#include <unistd.h>

static char tmpfile_name[] = "/tmp/aio.XXXXXX";
static int tmpfd;
static int pipefds[2];

static void die(const char *msg)
{
        perror(msg);
        exit(1);
}

static void *thrproc1(void *arg)
{
        off_t offset = 0;

        usleep(rand() % 50);
        if (splice(tmpfd, &offset, pipefds[1], NULL, 1, 0) != 1)
                die("splice");
        return NULL;
}

static void *thrproc2(void *arg)
{
        char buf[4096];
        off_t offset = 0;

        usleep(rand() % 100);
        read(pipefds[0], buf, sizeof(buf));
        if (splice(tmpfd, &offset, pipefds[1], NULL, 1, 0) != 1)
                die("splice");
        return NULL;
}

static int run_test(void)
{
        aio_context_t aio_ctx = 0;
        struct iocb iocb = {};
        struct iocb *iocbs[] = {&iocb};
        struct io_event event;
        struct timespec timeout = { .tv_sec = 5 };
        pthread_t t1, t2;
        int i;
        int ret;

        if (syscall(__NR_io_setup, 1, &aio_ctx) != 0) {
                printf("aio not supported, can't run test.\n");
                return 1;
        }

        for (i = 0; i < 25000; i++) {
                if (pipe(pipefds) != 0)
                        die("pipe");
                iocb.aio_fildes = pipefds[0];
                iocb.aio_lio_opcode = IOCB_CMD_POLL;
                iocb.aio_buf = POLLIN;

                if (syscall(__NR_io_submit, aio_ctx, 1, iocbs) != 1)
                        die("io_submit");

                pthread_create(&t1, NULL, thrproc1, NULL);
                pthread_create(&t2, NULL, thrproc2, NULL);

                ret = syscall(__NR_io_getevents, aio_ctx, 1, 1, &event,
                              &timeout);
                if (ret < 0)
                        die("io_getevents");
                if (ret == 0) {
                        printf("FAIL: poll missed an event; i=%d\n", i);
                        return 1;
                }
                pthread_join(t1, NULL);
                pthread_join(t2, NULL);
                close(pipefds[0]);
                close(pipefds[1]);
        }
        return 0;
}

int main()
{
        int ncpus;
        int status;
        int overall_status = 0;
        int i;

        tmpfd = mkstemp(tmpfile_name);
        if (tmpfd < 0)
                die("mkstemp");
        if (pwrite(tmpfd, "X", 1, 0) != 1)
                die("pwrite");

        ncpus = sysconf(_SC_NPROCESSORS_CONF);
        if (ncpus < 1)
                ncpus = 1;
        for (i = 0; i < ncpus; i++) {
                if (fork() == 0)
                        return run_test();
        }
        for (i = 0; i < ncpus; i++) {
                status = -1;
                wait(&status);
                overall_status |= status;
        }
        unlink(tmpfile_name);
        return overall_status;
}

