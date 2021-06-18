Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650A23AD63B
	for <lists+stable@lfdr.de>; Sat, 19 Jun 2021 02:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbhFSASm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 20:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbhFSASl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 20:18:41 -0400
X-Greylist: delayed 1075 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 18 Jun 2021 17:16:31 PDT
Received: from puleglot.ru (puleglot.ru [IPv6:2a01:4f8:1c0c:58e8::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08EFC061574;
        Fri, 18 Jun 2021 17:16:31 -0700 (PDT)
Received: from [2a00:1370:8125:af50::b41]
        by puleglot.ru with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <puleglot@puleglot.ru>)
        id 1luONb-0000mP-2Y; Sat, 19 Jun 2021 02:58:30 +0300
Message-ID: <fb24ef9ad94f8b052407c5bdd4e3815675b89213.camel@tsoy.me>
Subject: Re: [PATCH 5.10 35/38] rtnetlink: Fix missing error code in
 rtnl_bridge_notify()
From:   Alexander Tsoy <alexander@tsoy.me>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Date:   Sat, 19 Jun 2021 02:58:28 +0300
In-Reply-To: <20210616152836.507544876@linuxfoundation.org>
References: <20210616152835.407925718@linuxfoundation.org>
         <20210616152836.507544876@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: puleglot@puleglot.ru
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

В Ср, 16/06/2021 в 17:33 +0200, Greg Kroah-Hartman пишет:
> From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [ Upstream commit a8db57c1d285c758adc7fb43d6e2bad2554106e1 ]
> 
> The error code is missing in this code scenario, add the error code
> '-EINVAL' to the return value 'err'.
> 
> Eliminate the follow smatch warning:
> 
> net/core/rtnetlink.c:4834 rtnl_bridge_notify() warn: missing error code
> 'err'.

This patch breaks systemd-resolved. It is 100% reproducible on two of
my systems, but there are also systems where I cannot reproduce it. The
problem manifests itself as SERVFAIL on every DNS query.

Just reverting this patch from 5.10.45 fixes the problem for me.

> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/core/rtnetlink.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index eae8e87930cd..83894723ebee 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -4842,8 +4842,10 @@ static int rtnl_bridge_notify(struct net_device
> *dev)
>         if (err < 0)
>                 goto errout;
>  
> -       if (!skb->len)
> +       if (!skb->len) {
> +               err = -EINVAL;
>                 goto errout;
> +       }
>  
>         rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, GFP_ATOMIC);
>         return 0;


