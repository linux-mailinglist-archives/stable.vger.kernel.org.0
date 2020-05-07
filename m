Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AFC1C9EA0
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 00:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgEGWow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 18:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgEGWow (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 18:44:52 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D6CC05BD43;
        Thu,  7 May 2020 15:44:52 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWpG3-003HUj-EA; Thu, 07 May 2020 22:44:47 +0000
Date:   Thu, 7 May 2020 23:44:47 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Max Kellermann <mk@cm4all.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fs/io_uring: fix O_PATH fds in openat, openat2, statx
Message-ID: <20200507224447.GI23230@ZenIV.linux.org.uk>
References: <20200507185725.15840-1-mk@cm4all.com>
 <20200507190131.GF23230@ZenIV.linux.org.uk>
 <4cac0e53-656c-50f0-3766-ae3cc6c0310a@kernel.dk>
 <20200507192903.GG23230@ZenIV.linux.org.uk>
 <8e3c88cc-027b-4f90-b4f8-a20d11d35c4b@kernel.dk>
 <20200507220637.GH23230@ZenIV.linux.org.uk>
 <283c8edb-fea2-5192-f1d6-3cc57815b1e2@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <283c8edb-fea2-5192-f1d6-3cc57815b1e2@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 07, 2020 at 04:25:24PM -0600, Jens Axboe wrote:

>  static int io_close(struct io_kiocb *req, bool force_nonblock)
>  {
> +	struct files_struct *files = current->files;
>  	int ret;
>  
>  	req->close.put_file = NULL;
> -	ret = __close_fd_get_file(req->close.fd, &req->close.put_file);
> +	spin_lock(&files->file_lock);
> +	if (req->file->f_op == &io_uring_fops ||
> +	    req->close.fd == req->ctx->ring_fd) {
> +		spin_unlock(&files->file_lock);
> +		return -EBADF;
> +	}
> +
> +	ret = __close_fd_get_file_locked(files, req->close.fd,
> +						&req->close.put_file);

Pointless.  By that point req->file might have nothing in common with
anything in any descriptor table.

Al, carefully _not_ saying anything about the taste and style of the
entire thing...
