Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601921C9E37
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 00:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgEGWGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 18:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgEGWGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 18:06:43 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08152C05BD43;
        Thu,  7 May 2020 15:06:43 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWof7-003GTu-PA; Thu, 07 May 2020 22:06:38 +0000
Date:   Thu, 7 May 2020 23:06:37 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Max Kellermann <mk@cm4all.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fs/io_uring: fix O_PATH fds in openat, openat2, statx
Message-ID: <20200507220637.GH23230@ZenIV.linux.org.uk>
References: <20200507185725.15840-1-mk@cm4all.com>
 <20200507190131.GF23230@ZenIV.linux.org.uk>
 <4cac0e53-656c-50f0-3766-ae3cc6c0310a@kernel.dk>
 <20200507192903.GG23230@ZenIV.linux.org.uk>
 <8e3c88cc-027b-4f90-b4f8-a20d11d35c4b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e3c88cc-027b-4f90-b4f8-a20d11d35c4b@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 07, 2020 at 02:53:30PM -0600, Jens Axboe wrote:

> I think the patch is correct as-is, I took a good look at how we're
> currently handling it. None of those three ops should fiddle with
> the fd at all, and all of them do forbid the use of fixed files (the
> descriptor table look-alikes), so that part is fine, too.
> 
> There's some low hanging fruit around optimizing and improving it,
> I'm including an updated version below. Max, can you double check
> with your testing?

<looks>

Could you explain WTF is io_issue_sqe() doing in case of IORING_OP_CLOSE?
Specifically, what is the value of
        req->close.fd = READ_ONCE(sqe->fd);
        if (req->file->f_op == &io_uring_fops ||
            req->close.fd == req->ctx->ring_fd)
                return -EBADF;
in io_close_prep()?  And what does happen if some joker does dup2()
of something with io_uring_fops into our slot right after that check?
Before the subsequent
        ret = __close_fd_get_file(req->close.fd, &req->close.put_file);
that is.
