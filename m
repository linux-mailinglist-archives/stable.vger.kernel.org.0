Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B86B7CE490
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 16:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfJGOCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 10:02:43 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42782 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbfJGOCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 10:02:43 -0400
Received: by mail-lj1-f196.google.com with SMTP id y23so13769253lje.9;
        Mon, 07 Oct 2019 07:02:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uJ53ip/908aA3HmGvsys5J4NL/0eR3dq/ckq75H04zI=;
        b=HMXMrJuMLPiU45E41j6HPFsZGOqxRfrkCm1Z69ILxNOdUrYBGy54qEXqQOjvf4DRtv
         OU8f4lf+ydtEDnrbkFLu6F7SXzhmz8K5vgOAKnd4+akqX94ULo6+jCxh4gxGCfEVKMcK
         yI3kaOyfy2LceXS0kXhXtBNpe/boVqlL91G+etZgpGDE3zg1LIi15GF/4tKbeLMmCjRx
         EZLiTf+lqdp5uQRYVUNh7l/vvzM9Zq/i2iH/eXxpWPYDF+7xhoxyo6ZUQZgrqTh3+lgY
         xa1Owxfbdr53FoqjvyGbeo6XvzNIIJsgDmgbgrpQp9jFLcKXCqx6mgZZ/hmOVv0Hknig
         hSNQ==
X-Gm-Message-State: APjAAAX4zoUL09+W1Q1PbW9Mu4SKSvJFCCfN+OVHuIN6NSbonACbSNr7
        FD03NmI23aPw60TAQ1qGxnk=
X-Google-Smtp-Source: APXvYqxyu6LEWOsBLBLqNL/Yy7/hQoo+9oWhfCoiMPoDsP7o8om6eu3mKqihAFWrW72hDFm1vmgH4Q==
X-Received: by 2002:a05:651c:1ae:: with SMTP id c14mr18699129ljn.169.1570456960868;
        Mon, 07 Oct 2019 07:02:40 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id l7sm3116545lji.46.2019.10.07.07.02.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 07:02:39 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@kernel.org>)
        id 1iHTb3-0005zB-CB; Mon, 07 Oct 2019 16:02:46 +0200
Date:   Mon, 7 Oct 2019 16:02:45 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        "# v5 . 3" <stable@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 8/8] xhci: Fix NULL pointer dereference in
 xhci_clear_tt_buffer_complete()
Message-ID: <20191007140245.GD13531@localhost>
References: <1570190373-30684-1-git-send-email-mathias.nyman@linux.intel.com>
 <1570190373-30684-9-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570190373-30684-9-git-send-email-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ +CC: Alan ]

On Fri, Oct 04, 2019 at 02:59:33PM +0300, Mathias Nyman wrote:
> udev stored in ep->hcpriv might be NULL if tt buffer is cleared
> due to a halted control endpoint during device enumeration
> 
> xhci_clear_tt_buffer_complete is called by hub_tt_work() once it's
> scheduled,  and by then usb core might have freed and allocated a
> new udev for the next enumeration attempt.
>
> Fixes: ef513be0a905 ("usb: xhci: Add Clear_TT_Buffer")
> Cc: <stable@vger.kernel.org> # v5.3
> Reported-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 00f3804f7aa7..517ec3206f6e 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -5238,8 +5238,16 @@ static void xhci_clear_tt_buffer_complete(struct usb_hcd *hcd,
>  	unsigned int ep_index;
>  	unsigned long flags;
>  
> +	/*
> +	 * udev might be NULL if tt buffer is cleared during a failed device
> +	 * enumeration due to a halted control endpoint. Usb core might
> +	 * have allocated a new udev for the next enumeration attempt.
> +	 */
> +
>  	xhci = hcd_to_xhci(hcd);
>  	udev = (struct usb_device *)ep->hcpriv;
> +	if (!udev)
> +		return;

I didn't have time to look into this myself last week, or comment on the
patch before Greg picked it up, but this clearly isn't the right fix.

As your comment suggests, ep->hcpriv may indeed be NULL here if USB core
have allocated a new udev. But this only happens after USB has freed the
old usb_device and the new one happens to get the same address.

Note that even the usb_host_endpoint itself (ep) has then been freed and
reallocated since it is member of struct usb_device, and it is the
use-after-free that needs fixing.

I've even been able to trigger another NULL-deref in this function
before a new udev has been allocated, due to the virt dev having been
freed by xhci_free_dev as part of usb_release_dev:

[   19.627771] usb 2-2.4: unable to read config index 0 descriptor/start: -32
[   19.627966] usb 2-2.4: chopping to 0 config(s)
[   19.628133] usb 2-2.4: can't read configurations, error -32
[   19.629017] usb 2-2.4: usb_release_dev - udev = ffff930b14d82000

udev is freed here

[   19.629258] usb 2-2-port4: attempt power cycle
[   19.629461] xhci_clear_tt_buffer_complete - udev = ffff930b14d82000

use-after-free when tt work is scheduled (note than udev is non-NULL
since udev hasn't been reallocated and initialised yet):

[   19.629643] xhci_clear_tt_buffer_complete - xhci->devs[4] = 0000000000000000

virt dev is NULL after having been freed by xhci_free_dev()

[   19.629876] BUG: kernel NULL pointer dereference, address: 0000000000000030

and is later dereferenced

[   19.630034] #PF: supervisor write access in kernel mode
[   19.630155] #PF: error_code(0x0002) - not-present page
[   19.630270] PGD 0 P4D 0 
[   19.630341] Oops: 0002 [#1] SMP
[   19.630425] CPU: 2 PID: 110 Comm: kworker/2:2 Not tainted 5.4.0-rc1 #28
[   19.630572] Hardware name:  /D34010WYK, BIOS WYLPT10H.86A.0051.2019.0322.1320 03/22/2019
[   19.636141] Workqueue: events hub_tt_work
[   19.638125] RIP: 0010:xhci_clear_tt_buffer_complete.cold.69+0x9b/0xcd

It seems the xhci clear-tt implementation was incomplete since it did
not take care to wait for any ongoing work before disabling the
endpoint. EHCI does this in ehci_endpoint_disable(), but xhci doesn't
even implement that callback.

As this may be something you could end up hitting in other paths as
well, perhaps we should even consider reverting the offending commit
pending a more complete implementation?

>  	slot_id = udev->slot_id;
>  	ep_index = xhci_get_endpoint_index(&ep->desc);

For reference, my original report is here:

	https://lkml.kernel.org/r/20190930103107.GC13531@localhost

Johan
