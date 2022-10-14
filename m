Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7D95FEEEA
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 15:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiJNNrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 09:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiJNNrk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 09:47:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E657106E3F
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 06:47:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C556561B29
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 13:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9D4C433D6;
        Fri, 14 Oct 2022 13:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665755258;
        bh=9z0ybjQ4P3r6t2McVrNar/ahgma6WC3ryWR3iMyaMjE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=146W14/QZ7F0+9dLhGVuYn8D3abaH6hCdaRbKQDZ3cjCqgF+YW8sxybkShmwPiPBi
         vPIEV4kOJ9vMZCKF1u6n/E9le8kr1AF+8Mz3Y+sZlbouchFcVnL5CCZogfzU/7T+Es
         goGn3zLAC1u1Ehe+LY6Z4iS1GYug1mrnDtfAG518=
Date:   Fri, 14 Oct 2022 15:48:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Felix Fietkau <nbd@nbd.name>, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 1/6] mac80211: mesh: clean up rx_bcn_presp API
Message-ID: <Y0lop47g4sHr22Js@kroah.com>
References: <20221013181601.5712-1-nbd@nbd.name>
 <Y0kLsThZoDPPENhI@kroah.com>
 <Y0kyTNju0rwqojrH@quatroqueijos.cascardo.eti.br>
 <4c6490032936b50785015ea93bb88575e09a5c8c.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c6490032936b50785015ea93bb88575e09a5c8c.camel@sipsolutions.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 14, 2022 at 01:04:10PM +0200, Johannes Berg wrote:
> On Fri, 2022-10-14 at 06:56 -0300, Thadeu Lima de Souza Cascardo wrote:
> > On Fri, Oct 14, 2022 at 09:11:45AM +0200, Greg KH wrote:
> > > On Thu, Oct 13, 2022 at 08:15:56PM +0200, Felix Fietkau wrote:
> > > > From: Johannes Berg <johannes.berg@intel.com>
> > > > 
> > > > commit a5b983c6073140b624f64e79fea6d33c3e4315a0 upstream.
> > > > 
> > > > We currently pass the entire elements to the rx_bcn_presp()
> > > > method, but only need mesh_config. Additionally, we use the
> > > > length of the elements to calculate back the entire frame's
> > > > length, but that's confusing - just pass the length of the
> > > > frame instead.
> > > > 
> > > > Link: https://lore.kernel.org/r/20210920154009.a18ed3d2da6c.I1824b773a0fbae4453e1433c184678ca14e8df45@changeid
> > > > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > > > ---
> > > >  net/mac80211/ieee80211_i.h |  7 +++----
> > > >  net/mac80211/mesh.c        |  4 ++--
> > > >  net/mac80211/mesh_sync.c   | 26 ++++++++++++--------------
> > > >  3 files changed, 17 insertions(+), 20 deletions(-)
> > > 
> > > Many thanks for this series.  Will this also work in 5.4.y and 5.10.y?
> > > 
> > 
> > Not sure about 5.10, but that won't work as is on 5.4. We are considering some
> > other approach for 5.4, but not sure yet. But simply taking dozens of clean
> > cherry picks did not strike as a good option to me.

Taking lots of clean cherrypicks _is_ normally the best way, I have no
objection to that at all as it keeps things in sync properly.  Doing
out-of-tree changes is the hard way and we almost always get that wrong.

> I'm thinking of just disabling multi-BSSID, it's not really used anyway
> as far as I can tell.

That's fine with me too if it's an easy change and no one complains or
notices :)

thanks,

greg k-h
