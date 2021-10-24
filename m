Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C62438900
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 15:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhJXNRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 09:17:33 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.164]:12394 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhJXNRc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Oct 2021 09:17:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1635081295;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=m44LCMPspsqMLR8FFq3T9J6h/YPjtv6sNxBGq9wlQh0=;
    b=kbGy+gvROyq2+Pyj4SXZSCRdfXFz5Bhyu7buLhc+dPce00KScccwKbOANNojO6Oqbc
    Ca98yur7461m/WjZR/XidWlDlfuFMkJ81HC9AW+YY3TCnUCe/nUE8yC4pxn7WxIbl/UI
    Mn/Awghp1EPohRvfJYLAcNElfID5a9Kks6brVRy6JEmDXltCUf5r6myGtA/qpTLYgF0M
    k4clquXNAAnzIcH5UpwNjNXfDAwFx+b6kf9zIyXPuR/kJz844RbuoFhfsOH/lkE9rh02
    dnBl3ixRrQ2eRFk/NPhW12ok+4tIGWOBCo2KEYKOwDb8m6eN939H9OfZKmahOM0N563u
    MzSg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.33.8 AUTH)
    with ESMTPSA id 900f80x9ODEtWFg
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 24 Oct 2021 15:14:55 +0200 (CEST)
Subject: Re: FAILED: patch "[PATCH] can: isotp: isotp_sendmsg(): fix TX buffer
 concurrent access" failed to apply to 5.10-stable tree
To:     gregkh@linuxfoundation.org, william.xuanziyang@huawei.com,
        mkl@pengutronix.de
Cc:     stable@vger.kernel.org, linux-can <linux-can@vger.kernel.org>
References: <16350748387398@kroah.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <abf4c126-844b-615f-7704-0d6a4697cadb@hartkopp.net>
Date:   Sun, 24 Oct 2021 15:14:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <16350748387398@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

Linux 5.10 is missing the SF_BROADCAST support which was introduced in 
5.11 - that broke the application of the original patch.

Just sent out a patch for 5.10-stable some minutes ago:

[PATCH 5.10-stable] can: isotp: isotp_sendmsg(): fix TX buffer 
concurrent access in isotp_sendmsg()

Thanks for your work!

Best regards,
Oliver

On 24.10.21 13:27, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
>  From 43a08c3bdac4cb42eff8fe5e2278bffe0c5c3daa Mon Sep 17 00:00:00 2001
> From: Ziyang Xuan <william.xuanziyang@huawei.com>
> Date: Sat, 9 Oct 2021 15:40:30 +0800
> Subject: [PATCH] can: isotp: isotp_sendmsg(): fix TX buffer concurrent access
>   in isotp_sendmsg()
> 
> When isotp_sendmsg() concurrent, tx.state of all TX processes can be
> ISOTP_IDLE. The conditions so->tx.state != ISOTP_IDLE and
> wq_has_sleeper(&so->wait) can not protect TX buffer from being
> accessed by multiple TX processes.
> 
> We can use cmpxchg() to try to modify tx.state to ISOTP_SENDING firstly.
> If the modification of the previous process succeed, the later process
> must wait tx.state to ISOTP_IDLE firstly. Thus, we can ensure TX buffer
> is accessed by only one process at the same time. And we should also
> restore the original tx.state at the subsequent error processes.
> 
> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
> Link: https://lore.kernel.org/all/c2517874fbdf4188585cf9ddf67a8fa74d5dbde5.1633764159.git.william.xuanziyang@huawei.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> diff --git a/net/can/isotp.c b/net/can/isotp.c
> index 2ac29c2b2ca6..d1f54273c0bb 100644
> --- a/net/can/isotp.c
> +++ b/net/can/isotp.c
> @@ -121,7 +121,7 @@ enum {
>   struct tpcon {
>   	int idx;
>   	int len;
> -	u8 state;
> +	u32 state;
>   	u8 bs;
>   	u8 sn;
>   	u8 ll_dl;
> @@ -848,6 +848,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
>   {
>   	struct sock *sk = sock->sk;
>   	struct isotp_sock *so = isotp_sk(sk);
> +	u32 old_state = so->tx.state;
>   	struct sk_buff *skb;
>   	struct net_device *dev;
>   	struct canfd_frame *cf;
> @@ -860,47 +861,55 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
>   		return -EADDRNOTAVAIL;
>   
>   	/* we do not support multiple buffers - for now */
> -	if (so->tx.state != ISOTP_IDLE || wq_has_sleeper(&so->wait)) {
> -		if (msg->msg_flags & MSG_DONTWAIT)
> -			return -EAGAIN;
> +	if (cmpxchg(&so->tx.state, ISOTP_IDLE, ISOTP_SENDING) != ISOTP_IDLE ||
> +	    wq_has_sleeper(&so->wait)) {
> +		if (msg->msg_flags & MSG_DONTWAIT) {
> +			err = -EAGAIN;
> +			goto err_out;
> +		}
>   
>   		/* wait for complete transmission of current pdu */
>   		err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
>   		if (err)
> -			return err;
> +			goto err_out;
>   	}
>   
> -	if (!size || size > MAX_MSG_LENGTH)
> -		return -EINVAL;
> +	if (!size || size > MAX_MSG_LENGTH) {
> +		err = -EINVAL;
> +		goto err_out;
> +	}
>   
>   	/* take care of a potential SF_DL ESC offset for TX_DL > 8 */
>   	off = (so->tx.ll_dl > CAN_MAX_DLEN) ? 1 : 0;
>   
>   	/* does the given data fit into a single frame for SF_BROADCAST? */
>   	if ((so->opt.flags & CAN_ISOTP_SF_BROADCAST) &&
> -	    (size > so->tx.ll_dl - SF_PCI_SZ4 - ae - off))
> -		return -EINVAL;
> +	    (size > so->tx.ll_dl - SF_PCI_SZ4 - ae - off)) {
> +		err = -EINVAL;
> +		goto err_out;
> +	}
>   
>   	err = memcpy_from_msg(so->tx.buf, msg, size);
>   	if (err < 0)
> -		return err;
> +		goto err_out;
>   
>   	dev = dev_get_by_index(sock_net(sk), so->ifindex);
> -	if (!dev)
> -		return -ENXIO;
> +	if (!dev) {
> +		err = -ENXIO;
> +		goto err_out;
> +	}
>   
>   	skb = sock_alloc_send_skb(sk, so->ll.mtu + sizeof(struct can_skb_priv),
>   				  msg->msg_flags & MSG_DONTWAIT, &err);
>   	if (!skb) {
>   		dev_put(dev);
> -		return err;
> +		goto err_out;
>   	}
>   
>   	can_skb_reserve(skb);
>   	can_skb_prv(skb)->ifindex = dev->ifindex;
>   	can_skb_prv(skb)->skbcnt = 0;
>   
> -	so->tx.state = ISOTP_SENDING;
>   	so->tx.len = size;
>   	so->tx.idx = 0;
>   
> @@ -956,7 +965,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
>   	if (err) {
>   		pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
>   			       __func__, ERR_PTR(err));
> -		return err;
> +		goto err_out;
>   	}
>   
>   	if (wait_tx_done) {
> @@ -965,6 +974,13 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
>   	}
>   
>   	return size;
> +
> +err_out:
> +	so->tx.state = old_state;
> +	if (so->tx.state == ISOTP_IDLE)
> +		wake_up_interruptible(&so->wait);
> +
> +	return err;
>   }
>   
>   static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
> 
