Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540F9595FD2
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 18:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236117AbiHPQI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 12:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236138AbiHPQIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 12:08:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A76079EFA;
        Tue, 16 Aug 2022 09:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FAD161137;
        Tue, 16 Aug 2022 16:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76554C433D6;
        Tue, 16 Aug 2022 16:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660665953;
        bh=oX8a4Yc270FO6i3GnGRsTJDJZIrW76PBw+e+cAjAJ4I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CBC994t7paw0nH4ChV42k5Xp5e89pB0Mwx+kZC+HVoZcz/ajMustPickt0qNtrDG+
         Tn3Re8+nPu4nJ2sfll7a5KyFthf0l94u68ZhN0YediWWsGNFLBEYcY/7UbNAAV1bEU
         5DhEGGepIn+ndKXInq59motPjgLAEot3wxR3vLB8=
Date:   Tue, 16 Aug 2022 18:05:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paul Chaignon <paul@isovalent.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.19 0537/1157] bpf: Set flow flag to allow any source IP
 in bpf_tunnel_key
Message-ID: <YvvAX5JbA9c7aNz6@kroah.com>
References: <20220815180439.416659447@linuxfoundation.org>
 <20220815180501.149595269@linuxfoundation.org>
 <20220816143554.GA67569@Mem>
 <YvuuAprVhybi0CMj@kroah.com>
 <20220816150727.GA88824@Mem>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816150727.GA88824@Mem>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 05:07:27PM +0200, Paul Chaignon wrote:
> On Tue, Aug 16, 2022 at 04:47:30PM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Aug 16, 2022 at 04:35:54PM +0200, Paul Chaignon wrote:
> > > On Mon, Aug 15, 2022 at 07:58:13PM +0200, Greg Kroah-Hartman wrote:
> > > > From: Paul Chaignon <paul@isovalent.com>
> > > > 
> > > > [ Upstream commit b8fff748521c7178b9a7d32b5a34a81cec8396f3 ]
> > > > 
> > > > Commit 26101f5ab6bd ("bpf: Add source ip in "struct bpf_tunnel_key"")
> > > > added support for getting and setting the outer source IP of encapsulated
> > > > packets via the bpf_skb_{get,set}_tunnel_key BPF helper. This change
> > > > allows BPF programs to set any IP address as the source, including for
> > > > example the IP address of a container running on the same host.
> > > > 
> > > > In that last case, however, the encapsulated packets are dropped when
> > > > looking up the route because the source IP address isn't assigned to any
> > > > interface on the host. To avoid this, we need to set the
> > > > FLOWI_FLAG_ANYSRC flag.
> > > 
> > > This fix will also require upstream commits 861396ac0b47 ("geneve: Use
> > > ip_tunnel_key flow flags in route lookups") and 7e2fb8bc7ef6 ("vxlan:
> > > Use ip_tunnel_key flow flags in route lookups") to have the intended
> > > effect. In short, these two commits "consume" the new field introduced
> > > in 451ef36bd229 ("ip_tunnels: Add new flow flags field to
> > > ip_tunnel_key") and populated in the present commit.
> > 
> > Ick.  Is it better to just drop this commit instead?  Or is it ok to
> > also backport those 2 patches to 5.19.y?
> 
> It should be okay to backport those additional 2 patches to 5.19.y.

Thanks, both queued up now.

greg k-h
