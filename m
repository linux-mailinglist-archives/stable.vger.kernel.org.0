Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A7856CF71
	for <lists+stable@lfdr.de>; Sun, 10 Jul 2022 16:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiGJOW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 10:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiGJOW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 10:22:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34C111817;
        Sun, 10 Jul 2022 07:22:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F25B61244;
        Sun, 10 Jul 2022 14:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B556C3411E;
        Sun, 10 Jul 2022 14:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657462946;
        bh=qWBYBfbEx18IMNplQu8hjhn6Iw8VPpuKIayFa9NjD88=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=phFYEo5Vty8ibHQfLBBZgU6s8X5pwxzjxqr5mcOghTCj7+MyiKyB5p0l1DGy3XYNJ
         1Qow0PV9HM8OupxQYwOdqSPzO8Yv8dSb4ZqPasdQCFhu8nYX8+9e8caeNWEGHrXFhu
         A3DEeY+6YWontFrKoK+9Pcahmjy/fHQ3hRsmKrlY=
Date:   Sun, 10 Jul 2022 16:22:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jimmy Assarsson <extja@kvaser.com>
Cc:     stable@vger.kernel.org, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jimmy Assarsson <jimmyassarsson@gmail.com>
Subject: Re: [PATCH 5.15 0/3] can: kvaser_usb: CAN clock frequency regression
Message-ID: <YsrgoLKzoveR4/R4@kroah.com>
References: <20220708184846.281174-1-extja@kvaser.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708184846.281174-1-extja@kvaser.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 08, 2022 at 08:48:43PM +0200, Jimmy Assarsson wrote:
> Backport of upstream patch series [1].
> 
> When fixing the CAN clock frequency,
> fb12797ab1fe ("can: kvaser_usb: get CAN clock frequency from device"),
> I introduced a regression.
> 
> For Leaf devices based on M32C, the firmware expects bittiming parameters
> calculated for 16MHz clock. Regardless of the actual clock frequency.
> 
> This regression affects M32C based Leaf devices with non-16MHz clock.
> 
> Also correct the bittiming constants in kvaser_usb_leaf.c, where the
> limits are different depending on which firmware/device being used.
> 
> [1]
> https://lore.kernel.org/linux-can/20220603083820.800246-1-extja@kvaser.com/
> 
> Jimmy Assarsson (3):
>   can: kvaser_usb: replace run-time checks with struct
>     kvaser_usb_driver_info
>   can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression
>   can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits
> 
>  drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  25 +-
>  .../net/can/usb/kvaser_usb/kvaser_usb_core.c  | 286 ++++++++++--------
>  .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c |   4 +-
>  .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 119 ++++----
>  4 files changed, 244 insertions(+), 190 deletions(-)
> 
> -- 
> 2.36.1
> 

5.15, 5.10, 5.4, and 4.19 patches now queued up, thanks!

greg k-h
