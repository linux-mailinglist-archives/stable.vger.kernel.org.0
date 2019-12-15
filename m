Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D98211FA45
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 19:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfLOSD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 13:03:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfLOSD0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 13:03:26 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3F6724679;
        Sun, 15 Dec 2019 18:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576433006;
        bh=7MDVBjL0bmPQT4KZwYEhaHZVXQKkz7O30G5Ndek4WpY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ti6kp3hLrjQtb+RSeMHlimXqZC8C+7dwr/7NN7QhiI0OGUPn8mLMRQZi6EirbFZjM
         g8vv3y05xPs+5TptJyhpHcBZTrwEg3z7R30cxj/Nq4bFQZr3Z2GTFTxjtSvwQPe1cY
         hRiKKdQe0E+rgY92M/E35it7Sl5x2mEx5EcDHubc=
Date:   Sun, 15 Dec 2019 13:03:24 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     mathias.nyman@linux.intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] xhci: make sure interrupts are restored
 to correct state" failed to apply to 4.19-stable tree
Message-ID: <20191215180324.GH18043@sasha-vm>
References: <15764020665465@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15764020665465@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 10:27:46AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From bd82873f23c9a6ad834348f8b83f3b6a5bca2c65 Mon Sep 17 00:00:00 2001
>From: Mathias Nyman <mathias.nyman@linux.intel.com>
>Date: Wed, 11 Dec 2019 16:20:07 +0200
>Subject: [PATCH] xhci: make sure interrupts are restored to correct state
>
>spin_unlock_irqrestore() might be called with stale flags after
>reading port status, possibly restoring interrupts to a incorrect
>state.
>
>If a usb2 port just finished resuming while the port status is read
>the spin lock will be temporary released and re-acquired in a separate
>function. The flags parameter is passed as value instead of a pointer,
>not updating flags properly before the final spin_unlock_irqrestore()
>is called.
>
>Cc: <stable@vger.kernel.org> # v3.12+
>Fixes: 8b3d45705e54 ("usb: Fix xHCI host issues on remote wakeup.")
>Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>Link: https://lore.kernel.org/r/20191211142007.8847-7-mathias.nyman@linux.intel.com
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

There were quite a few code movements around this:

	e67ebf1b3815 ("xhci: move usb2 get port status link resume handling to its own function")
	5f78a54f8d31 ("xhci: move usb3 speficic bits to own function in get_port_status call")
	70e9b53dfedc ("xhci: move usb2 speficic bits to own function in get_port_status call")

I've fixed up the original patch to work around that and queued for 4.19
- 4.4.

-- 
Thanks,
Sasha
