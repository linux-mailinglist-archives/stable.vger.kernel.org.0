Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4C6157E09
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 16:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgBJPBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 10:01:20 -0500
Received: from netrider.rowland.org ([192.131.102.5]:36427 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727842AbgBJPBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 10:01:20 -0500
Received: (qmail 16865 invoked by uid 500); 10 Feb 2020 10:01:19 -0500
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 10 Feb 2020 10:01:19 -0500
Date:   Mon, 10 Feb 2020 10:01:19 -0500 (EST)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To:     Peter Enderborg <peter.enderborg@sony.com>
cc:     Jiri Kosina <jikos@kernel.org>, Johan Korsnes <jkorsnes@cisco.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] HID: Extend report buffer size
In-Reply-To: <20200210120847.31737-1-peter.enderborg@sony.com>
Message-ID: <Pine.LNX.4.44L0.2002100957401.14460-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Feb 2020, Peter Enderborg wrote:

> In the patch "HID: Fix slab-out-of-bounds read in hid_field_extract"
> there added a check for buffer overruns. This made Elgato StreamDeck
> to fail. This patch extend the buffer to 8192 to solve this. It also
> adds a print of the requested length if it fails on this test.
> 
> Signed-off-by: Peter Enderborg <peter.enderborg@sony.com>
> ---
>  drivers/hid/hid-core.c | 2 +-
>  include/linux/hid.h    | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 851fe54ea59e..28841219b3d2 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -290,7 +290,7 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
>  
>  	/* Total size check: Allow for possible report index byte */
>  	if (report->size > (HID_MAX_BUFFER_SIZE - 1) << 3) {
> -		hid_err(parser->device, "report is too long\n");
> +		hid_err(parser->device, "report is too long (%d)\n", report->size);
>  		return -1;
>  	}
>  
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index cd41f209043f..875f71132b14 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -492,7 +492,7 @@ struct hid_report_enum {
>  };
>  
>  #define HID_MIN_BUFFER_SIZE	64		/* make sure there is at least a packet size of space */
> -#define HID_MAX_BUFFER_SIZE	4096		/* 4kb */
> +#define HID_MAX_BUFFER_SIZE	8192		/* 8kb */
>  #define HID_CONTROL_FIFO_SIZE	256		/* to init devices with >100 reports */
>  #define HID_OUTPUT_FIFO_SIZE	64

The second part of this patch is identical to the "HID: core: increase
HID report buffer size to 8KiB" patch submitted by Johan Korsnes a few
weeks ago.  You might want to submit just the first part of your patch,
or not submit anything at all.

Alan Stern

