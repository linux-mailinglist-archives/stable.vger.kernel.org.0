Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1764F02D1
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 15:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbiDBNpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 09:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352843AbiDBNpv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 09:45:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEA3FE419;
        Sat,  2 Apr 2022 06:43:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3960061481;
        Sat,  2 Apr 2022 13:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F8AC340EE;
        Sat,  2 Apr 2022 13:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648907037;
        bh=67v+RBD5JCp8Wx6aasmnBgOWhAxW76iJPRm/WfXych4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BUGxSsLO4q+sXtitUFI/v+Sc29vapmdDjA2Yh9+l+Okuwx0irDg2Dc0TvIGxz1DYg
         1tp+Lg2XJvyRLrKYkM/OCwZJGXccJ6fIaPBOsalkdn0vVZgjsnABm6n0vOSjGinQT7
         r2DJ0WNOLTgIIrYE7IcXV2jZHrzXX1fO9moRs5B8=
Date:   Sat, 2 Apr 2022 15:43:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        stable@vger.kernel.org, Peter Seiderer <ps.report@gmx.net>
Subject: Re: [PATCH v5.18] ath9k: Save rate counts before clearing tx status
 area
Message-ID: <YkhTGod1f+Uq3Bpt@kroah.com>
References: <20220402122752.2347797-1-toke@toke.dk>
 <YkhEO9teh58RdrXR@kroah.com>
 <87o81jfwz6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87o81jfwz6.fsf@toke.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 02, 2022 at 03:14:53PM +0200, Toke Høiland-Jørgensen wrote:
> Greg KH <gregkh@linuxfoundation.org> writes:
> 
> > On Sat, Apr 02, 2022 at 02:27:51PM +0200, Toke Høiland-Jørgensen wrote:
> >> From: Toke Høiland-Jørgensen <toke@redhat.com>
> >> 
> >> The ieee80211_tx_info_clear_status() helper also clears the rate counts, so
> >> we should restore them after clearing. However, we can get rid of the
> >> existing clearing of the counts of invalid rates. Rearrange the code a bit
> >> so the order fits the indexes, and so the setting of the count to
> >> hw->max_rate_tries on underrun is not immediately overridden.
> >> 
> >> Cc: stable@vger.kernel.org
> >> Reported-by: Peter Seiderer <ps.report@gmx.net>
> >> Fixes: 037250f0a45c ("ath9k: Properly clear TX status area before reporting to mac80211")
> >> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> >> ---
> >>  drivers/net/wireless/ath/ath9k/xmit.c | 25 +++++++++++++++----------
> >>  1 file changed, 15 insertions(+), 10 deletions(-)
> >
> > What is the git commit id of this change in Linus's tree?
> 
> You mean the commit referred to in the Fixes: tag, right? That's not in
> Linus' tree yet, it's a follow-up to a commit that was merged into the
> wireless tree yesterday and marked for stable, so the two commits should
> be added to stable together once they do hit Linus' tree.
> 
> I forgot to add the stable Cc when sending out the previous patch, so
> Kalle added it when committing; so I guess you haven't seen that one? :)

Ah, sorry, I thought this was a request to add a specific patch to the
stable tree.  Nevermind, sorry for the noise.

greg k-h
