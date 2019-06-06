Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7957136E23
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 10:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfFFIHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 04:07:05 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:35416 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726140AbfFFIHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 04:07:05 -0400
Received: from mailhost.synopsys.com (unknown [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id F0C2CC020C;
        Thu,  6 Jun 2019 08:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559808403; bh=GpXJq+ymWPv5WxqUDuZLz9fH+iR4qDK05gnuVQdFxtQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=MDKHFZjxzBaGe0Bak9EpNqBQIvVeudXrlQGyAUEeypawBhgWEfzScUfwFdP/sLVFJ
         0z0Q9fj/HctTr7B4OAKEZyYf0J+C30cs1UFZFL9BHmUayPd0m8CCSHsu1E6wA7vQBt
         R3nHp7T5IDaPVynrmQAemcmC5RS5FA3YZ3F1PuXtsAOna3Do0hVYjljNxerzm4hJL9
         DTSohutAlk2CVAMJBjAC+mXL/km0X8Q3zG1bfts30n51JSMnNiWaEOkr6Iho9Lqbq7
         7OTcCEl7jPkbJsBgtSmwZ/Jo3v37g1O729aEGuatUp0hAh+QdRPV/GEEEmH8wOLeNy
         UtfU7YytK6pNQ==
Received: from [10.116.70.206] (unknown [10.116.70.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 86B12A022F;
        Thu,  6 Jun 2019 08:06:57 +0000 (UTC)
Subject: Re: [PATCH] usb: dwc2: host: Fix wMaxPacketSize handling (fix webcam
 regression)
To:     Douglas Anderson <dianders@chromium.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "mka@chromium.org" <mka@chromium.org>,
        "groeck@chromium.org" <groeck@chromium.org>,
        Martin Schiller <ms@dev.tdt.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190531200412.129429-1-dianders@chromium.org>
From:   Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Message-ID: <90cfd1f9-42c5-fdf8-864a-1c9cb48502db@synopsys.com>
Date:   Thu, 6 Jun 2019 12:06:55 +0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190531200412.129429-1-dianders@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/1/2019 12:05 AM, Douglas Anderson wrote:
> In commit abb621844f6a ("usb: ch9: make usb_endpoint_maxp() return
> only packet size") the API to usb_endpoint_maxp() changed.  It used to
> just return wMaxPacketSize but after that commit it returned
> wMaxPacketSize with the high bits (the multiplier) masked off.  If you
> wanted to get the multiplier it was now up to your code to call the
> new usb_endpoint_maxp_mult() which was introduced in
> commit 541b6fe63023 ("usb: add helper to extract bits 12:11 of
> wMaxPacketSize").
> 
> Prior to the API change most host drivers were updated, but no update
> was made to dwc2.  Presumably it was assumed that dwc2 was too
> simplistic to use the multiplier and thus just didn't support a
> certain class of USB devices.  However, it turns out that dwc2 did use
> the multiplier and many devices using it were working quite nicely.
> That means that many USB devices have been broken since the API
> change.  One such device is a Logitech HD Pro Webcam C920.
> 
> Specifically, though dwc2 didn't directly call usb_endpoint_maxp(), it
> did call usb_maxpacket() which in turn called usb_endpoint_maxp().
> 
> Let's update dwc2 to work properly with the new API.
> 
> Fixes: abb621844f6a ("usb: ch9: make usb_endpoint_maxp() return only packet size")
> Cc: stable@vger.kernel.org
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> ---

Acked-by: Minas Harutyunyan <hminas@synopsys.com>

> 
>   drivers/usb/dwc2/hcd.c       | 29 +++++++++++++++++------------
>   drivers/usb/dwc2/hcd.h       | 20 +++++++++++---------
>   drivers/usb/dwc2/hcd_intr.c  |  5 +++--
>   drivers/usb/dwc2/hcd_queue.c | 10 ++++++----
>   4 files changed, 37 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
> index b50ec3714fd8..5c51bf5506d1 100644
> --- a/drivers/usb/dwc2/hcd.c
> +++ b/drivers/usb/dwc2/hcd.c
> @@ -2608,7 +2608,7 @@ static int dwc2_assign_and_init_hc(struct dwc2_hsotg *hsotg, struct dwc2_qh *qh)
>   	chan->dev_addr = dwc2_hcd_get_dev_addr(&urb->pipe_info);
>   	chan->ep_num = dwc2_hcd_get_ep_num(&urb->pipe_info);
>   	chan->speed = qh->dev_speed;
> -	chan->max_packet = dwc2_max_packet(qh->maxp);
> +	chan->max_packet = qh->maxp;
>   
>   	chan->xfer_started = 0;
>   	chan->halt_status = DWC2_HC_XFER_NO_HALT_STATUS;
> @@ -2686,7 +2686,7 @@ static int dwc2_assign_and_init_hc(struct dwc2_hsotg *hsotg, struct dwc2_qh *qh)
>   		 * This value may be modified when the transfer is started
>   		 * to reflect the actual transfer length
>   		 */
> -		chan->multi_count = dwc2_hb_mult(qh->maxp);
> +		chan->multi_count = qh->maxp_mult;
>   
>   	if (hsotg->params.dma_desc_enable) {
>   		chan->desc_list_addr = qh->desc_list_dma;
> @@ -3806,19 +3806,21 @@ static struct dwc2_hcd_urb *dwc2_hcd_urb_alloc(struct dwc2_hsotg *hsotg,
>   
>   static void dwc2_hcd_urb_set_pipeinfo(struct dwc2_hsotg *hsotg,
>   				      struct dwc2_hcd_urb *urb, u8 dev_addr,
> -				      u8 ep_num, u8 ep_type, u8 ep_dir, u16 mps)
> +				      u8 ep_num, u8 ep_type, u8 ep_dir,
> +				      u16 maxp, u16 maxp_mult)
>   {
>   	if (dbg_perio() ||
>   	    ep_type == USB_ENDPOINT_XFER_BULK ||
>   	    ep_type == USB_ENDPOINT_XFER_CONTROL)
>   		dev_vdbg(hsotg->dev,
> -			 "addr=%d, ep_num=%d, ep_dir=%1x, ep_type=%1x, mps=%d\n",
> -			 dev_addr, ep_num, ep_dir, ep_type, mps);
> +			 "addr=%d, ep_num=%d, ep_dir=%1x, ep_type=%1x, maxp=%d (%d mult)\n",
> +			 dev_addr, ep_num, ep_dir, ep_type, maxp, maxp_mult);
>   	urb->pipe_info.dev_addr = dev_addr;
>   	urb->pipe_info.ep_num = ep_num;
>   	urb->pipe_info.pipe_type = ep_type;
>   	urb->pipe_info.pipe_dir = ep_dir;
> -	urb->pipe_info.mps = mps;
> +	urb->pipe_info.maxp = maxp;
> +	urb->pipe_info.maxp_mult = maxp_mult;
>   }
>   
>   /*
> @@ -3909,8 +3911,9 @@ void dwc2_hcd_dump_state(struct dwc2_hsotg *hsotg)
>   					dwc2_hcd_is_pipe_in(&urb->pipe_info) ?
>   					"IN" : "OUT");
>   				dev_dbg(hsotg->dev,
> -					"      Max packet size: %d\n",
> -					dwc2_hcd_get_mps(&urb->pipe_info));
> +					"      Max packet size: %d (%d mult)\n",
> +					dwc2_hcd_get_maxp(&urb->pipe_info),
> +					dwc2_hcd_get_maxp_mult(&urb->pipe_info));
>   				dev_dbg(hsotg->dev,
>   					"      transfer_buffer: %p\n",
>   					urb->buf);
> @@ -4510,8 +4513,10 @@ static void dwc2_dump_urb_info(struct usb_hcd *hcd, struct urb *urb,
>   	}
>   
>   	dev_vdbg(hsotg->dev, "  Speed: %s\n", speed);
> -	dev_vdbg(hsotg->dev, "  Max packet size: %d\n",
> -		 usb_maxpacket(urb->dev, urb->pipe, usb_pipeout(urb->pipe)));
> +	dev_vdbg(hsotg->dev, "  Max packet size: %d (%d mult)\n",
> +		 usb_endpoint_maxp(&urb->ep->desc),
> +		 usb_endpoint_maxp_mult(&urb->ep->desc));
> +
>   	dev_vdbg(hsotg->dev, "  Data buffer length: %d\n",
>   		 urb->transfer_buffer_length);
>   	dev_vdbg(hsotg->dev, "  Transfer buffer: %p, Transfer DMA: %08lx\n",
> @@ -4594,8 +4599,8 @@ static int _dwc2_hcd_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
>   	dwc2_hcd_urb_set_pipeinfo(hsotg, dwc2_urb, usb_pipedevice(urb->pipe),
>   				  usb_pipeendpoint(urb->pipe), ep_type,
>   				  usb_pipein(urb->pipe),
> -				  usb_maxpacket(urb->dev, urb->pipe,
> -						!(usb_pipein(urb->pipe))));
> +				  usb_endpoint_maxp(&ep->desc),
> +				  usb_endpoint_maxp_mult(&ep->desc));
>   
>   	buf = urb->transfer_buffer;
>   
> diff --git a/drivers/usb/dwc2/hcd.h b/drivers/usb/dwc2/hcd.h
> index c089ffa1f0a8..ce6445a06588 100644
> --- a/drivers/usb/dwc2/hcd.h
> +++ b/drivers/usb/dwc2/hcd.h
> @@ -171,7 +171,8 @@ struct dwc2_hcd_pipe_info {
>   	u8 ep_num;
>   	u8 pipe_type;
>   	u8 pipe_dir;
> -	u16 mps;
> +	u16 maxp;
> +	u16 maxp_mult;
>   };
>   
>   struct dwc2_hcd_iso_packet_desc {
> @@ -264,6 +265,7 @@ struct dwc2_hs_transfer_time {
>    *                       - USB_ENDPOINT_XFER_ISOC
>    * @ep_is_in:           Endpoint direction
>    * @maxp:               Value from wMaxPacketSize field of Endpoint Descriptor
> + * @maxp_mult:          Multiplier for maxp
>    * @dev_speed:          Device speed. One of the following values:
>    *                       - USB_SPEED_LOW
>    *                       - USB_SPEED_FULL
> @@ -340,6 +342,7 @@ struct dwc2_qh {
>   	u8 ep_type;
>   	u8 ep_is_in;
>   	u16 maxp;
> +	u16 maxp_mult;
>   	u8 dev_speed;
>   	u8 data_toggle;
>   	u8 ping_state;
> @@ -503,9 +506,14 @@ static inline u8 dwc2_hcd_get_pipe_type(struct dwc2_hcd_pipe_info *pipe)
>   	return pipe->pipe_type;
>   }
>   
> -static inline u16 dwc2_hcd_get_mps(struct dwc2_hcd_pipe_info *pipe)
> +static inline u16 dwc2_hcd_get_maxp(struct dwc2_hcd_pipe_info *pipe)
> +{
> +	return pipe->maxp;
> +}
> +
> +static inline u16 dwc2_hcd_get_maxp_mult(struct dwc2_hcd_pipe_info *pipe)
>   {
> -	return pipe->mps;
> +	return pipe->maxp_mult;
>   }
>   
>   static inline u8 dwc2_hcd_get_dev_addr(struct dwc2_hcd_pipe_info *pipe)
> @@ -620,12 +628,6 @@ static inline bool dbg_urb(struct urb *urb)
>   static inline bool dbg_perio(void) { return false; }
>   #endif
>   
> -/* High bandwidth multiplier as encoded in highspeed endpoint descriptors */
> -#define dwc2_hb_mult(wmaxpacketsize) (1 + (((wmaxpacketsize) >> 11) & 0x03))
> -
> -/* Packet size for any kind of endpoint descriptor */
> -#define dwc2_max_packet(wmaxpacketsize) ((wmaxpacketsize) & 0x07ff)
> -
>   /*
>    * Returns true if frame1 index is greater than frame2 index. The comparison
>    * is done modulo FRLISTEN_64_SIZE. This accounts for the rollover of the
> diff --git a/drivers/usb/dwc2/hcd_intr.c b/drivers/usb/dwc2/hcd_intr.c
> index 88b5dcf3aefc..a052d39b4375 100644
> --- a/drivers/usb/dwc2/hcd_intr.c
> +++ b/drivers/usb/dwc2/hcd_intr.c
> @@ -1617,8 +1617,9 @@ static void dwc2_hc_ahberr_intr(struct dwc2_hsotg *hsotg,
>   
>   	dev_err(hsotg->dev, "  Speed: %s\n", speed);
>   
> -	dev_err(hsotg->dev, "  Max packet size: %d\n",
> -		dwc2_hcd_get_mps(&urb->pipe_info));
> +	dev_err(hsotg->dev, "  Max packet size: %d (mult %d)\n",
> +		dwc2_hcd_get_maxp(&urb->pipe_info),
> +		dwc2_hcd_get_maxp_mult(&urb->pipe_info));
>   	dev_err(hsotg->dev, "  Data buffer length: %d\n", urb->length);
>   	dev_err(hsotg->dev, "  Transfer buffer: %p, Transfer DMA: %08lx\n",
>   		urb->buf, (unsigned long)urb->dma);
> diff --git a/drivers/usb/dwc2/hcd_queue.c b/drivers/usb/dwc2/hcd_queue.c
> index ea3aa640c15c..68bbac64b753 100644
> --- a/drivers/usb/dwc2/hcd_queue.c
> +++ b/drivers/usb/dwc2/hcd_queue.c
> @@ -708,7 +708,7 @@ static void dwc2_hs_pmap_unschedule(struct dwc2_hsotg *hsotg,
>   static int dwc2_uframe_schedule_split(struct dwc2_hsotg *hsotg,
>   				      struct dwc2_qh *qh)
>   {
> -	int bytecount = dwc2_hb_mult(qh->maxp) * dwc2_max_packet(qh->maxp);
> +	int bytecount = qh->maxp_mult * qh->maxp;
>   	int ls_search_slice;
>   	int err = 0;
>   	int host_interval_in_sched;
> @@ -1332,7 +1332,7 @@ static int dwc2_check_max_xfer_size(struct dwc2_hsotg *hsotg,
>   	u32 max_channel_xfer_size;
>   	int status = 0;
>   
> -	max_xfer_size = dwc2_max_packet(qh->maxp) * dwc2_hb_mult(qh->maxp);
> +	max_xfer_size = qh->maxp * qh->maxp_mult;
>   	max_channel_xfer_size = hsotg->params.max_transfer_size;
>   
>   	if (max_xfer_size > max_channel_xfer_size) {
> @@ -1517,8 +1517,9 @@ static void dwc2_qh_init(struct dwc2_hsotg *hsotg, struct dwc2_qh *qh,
>   	u32 prtspd = (hprt & HPRT0_SPD_MASK) >> HPRT0_SPD_SHIFT;
>   	bool do_split = (prtspd == HPRT0_SPD_HIGH_SPEED &&
>   			 dev_speed != USB_SPEED_HIGH);
> -	int maxp = dwc2_hcd_get_mps(&urb->pipe_info);
> -	int bytecount = dwc2_hb_mult(maxp) * dwc2_max_packet(maxp);
> +	int maxp = dwc2_hcd_get_maxp(&urb->pipe_info);
> +	int maxp_mult = dwc2_hcd_get_maxp_mult(&urb->pipe_info);
> +	int bytecount = maxp_mult * maxp;
>   	char *speed, *type;
>   
>   	/* Initialize QH */
> @@ -1531,6 +1532,7 @@ static void dwc2_qh_init(struct dwc2_hsotg *hsotg, struct dwc2_qh *qh,
>   
>   	qh->data_toggle = DWC2_HC_PID_DATA0;
>   	qh->maxp = maxp;
> +	qh->maxp_mult = maxp_mult;
>   	INIT_LIST_HEAD(&qh->qtd_list);
>   	INIT_LIST_HEAD(&qh->qh_list_entry);
>   
> 

