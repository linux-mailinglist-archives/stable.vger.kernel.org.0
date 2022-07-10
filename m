Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C6756CF6C
	for <lists+stable@lfdr.de>; Sun, 10 Jul 2022 16:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiGJOVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 10:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGJOVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 10:21:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9746D11142;
        Sun, 10 Jul 2022 07:21:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36B2CB807EC;
        Sun, 10 Jul 2022 14:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F69DC3411E;
        Sun, 10 Jul 2022 14:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657462896;
        bh=h52mTKVbGTkntES83s8325HaB3fVU9c5mNB/kvBTji4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z9dRVC8U1+OO+qLwCAqX85eAor0iRJAVL/mpLT1mws5MG73LcQZ2fCw/k9xNelNp6
         664jBleNF6rN8cELyxgOZBM3JvUYoGoC7c0Ygu7TzZF8YQjmq7HG62nwhvehcLyPpG
         hxDzHn6WSVxB4X5ID6Aw3BCwA0Ma5ANiPEorv2DY=
Date:   Sun, 10 Jul 2022 16:21:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jimmy Assarsson <extja@kvaser.com>
Cc:     stable@vger.kernel.org, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jimmy Assarsson <jimmyassarsson@gmail.com>
Subject: Re: [PATCH 4.14 1/4] can: kvaser_usb: Add struct kvaser_usb_dev_cfg
Message-ID: <YsrgbqIFfcxXesWw@kroah.com>
References: <20220708184653.280882-1-extja@kvaser.com>
 <20220708184653.280882-2-extja@kvaser.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708184653.280882-2-extja@kvaser.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 08, 2022 at 08:46:50PM +0200, Jimmy Assarsson wrote:
> Add struct kvaser_usb_dev_cfg to ease backporting of upstream commits:
> 49f274c72357 (can: kvaser_usb: replace run-time checks with struct kvaser_usb_driver_info)
> e6c80e601053 (can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression)
> b3b6df2c56d8 (can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits)

What upstream commit is this from?

> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
> ---
>  drivers/net/can/usb/kvaser_usb.c | 76 ++++++++++++++++++++++----------
>  1 file changed, 52 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
> index 9742e32d5cd5..6759868924b2 100644
> --- a/drivers/net/can/usb/kvaser_usb.c
> +++ b/drivers/net/can/usb/kvaser_usb.c
> @@ -31,10 +31,6 @@
>  #define USB_SEND_TIMEOUT		1000 /* msecs */
>  #define USB_RECV_TIMEOUT		1000 /* msecs */
>  #define RX_BUFFER_SIZE			3072
> -#define KVASER_USB_CAN_CLOCK_8MHZ	8000000
> -#define KVASER_USB_CAN_CLOCK_16MHZ	16000000
> -#define KVASER_USB_CAN_CLOCK_24MHZ	24000000
> -#define KVASER_USB_CAN_CLOCK_32MHZ	32000000

You also deleted these, you didn't really describe any of this in the
changelog text at all :(

Why not just backport the needed commit instead of this unknown one?

thanks,

greg k-h
