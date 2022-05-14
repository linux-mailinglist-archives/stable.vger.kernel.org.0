Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24AB4526E81
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 09:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiENE4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 00:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbiENE4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 00:56:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE61A2B240
        for <stable@vger.kernel.org>; Fri, 13 May 2022 21:56:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5957B831D5
        for <stable@vger.kernel.org>; Sat, 14 May 2022 04:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225D6C340EE;
        Sat, 14 May 2022 04:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652504168;
        bh=zfsH9dKLRVJw1jZg2j1G3rJGB6Eoy9mQTUdjwpY+0+Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DXCWGF3RyL0yBx5XNTqFe5diJ7oL7I4IjVUD4XRUQA1Sxkz+FIOm7OfFYlRxmvAGd
         SttGvk+Yfhj/0dERSWCjG2vy1/w0zviY8+kcofkHJJebu8A1DjnT5GJDz9r6YPYYYM
         FZLvwcraWF4W4Rje1S5MTlldiLJvAPookGLR8hxo=
Date:   Sat, 14 May 2022 06:56:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Meena Shanmugam <meenashanmugam@google.com>
Cc:     stable@vger.kernel.org, trond.myklebust@hammerspace.com,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Subject: Re: [PATCH] SUNRPC: Don't call connect() more than once on a TCP
 socket
Message-ID: <Yn82ZO/Ysxq0v/0/@kroah.com>
References: <Yn4V4HdJFyHARf1b@kroah.com>
 <20220513175959.3179701-1-meenashanmugam@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513175959.3179701-1-meenashanmugam@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 13, 2022 at 05:59:59PM +0000, Meena Shanmugam wrote:
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
> 2.36.0.512.ge40c2bad7a-goog
> 

This should be a patch series, not just this one commit, right?

What are _ALL_ of the commits you want to see applied for 5.10.y?

thanks,

greg k-h
