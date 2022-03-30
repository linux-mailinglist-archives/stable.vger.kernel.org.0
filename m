Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B894EBCB5
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 10:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiC3I2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 04:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244356AbiC3I1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 04:27:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92935BE6D
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 01:26:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95F7AB8128F
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 08:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06345C340EC;
        Wed, 30 Mar 2022 08:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648628764;
        bh=8YSlaSucHwB36UAafgZTRApNkfTcZKWcIBdGcqrp9as=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ahRnaUslyzjoKx5RLqhcB/w2f+BuJBFqIvbyq3jPRWzKvUNxLKtho8FLV9FZIrl6U
         dR+AYWQz6yVu/2V5lhoJ4BHmDSfnNyvpWe/1cxkX50U3MSeNurDky+jlcbcP7UNkqu
         he6VslM4gScp5heY7JRW74KUwMfNjLKLCwztDL20=
Date:   Wed, 30 Mar 2022 10:26:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joshua Freedman <freedman.joshua@gmail.com>
Cc:     lis8215@gmail.com, paul@crapouillou.net, stable@vger.kernel.org,
        sboyd@kernel.org
Subject: Re: kernel 5.16.12 and above broke yoga c930 sound and mic
Message-ID: <YkQUGVC3MBSnc2LI@kroah.com>
References: <CAJQ3t4RxYXkREhwBb_JgYj4=ty+VtnV9m65U79ZLbmmj4mN7WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJQ3t4RxYXkREhwBb_JgYj4=ty+VtnV9m65U79ZLbmmj4mN7WA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 03:34:34AM -0400, Joshua Freedman wrote:
> Hi, I noticed my audio and mic stopped working on my yoga c930 on 5.16.12
> and newer. 5.16.11 was ok.   On 5.16.12 and above I get a dummy output and
> no mic.
> 
> Anything we can do about that?  Thanks.
> 
> I'm not a git guy so I just looked at the changlogs and this was the only
> audio one in 5.16.12.  I could be wrong in the ID though.
> 
> commit 6b0d719ffed1c21c1a2e473301fd95f78cd35c9e
> Author: Siarhei Volkau <lis8215@gmail.com>
> Date:   Sat Feb 5 20:18:49 2022 +0300
> 
>     clk: jz4725b: fix mmc0 clock gating
> 
>     commit 2f0754f27a230fee6e6d753f07585cee03bedfe3 upstream.
> 
>     The mmc0 clock gate bit was mistakenly assigned to "i2s" clock.
>     You can find that the same bit is assigned to "mmc0" too.
>     It leads to mmc0 hang for a long time after any sound activity
>     also it  prevented PM_SLEEP to work properly.
>     I guess it was introduced by copy-paste from jz4740 driver
>     where it is really controls I2S clock gate.
> 
>     Fixes: 226dfa4726eb ("clk: Add Ingenic jz4725b CGU driver")
>     Signed-off-by: Siarhei Volkau <lis8215@gmail.com>
>     Tested-by: Siarhei Volkau <lis8215@gmail.com>
>     Reviewed-by: Paul Cercueil <paul@crapouillou.net>
>     Cc: stable@vger.kernel.org
>     Link: https://lore.kernel.org/r/20220205171849.687805-2-lis8215@gmail.com
>     Signed-off-by: Stephen Boyd <sboyd@kernel.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 

If you revert this does your machine work properly?  Is 5.17 also broken
for you due to this change, or does it work properly?

thanks,

greg k-h
