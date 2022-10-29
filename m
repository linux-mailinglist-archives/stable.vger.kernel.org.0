Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1776120B0
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 08:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJ2G0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 02:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiJ2G0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 02:26:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91231C883B
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 23:26:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39B77B82EAF
        for <stable@vger.kernel.org>; Sat, 29 Oct 2022 06:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5BEC433C1;
        Sat, 29 Oct 2022 06:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667024794;
        bh=EWzBtxVwGLgORLQBeHu6093lNnoUlrNYoln5vE/g+20=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dpz+P5hBHD2ZQqArjWUxIwLW2jS2bRWEFatvNxRKKVaWtvkJ+UY/QN+/5UvmdwBPe
         JEy/I8xLeO88GBCZFVUrkXPBFMTjd7iUO4ZAcZUFm0zQ3+CUlJf1ApawD4TrCP6Ijk
         H9KstRDdIBQ/eS0q7WyryF2wtY28xCw1fR9vtw7g=
Date:   Sat, 29 Oct 2022 08:27:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     daniel@iogearbox.net, edumazet@google.com, kafai@fb.com,
        kuniyu@amazon.co.jp, pabeni@redhat.com, patches@lists.linux.dev,
        sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 35/79] tcp: Add num_closed_socks to struct
 sock_reuseport.
Message-ID: <Y1zH0kb1gdm+zjt3@kroah.com>
References: <Y1t0Br1mqkhqYP8U@kroah.com>
 <20221028170552.59120-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028170552.59120-1-kuniyu@amazon.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 28, 2022 at 10:05:52AM -0700, Kuniyuki Iwashima wrote:
> From:   Greg KH <gregkh@linuxfoundation.org>
> Date:   Fri, 28 Oct 2022 08:17:42 +0200
> > On Thu, Oct 27, 2022 at 12:53:49PM -0700, Kuniyuki Iwashima wrote:
> > > Hi Greg, Sasha,
> > > 
> > > From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Date:   Thu, 27 Oct 2022 18:55:45 +0200
> > > > From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > 
> > > > [ Upstream commit 5c040eaf5d1753aafe12989ca712175df0b9c436 ]
> > > > 
> > > > As noted in the following commit, a closed listener has to hold the
> > > > reference to the reuseport group for socket migration. This patch adds a
> > > > field (num_closed_socks) to struct sock_reuseport to manage closed sockets
> > > > within the same reuseport group. Moreover, this and the following commits
> > > > introduce some helper functions to split socks[] into two sections and keep
> > > > TCP_LISTEN and TCP_CLOSE sockets in each section. Like a double-ended
> > > > queue, we will place TCP_LISTEN sockets from the front and TCP_CLOSE
> > > > sockets from the end.
> > > > 
> > > >   TCP_LISTEN---------->       <-------TCP_CLOSE
> > > >   +---+---+  ---  +---+  ---  +---+  ---  +---+
> > > >   | 0 | 1 |  ...  | i |  ...  | j |  ...  | k |
> > > >   +---+---+  ---  +---+  ---  +---+  ---  +---+
> > > > 
> > > >   i = num_socks - 1
> > > >   j = max_socks - num_closed_socks
> > > >   k = max_socks - 1
> > > > 
> > > > This patch also extends reuseport_add_sock() and reuseport_grow() to
> > > > support num_closed_socks.
> > > > 
> > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > > > Reviewed-by: Eric Dumazet <edumazet@google.com>
> > > > Acked-by: Martin KaFai Lau <kafai@fb.com>
> > > > Link: https://lore.kernel.org/bpf/20210612123224.12525-3-kuniyu@amazon.co.jp
> > > > Stable-dep-of: 69421bf98482 ("udp: Update reuse->has_conns under reuseport_lock.")
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > 
> > > I think this patch is backported due to a conflict with the cited commit
> > > 69421bf98482 ("udp: Update reuse->has_conns under reuseport_lock.").
> > > 
> > > The following patch seems to conflicts with some functions which are
> > > introduced in this patch, but the cited commit does not depend on the
> > > functions.
> > > 
> > > So, we can just remove the functions in this patch and resolve the
> > > conflict in the next patch like below. (based on the v5.10.150 branch)
> > 
> > so drop this "dependent" patch and just take your backport instead?
> 
> Yes, my backport patch replaces these patches in this series.
> 
>   [PATCH 5.10 35/79] tcp: Add num_closed_socks to struct sock_reuseport
>   [PATCH 5.10 36/79] udp: Update reuse->has_conns under reuseport_lock

Ah, yes, thank you, your backport was much simpler.  Now fixed up.

greg k-h
