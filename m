Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBF96509EA
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 11:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiLSKQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 05:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbiLSKQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 05:16:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6D9B489
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 02:16:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36B7060ED6
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 10:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B0BC433D2;
        Mon, 19 Dec 2022 10:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671444997;
        bh=9oSB6wA8J0Fzx083OD1V1hloA8OfjH0qFSMJ7us/7WY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CtINC5s/cgbuu3HFa9IFKokcpDAxtvkkrFG7lq+neuxtRFk12UkcOMDgCZnPTwjfz
         inoU3m51/gfUPKIvL4yUCrkVcQm7kMv6mrE7B6meG1zwbAouCj91yewXH+pzCSIAxM
         EqMVqA2yzGwiB9/FZtyx0WyY13p3PBSMyWuYs96g=
Date:   Mon, 19 Dec 2022 11:16:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 11/14] net: fec: dont reset irq coalesce settings to
 defaults on "ip link up"
Message-ID: <Y6A6AZRYm4Yq3cIz@kroah.com>
References: <20221215172906.338769943@linuxfoundation.org>
 <20221215172907.210669704@linuxfoundation.org>
 <6314ea2f-61f7-2c5a-86d3-1158b80bd5d4@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6314ea2f-61f7-2c5a-86d3-1158b80bd5d4@rasmusvillemoes.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 16, 2022 at 10:13:48AM +0100, Rasmus Villemoes wrote:
> On 15/12/2022 19.10, Greg Kroah-Hartman wrote:
> > From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> > 
> > [ Upstream commit df727d4547de568302b0ed15b0d4e8a469bdb456 ]
> 
> You should not take this unless you at the same time also take
> 
> commit 7e6303567ce3ca506e4a2704e4baa86f1d8bde02
> Author: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Date:   Mon Dec 5 21:46:04 2022 +0100
> 
>     net: fec: properly guard irq coalesce setup
> 
> which
> 
>     Fixes: df727d4547de (net: fec: don't reset irq coalesce settings to
> defaults on "ip link up")
> 
> The same of course applies to the 6.0.y series.
> 
> I don't know if your scripts already do this and it just somehow failed
> here, but it would probably be a good idea to always check if there is
> already a Fixes for a commit that gets chosen for -stable.

Ick, sorry, I thought I did run my "are there fixes for the queue"
script, but it looks like I did not at all, thank you for catching this!
I've now queued it up.

greg k-h
