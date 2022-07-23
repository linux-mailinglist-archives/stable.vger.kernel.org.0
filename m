Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3140F57F00D
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 17:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235221AbiGWPUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 11:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbiGWPT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 11:19:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A22B87F;
        Sat, 23 Jul 2022 08:19:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0F4360C0A;
        Sat, 23 Jul 2022 15:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADED0C341C0;
        Sat, 23 Jul 2022 15:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658589598;
        bh=IKWj0a/HfvVLYcT/bIqRy//jkSi5vKPspnLfv/oMmGA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ud8lphhIODAgW1NnifDqMNjf/SZnYHBYK3G2I/msx3yd3bo6xiSSI6XlCZwjrUClO
         jnHNGqkOXNOEvxDkrUwWr1avnz/k//yb0zUQaeHw8eDlPamhj/C94st7f/AkdCDRNm
         hjJtrmDeLJF0Ah/AD5g8KK7h8zfv0u5fvlJ+Ax+M=
Date:   Sat, 23 Jul 2022 17:19:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Antonio Quartulli <a@unstable.cc>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>,
        b.a.t.m.a.n@lists.open-mesh.org,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5.15] batman-adv: Use netif_rx_any_context() any.
Message-ID: <YtwRk2OVuALT3khr@kroah.com>
References: <YtbW7Ca3t4/3qB7k@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtbW7Ca3t4/3qB7k@linutronix.de>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 06:08:12PM +0200, Sebastian Andrzej Siewior wrote:
> This reverts the stable commit
>    e65d78b12fbc0 ("batman-adv: Use netif_rx().")
> 
> The commit message says:
> 
> | Since commit
> |    baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any context.")
> |
> | the function netif_rx() can be used in preemptible/thread context as
> | well as in interrupt context.
> 
> This commit (baebdf48c3600) has not been backported to the 5.15 stable
> series and therefore, the commit which builds upon it, must not be
> backported either.
> 
> Revert the backport and use netif_rx_any_context() again.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  net/batman-adv/bridge_loop_avoidance.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
