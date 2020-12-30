Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2BC2E7A51
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 16:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgL3P34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 10:29:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:42526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbgL3P34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 10:29:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E782B207B2;
        Wed, 30 Dec 2020 15:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609342155;
        bh=je+exU43lr3MB3kMbRTXOz2v5D4Il5Vuz9obRPrmbWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fyXjC8apMi70xiRjf2knNjsis/XIfoK1b/GMaZ9ojHX9PkcKQ0KE1GlGRQQITXujU
         sdR0fnfGqbhag7wfqO/t/5pwWSsd3g0yCjDkpAox0moEW8mWVGDiH/fisAwm3gmR9W
         05Ku7cHdkU4PhkeFbBBXXt24z00tMWTFcVYGwAD4=
Date:   Wed, 30 Dec 2020 16:30:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: Re: [PATCH backport 5.10] io_uring: close a small race gap for files
 cancel
Message-ID: <X+ydIQfWLELe4IfF@kroah.com>
References: <cover.1609215832.git.asml.silence@gmail.com>
 <c47ff9d5a4dadaaa47fa2f2ad2f6cae8c39a9b98.1609215832.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c47ff9d5a4dadaaa47fa2f2ad2f6cae8c39a9b98.1609215832.git.asml.silence@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 29, 2020 at 04:35:49AM +0000, Pavel Begunkov wrote:
> commit dfea9fce29fda6f2f91161677e0e0d9b671bc099 upstream.
> 
> The purpose of io_uring_cancel_files() is to wait for all requests
> matching ->files to go/be cancelled. We should first drop files of a
> request in io_req_drop_files() and only then make it undiscoverable for
> io_uring_cancel_files.
> 
> First drop, then delete from list. It's ok to leave req->id->files
> dangling, because it's not dereferenced by cancellation code, only
> compared against. It would potentially go to sleep and be awaken by
> following in io_req_drop_files() wake_up().
> 
> Fixes: 0f2122045b946 ("io_uring: don't rely on weak ->files references")
> Cc: <stable@vger.kernel.org> # 5.5+
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Now applied, thanks.

greg k-h
