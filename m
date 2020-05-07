Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C791C9B0D
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 21:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgEGT3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 15:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726367AbgEGT3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 15:29:06 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32798C05BD43;
        Thu,  7 May 2020 12:29:06 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWmCd-003ASV-I0; Thu, 07 May 2020 19:29:03 +0000
Date:   Thu, 7 May 2020 20:29:03 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Max Kellermann <mk@cm4all.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fs/io_uring: fix O_PATH fds in openat, openat2, statx
Message-ID: <20200507192903.GG23230@ZenIV.linux.org.uk>
References: <20200507185725.15840-1-mk@cm4all.com>
 <20200507190131.GF23230@ZenIV.linux.org.uk>
 <4cac0e53-656c-50f0-3766-ae3cc6c0310a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cac0e53-656c-50f0-3766-ae3cc6c0310a@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 07, 2020 at 01:05:23PM -0600, Jens Axboe wrote:
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

Just in case - you do realize that you should either resolve the
descriptor yourself (and use the resulting struct file *, without
letting anyone even look at the descriptor) *or* pass the
descriptor as-is and don't even look at the descriptor table?

Once more, with feeling:

Descriptor tables are inherently sharable objects.  You can't resolve
a descriptor twice and assume you'll get the same thing both times.
You can't insert something into descriptor table and assume that the
same slot will be holding the same struct file reference after
the descriptor table has been unlocked.

Again, resolving the descriptor more than once in course of syscall
is almost always a serious bug; there are very few exceptions and
none of the mentioned in that patch are anywhere near those.

IOW, that patch will either immediately break things on O_PATH
(if you are really passing struct file *) or it's probably correct,
but the reason is entirely different - it's that you are passing
descriptor, which gets resolved by whatever you are calling, in
which case io_uring has no business resolving it.  And if that's
the case, you are limited to real descriptors - your descriptor
table lookalikes won't be of any use.
