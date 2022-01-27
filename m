Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E4049E5E4
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 16:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbiA0PV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 10:21:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39886 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbiA0PV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 10:21:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34DC560D36;
        Thu, 27 Jan 2022 15:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167A6C340E4;
        Thu, 27 Jan 2022 15:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643296886;
        bh=76nZwLBHp/od8C56ExFMjc0Xuxw2Kck3UnGovEIXx8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yCjw6t28dZIV1UVe9Gi25+ZaW4qio1HfH2BlhmYeOXRj4TCJ9uYpij0K0B6+CWqJ1
         b/QeCFnHqiucCdU/N/MuaRbozQUMDS/+ITdJw2uJ8U0IjVXI51bp7A4nDQ6A0Vk9sV
         hZh813jcm4TxXNtaMphbJrNd7/zlTueOEVMD25ho=
Date:   Thu, 27 Jan 2022 16:21:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Re: [PATCH stable-5.16] io_uring: fix not released cached task refs
Message-ID: <YfK4c8qRZ2p0g6qF@kroah.com>
References: <562c76e037f77a17401327b9c953cd53744a5c7d.1643221940.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <562c76e037f77a17401327b9c953cd53744a5c7d.1643221940.git.asml.silence@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 06:41:00PM +0000, Pavel Begunkov wrote:
> [ upstream commit 3cc7fdb9f90a25ae92250bf9e6cf3b9556b230e9 ]
> 
> tctx_task_work() may get run after io_uring cancellation and so there
> will be no one to put cached in tctx task refs that may have been added
> back by tw handlers using inline completion infra, Call
> io_uring_drop_tctx_refs() at the end of the main tw handler to release
> them.
> 
> Cc: stable@vger.kernel.org # 5.15+
> Reported-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Fixes: e98e49b2bbf7 ("io_uring: extend task put optimisations")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Link: https://lore.kernel.org/r/69f226b35fbdb996ab799a8bbc1c06bf634ccec1.1641688805.git.asml.silence@gmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 34 +++++++++++++++++++++-------------
>  1 file changed, 21 insertions(+), 13 deletions(-)
> 

Both backports now queued up, thanks.

greg k-h
