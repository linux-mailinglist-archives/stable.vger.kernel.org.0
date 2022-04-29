Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843F151449E
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 10:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355910AbiD2Iqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 04:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355836AbiD2Iqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 04:46:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC3B13D3A
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 01:43:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD84CB832D7
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 08:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D78C385AD;
        Fri, 29 Apr 2022 08:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651221788;
        bh=FqHGnIVLpY0QD1OV4EsnpnMPUJvSPum/CjmKp/NIZg0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1oNCoduQHbIvtgwBHVbVavWsduYL/PPFwygNLEKNxBWyDTbf/PyWdCodOO68ExJMp
         zIhEDKmjTHIz91UmV9rTY20jYPXgTr7DhkCyKMWXWxkmjUfRNYJt56K2ocM+HxyLiS
         OpU3e0dtwcskVxMVqXOKi1ij2UU2RG10Db6vJ7Ik=
Date:   Fri, 29 Apr 2022 10:43:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Xu Jia <xujia39@huawei.com>
Subject: Re: [PATCH 5.4 1/2] hamradio: defer 6pack kfree after
 unregister_netdev
Message-ID: <YmulFKXYoHTuD4W/@kroah.com>
References: <20220428133111.916981-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428133111.916981-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 28, 2022 at 04:31:10PM +0300, Ovidiu Panait wrote:
> From: Lin Ma <linma@zju.edu.cn>
> 
> commit 0b9111922b1f399aba6ed1e1b8f2079c3da1aed8 upstream.
> 
> There is a possible race condition (use-after-free) like below
> 
>  (USE)                       |  (FREE)
>   dev_queue_xmit             |
>    __dev_queue_xmit          |
>     __dev_xmit_skb           |
>      sch_direct_xmit         | ...
>       xmit_one               |
>        netdev_start_xmit     | tty_ldisc_kill
>         __netdev_start_xmit  |  6pack_close
>          sp_xmit             |   kfree
>           sp_encaps          |
>                              |
> 
> According to the patch "defer ax25 kfree after unregister_netdev", this
> patch reorder the kfree after the unregister_netdev to avoid the possible
> UAF as the unregister_netdev() is well synchronized and won't return if
> there is a running routine.
> 
> Signed-off-by: Lin Ma <linma@zju.edu.cn>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Xu Jia <xujia39@huawei.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
> These commits are part of CVE-2022-1195 patchset.
> Reference: https://bugzilla.redhat.com/show_bug.cgi?id=2056381
> [1] https://github.com/torvalds/linux/commit/3e0588c291d6ce225f2b891753ca41d45ba42469
> [2] https://github.com/torvalds/linux/commit/b2f37aead1b82a770c48b5d583f35ec22aabb61e
> [3] https://github.com/torvalds/linux/commit/0b9111922b1f399aba6ed1e1b8f2079c3da1aed8
> [4] https://github.com/torvalds/linux/commit/81b1d548d00bcd028303c4f3150fa753b9b8aa71
> 
> Commits [1] and [2] are already present in 5.4-stable, this patchset includes
> backports for [3] and [4] (clean cherry-picks from 5.10 stable).
> 
>  drivers/net/hamradio/6pack.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
> index 02d6f3ad9aca..82507a688efe 100644
> --- a/drivers/net/hamradio/6pack.c
> +++ b/drivers/net/hamradio/6pack.c
> @@ -679,9 +679,11 @@ static void sixpack_close(struct tty_struct *tty)
>  	del_timer_sync(&sp->tx_t);
>  	del_timer_sync(&sp->resync_t);
>  
> -	/* Free all 6pack frame buffers. */
> +	/* Free all 6pack frame buffers after unreg. */
>  	kfree(sp->rbuff);
>  	kfree(sp->xbuff);
> +
> +	free_netdev(sp->dev);
>  }
>  
>  /* Perform I/O control on an active 6pack channel. */
> -- 
> 2.36.0
> 

All backports now queued up, thanks!

greg k-h
