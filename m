Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D2CD6D6D
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 05:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfJODA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 23:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727540AbfJODA4 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 14 Oct 2019 23:00:56 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8C9220673;
        Tue, 15 Oct 2019 02:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571108118;
        bh=I0EDowEOMzLZDTzTPWxkunjiW/heK91S1keohUDBaoM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kXM6AIoK4mOa6hMnDwWQUqQrq9iiYN5eDjCwVdlP8tdagb9AsvKoSbbmQcjM1ssYI
         zipcALdJ1kQKPOPTyVaWc88EI1Gaey5Dvst8pBRBfuU0Hi5wPNrPsmZS3dRdSY1HJ+
         HY5+QbPDGQDANua0swDeQhFtuEYZzWSz4R/511c4=
Date:   Mon, 14 Oct 2019 22:55:16 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     fabrice.gasnier@st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: adc: stm32-adc: fix a race when
 using several adcs with" failed to apply to 4.19-stable tree
Message-ID: <20191015025516.GI31224@sasha-vm>
References: <15710686967202@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15710686967202@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 05:58:16PM +0200, gregkh@linuxfoundation.org wrote:
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
>From dcb10920179ab74caf88a6f2afadecfc2743b910 Mon Sep 17 00:00:00 2001
>From: Fabrice Gasnier <fabrice.gasnier@st.com>
>Date: Tue, 17 Sep 2019 14:38:16 +0200
>Subject: [PATCH] iio: adc: stm32-adc: fix a race when using several adcs with
> dma and irq
>
>End of conversion may be handled by using IRQ or DMA. There may be a
>race when two conversions complete at the same time on several ADCs.
>EOC can be read as 'set' for several ADCs, with:
>- an ADC configured to use IRQs. EOCIE bit is set. The handler is normally
>  called in this case.
>- an ADC configured to use DMA. EOCIE bit isn't set. EOC triggers the DMA
>  request instead. It's then automatically cleared by DMA read. But the
>  handler gets called due to status bit is temporarily set (IRQ triggered
>  by the other ADC).
>So both EOC status bit in CSR and EOCIE control bit must be checked
>before invoking the interrupt handler (e.g. call ISR only for
>IRQ-enabled ADCs).
>
>Fixes: 2763ea0585c9 ("iio: adc: stm32: add optional dma support")
>
>Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
>Cc: <Stable@vger.kernel.org>
>Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

It would be nice if a stable patch wouldn't depend on a massive code
movement patch...

Anyway, I ported both to 4.19 as it was just a minor missing dependency,
but 4.14 requires more work I'll leave to someone who knows that code
better than me.

-- 
Thanks,
Sasha
