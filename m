Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 629E911FA60
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 19:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfLOSVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 13:21:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfLOSVu (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sun, 15 Dec 2019 13:21:50 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 964D2206E0;
        Sun, 15 Dec 2019 18:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576434109;
        bh=gG0fv9BJ81LZFhNXe9aYEiQsoDXBuwKGxAtDvl+Tqd4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0q5KP+5TI3EzFRyOUCU5nL3+7CGqoS5oHKtShSBPWZMVwsaMdUktF7/c9Y077ReKk
         23+lbPUacQMuoqcN040MKBx0Gg4f/+cIWO1x5Z0T3wyHVbdFR+GkA5KbhggznWGzj8
         hWRbwywQ5Swq0zZurav2ZzMT4uqsqNsRJKK6C4sA=
Date:   Sun, 15 Dec 2019 13:21:48 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     andrea.merello@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, charles-antoine.couret@essensium.com
Subject: Re: FAILED: patch "[PATCH] iio: ad7949: fix channels mixups" failed
 to apply to 5.4-stable tree
Message-ID: <20191215182148.GK18043@sasha-vm>
References: <157640227474124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157640227474124@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 10:31:14AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
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
>From 3b71f6b59508b1c9befcb43de434866aafc76520 Mon Sep 17 00:00:00 2001
>From: Andrea Merello <andrea.merello@gmail.com>
>Date: Mon, 2 Dec 2019 15:13:36 +0100
>Subject: [PATCH] iio: ad7949: fix channels mixups
>
>Each time we need to read a sample (from the sysfs interface, since the
>driver supports only it) the driver writes the configuration register
>with the proper settings needed to perform the said read, then it runs
>another xfer to actually read the resulting value. Most notably the
>configuration register is updated to set the ADC internal MUX depending by
>which channel the read targets.
>
>Unfortunately this seems not enough to ensure correct operation because
>the ADC works in a pipelined-like fashion and the new configuration isn't
>applied in time.
>
>The ADC alternates two phases: acquisition and conversion. During the
>acquisition phase the ADC samples the analog signal in an internal
>capacitor; in the conversion phase the ADC performs the actual analog to
>digital conversion of the stored voltage. Note that of course the MUX
>needs to be set to the proper channel when the acquisition phase is
>performed.
>
>Once the conversion phase has been completed, the device automatically
>switches back to a new acquisition; on the other hand the device switches
>from acquisition to conversion on the rising edge of SPI cs signal (that
>is when the xfer finishes).
>
>Only after both two phases have been completed (with the proper settings
>already written in the configuration register since the beginning) it is
>possible to read the outcome from SPI bus.
>
>With the current driver implementation, we end up in the following
>situation:
>
>        _______  1st xfer ____________  2nd xfer ___________________
>SPI cs..       \_________/            \_________/
>SPI rd.. idle  |(val N-2)+    idle    | val N-1 +   idle ...
>SPI wr.. idle  |  cfg N  +    idle    |   (X)   +   idle ...
>------------------------ + -------------------- + ------------------
>  AD  ..   acq  N-1      + cnv N-1 |  acq N     +  cnv N  | acq N+1
>
>As shown in the diagram above, the value we read in the Nth read belongs
>to configuration setting N-1.
>
>In case the configuration is not changed (config[N] == config[N-1]), then
>we still get correct data, but in case the configuration changes (i.e.
>switching the MUX on another channel), we get wrong data (data from the
>previously selected channel).
>
>This patch fixes this by performing one more "dummy" transfer in order to
>ending up in reading the data when it's really ready, as per the following
>timing diagram.
>
>        _______  1st xfer ____________  2nd xfer ___________  3rd xfer ___
>SPI cs..       \_________/            \_________/           \_________/
>SPI rd.. idle  |(val N-2)+    idle    |(val N-1)+    idle   |  val N  + ..
>SPI wr.. idle  |  cfg N  +    idle    |   (X)   +    idle   |   (X)   + ..
>------------------------ + -------------------- + ------------------- + --
>  AD  ..   acq  N-1      + cnv N-1 |  acq N     +  cnv N  | acq N+1   | ..
>
>NOTE: in the latter case (cfg changes), the acquisition phase for the
>value to be read begins after the 1st xfer, that is after the read request
>has been issued on sysfs. On the other hand, if the cfg doesn't change,
>then we can refer to the fist diagram assuming N == (N - 1); the
>acquisition phase _begins_ before the 1st xfer (potentially a lot of time
>before the read has been issued via sysfs, but it _ends_ after the 1st
>xfer, that is _after_ the read has started. This should guarantee a
>reasonably fresh data, which value represents the voltage that the sampled
>signal has after the read start or maybe just around it.
>
>Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
>Reviewed-by: Charles-Antoine Couret <charles-antoine.couret@essensium.com>
>Cc: <Stable@vger.kernel.org>
>Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

I took in the following as a depndency and queued for 5.4-4.19:

	c270bbf7bb9d ("iio: ad7949: kill pointless "readback"-handling code")

-- 
Thanks,
Sasha
