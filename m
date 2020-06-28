Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EA820CAD3
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 00:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgF1WBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 18:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgF1WBs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jun 2020 18:01:48 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 889FA20672;
        Sun, 28 Jun 2020 22:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593381707;
        bh=4hYE+lRLGGCsXCjtjMbftfGY6p839lc6ytEcFM7ut8Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KkInysPOFdqWmq7Oh8/PoJ0cBfbV2TpYCQjQbUfjLNnZ8vdbvRP7DlmjCA6BC+g5D
         w4JjlcaO3My5DALDK1TomOBJKYf9DGEkiQkiyStEwvCvHceIrZ1T/2OyjGPBRO94P/
         bDrZbC3cAHC6lWKdajZ6O255ydmArOC9Mt3UifOw=
Date:   Sun, 28 Jun 2020 18:01:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     kai.heng.feng@canonical.com, mathias.nyman@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] xhci: Poll for U0 after disabling USB2
 LPM" failed to apply to 4.14-stable tree
Message-ID: <20200628220146.GN1931@sasha-vm>
References: <1593358699218117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1593358699218117@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 28, 2020 at 05:38:19PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
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
>From b3d71abd135e6919ca0b6cab463738472653ddfb Mon Sep 17 00:00:00 2001
>From: Kai-Heng Feng <kai.heng.feng@canonical.com>
>Date: Wed, 24 Jun 2020 16:59:49 +0300
>Subject: [PATCH] xhci: Poll for U0 after disabling USB2 LPM
>
>USB2 devices with LPM enabled may interrupt the system suspend:
>[  932.510475] usb 1-7: usb suspend, wakeup 0
>[  932.510549] hub 1-0:1.0: hub_suspend
>[  932.510581] usb usb1: bus suspend, wakeup 0
>[  932.510590] xhci_hcd 0000:00:14.0: port 9 not suspended
>[  932.510593] xhci_hcd 0000:00:14.0: port 8 not suspended
>..
>[  932.520323] xhci_hcd 0000:00:14.0: Port change event, 1-7, id 7, portsc: 0x400e03
>..
>[  932.591405] PM: pci_pm_suspend(): hcd_pci_suspend+0x0/0x30 returns -16
>[  932.591414] PM: dpm_run_callback(): pci_pm_suspend+0x0/0x160 returns -16
>[  932.591418] PM: Device 0000:00:14.0 failed to suspend async: error -16
>
>During system suspend, USB core will let HC suspends the device if it
>doesn't have remote wakeup enabled and doesn't have any children.
>However, from the log above we can see that the usb 1-7 doesn't get bus
>suspended due to not in U0. After a while the port finished U2 -> U0
>transition, interrupts the suspend process.
>
>The observation is that after disabling LPM, port doesn't transit to U0
>immediately and can linger in U2. xHCI spec 4.23.5.2 states that the
>maximum exit latency for USB2 LPM should be BESL + 10us. The BESL for
>the affected device is advertised as 400us, which is still not enough
>based on my testing result.
>
>So let's use the maximum permitted latency, 10000, to poll for U0
>status to solve the issue.
>
>Cc: stable@vger.kernel.org
>Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>Link: https://lore.kernel.org/r/20200624135949.22611-6-mathias.nyman@linux.intel.com
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I've adjusted the patch to missing 38986ffa6a74 ("xhci: use port
structures instead of port arrays in xhci.c functions") and queued it
for 4.14, 4.9, and 4.4.

-- 
Thanks,
Sasha
