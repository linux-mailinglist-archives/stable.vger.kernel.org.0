Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDB0D6CAD
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 02:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfJOA5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 20:57:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbfJOA5f (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 14 Oct 2019 20:57:35 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD96A2089C;
        Tue, 15 Oct 2019 00:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571101055;
        bh=kjQ2q4H55IKgv4g7eneH9N+TE7dK92bPqOPWFRmKf1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z8VrBEbq2s7ZfQiM+J4uX6+sjOW6ydIjhoY8lUDFiOzJUo2W+IR0OuZ2NAUqjajv9
         LZDVaxMnOdAhlY0ETjAEJkKR35UDtIaTy3rTKdsxZf/eJqytsa1SM5keLz0dZWwkkz
         CVACQ72a+9lxkLxCT6O7ZG06pUm6zc0qA/WNZPPY=
Date:   Mon, 14 Oct 2019 20:57:33 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     ak@it-klinger.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: adc: hx711: fix bug in sampling of
 data" failed to apply to 4.14-stable tree
Message-ID: <20191015005733.GH31224@sasha-vm>
References: <15710652867196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15710652867196@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 05:01:26PM +0200, gregkh@linuxfoundation.org wrote:
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
>From 4043ecfb5fc4355a090111e14faf7945ff0fdbd5 Mon Sep 17 00:00:00 2001
>From: Andreas Klinger <ak@it-klinger.de>
>Date: Mon, 9 Sep 2019 14:37:21 +0200
>Subject: [PATCH] iio: adc: hx711: fix bug in sampling of data
>
>Fix bug in sampling function hx711_cycle() when interrupt occures while
>PD_SCK is high. If PD_SCK is high for at least 60 us power down mode of
>the sensor is entered which in turn leads to a wrong measurement.
>
>Switch off interrupts during a PD_SCK high period and move query of DOUT
>to the latest point of time which is at the end of PD_SCK low period.
>
>This bug exists in the driver since it's initial addition. The more
>interrupts on the system the higher is the probability that it happens.
>
>Fixes: c3b2fdd0ea7e ("iio: adc: hx711: Add IIO driver for AVIA HX711")
>Signed-off-by: Andreas Klinger <ak@it-klinger.de>
>Cc: <Stable@vger.kernel.org>
>Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

I've queued up this patch in addition: 461631face580 ("iio: hx711: add
delay until DOUT is ready") and queued both for 4.14. It's not needed on
older kernels.

-- 
Thanks,
Sasha
