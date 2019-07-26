Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0546F7661B
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 14:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfGZMpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 08:45:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbfGZMpW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 08:45:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A732921951;
        Fri, 26 Jul 2019 12:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564145121;
        bh=VstrHKlLwVD4oiqI8kzSLM5YTJWL47oNQH4NV5pgMgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HuSa2yeEQXT35JfmTqfXTbF9BBLBWCCL8C9u4p5y2Gref8s04U+qe1cMsvXes3hwa
         DfTv2F2mY74Gn2RxYLhG85OueOF0BSuXkfMvZOiHPFHed/YGIORg27IpnJstQwEy7h
         zrNdlHODQ9gDsXUIIrPflmaPIq3jm3zbjsMF17Rs=
Date:   Fri, 26 Jul 2019 14:45:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     edumazet@google.com, aprout@ll.mit.edu, cpaasch@apple.com,
        davem@davemloft.net, jonathan.lemon@gmail.com, jtl@netflix.com,
        mkubecek@suse.cz, ncardwell@google.com, ycheng@google.com
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tcp: be more careful in tcp_fragment()"
 failed to apply to 4.14-stable tree
Message-ID: <20190726124517.GA8301@kroah.com>
References: <1564144694159130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564144694159130@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 02:38:14PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
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
> >From b617158dc096709d8600c53b6052144d12b89fab Mon Sep 17 00:00:00 2001
> From: Eric Dumazet <edumazet@google.com>
> Date: Fri, 19 Jul 2019 11:52:33 -0700
> Subject: [PATCH] tcp: be more careful in tcp_fragment()
> 
> Some applications set tiny SO_SNDBUF values and expect
> TCP to just work. Recent patches to address CVE-2019-11478
> broke them in case of losses, since retransmits might
> be prevented.
> 
> We should allow these flows to make progress.
> 
> This patch allows the first and last skb in retransmit queue
> to be split even if memory limits are hit.
> 
> It also adds the some room due to the fact that tcp_sendmsg()
> and tcp_sendpage() might overshoot sk_wmem_queued by about one full
> TSO skb (64KB size). Note this allowance was already present
> in stable backports for kernels < 4.15
> 
> Note for < 4.15 backports :
>  tcp_rtx_queue_tail() will probably look like :
> 
> static inline struct sk_buff *tcp_rtx_queue_tail(const struct sock *sk)
> {
> 	struct sk_buff *skb = tcp_send_head(sk);
> 
> 	return skb ? tcp_write_queue_prev(sk, skb) : tcp_write_queue_tail(sk);
> }


Note, I tried the above, but still ran into problems a 4.14 does not
have tcp_rtx_queue_head() and while I could guess as to what it would be
(tcp_sent_head()?), I figured it would be safer to ask for a backport :)

thanks,

greg k-h
