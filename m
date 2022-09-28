Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548AD5EDDFE
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 15:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbiI1NnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 09:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiI1NnP (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 28 Sep 2022 09:43:15 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD6295ACF;
        Wed, 28 Sep 2022 06:43:14 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 7AEC86601FFC;
        Wed, 28 Sep 2022 14:43:12 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1664372593;
        bh=Av/PH6kVhiIAtYUMsFAbHa4P+77I27U8HuG+9Mk9/bw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=d9tOE73f5N7QYoN5O7LrOr8s52r3Xlx1RhKU80LLOuMfdeu8KhnI8UCrMBL4j7p3o
         r50UPhG+kkdyKoHINKIplmXyqlOXi9bjgdBoR6N3EjdNjMRq4X3PuuM8D/IO36hyQ+
         Rd9SmKPXBYK7KO4BJjafKztwOndX8j8fY8l6YEij1lOmrORxrYuS5Ffvd/Ovhn6N7L
         ve1/nUgSYHNKIsEI9zFOrY/+s6/KJd+iqoADU4sg8PYO4c83swVIlnEInAb6VahFF8
         9U/mtbW/FpK6uiUUDGosUF3cth3GsopyztXtkWySH1VfceclPI4R9BOK9t4Th4suyy
         Nt0VgoGJiKcUA==
Message-ID: <6d312360-55b7-ebd5-be86-14f6943e273f@collabora.com>
Date:   Wed, 28 Sep 2022 15:43:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 1/2] usb: mtu3: fix ep0's stall of out data stage
Content-Language: en-US
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eddie Hung <eddie.hung@mediatek.com>,
        Min Guo <min.guo@mediatek.com>,
        Tianping Fang <tianping.fang@mediatek.com>,
        Stable@vger.kernel.org
References: <20220928091721.26112-1-chunfeng.yun@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20220928091721.26112-1-chunfeng.yun@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Il 28/09/22 11:17, Chunfeng Yun ha scritto:
> It happens when enable uvc function, the flow as below:
> the controller switch to data stage, then call
>      -> foward_to_driver() -> composite_setup() -> uvc_function_setup(),
> it send out an event to user layer to notify it call
>      -> ioctl() -> uvc_send_response() -> usb_ep_queue(),
> but before the user call ioctl to queue ep0's buffer, the host already send
> out data, but the controller find that no buffer is queued to receive data,
> it send out STALL handshake.
> 
> To fix the issue, don't send out ACK of setup stage to switch to out data
> stage until the buffer is available.
> 
> Cc: <Stable@vger.kernel.org>
> Reported-by: Min Guo <min.guo@mediatek.com>
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> ---
>   drivers/usb/mtu3/mtu3.h            |  4 ++++
>   drivers/usb/mtu3/mtu3_gadget_ep0.c | 22 +++++++++++++++++++---
>   2 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/mtu3/mtu3.h b/drivers/usb/mtu3/mtu3.h
> index 2d7b57e07eee..6b64ad17724d 100644
> --- a/drivers/usb/mtu3/mtu3.h
> +++ b/drivers/usb/mtu3/mtu3.h
> @@ -318,6 +318,9 @@ static inline struct ssusb_mtk *dev_to_ssusb(struct device *dev)
>    *		for GET_STATUS and SET_SEL
>    * @setup_buf: ep0 response buffer for GET_STATUS and SET_SEL requests
>    * @u3_capable: is capable of supporting USB3
> + * @delayed_setup: delay the setup stage to avoid STALL handshake in
> + *		out data stage due to the class driver doesn't queue buffer
> + *		before the host send out data
>    */
>   struct mtu3 {
>   	spinlock_t lock;
> @@ -360,6 +363,7 @@ struct mtu3 {
>   	unsigned connected:1;
>   	unsigned async_callbacks:1;
>   	unsigned separate_fifo:1;
> +	unsigned delayed_setup:1;
>   
>   	u8 address;
>   	u8 test_mode_nr;
> diff --git a/drivers/usb/mtu3/mtu3_gadget_ep0.c b/drivers/usb/mtu3/mtu3_gadget_ep0.c
> index e4fd1bb14a55..f7a71cc83e15 100644
> --- a/drivers/usb/mtu3/mtu3_gadget_ep0.c
> +++ b/drivers/usb/mtu3/mtu3_gadget_ep0.c
> @@ -162,6 +162,19 @@ static void ep0_do_status_stage(struct mtu3 *mtu)
>   	mtu3_writel(mbase, U3D_EP0CSR, value | EP0_SETUPPKTRDY | EP0_DATAEND);
>   }
>   
> +/* delay sending out ACK of setup stage to wait for OUT buffer queued */
> +static void ep0_setup_stage_send_ack(struct mtu3 *mtu)
> +{
> +	void __iomem *mbase = mtu->mac_base;
> +	u32 value;
> +
> +	if (mtu->delayed_setup) {
> +		value = mtu3_readl(mbase, U3D_EP0CSR) & EP0_W1C_BITS;
> +		mtu3_writel(mbase, U3D_EP0CSR, value | EP0_SETUPPKTRDY);
> +		mtu->delayed_setup = 0;
> +	}
> +}
> +
>   static int ep0_queue(struct mtu3_ep *mep0, struct mtu3_request *mreq);
>   
>   static void ep0_dummy_complete(struct usb_ep *ep, struct usb_request *req)
> @@ -628,8 +641,9 @@ static void ep0_read_setup(struct mtu3 *mtu, struct usb_ctrlrequest *setup)
>   			csr | EP0_SETUPPKTRDY | EP0_DPHTX);
>   		mtu->ep0_state = MU3D_EP0_STATE_TX;
>   	} else {
> -		mtu3_writel(mtu->mac_base, U3D_EP0CSR,
> -			(csr | EP0_SETUPPKTRDY) & (~EP0_DPHTX));
> +		mtu3_writel(mtu->mac_base, U3D_EP0CSR, csr & ~EP0_DPHTX);
> +		/* send ACK when the buffer is queued */
> +		mtu->delayed_setup = 1;

I don't think that you need this variable: you're calling the function
ep0_setup_stage_send_ack() only when ep0_state == MU3D_EP0_STATE_RX in
ep0_queue()...

..so you'll never get a call to ep0_setup_stage_send_ack() with delayed_setup == 0!

Regards,
Angelo

>   		mtu->ep0_state = MU3D_EP0_STATE_RX;
>   	}
>   }
> @@ -804,9 +818,11 @@ static int ep0_queue(struct mtu3_ep *mep, struct mtu3_request *mreq)
>   
>   	switch (mtu->ep0_state) {
>   	case MU3D_EP0_STATE_SETUP:
> -	case MU3D_EP0_STATE_RX:	/* control-OUT data */
>   	case MU3D_EP0_STATE_TX:	/* control-IN data */
>   		break;
> +	case MU3D_EP0_STATE_RX:	/* control-OUT data */
> +		ep0_setup_stage_send_ack(mtu);
> +		break;
>   	default:
>   		dev_err(mtu->dev, "%s, error in ep0 state %s\n", __func__,
>   			decode_ep0_state(mtu));



