Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0784E2C29FE
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 15:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389257AbgKXOpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 09:45:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58966 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389056AbgKXOpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 09:45:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606229130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pz513mSJDNIdupfQR9PNXZ8uSX6HJ6vNuuU0z0gMigg=;
        b=MIV58pK4/IwGtUZb+tGWIpYkReu4xoadH+1rMrBMo2OLBEvpF5p+R2dxT+x5yCf7ui9KrQ
        ivoJjOh7pWpM60QurWZ1XclI/jZxsLQ5GmcqGrNWxMKhN2h1Rb4U0KekLKaBtlCEZFTtRC
        OXd/2kv3onMYB46QcXezhRnu/ijO8Mo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-AaP1Fq4oOh-Sueqrb2jkQg-1; Tue, 24 Nov 2020 09:45:23 -0500
X-MC-Unique: AaP1Fq4oOh-Sueqrb2jkQg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C390195D573;
        Tue, 24 Nov 2020 14:45:03 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A505F722D1;
        Tue, 24 Nov 2020 14:45:02 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5.10] io_uring: fix ITER_BVEC check
References: <26e5446cb6252589a7edc4c3bbe4d8a503919bd8.1606172908.git.asml.silence@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Tue, 24 Nov 2020 09:45:06 -0500
In-Reply-To: <26e5446cb6252589a7edc4c3bbe4d8a503919bd8.1606172908.git.asml.silence@gmail.com>
        (Pavel Begunkov's message of "Mon, 23 Nov 2020 23:20:27 +0000")
Message-ID: <x49mtz6izkd.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pavel Begunkov <asml.silence@gmail.com> writes:

> iov_iter::type is a bitmask that also keeps direction etc., so it
> shouldn't be directly compared against ITER_*. Use proper helper.
>
> Cc: <stable@vger.kernel.org> # 5.9
> Reported-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Fixes: ff6165b2d7f6 ("io_uring: retain iov_iter state over io_read/io_write calls")

> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 593dfef32b17..7c1f255807f5 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3278,7 +3278,7 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
>  	rw->free_iovec = iovec;
>  	rw->bytes_done = 0;
>  	/* can only be fixed buffers, no need to do anything */
> -	if (iter->type == ITER_BVEC)
> +	if (iov_iter_is_bvec(iter))
>  		return;
>  	if (!iovec) {
>  		unsigned iov_off = 0;

