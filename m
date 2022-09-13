Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9625B77E6
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbiIMR0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbiIMRZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:25:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1D19F743;
        Tue, 13 Sep 2022 09:13:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EAE9614FF;
        Tue, 13 Sep 2022 16:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28261C433D7;
        Tue, 13 Sep 2022 16:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663085577;
        bh=qnvPs8zuOVXMLGic2bOXDptky5r4yPlzmOAuJGbqcLc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vJJt/wbK3ARGVFQAK83Sxh87+bFDfPW6vruBlq5svqco/4V01EyhiP4eGlJ3oLhYz
         5roq4pvJofEzz/VSf4XmqXe4W2hbwdLqUywCqg5ddfAL7xQSrqvngxp0050X/5zzvF
         KjlQwUZ1EvytWPB4xRHWrDn/iGfapWuIMJA+IVT8=
Date:   Tue, 13 Sep 2022 18:13:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: Re: [PATCH 5.19 123/192] net: fec: Use a spinlock to guard
 `fep->ptp_clk_on`
Message-ID: <YyCsIZnjR11y8obI@kroah.com>
References: <20220913140410.043243217@linuxfoundation.org>
 <20220913140416.124325107@linuxfoundation.org>
 <20220913141917.ukoid65sqao5f4lg@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220913141917.ukoid65sqao5f4lg@pengutronix.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 13, 2022 at 04:19:17PM +0200, Marc Kleine-Budde wrote:
> Hello Greg,
> 
> On 13.09.2022 16:03:49, Greg Kroah-Hartman wrote:
> > From: Csókás Bence <csokas.bence@prolan.hu>
> > 
> > [ Upstream commit b353b241f1eb9b6265358ffbe2632fdcb563354f ]
> > 
> > Mutexes cannot be taken in a non-preemptible context,
> > causing a panic in `fec_ptp_save_state()`. Replacing
> > `ptp_clk_mutex` by `tmreg_lock` fixes this.
> > 
> > Fixes: 6a4d7234ae9a ("net: fec: ptp: avoid register access when ipg clock is disabled")
> > Fixes: f79959220fa5 ("fec: Restart PPS after link state change")
> > Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
> > Link: https://lore.kernel.org/all/20220827160922.642zlcd5foopozru@pengutronix.de/
> > Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
> > Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com> # Toradex Apalis iMX6
> > Link: https://lore.kernel.org/r/20220901140402.64804-1-csokas.bence@prolan.hu
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> there's a revert pending for this patch:
> 
> | https://lore.kernel.org/all/20220912070143.98153-1-francesco.dolcini@toradex.com
> 
> ...as it causes troubles in 6.0-rc4:
> 
> | https://lore.kernel.org/all/20220907143915.5w65kainpykfobte@pengutronix.de/
> | https://lore.kernel.org/all/CAHk-=wj1obPoTu1AHj9Bd_BGYjdjDyPP+vT5WMj8eheb3A9WHw@mail.gmail.com/
> 
> please drop this patch.

Now dropped from all 3 queues, thanks.

greg k-h
