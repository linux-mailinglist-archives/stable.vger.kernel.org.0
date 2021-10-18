Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF0A431017
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 08:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhJRGDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 02:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhJRGDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 02:03:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D777460F25;
        Mon, 18 Oct 2021 06:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634536849;
        bh=RECzbXZ+8IIFp3dDqHwQoTtgoSGnf9j0ExTatmTH5cc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uxBzsN/ifh062VVygB7Q6r3sfF4yipAsU17BnwAD3/3Yh5+NFAIZpzV1sPULyi1+T
         ahLGjP/OndRTKBfMwtDyUWmVvx77jc4htRakVAqojwlZDzATxo2AluFyNEjRNva2/x
         lIXwZAbkcWGJBeVonZzsw3/vWzyFj4cL/SmXrkgA=
Date:   Mon, 18 Oct 2021 08:00:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] io_uring: fail iopoll links if can't retry
Message-ID: <YW0Ni7BxHaJQsmSn@kroah.com>
References: <cover.1634501363.git.asml.silence@gmail.com>
 <ff66f584ff352b94ef0f5cb4188da609834fe173.1634501363.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff66f584ff352b94ef0f5cb4188da609834fe173.1634501363.git.asml.silence@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 17, 2021 at 08:30:55PM +0000, Pavel Begunkov wrote:
> If io_rw_should_reissue() fails in iopoll path and we can't reissue we
> fail the request. Don't forget to also mark it as failed, so links are
> broken.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 0d7613c7355c..40b1697e7354 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2687,6 +2687,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
>  			req->flags |= REQ_F_REISSUE;
>  			return;
>  		}
> +		req_set_fail(req);
>  		req->result = res;
>  	}
>  
> -- 
> 2.33.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
