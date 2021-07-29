Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9913DAECD
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 00:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbhG2W12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 18:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhG2W12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 18:27:28 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9E8C0613C1
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 15:27:23 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id a4-20020a17090aa504b0290176a0d2b67aso17890066pjq.2
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 15:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0qEtOVI+2bxrwcA0/khpilqHg8S4yKEf0/piqF/74tU=;
        b=WNyPqykzza9gkT1w9OQXvq0HkGQimtoedVVSXRi/bk9yvFDLA2dhQm4bE490HMhoLB
         fxlXtzImR2x82rDCE0GlyIV0aeBfcAlYTQD+XYdVjWOrvhwiVsO9Zfq2fEJTpZI0uMW2
         O6h387/SWxbh1Efq7/BdE0XpThwQN/gcuhN3QUpefrigO9x9unlsJGhOZ98RSTFZLCOZ
         7YKPcVKu6txlyzL7zxT9H9010oJPlQBHExj7CyNUnHLiEeElSUpl7rTa7cCO4/GaQPvq
         ER1ZWF/WvryYLQ6IHMrR69U1zHxKDN1fbkmyeGs1gTfwosrNf6c7ePuARagnfJXOHY2X
         WBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0qEtOVI+2bxrwcA0/khpilqHg8S4yKEf0/piqF/74tU=;
        b=AKh6N6kMyRf6un2jw7lCRCUksSuG1A2Xs+7Nmjz8JrsP6zOH4A61DneQU9i3l6TC5X
         L7cFThLqESTm9zWVRtwUPYIwR8CsyQ2nOCAb246EBhpBdcIPS/lByvWCIzRa0Lz3y3cP
         fU0F/W0BfvZpd2ZiJOUcfCL7X30yt86Tnr7UU6xNUyiT7lG4KXZGnm+NED1ZZtGLFlQp
         OwhuRsv9siFSQwAOB+om0+ekKDUPVQjhd+xkDzVJBl+/5aOUBW3QhJ9j69uTCeAfc6mK
         zLErIhw9F8CiCYDfjuczErRY4rjYRTdyFuJzeUtaj/J0LIqVKsCSolV9D9kR5PWCB65S
         DIMw==
X-Gm-Message-State: AOAM530zD+TG6QY3j1EbiDCnM0ZgLGBml4ZlaNbKoOkbYSXY3PzTGj5y
        tnjpdq6H/FG3p+Abc9WEDQMriw==
X-Google-Smtp-Source: ABdhPJwnFzHhdA9Nt1EQ2Lu4QCvWt5JDEIU/9eS3ALJ2RdthG0rTMuVPqfq0HJC1X/dQBOPU+5DqIw==
X-Received: by 2002:a17:90a:a105:: with SMTP id s5mr7506299pjp.9.1627597643146;
        Thu, 29 Jul 2021 15:27:23 -0700 (PDT)
Received: from sspatil2.c.googlers.com.com (190.40.105.34.bc.googleusercontent.com. [34.105.40.190])
        by smtp.gmail.com with ESMTPSA id 5sm4761989pfp.154.2021.07.29.15.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 15:27:22 -0700 (PDT)
From:   Sandeep Patil <sspatil@android.com>
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sandeep Patil <sspatil@android.com>, torvalds@linux-foundation.org,
        dhowells@redhat.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 0/1] Revert change in pipe reader wakeup behavior
Date:   Thu, 29 Jul 2021 22:26:34 +0000
Message-Id: <20210729222635.2937453-1-sspatil@android.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit <1b6b26ae7053>("pipe: fix and clarify pipe write wakeup
logic") changed pipe write logic to wakeup readers only if the pipe
was empty at the time of write. However, there are libraries that relied
upon the older behavior for notification scheme similar to what's
described in [1]

One such library 'realm-core'[2] is used by numerous Android applications.
The library uses a similar notification mechanism as GNU Make but it
never drains the pipe until it is full. When Android moved to v5.10
kernel, all applications using this library stopped working.
The C program at the end of this email mimics the library code.

The program works with 5.4 kernel. It fails with v5.10 and I am fairly
certain it will fail wiht v5.5 as well. The single patch in this series
restores the old behavior. With the patch, the test and all affected
Android applications start working with v5.10

After reading through epoll(7), I think the pipe should be drained after
each epoll_wait() comes back. Also, that a non-empty pipe is
considered to be "ready" for readers. The problem is that prior
to the commit above, any new data written to non-empty pipes
would wakeup threads waiting in epoll(EPOLLIN|EPILLET) and thats
how this library worked.

I do think the program below is using EPOLLET wrong. However, it
used to work before and now it doesn't. So, I thought it is
worth asking if this counts as userspace break.

There was also a symmetrical change made to pipe_read in commit
<f467a6a66419> ("pipe: fix and clarify pipe read wakeup logic")
that I am not sure needs changing.

The library has since been fixed[3] but it will be a while
before all applications incorporate the updated library.


- ssp

1. https://lore.kernel.org/lkml/CAHk-=wjeG0q1vgzu4iJhW5juPkTsjTYmiqiMUYAebWW+0bam6w@mail.gmail.com/
2. https://github.com/realm/realm-core
3. https://github.com/realm/realm-core/issues/4666

====
#include <stdio.h>
#include <error.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <sys/epoll.h>
#include <sys/stat.h>
#include <sys/types.h>

#define FIFO_NAME "epoll-test-fifo"

pthread_t tid;
int max_delay_ms = 20;
int fifo_fd;
unsigned char written;
unsigned char received;
int epoll_fd;

void *wait_on_fifo(void *unused)
{
	while (1) {
		struct epoll_event ev;
		int ret;
		unsigned char c;

		ret = epoll_wait(epoll_fd, &ev, 1, 5000);
		if (ret == -1) {
			/* If interrupted syscall, continue .. */
			if (errno == EINTR)
				continue;
			/* epoll_wait failed, bail.. */
			error(99, errno, "epoll_wait failed \n");
		}

		/* timeout */
		if (ret == 0)
			break;

		if (ev.data.fd == fifo_fd) {
			/* Assume this is notification where the thread is catching up.
			 * pipe is emptied by the writer when it detects it is full.
			 */
			received = written;
		}
	}

	return NULL;
}

int write_fifo(int fd, unsigned char c)
{
	while (1) {
		int actual;
		char buf[1024];

		ssize_t ret = write(fd, &c, 1);
		if (ret == 1)
			break;
		/*
		 * If the pipe's buffer is full, we need to read some of the old data in
		 * it to make space. We dont read in the code waiting for
		 * notifications so that we can notify multiple waiters with a single
		 * write.
		 */
		if (ret != 0) {
			if (errno != EAGAIN)
				return -EIO;
		}
		actual = read(fd, buf, 1024);
		if (actual == 0)
			return -errno;
	}

	return 0;
}

int create_and_setup_fifo()
{
	int ret;
	char fifo_path[4096];
	struct epoll_event ev;

	char *tmpdir = getenv("TMPDIR");
	if (tmpdir == NULL)
		tmpdir = ".";

	ret = sprintf(fifo_path, "%s/%s", tmpdir, FIFO_NAME);
	if (access(fifo_path, F_OK) == 0)
		unlink(fifo_path);

	ret = mkfifo(fifo_path, 0600);
	if (ret < 0)
		error(1, errno, "Failed to create fifo");

	fifo_fd = open(fifo_path, O_RDWR | O_NONBLOCK);
	if (fifo_fd < 0)
		error(2, errno, "Failed to open Fifo");

	ev.events = EPOLLIN | EPOLLET;
	ev.data.fd = fifo_fd;

	ret = epoll_ctl(epoll_fd, EPOLL_CTL_ADD, fifo_fd, &ev);
	if (ret < 0)
		error(4, errno, "Failed to add fifo to epoll instance");

	return 0;
}

int main(int argc, char *argv[])
{
	int ret, random;
	unsigned char c = 1;

	epoll_fd = epoll_create(1);
	if (epoll_fd == -1)
		error(3, errno, "Failed to create epoll instance");

	ret = create_and_setup_fifo();
	if (ret != 0)
		error(45, EINVAL, "Failed to setup fifo");

	ret = pthread_create(&tid, NULL, wait_on_fifo, NULL);
	if (ret != 0)
		error(2, errno, "Failed to create a thread");

	srand(time(NULL));

	/* Write 256 bytes to fifo one byte at a time with random delays upto 20ms */
	do {
		written = c;
		ret = write_fifo(fifo_fd, c);
		if (ret != 0)
			error(55, errno, "Failed to notify fifo, write #%u", (unsigned int)c);
		c++;

		random = rand();
		usleep((random % max_delay_ms) * 1000);
	} while (written <= c); /* stop after c = 255 */

	pthread_join(tid, NULL);

	printf("Test: %s", written == received ? "PASS\n" : "FAIL");
	if (written != received)
		printf(": Written (%d) Received (%d)\n", written, received);

	close(fifo_fd);
	close(epoll_fd);

	return 0;
}
====

Sandeep Patil (1):
  fs: pipe: wakeup readers everytime new data written is to pipe

 fs/pipe.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

-- 
2.32.0.554.ge1b32706d8-goog

