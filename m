Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB52596DF9
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 14:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239260AbiHQMEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 08:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239241AbiHQMEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 08:04:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF3B4D247
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 05:04:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE9F5B81D90
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 12:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB18C433B5;
        Wed, 17 Aug 2022 12:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660737865;
        bh=6JT/9tCvggxa5M5DKmkpDy+jtV2jYGe/kNrkWSv2M88=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0LJhe/TFTFJ33xJePzxbpfgLVoDTHFE6peyWBNmJHDtew2jR2FBlmkgPixHwCM2Wd
         Yt9D8zKcW5cttk33KaFqyIwLY7JzuPA8mtYB5Dg9V56p55lfHfprcuIo6Df5zxy2I7
         4tsKOGymP+DAPWTLxzHGz6k4s9rWxxwfASfqNujc=
Date:   Wed, 17 Aug 2022 14:04:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>, stable@vger.kernel.org,
        Wei Wang <weiwan@google.com>, LemmyHuang <hlm3280@163.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH stable 5.4] Revert "tcp: change pingpong threshold to 3"
Message-ID: <YvzZR4busDunw1Cd@kroah.com>
References: <165919469116877@kroah.com>
 <20220815205129.6335-1-kuniyu@amazon.com>
 <47081c01-9e03-8505-6ff9-c6d3def2cc06@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47081c01-9e03-8505-6ff9-c6d3def2cc06@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 07:49:17AM +0200, Jiri Slaby wrote:
> On 15. 08. 22, 22:51, Kuniyuki Iwashima wrote:
> > From: Wei Wang <weiwan@google.com>
> > 
> > commit 4d8f24eeedc58d5f87b650ddda73c16e8ba56559 upstream.
> > 
> > This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.
> > 
> > This to-be-reverted commit was meant to apply a stricter rule for the
> > stack to enter pingpong mode. However, the condition used to check for
> > interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
> > jiffy based and might be too coarse, which delays the stack entering
> > pingpong mode.
> > We revert this patch so that we no longer use the above condition to
> > determine interactive session, and also reduce pingpong threshold to 1.
> 
> I would wait a bit before backporting this to stable:
> https://lore.kernel.org/all/ca408271-8730-eb2b-f12e-3f66df2e643a@kernel.org/

Looks like all is good, so I'll leave this be for now.

thanks,

greg k-h
