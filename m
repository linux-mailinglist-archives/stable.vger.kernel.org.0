Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7235A4ACF
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiH2L5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiH2L5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:57:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C7A95AE0;
        Mon, 29 Aug 2022 04:41:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4BA9610E7;
        Mon, 29 Aug 2022 11:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72600C433C1;
        Mon, 29 Aug 2022 11:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661773157;
        bh=PUH3ViVHVj54pbPEDClUi/8HHM7+ZaoZalmXOTxsBTI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZC4eJtFSoF30Mn/CPoOM7gOwz4yywp1R8svyfupEQ1gONEOkmY4t/FSJ5cBgzn2NZ
         hE7mFlzHVmiLUR5Ntjl/ZbN7QsOAZYAOyDl+S5Ik/s/5UTMCcLZnk2maP/W3Mwb9vT
         iIhLrzStvmJ1iAJvE1VLxBicn3umbgP2sJ3pH1k4=
Date:   Mon, 29 Aug 2022 13:39:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 042/136] ice: xsk: Force rings to be sized to power
 of 2
Message-ID: <YwylYXZ9R9ILBYTx@kroah.com>
References: <20220829105804.609007228@linuxfoundation.org>
 <20220829105806.324347516@linuxfoundation.org>
 <YwygGA09Qtddbgw6@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwygGA09Qtddbgw6@boxer>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 01:16:40PM +0200, Maciej Fijalkowski wrote:
> On Mon, Aug 29, 2022 at 12:58:29PM +0200, Greg Kroah-Hartman wrote:
> > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > 
> > [ Upstream commit 296f13ff3854535009a185aaf8e3603266d39d94 ]
> > 
> > With the upcoming introduction of batching to XSK data path,
> > performance wise it will be the best to have the ring descriptor count
> > to be aligned to power of 2.
> > 
> > Check if ring sizes that user is going to attach the XSK socket fulfill
> > the condition above. For Tx side, although check is being done against
> > the Tx queue and in the end the socket will be attached to the XDP
> > queue, it is fine since XDP queues get the ring->count setting from Tx
> > queues.
> 
> Hi Greg,
> 
> We had multiple customers reporting that this change makes them unable to
> use max ring size which is 8160 for this particular driver (which is not a
> power of 2 obviously) so we are about to send a patch that will drop this
> limitation.
> 
> To avoid the double work, can you please not proceed with this one?
> The other two:
> ice: xsk: prohibit usage of non-balanced queue id
> ice: xsk: use Rx rings XDP ring when picking NAPI context
> 
> are valid and needed.

This is in the 5.18 kernel release, which has been out for a while.

We will be glad to pick up the fixed commit when it hits Linus's tree.

> FWIW this was a part of -next patch set, so I suppose you picked this due
> to some dependency?

I think it was, for a later patch in the series, 5a42f112d367 ("ice:
xsk: prohibit usage of non-balanced queue id").

thanks,

greg k-h
