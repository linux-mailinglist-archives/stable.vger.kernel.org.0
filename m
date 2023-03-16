Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC4386BD88B
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 20:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjCPTEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 15:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjCPTEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 15:04:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48B59EDB;
        Thu, 16 Mar 2023 12:04:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0FE58CE1E57;
        Thu, 16 Mar 2023 19:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9AEC433EF;
        Thu, 16 Mar 2023 19:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678993467;
        bh=4SDqdWNCGiFNqnb3Zj29x5lAsT1AarZiIiw0TYkTpiE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VfHiiY9GRX7fn94lYsR8Wqi9IjIzu/eIr4lubBYjatgNdSaFR3hQuwMxXNzZlAtrW
         7UapnNMK4ufFq1Ib5ne0JOcoV4E8J7/1WzgB1TM4DpgXNSuaE7PdPnzFao0XKudL1O
         Zh9kK0OR+lqY9zNPQYrVL97yIMRI53Y238/12fF4=
Date:   Thu, 16 Mar 2023 20:04:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10/5.15] io_uring: avoid null-ptr-deref in
 io_arm_poll_handler
Message-ID: <ZBNoOE0tMiJZd6r8@kroah.com>
References: <20230316185616.271024-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316185616.271024-1-pchelkin@ispras.ru>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 16, 2023 at 09:56:16PM +0300, Fedor Pchelkin wrote:
> No upstream commit exists for this commit.
> 
> The issue was introduced with backporting upstream commit c16bda37594f
> ("io_uring/poll: allow some retries for poll triggering spuriously").
> 
> Memory allocation can possibly fail causing invalid pointer be
> dereferenced just before comparing it to NULL value.
> 
> Move the pointer check in proper place (upstream has the similar location
> of the check). In case the request has REQ_F_POLLED flag up, apoll can't
> be NULL so no need to check there.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> ---
>  io_uring/io_uring.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 445afda927f4..fd799567fc23 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -5792,10 +5792,10 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>  		}
>  	} else {
>  		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
> +		if (unlikely(!apoll))
> +			return IO_APOLL_ABORTED;

How can you trigger a GFP_ATOMIC memory failure?  If you do, worse
things are about to happen to your system, right?

thanks,

greg k-h
