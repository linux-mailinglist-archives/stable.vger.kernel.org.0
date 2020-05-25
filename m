Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8CD1E1557
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 22:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390613AbgEYUwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 16:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388714AbgEYUwy (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 25 May 2020 16:52:54 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F83E206D5;
        Mon, 25 May 2020 20:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590439974;
        bh=NCQlb7YTv4yMe9ZHhlCP6kaLAWNOVDfJJ7zgbj2CTBM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tj03PNcVrtQMeyym0rxzuYAyI0Mjm0cupkVyIwnZDNnT5XRtJ+kqUA2k1GnVlx2gq
         x+BSRh+D9gWGVWs5NXCIlYND9e88Qc4vs3ay3WuWnt0NKsNLHrAkmsDe1f2FuNcrUt
         H4fM9zs0x2BQNnvWqNC55syyA0XiXCLPE9VDqcqs=
Date:   Mon, 25 May 2020 16:52:53 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     fabrice.gasnier@st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: adc: stm32-dfsdm: fix device used to
 request dma" failed to apply to 5.4-stable tree
Message-ID: <20200525205253.GA33628@sasha-vm>
References: <159041484016177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <159041484016177@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 03:54:00PM +0200, gregkh@linuxfoundation.org wrote:
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
>From b455d06e6fb3c035711e8aab1ca18082ccb15d87 Mon Sep 17 00:00:00 2001
>From: Fabrice Gasnier <fabrice.gasnier@st.com>
>Date: Thu, 30 Apr 2020 11:28:46 +0200
>Subject: [PATCH] iio: adc: stm32-dfsdm: fix device used to request dma
>
>DMA channel request should use device struct from platform device struct.
>Currently it's using iio device struct. But at this stage when probing,
>device struct isn't yet registered (e.g. device_register is done in
>iio_device_register). Since commit 71723a96b8b1 ("dmaengine: Create
>symlinks between DMA channels and slaves"), a warning message is printed
>as the links in sysfs can't be created, due to device isn't yet registered:
>- Cannot create DMA slave symlink
>- Cannot create DMA dma:rx symlink
>
>Fix this by using device struct from platform device to request dma chan.
>
>Fixes: eca949800d2d ("IIO: ADC: add stm32 DFSDM support for PDM microphone")
>
>Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
>Cc: <Stable@vger.kernel.org>
>Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

I've also grabbed a9ab624edd91 ("iio: adc: stm32-dfsdm: Use
dma_request_chan() instead dma_request_slave_channel()") and queued both
for 5.4 and 4.19.

-- 
Thanks,
Sasha
