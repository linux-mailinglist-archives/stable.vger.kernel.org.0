Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5126463C5DF
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 17:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbiK2Q7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 11:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236419AbiK2Q7T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 11:59:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B022D6CA09;
        Tue, 29 Nov 2022 08:54:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39594B816AA;
        Tue, 29 Nov 2022 16:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913EDC433D6;
        Tue, 29 Nov 2022 16:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669740873;
        bh=ygBCEMDajaDr54eqmGvoWqIfS5rHpbo1MjEW8YvhyNw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mxzxTOItaUE4RU1mpWAPrF8eLmvZkg4wsnUbEFDaP6Z9jNpM5rmlJB5yy0+45CkZ9
         XgAG7Khle7kIbIMDfqIngffvZJjcj5oZglahRlQFojKtbnBMz+xH0aefbeIuel35XR
         lQIzd+Xsdqoe0gX95RpxGWnqHKkiya7SP75kNE/g=
Date:   Tue, 29 Nov 2022 17:54:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, Peter Fink <pfink@christ-es.de>,
        stable@vger.kernel.org, Ryan Edwards <ryan.edwards@gmail.com>
Subject: Re: [PATCH] can: gs_usb: fix size parameter to usb_free_coherent()
 calls
Message-ID: <Y4Y5Rp1E6ApR+s2n@kroah.com>
References: <20221125201727.1558965-1-mkl@pengutronix.de>
 <20221125203217.cuv63t4ijxwmqun7@pengutronix.de>
 <Y4G6a4hlJFgH+iAy@kroah.com>
 <20221126192656.yb2v2sw6af57sa4f@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221126192656.yb2v2sw6af57sa4f@pengutronix.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 26, 2022 at 08:26:56PM +0100, Marc Kleine-Budde wrote:
> On 26.11.2022 08:04:11, Greg Kroah-Hartman wrote:
> > On Fri, Nov 25, 2022 at 09:32:17PM +0100, Marc Kleine-Budde wrote:
> > > Hello Greg,
> > > 
> > > with v5.18-rc1 in commit
> > > 
> > > | c359931d2545 ("can: gs_usb: use union and FLEX_ARRAY for data in struct gs_host_frame")
> > > 
> > > a bug in the gs_usb driver in the usage of usb_free_coherent() was
> > > introduced. With v6.1-rc1
> > > 
> > > | 62f102c0d156 ("can: gs_usb: remove dma allocations")
> > > 
> > > the DMA allocation was removed altogether from the driver, fixing the
> > > bug unintentionally.
> > > 
> > > We can either cherry-pick 62f102c0d156 ("can: gs_usb: remove dma
> > > allocations") on v6.0, v5.19, and v5.18 or apply this patch, which fixes
> > > the usage of usb_free_coherent() only.
> > 
> > We should always take what is in Linus's tree, that's the best
> > solution.
> 
> Ok.
> 
> > Does the change backport cleanly?
> 
> ACK.
> 
> > And 5.19 and 5.18 are long end-of-life, no need to worry about them.
> > Only 6.0 matters right now.
> 
> Please queue 62f102c0d156 ("can: gs_usb: remove dma allocations") for
> v6.0.x and add the fixes tag:
> 
> Fixes: c359931d2545 ("can: gs_usb: use union and FLEX_ARRAY for data in struct gs_host_frame")

Now queued up, thanks.

greg k-h
