Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165AF1C9A91
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 21:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgEGTMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 15:12:34 -0400
Received: from nibbler.cm4all.net ([82.165.145.151]:33077 "EHLO
        nibbler.cm4all.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728212AbgEGTM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 15:12:29 -0400
Received: from localhost (localhost [127.0.0.1])
        by nibbler.cm4all.net (Postfix) with ESMTP id 9B75EC022E
        for <stable@vger.kernel.org>; Thu,  7 May 2020 21:12:27 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at nibbler.cm4all.net
Received: from nibbler.cm4all.net ([127.0.0.1])
        by localhost (nibbler.cm4all.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id auhR1r0P9nq1 for <stable@vger.kernel.org>;
        Thu,  7 May 2020 21:12:27 +0200 (CEST)
Received: from zero.intern.cm-ag (zero.intern.cm-ag [172.30.16.10])
        by nibbler.cm4all.net (Postfix) with SMTP id 7ADA0C01F8
        for <stable@vger.kernel.org>; Thu,  7 May 2020 21:12:27 +0200 (CEST)
Received: (qmail 3684 invoked from network); 7 May 2020 22:28:44 +0200
Received: from unknown (HELO rabbit.intern.cm-ag) (172.30.3.1)
  by zero.intern.cm-ag with SMTP; 7 May 2020 22:28:44 +0200
Received: by rabbit.intern.cm-ag (Postfix, from userid 1023)
        id 4E1C8461450; Thu,  7 May 2020 21:12:27 +0200 (CEST)
Date:   Thu, 7 May 2020 21:12:27 +0200
From:   Max Kellermann <mk@cm4all.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Max Kellermann <mk@cm4all.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] fs/io_uring: fix O_PATH fds in openat, openat2, statx
Message-ID: <20200507191227.GA16101@rabbit.intern.cm-ag>
References: <20200507185725.15840-1-mk@cm4all.com>
 <20200507190131.GF23230@ZenIV.linux.org.uk>
 <4cac0e53-656c-50f0-3766-ae3cc6c0310a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cac0e53-656c-50f0-3766-ae3cc6c0310a@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/05/07 21:05, Jens Axboe <axboe@kernel.dk> wrote:
> On 5/7/20 1:01 PM, Al Viro wrote:
> > On Thu, May 07, 2020 at 08:57:25PM +0200, Max Kellermann wrote:
> >> If an operation's flag `needs_file` is set, the function
> >> io_req_set_file() calls io_file_get() to obtain a `struct file*`.
> >>
> >> This fails for `O_PATH` file descriptors, because those have no
> >> `struct file*`
> > 
> > O_PATH descriptors most certainly *do* have that.  What the hell
> > are you talking about?
> 
> Yeah, hence I was interested in the test case. Since this is
> bypassing that part, was assuming we'd have some logic error
> that attempted a file grab for a case where we shouldn't.

Reproduce this by patching liburing/test/lfs-openat.c:

-       int dfd = open("/tmp", O_RDONLY | O_DIRECTORY);
+       int dfd = open("/tmp", O_PATH);

 $ ./test/lfs-openat
 io_uring openat failed: Bad file descriptor

GH PR: https://github.com/axboe/liburing/pull/130

Max
