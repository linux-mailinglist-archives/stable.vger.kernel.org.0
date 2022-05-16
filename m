Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692395292ED
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 23:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346780AbiEPVen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 17:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiEPVel (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 17:34:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE67403CA
        for <stable@vger.kernel.org>; Mon, 16 May 2022 14:34:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3C39B8124E
        for <stable@vger.kernel.org>; Mon, 16 May 2022 21:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D70C385AA;
        Mon, 16 May 2022 21:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652736877;
        bh=qapqPzikisdJ6Ct7Ji6yBuyidrXdJwxRuO0ntM1ocrM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A46u+T0HRUz0girhT6CL9+rv6HHzw7LyjnVtJMRpxkB7B7iv1b6o+MimiFeypCVLM
         NexLQtao3qyK/sQqOTjD+Srs7oYcNvAnYbJr1n4mU9z8Rtk9l2thXdCV9QELXpxNN3
         x4iLF7wD4ItNjZ6a2e+NdTH/wWITcOMAErtkI5Nw=
Date:   Mon, 16 May 2022 23:34:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Meena Shanmugam <meenashanmugam@google.com>
Cc:     enrico.scholz@sigma-chemnitz.de, stable@vger.kernel.org,
        trond.myklebust@hammerspace.com
Subject: Re: [PATCH 3/4] SUNRPC: Don't call connect() more than once on a TCP
 socket
Message-ID: <YoLDak9O1c1gu54I@kroah.com>
References: <Yn82ZO/Ysxq0v/0/@kroah.com>
 <20220514053453.3277330-1-meenashanmugam@google.com>
 <20220514053453.3277330-4-meenashanmugam@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220514053453.3277330-4-meenashanmugam@google.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 14, 2022 at 05:34:52AM +0000, Meena Shanmugam wrote:
> From: Trond Myklebust <trond.myklebust@hammerspace.com>
> 
> commit 89f42494f92f448747bd8a7ab1ae8b5d5520577d upstream.
> 
> Avoid socket state races due to repeated calls to ->connect() using the
> same socket. If connect() returns 0 due to the connection having
> completed, but we are in fact in a closing state, then we may leave the
> XPRT_CONNECTING flag set on the transport.
> 
> Reported-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> Fixes: 3be232f11a3c ("SUNRPC: Prevent immediate close+reconnect")
> Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
> [meenashanmugam: Backported to 5.10: Fixed merge conflict in xs_tcp_setup_socket]
> Signed-off-by: Meena Shanmugam <meenashanmugam@google.com>
> ---
>  include/linux/sunrpc/xprtsock.h |  1 +
>  net/sunrpc/xprtsock.c           | 21 +++++++++++----------
>  2 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/sunrpc/xprtsock.h b/include/linux/sunrpc/xprtsock.h
> index 8c2a712cb242..689062afdd61 100644
> --- a/include/linux/sunrpc/xprtsock.h
> +++ b/include/linux/sunrpc/xprtsock.h
> @@ -89,5 +89,6 @@ struct sock_xprt {
>  #define XPRT_SOCK_WAKE_WRITE	(5)
>  #define XPRT_SOCK_WAKE_PENDING	(6)
>  #define XPRT_SOCK_WAKE_DISCONNECT	(7)
> +#define XPRT_SOCK_CONNECT_SENT	(8)
>  
>  #endif /* _LINUX_SUNRPC_XPRTSOCK_H */
> diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
> index 60c58eb9a456..33a81f9703b1 100644
> --- a/net/sunrpc/xprtsock.c
> +++ b/net/sunrpc/xprtsock.c
> @@ -2260,10 +2260,14 @@ static void xs_tcp_setup_socket(struct work_struct *work)
>  	struct rpc_xprt *xprt = &transport->xprt;
>  	int status = -EIO;
>  
> -	if (!sock) {
> -		sock = xs_create_sock(xprt, transport,
> -				xs_addr(xprt)->sa_family, SOCK_STREAM,
> -				IPPROTO_TCP, true);
> +	if (xprt_connected(xprt))
> +		goto out;
> +	if (test_and_clear_bit(XPRT_SOCK_CONNECT_SENT,
> +			       &transport->sock_state) ||
> +	    !sock) {
> +		xs_reset_transport(transport);
> +		sock = xs_create_sock(xprt, transport, xs_addr(xprt)->sa_family,
> +				      SOCK_STREAM, IPPROTO_TCP, true);
>  		if (IS_ERR(sock)) {
>  			status = PTR_ERR(sock);
>  			goto out;
> @@ -2294,6 +2298,7 @@ static void xs_tcp_setup_socket(struct work_struct *work)
>  		break;
>  	case 0:
>  	case -EINPROGRESS:
> +		set_bit(XPRT_SOCK_CONNECT_SENT, &transport->sock_state);
>  	case -EALREADY:
>  		xprt_unlock_connect(xprt, transport);
>  		return;
> @@ -2345,13 +2350,9 @@ static void xs_connect(struct rpc_xprt *xprt, struct rpc_task *task)
>  
>  	WARN_ON_ONCE(!xprt_lock_connect(xprt, task, transport));
>  
> -	if (transport->sock != NULL && !xprt_connecting(xprt)) {
> +	if (transport->sock != NULL) {
>  		dprintk("RPC:       xs_connect delayed xprt %p for %lu "
> -				"seconds\n",
> -				xprt, xprt->reestablish_timeout / HZ);
> -
> -		/* Start by resetting any existing state */
> -		xs_reset_transport(transport);
> +			"seconds\n", xprt, xprt->reestablish_timeout / HZ);
>  
>  		delay = xprt_reconnect_delay(xprt);
>  		xprt_reconnect_backoff(xprt, XS_TCP_INIT_REEST_TO);
> -- 
> 2.36.0.550.gb090851708-goog
> 

This commit added a build warning.  Always properly test your changes,
they can not add warnings.

I've fixed it up by hand now.

thanks,

greg k-h
