Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7338B3652FA
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 09:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhDTHNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 03:13:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhDTHNe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 03:13:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6032461154;
        Tue, 20 Apr 2021 07:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618902783;
        bh=hyy9kPw6FnlS5XBptvg6tMY/F+u5h5oS2Ot4txHGO/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oa9Tr1YQlFCBMSyE+PhLQrZK+BSOU8Ag1tkJ6g5I0m4Yr1T4JBKLqKpFWqdX/7ixw
         9QqF2zAOftabQiNif3NOH89r22UY+ajU/X4uRdJYn5k3avN7h4gTvv7hzYMejViCoA
         aVRN2hQP3g6HGzQ2dFLDUtZUg2jjIqkxUlCYSCc0=
Date:   Tue, 20 Apr 2021 09:13:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 042/103] net/rds: Avoid potential use after free in
 rds_send_remove_from_sock
Message-ID: <YH5+/P0iQ6irl7us@kroah.com>
References: <20210419130527.791982064@linuxfoundation.org>
 <20210419130529.251281725@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419130529.251281725@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 03:05:53PM +0200, Greg Kroah-Hartman wrote:
> From: Aditya Pakki <pakki001@umn.edu>
> 
> [ Upstream commit 0c85a7e87465f2d4cbc768e245f4f45b2f299b05 ]
> 
> In case of rs failure in rds_send_remove_from_sock(), the 'rm' resource
> is freed and later under spinlock, causing potential use-after-free.
> Set the free pointer to NULL to avoid undefined behavior.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/rds/message.c | 1 +
>  net/rds/send.c    | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/rds/message.c b/net/rds/message.c
> index 799034e0f513..4fc66ff0f1ec 100644
> --- a/net/rds/message.c
> +++ b/net/rds/message.c
> @@ -180,6 +180,7 @@ void rds_message_put(struct rds_message *rm)
>  		rds_message_purge(rm);
>  
>  		kfree(rm);
> +		rm = NULL;
>  	}
>  }
>  EXPORT_SYMBOL_GPL(rds_message_put);
> diff --git a/net/rds/send.c b/net/rds/send.c
> index 985d0b7713ac..fe5264b9d4b3 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -665,7 +665,7 @@ static void rds_send_remove_from_sock(struct list_head *messages, int status)
>  unlock_and_drop:
>  		spin_unlock_irqrestore(&rm->m_rs_lock, flags);
>  		rds_message_put(rm);
> -		if (was_on_sock)
> +		if (was_on_sock && rm)
>  			rds_message_put(rm);
>  	}
>  
> -- 
> 2.30.2
> 
> 
> 

Ah crap, I will go drop this stuff.

I also will strongly recommend that all maintainers blacklist umn.edu
patches at this point in time, as it is obvious that a professor there
is operating a sociological experiment on Linux kernel maintainers and
is wasting our time.

This is not ok.

greg k-h
