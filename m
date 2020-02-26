Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED6F16FA6E
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 10:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgBZJQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 04:16:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726494AbgBZJQL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Feb 2020 04:16:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB6FE2084E;
        Wed, 26 Feb 2020 09:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582708571;
        bh=vOyXD9rJhId298oS+EZGvV57KKU6jKyffK7L4FrbpG8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I9kRPDu+j/4E8TOMt2vRI+Oi3l8pDpiE0AEeq7VFccNkdRBUWXmkpgxuvaa12JrDW
         SKwhVZUhrphU4M1WPYK0c8zGFeIT8qMiWC8BMr8Kcs5WDQilTcAamGOj2RrNRpp2Zi
         J8RVNJs0QWwNTVsUQS31VRW0AqiGjDdSb5PTxO+A=
Date:   Wed, 26 Feb 2020 10:16:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     stable@vger.kernel.org, peter.chen@nxp.com,
        mathias.nyman@linux.intel.com
Subject: Re: usb: host: xhci: update event ring dequeue pointer on purpose
Message-ID: <20200226091609.GA48573@kroah.com>
References: <20200220105209.27506-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220105209.27506-1-festevam@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 20, 2020 at 07:52:09AM -0300, Fabio Estevam wrote:
> From: Peter Chen <peter.chen@nxp.com>
> 
> [ Upstream commit dc0ffbea5729a3abafa577ebfce87f18b79e294b ]
> 
> On some situations, the software handles TRB events slower
> than adding TRBs, then xhci_handle_event can't return zero
> long time, the xHC will consider the event ring is full,
> and trigger "Event Ring Full" error, but in fact, the software
> has already finished lots of events, just no chance to
> update ERDP (event ring dequeue pointer).
> 
> In this commit, we force update ERDP if half of TRBS_PER_SEGMENT
> events have handled to avoid "Event Ring Full" error.
> 
> Signed-off-by: Peter Chen <peter.chen@nxp.com>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Link: https://lore.kernel.org/r/1573836603-10871-2-git-send-email-mathias.nyman@linux.intel.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
> Hi,
> 
> One of our customer running 4.14 reported that this upstream patch
> fixes USB issues, so I am sending it to the stable trees.

It also needs to go to 4.19.y and 5.4.y, so I have added it there too.

thanks,

greg k-h
