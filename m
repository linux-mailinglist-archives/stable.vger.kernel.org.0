Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D735C533C8F
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 14:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241046AbiEYMZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 08:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbiEYMZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 08:25:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347E16D3AC
        for <stable@vger.kernel.org>; Wed, 25 May 2022 05:25:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81BFB61711
        for <stable@vger.kernel.org>; Wed, 25 May 2022 12:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78442C34113;
        Wed, 25 May 2022 12:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653481535;
        bh=2znGh1s/eVsz7Fjr0CgOkei6MenX44CicFVVkPOfXxE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=saoKls/Fx8b3fgAV9Yu1nyt0HN09NXCU1YYMPxcG9+KD8TdHvHnO4Bt2aU6BW75Mv
         BmRknH6uukaZjsbt23JyHxV+Nm2E+IP9KJoTP0tlFXYXGnsdztO2boiJGucH8JZ8cS
         MGbI+ktJoSss1Vn3Y1LtJt8Itzs3qgUr+wmpV380=
Date:   Wed, 25 May 2022 14:25:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        stable@vger.kernel.org, sashal@kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        MPTCP Upstream <mptcp@lists.linux.dev>
Subject: Re: [PATCH] mptcp: Do TCP fallback on early DSS checksum failure
Message-ID: <Yo4gPPQ1GVzblG8B@kroah.com>
References: <20220524181041.19543-1-mathew.j.martineau@linux.intel.com>
 <Yo3gG9H8Sw/w7baR@kroah.com>
 <0648dc99-7465-871c-90a1-8a69f60d893c@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0648dc99-7465-871c-90a1-8a69f60d893c@tessares.net>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 25, 2022 at 12:32:04PM +0200, Matthieu Baerts wrote:
> Hi Greg, Mat,
> 
> On 25/05/2022 09:51, Greg KH wrote:
> > On Tue, May 24, 2022 at 11:10:41AM -0700, Mat Martineau wrote:
> >> [ Upstream commit ae66fb2ba6c3dcaf8b9612b65aa949a1a4bed150 ]
> >>
> >> RFC 8684 section 3.7 describes several opportunities for a MPTCP
> >> connection to "fall back" to regular TCP early in the connection
> >> process, before it has been confirmed that MPTCP options can be
> >> successfully propagated on all SYN, SYN/ACK, and data packets. If a peer
> >> acknowledges the first received data packet with a regular TCP header
> >> (no MPTCP options), fallback is allowed.
> >>
> >> If the recipient of that first data packet finds a MPTCP DSS checksum
> >> error, this provides an opportunity to fail gracefully with a TCP
> >> fallback rather than resetting the connection (as might happen if a
> >> checksum failure were detected later).
> >>
> >> This commit modifies the checksum failure code to attempt fallback on
> >> the initial subflow of a MPTCP connection, only if it's a failure in the
> >> first data mapping. In cases where the peer initiates the connection,
> >> requests checksums, is the first to send data, and the peer is sending
> >> incorrect checksums (see
> >> https://github.com/multipath-tcp/mptcp_net-next/issues/275), this allows
> >> the connection to proceed as TCP rather than reset.
> >>
> >> Cc: <stable@vger.kernel.org> # 5.17.x
> >> Cc: <stable@vger.kernel.org> # 5.15.x
> >> Fixes: dd8bcd1768ff ("mptcp: validate the data checksum")
> >> Acked-by: Paolo Abeni <pabeni@redhat.com>
> >> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> >> Signed-off-by: David S. Miller <davem@davemloft.net>
> >> [mathew.j.martineau: backport: Resolved bitfield conflict in protocol.h]
> >> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> >> ---
> >>
> >> This patch is already in 5.17.10-rc1 and 5.15.42-rc1, but involves a
> >> context dependency on upstream commit 4cf86ae84c71 which I have
> >> requested to be dropped from the stable queues.
> >>
> >> I'm posting this backport without the protocol.h conflict to
> >> (hopefully?) make it easier for the stable maintainers to drop
> >> 4cf86ae84c71.
> >>
> >> For context see https://lore.kernel.org/stable/fa953ec-288f-7715-c6fb-47a222e85270@linux.intel.com/
> > 
> > THanks, will take this after this round of releases.
> 
> It might already be too late but is it possible to have this patch
> ("mptcp: Do TCP fallback on early DSS checksum failure") and "mptcp: fix
> checksum byte order" in the same stable release?
> 
> Note that "mptcp: fix checksum byte order" patch has been recently
> queued by Sasha at the same time as "mptcp: Do TCP fallback on early DSS
> checksum failure".
> 
> A bit of context: "mptcp: fix checksum byte order" fixes an important
> encoding issue but it also breaks the interoperability with previous
> Linux versions not having this patch.
> 
> The patch from Mat ("mptcp: Do TCP fallback on early DSS checksum
> failure") improves the situation when there is this interoperability
> issue with a previous Linux versions not implementing the RFC properly.
> The improvement is there to make the MPTCP connections falling back to
> TCP instead of resetting them: at least there is a connection.
> 
> In other words, that would be really nice to have these two commits
> backported together. If it is easier, it looks best to me to delay the
> main fix ("mptcp: fix checksum byte order") than having the two patches
> in different stable versions. But I understand it was not clear and
> maybe too late to do these modifications.
> 
> Anyway, thank you for your work maintaining these stable versions! :)

I have already done a release with the first change in it, sorry, but
have queued this up now.  Given that this is fixing a problem with that
commit, I'll go do a release right now for 5.17 and 5.15.

thanks,

greg k-h
