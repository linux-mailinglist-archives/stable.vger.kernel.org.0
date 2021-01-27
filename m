Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB5330597C
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 12:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhA0LU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 06:20:28 -0500
Received: from gloria.sntech.de ([185.11.138.130]:42148 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235466AbhA0Klg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 05:41:36 -0500
Received: from ip5f5aa64a.dynamic.kabel-deutschland.de ([95.90.166.74] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1l4iFm-0000lT-8T; Wed, 27 Jan 2021 11:40:50 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     hminas@synopsys.com, gregkh@linuxfoundation.org
Cc:     christoph.muellner@theobroma-systems.com, paulz@synopsys.com,
        yousaf.kaukab@intel.com, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc2: Fix endpoint direction check in ep_from_windex
Date:   Wed, 27 Jan 2021 11:40:48 +0100
Message-ID: <8309688.OUTRe80PYV@diego>
In-Reply-To: <20210125191324.1981199-1-heiko@sntech.de>
References: <20210125191324.1981199-1-heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Montag, 25. Januar 2021, 20:13:24 CET schrieb Heiko Stuebner:
> From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> 
> dwc2_hsotg_process_req_status uses ep_from_windex() to retrieve
> the endpoint for the index provided in the wIndex request param.
> 
> In a test-case with a rndis gadget running and sending a malformed
> packet to it like:
>     dev.ctrl_transfer(
>         0x82,      # bmRequestType
>         0x00,       # bRequest
>         0x0000,     # wValue
>         0x0001,     # wIndex
>         0x00       # wLength
>     )
> it is possible to cause a crash:
> 
> [  217.533022] dwc2 ff300000.usb: dwc2_hsotg_process_req_status: USB_REQ_GET_STATUS
> [  217.559003] Unable to handle kernel read from unreadable memory at virtual address 0000000000000088
> ...
> [  218.313189] Call trace:
> [  218.330217]  ep_from_windex+0x3c/0x54
> [  218.348565]  usb_gadget_giveback_request+0x10/0x20
> [  218.368056]  dwc2_hsotg_complete_request+0x144/0x184
> 
> This happens because ep_from_windex wants to compare the endpoint
> direction even if index_to_ep() didn't return an endpoint due to
> the direction not matching.
> 
> The fix is easy insofar that the actual direction check is already
> happening when calling index_to_ep() which will return NULL if there
> is no endpoint for the targeted direction, so the offending check
> can go away completely.
> 
> Fixes: c6f5c050e2a7 ("usb: dwc2: gadget: add bi-directional endpoint support")
> Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> Cc: stable@vger.kernel.org

superseeded by v3, which includes an appropriate Reported-by tag
and removes an now unused variable (in v2).


