Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D8E55896C
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 21:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbiFWTo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 15:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiFWToM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 15:44:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0094B60E37;
        Thu, 23 Jun 2022 12:36:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45D91619E2;
        Thu, 23 Jun 2022 19:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BCDC341C0;
        Thu, 23 Jun 2022 19:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656012985;
        bh=nDfbSGYCTY10pLb2wgmFt1IEf1MTe6t7GSlKVQ2JcT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TNYj8V4Vk+eOmExRYynKVKPcBCfhQDJxUM4nvDKUQbCJDlLXhl1G35xwsJDd0vx72
         AzX0zlP2qu8ObxTIQRvIFsUmCqVIHtybwiKaKtyHXianqPNd8Qd+P2ACY9YCXgq4I7
         iPWf01DgDD94W5hX8S/IzHvvAva4fmB8xwnrYOikZBmb01btT9RcFQ7YOrSkLVMovg
         xjbzZMfeekny02F1E1E1XGk1soGlEHoFCietgUSOe5v79RQhW1UCruedhljPnV50xf
         gAtM4zl+cqSOgVz/tLnMObKzUZcPdUdf8e5PJcDGAQf9n9+29HChputg/bdbzWun+S
         GiBiQcg4YrY1g==
Date:   Thu, 23 Jun 2022 12:36:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] timekeeping: contribute wall clock to rng on time
 change
Message-ID: <YrTAt2g4gg/2e+5L@sol.localdomain>
References: <CAHmME9qGQrgCEGgQpomq6W2EMUy_D5AxqgYHykmmgND+PPVjjw@mail.gmail.com>
 <20220623191249.1357363-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623191249.1357363-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 09:12:49PM +0200, Jason A. Donenfeld wrote:
> The rng's random_init() function contributes the real time to the rng at
> boot time, so that events can at least start in relation to something
> particular in the real world. But this clock might not yet be set that
> point in boot, so nothing is contributed. In addition, the relation
> between minor clock changes from, say, NTP, and the cycle counter is
> potentially useful entropic data.
> 
> This commit addresses this by mixing in a time stamp on calls to
> settimeofday and adjtimex. No entropy is credited in doing so, so it
> doesn't make initialization faster, but it is still useful input to
> have.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  kernel/time/timekeeping.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
