Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4983959CE
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 13:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhEaLmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 07:42:24 -0400
Received: from muru.com ([72.249.23.125]:34398 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231240AbhEaLmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 07:42:23 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 2DEA480C5;
        Mon, 31 May 2021 11:40:48 +0000 (UTC)
Date:   Mon, 31 May 2021 14:40:34 +0300
From:   Tony Lindgren <tony@atomide.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Bin Liu <b-liu@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: musb: fix MUSB_QUIRK_B_DISCONNECT_99 handling
Message-ID: <YLTLMnLlkhaJ29AO@atomide.com>
References: <20210528140446.278076-1-thomas.petazzoni@bootlin.com>
 <YLENtd45ly8ZFJO2@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLENtd45ly8ZFJO2@piout.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Alexandre Belloni <alexandre.belloni@bootlin.com> [210528 15:35]:
> On 28/05/2021 16:04:46+0200, Thomas Petazzoni wrote:
> > In commit 92af4fc6ec33 ("usb: musb: Fix suspend with devices
> > connected for a64"), the logic to support the
> > MUSB_QUIRK_B_DISCONNECT_99 quirk was modified to only conditionally
> > schedule the musb->irq_work delayed work.
> > 
> > This commit badly breaks ECM Gadget on AM335X. Indeed, with this
> > commit, one can observe massive packet loss:
> > 
> > $ ping 192.168.0.100
> > ...
> > 15 packets transmitted, 3 received, 80% packet loss, time 14316ms
> > 
> > Reverting this commit brings back a properly functioning ECM
> > Gadget. An analysis of the commit seems to indicate that a mistake was
> > made: the previous code was not falling through into the
> > MUSB_QUIRK_B_INVALID_VBUS_91, but now it is, unless the condition is
> > taken.
> > 
> > Changing the logic to be as it was before the problematic commit *and*
> > only conditionally scheduling musb->irq_work resolves the regression:
> > 
> > $ ping 192.168.0.100
> > ...
> > 64 packets transmitted, 64 received, 0% packet loss, time 64475ms
> > 
> > Fixes: 92af4fc6ec33 ("usb: musb: Fix suspend with devices connected for a64")
> > Signed-off-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
> Tested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

Ouch, sorry about that one. And thanks for fixing it:

Acked-by: Tony Lindgren <tony@atomide.com>
