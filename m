Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B134F0186
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 14:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242548AbiDBMmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 08:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240612AbiDBMmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 08:42:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7335C2980F;
        Sat,  2 Apr 2022 05:40:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E64A613F7;
        Sat,  2 Apr 2022 12:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32B4C340EC;
        Sat,  2 Apr 2022 12:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648903230;
        bh=ZE6ONiSMZO3GKZYOyFXS0R0urqYXEv40Y2pzxw+8kw0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R7YtDbcqRq878I/4TSp+oRcVtvTW9Pe4fRJTgNNmKEi1hvVOaSIUT0oHRyt/YEuvI
         749Ll6wwMHJbXEGwmaMseDdu8UY9UiXPv05Mg9K4A9VJbsnWwE9wP7hLJSrh3tEmvB
         Yrgu9udC6jwv9QUHXBSFwzTcd9ObH4biPOt+drc0=
Date:   Sat, 2 Apr 2022 14:40:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        stable@vger.kernel.org, Peter Seiderer <ps.report@gmx.net>
Subject: Re: [PATCH v5.18] ath9k: Save rate counts before clearing tx status
 area
Message-ID: <YkhEO9teh58RdrXR@kroah.com>
References: <20220402122752.2347797-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220402122752.2347797-1-toke@toke.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 02, 2022 at 02:27:51PM +0200, Toke Høiland-Jørgensen wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> The ieee80211_tx_info_clear_status() helper also clears the rate counts, so
> we should restore them after clearing. However, we can get rid of the
> existing clearing of the counts of invalid rates. Rearrange the code a bit
> so the order fits the indexes, and so the setting of the count to
> hw->max_rate_tries on underrun is not immediately overridden.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Peter Seiderer <ps.report@gmx.net>
> Fixes: 037250f0a45c ("ath9k: Properly clear TX status area before reporting to mac80211")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  drivers/net/wireless/ath/ath9k/xmit.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)

What is the git commit id of this change in Linus's tree?
