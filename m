Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 745C81FC2A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 23:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfEOVWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 17:22:15 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:60231 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfEOVWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 17:22:15 -0400
Received: from svr-orw-mbx-01.mgc.mentorg.com ([147.34.90.201])
        by relay1.mentorg.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        id 1hR1Lo-0001Iz-9i from George_Davis@mentor.com ; Wed, 15 May 2019 14:22:12 -0700
Received: from localhost (147.34.91.1) by svr-orw-mbx-01.mgc.mentorg.com
 (147.34.90.201) with Microsoft SMTP Server (TLS) id 15.0.1320.4; Wed, 15 May
 2019 14:22:09 -0700
Date:   Wed, 15 May 2019 17:22:08 -0400
From:   "George G. Davis" <george_davis@mentor.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     Eugeniu Rosca <erosca@de.adit-jv.com>,
        Chris Brandt <chris.brandt@renesas.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v3] serial: sh-sci: disable DMA for uart_console
Message-ID: <20190515212208.GC24340@mam-gdavis-lt>
References: <1557890974-21179-1-git-send-email-george_davis@mentor.com>
 <20190515105444.BB0722084F@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190515105444.BB0722084F@mail.kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-ClientProxiedBy: svr-orw-mbx-01.mgc.mentorg.com (147.34.90.201) To
 svr-orw-mbx-01.mgc.mentorg.com (147.34.90.201)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Sasha,

On Wed, May 15, 2019 at 10:54:43AM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.1.1, v5.0.15, v4.19.42, v4.14.118, v4.9.175, v4.4.179, v3.18.139.
> 
> v5.1.1: Build OK!
> v5.0.15: Build OK!
> v4.19.42: Build OK!
> v4.14.118: Build OK!

I've confirmed that the patch works on all of the above stable versions:

Tested-by: George G. Davis <george_davis@mentor.com> # on ARCH=arm64 boards r8a7795-es1-salvator-x and r8a7795-h3ulcb.


> v4.9.175: Failed to apply! Possible dependencies:
>     219fb0c1436e ("serial: sh-sci: Remove the platform data dma slave rx/tx channel IDs")

Although I've backported and build tested the patch on the above and below
stable versions, I'm unable to test on ARCH=arm64 boards due to lack of other
dependent commits for reliably booting the ARCH=arm64 boards that I have
available for testing.

I do have an ARCH=arm r8a7779-marzen board which hypothetically could be used
for testing on these earlier stable versions but it's rather mothballed at the
moment and will take some time to setup for testing.  I likely won't get to
that any time soon so since no one has reported this problem until recently,
I'd err on the side of limiting the stable update to v4.14+ for now.

If anyone has access to other targets which use the same driver and can test, please
feel free to backport and test the patch on ealier stable versions.

Thanks!

> 
> v4.4.179: Failed to apply! Possible dependencies:
>     219fb0c1436e ("serial: sh-sci: Remove the platform data dma slave rx/tx channel IDs")
> 
> v3.18.139: Failed to apply! Possible dependencies:
>     219fb0c1436e ("serial: sh-sci: Remove the platform data dma slave rx/tx channel IDs")
>     2922598cd913 ("serial: sh-sci: Replace hardcoded values in SCxSR_*_CLEAR macros")
>     2e0842a154f6 ("serial: sh-sci: Use the correct register for overrun checks")
>     31f90796c668 ("serial: sh-sci: Document remaining FIFO Control Register bits")
>     54af5001e1b8 ("serial: sh-sci: Use SCIF_DR instead of hardcoded literal 1")
>     75c249fd7cb9 ("serial: sh-sci: Replace hardcoded overrun bit values")
>     76735e9d558b ("serial: sh-sci: Add (H)SCIF RTS/CTS pin data register bit definitions")
>     8b6ff84c2d44 ("serial: sh-sci: Fix R-Car SCIF and HSCIF overrun handling")
>     8eadb56d6830 ("serial: sh-sci: Don't kick tx in sci_er_interrupt() when using DMA")
>     a1b5b43ffb84 ("serial: sh-sci: Replace buggy big #ifdef by runtime logic")
>     c097abc33f70 ("serial: sh-sci: Add SCIFA/B SCPCR register definitions")
>     c27ffc108017 ("serial: sh-sci: Move private definitions to private header file")
>     cb772fe75fa1 ("serial: sh-sci: Add overrun handling of SCIFA and SCIFB")
>     d94a0a385798 ("serial: sh-sci: Standardize on using the BIT() macro to define register bits")
>     e0a12a27e834 ("serial: sh-sci: Remove bogus sci_handle_fifo_overrun() call on (H)SCIF")
>     e1910fcdb545 ("serial: sh-sci: Shuffle functions around")
>     e6403c112f8c ("serial: sh-sci: Don't call sci_rx_interrupt() on error when using DMA")
>     ff4411296e99 ("serial: sh-sci: Add DT support to DMA setup")
> 
> 
> How should we proceed with this patch?
> 
> --
> Thanks,
> Sasha

-- 
Regards,
George
