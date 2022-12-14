Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E11864CF70
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 19:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238527AbiLNSa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 13:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238832AbiLNSa1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 13:30:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B2B19286;
        Wed, 14 Dec 2022 10:30:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB63AB81983;
        Wed, 14 Dec 2022 18:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40B6C433EF;
        Wed, 14 Dec 2022 18:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671042623;
        bh=NFgaBwH9iAJLgv24/VuvOV9n5tzSj9XqbZzAMz/3tu4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0VH2FjUNTYSQnMWEHKm5osJzrQQrby1oskqhB8SQ2i7z4s3/91QgG63p6k6CGpo8D
         tBjC5ukQteD2qpJRjxYkh7A08Gk73R4v1eHwITU1xsG8YbFbnGN3lar5AUJAFpclAK
         5PlRyMca1PSOvPtuIC//ofH0xoS9xMKoOA5fOj/M=
Date:   Wed, 14 Dec 2022 19:30:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Eric Dumazet <edumazet@google.com>,
        Willy Tarreau <w@1wt.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] [REBASED for 4.14] once: add DO_ONCE_SLOW() for
 sleepable contexts
Message-ID: <Y5oWPJ2qApAUgRs4@kroah.com>
References: <df44c3cd06ae0155f04f9d87fff35db67761beea.1670934155.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df44c3cd06ae0155f04f9d87fff35db67761beea.1670934155.git.christophe.leroy@csgroup.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 01:22:40PM +0100, Christophe Leroy wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> [ Upstream commit 62c07983bef9d3e78e71189441e1a470f0d1e653 ]
> 
> Christophe Leroy reported a ~80ms latency spike
> happening at first TCP connect() time.
> 
> This is because __inet_hash_connect() uses get_random_once()
> to populate a perturbation table which became quite big
> after commit 4c2c8f03a5ab ("tcp: increase source port perturb table to 2^16")
> 
> get_random_once() uses DO_ONCE(), which block hard irqs for the duration
> of the operation.
> 
> This patch adds DO_ONCE_SLOW() which uses a mutex instead of a spinlock
> for operations where we prefer to stay in process context.
> 
> Then __inet_hash_connect() can use get_random_slow_once()
> to populate its perturbation table.
> 
> Fixes: 4c2c8f03a5ab ("tcp: increase source port perturb table to 2^16")
> Fixes: 190cc82489f4 ("tcp: change source port randomizarion at connect() time")
> Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Link: https://lore.kernel.org/netdev/CANn89iLAEYBaoYajy0Y9UmGFff5GPxDUoG-ErVB2jDdRNQ5Tug@mail.gmail.com/T/#t
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Willy Tarreau <w@1wt.eu>
> Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> ---
>  include/linux/once.h       | 28 ++++++++++++++++++++++++++++
>  lib/once.c                 | 30 ++++++++++++++++++++++++++++++
>  net/ipv4/inet_hashtables.c |  4 ++--
>  3 files changed, 60 insertions(+), 2 deletions(-)

Now queued up, thanks.

greg k-h
