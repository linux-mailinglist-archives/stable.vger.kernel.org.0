Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D87E610A26
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 08:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiJ1GRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 02:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiJ1GQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 02:16:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25511B7F01
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 23:16:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BC666262C
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 06:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AD8C433D7;
        Fri, 28 Oct 2022 06:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666937808;
        bh=Mfi5LZ/GaWrjx99WaAT9YHNlhK3pk9tYo2kxoSYkznY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PSMONs181tMM0ZRU2vqXdSZ5m+9ZIdfeSCdcl1EhUpEY2W6+SmL5pBPwuUgOmlNR5
         7XcRkhfOLPMJ+7UYbbY83tiXSKYbJkcOBkHy2qEByFjnA3eesbRi94uZ1Bk2Ckc+c4
         79BAaVMDYU464gcwwMJxqQ+vuUX+HvEkfu7xeoxE=
Date:   Fri, 28 Oct 2022 08:17:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     sashal@kernel.org, daniel@iogearbox.net, edumazet@google.com,
        kafai@fb.com, kuniyu@amazon.co.jp, patches@lists.linux.dev,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH 5.10 35/79] tcp: Add num_closed_socks to struct
 sock_reuseport.
Message-ID: <Y1t0Br1mqkhqYP8U@kroah.com>
References: <20221027165055.564998662@linuxfoundation.org>
 <20221027195349.75736-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027195349.75736-1-kuniyu@amazon.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 12:53:49PM -0700, Kuniyuki Iwashima wrote:
> Hi Greg, Sasha,
> 
> From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Thu, 27 Oct 2022 18:55:45 +0200
> > From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > 
> > [ Upstream commit 5c040eaf5d1753aafe12989ca712175df0b9c436 ]
> > 
> > As noted in the following commit, a closed listener has to hold the
> > reference to the reuseport group for socket migration. This patch adds a
> > field (num_closed_socks) to struct sock_reuseport to manage closed sockets
> > within the same reuseport group. Moreover, this and the following commits
> > introduce some helper functions to split socks[] into two sections and keep
> > TCP_LISTEN and TCP_CLOSE sockets in each section. Like a double-ended
> > queue, we will place TCP_LISTEN sockets from the front and TCP_CLOSE
> > sockets from the end.
> > 
> >   TCP_LISTEN---------->       <-------TCP_CLOSE
> >   +---+---+  ---  +---+  ---  +---+  ---  +---+
> >   | 0 | 1 |  ...  | i |  ...  | j |  ...  | k |
> >   +---+---+  ---  +---+  ---  +---+  ---  +---+
> > 
> >   i = num_socks - 1
> >   j = max_socks - num_closed_socks
> >   k = max_socks - 1
> > 
> > This patch also extends reuseport_add_sock() and reuseport_grow() to
> > support num_closed_socks.
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > Reviewed-by: Eric Dumazet <edumazet@google.com>
> > Acked-by: Martin KaFai Lau <kafai@fb.com>
> > Link: https://lore.kernel.org/bpf/20210612123224.12525-3-kuniyu@amazon.co.jp
> > Stable-dep-of: 69421bf98482 ("udp: Update reuse->has_conns under reuseport_lock.")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> I think this patch is backported due to a conflict with the cited commit
> 69421bf98482 ("udp: Update reuse->has_conns under reuseport_lock.").
> 
> The following patch seems to conflicts with some functions which are
> introduced in this patch, but the cited commit does not depend on the
> functions.
> 
> So, we can just remove the functions in this patch and resolve the
> conflict in the next patch like below. (based on the v5.10.150 branch)

so drop this "dependent" patch and just take your backport instead?

confused,

greg k-h
