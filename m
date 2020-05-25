Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E37F1E1552
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 22:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390679AbgEYUwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 16:52:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388714AbgEYUwD (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 25 May 2020 16:52:03 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CF90206D5;
        Mon, 25 May 2020 20:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590439922;
        bh=Uolwe84asMVFPUHLyWBSC47R3hMCsLozNi0QPlpqycA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U2jDMszNG3pXPzq4jon8JEVDZFDPTArcQJsbs5a8L7h//KbSJx89zkb+457kX3oDZ
         r9XP/Gljwe+G0JXqDIqv2qsRjlClBQFjoypg4ggMIDfsYatHHoMJvfmv+JuZBB10Nm
         zb7pNOPLHxKytXqFfTD5naona0PCnx7crW7rUgTQ=
Date:   Mon, 25 May 2020 16:52:01 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     fabrice.gasnier@st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: adc: stm32-adc: fix device used to
 request dma" failed to apply to 5.4-stable tree
Message-ID: <20200525205201.GZ33628@sasha-vm>
References: <15904148129183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15904148129183@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 03:53:32PM +0200, gregkh@linuxfoundation.org wrote:
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
>From 52cd91c27f3908b88e8b25aed4a4d20660abcc45 Mon Sep 17 00:00:00 2001
>From: Fabrice Gasnier <fabrice.gasnier@st.com>
>Date: Thu, 30 Apr 2020 11:28:45 +0200
>Subject: [PATCH] iio: adc: stm32-adc: fix device used to request dma
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
>Fixes: 2763ea0585c99 ("iio: adc: stm32: add optional dma support")
>
>Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
>Cc: <Stable@vger.kernel.org>
>Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

I've also grabbed 735404b846df ("iio: adc: stm32-adc: Use
dma_request_chan() instead dma_request_slave_channel()") and queued both
for 5.4, 4.19, and 4.14.

-- 
Thanks,
Sasha
