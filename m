Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801CA2F8101
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 17:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbhAOQlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 11:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbhAOQlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 11:41:03 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C1EC0613C1;
        Fri, 15 Jan 2021 08:40:22 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id o13so14063112lfr.3;
        Fri, 15 Jan 2021 08:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F187jcrt4Vz8VHgovKT4HK4fPui79osVpZl7JJpdyOc=;
        b=mZOknVGJDkWQpykGvLYC/BBj6PEI2jG6HiR6vZYp3sb/c0YKdtrjKA2O6muuk1a2bn
         yaAVt/EUZKReqOVuNPeCQcWP1E+Hzz1tSBfsDVkII8QRylTXhn3a86IClOODXWGSWJy5
         oycfRabkjr4r1vmnqPot/TMhCyww6nwLTmk/rc8tfhI+vkcy6jlkneHHrJuOGvy2XXsJ
         jlNm9DIpB/qtGRQI2Dk5E4Ku9CkJ4waUxFq6N1WEOhJqfrxwxkJFIYJoGroYBwR+6uUT
         LRiu0/4gA0brCpZ0ZjRHdztuETcZDaTt8CZL/FE1w8MqOHmqwTdsqlK3CqJBCB9UnKir
         iiYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F187jcrt4Vz8VHgovKT4HK4fPui79osVpZl7JJpdyOc=;
        b=gCt1EjcIslRnwyi11GoViIt3f+1a7ibkYyooOZ1z7hbLwo1ZMkBofq4VWLWpucQdQV
         aq3SiYqW4TOpMXwUDv7Hy1tgXaZd7nXsU1cotGsdul1LNFWhYmzY3wFtBTsIT9PcMgGz
         G250Dg5CGbUXl3PArt0TyUkvMRWwolvGP1InTHa2WT+axs5TsDBPBMCKUAF+OIRFtSBz
         nNbcyBJxDBgfjjAOK7QayZnDyzsH8x/3dANkBXnV4KQ8ibZQT/KVlvqWd8cfwp7lu5aW
         +A7h8Hor+0g1EkuN8VXaWWFq48why/PLY0ynmChrNizSF+SRoqUDGfP615pt9bGLO4H4
         bluQ==
X-Gm-Message-State: AOAM532PaLB2wqkwC1TqTLCpIVZ+1+sYvOilJ/LJ4i6JtxYugz1Oa3Hm
        41u63tcYttQ6/GWYDUNFVpmW1+Fg7KY=
X-Google-Smtp-Source: ABdhPJx7o98bKipw2ZfLsopmWzaOAq+dq6NE/O3heYZVEVCyq/5PfpezmaCKY+5nyaELMFjrbV68aA==
X-Received: by 2002:a19:4f57:: with SMTP id a23mr5844513lfk.495.1610728821450;
        Fri, 15 Jan 2021 08:40:21 -0800 (PST)
Received: from [192.168.1.101] ([178.176.73.247])
        by smtp.gmail.com with ESMTPSA id m16sm618725lfu.220.2021.01.15.08.40.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 08:40:20 -0800 (PST)
Subject: Re: [PATCH 1/2] xhci: make sure TRB is fully written before giving it
 to the controller
To:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
References: <20210115161907.2875631-1-mathias.nyman@linux.intel.com>
 <20210115161907.2875631-2-mathias.nyman@linux.intel.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <42c6632e-28f1-9aae-e1a6-3525bb493c58@gmail.com>
Date:   Fri, 15 Jan 2021 19:40:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210115161907.2875631-2-mathias.nyman@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/15/21 7:19 PM, Mathias Nyman wrote:

> Once the command ring doorbell is rung the xHC controller will parse all
> command TRBs on the command ring that have the cycle bit set properly.
> 
> If the driver just started writing the next command TRB to the ring when
> hardware finished the previous TRB, then HW might fetch an incomplete TRB
> as long as its cycle bit set correctly.
> 
> A command TRB is 16 bytes (128 bits) long.
> Driver writes the command TRB in four 32 bit chunks, with the chunk
> containing the cycle bit last. This does however not guarantee that
> chunks actually get written in that order.
> 
> This was detected in stress testing when canceling URBs with several
> connected USB devices.
> Two consecutive "Set TR Dequeue pointer" commands got queued right
> after each other, and the second one was only partially written when
> the controller parsed it, causing the dequeue pointer to be set
> to bogus values. This was seen as error messages:
> 
> "Mismatch between completed Set TR Deq Ptr command & xHCI internal state"
> 
> Solution is to add a write memory barrier before writing the cycle bit.
> 
> Cc: <stable@vger.kernel.org>
> Tested-by: Ross Zwisler <zwisler@google.com>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci-ring.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index 5677b81c0915..cf0c93a90200 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -2931,6 +2931,8 @@ static void queue_trb(struct xhci_hcd *xhci, struct xhci_ring *ring,
>  	trb->field[0] = cpu_to_le32(field1);
>  	trb->field[1] = cpu_to_le32(field2);
>  	trb->field[2] = cpu_to_le32(field3);
> +	/* make sure TRB is fully written before giving it to the controller */
> +	wmb();

   Have you tried the lighter barrier, dma_wmb()? IIRC, it exists for these exact cases...

>  	trb->field[3] = cpu_to_le32(field4);
>  
>  	trace_xhci_queue_trb(ring, trb);

MBR, Sergei
