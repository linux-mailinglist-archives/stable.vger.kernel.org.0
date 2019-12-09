Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909AD117253
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 18:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfLIRAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 12:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726675AbfLIRAu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 12:00:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FE852077B;
        Mon,  9 Dec 2019 17:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575910850;
        bh=5zucAkFkjylyFzKUfb8di/8z3cOaIOU+rfO2sojAIGI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bXGkQ7RgSpTQoVRyF/c9bV9xkMR4Rk5TlMO8qBR2gM9ejdpWtdhXkmssn0rmRTDUx
         lVFImaFsrZSlmJKFFvubeeQz62Wu5TZ0PMcmMFlQ50J3gM8pqG2MP2xioBoy0glanm
         0FB4qKCefUyV1TmDBt3DAaHr9XDEt1peYOKGqY4A=
Date:   Mon, 9 Dec 2019 18:00:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>
Subject: Re: Linux 4.4.207-rc1 8dbad6fe errors
Message-ID: <20191209170047.GC1290729@kroah.com>
References: <TYAPR01MB22854300E93B9F6D02232982B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYAPR01MB22854300E93B9F6D02232982B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 09, 2019 at 04:33:17PM +0000, Chris Paterson wrote:
> Hello Greg, all,
> 
> I've seen an error with 4.4.207-rc1 (8dbad6fe).
> 
> 1)
> Config: arm multi_v7_defconfig
> Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/373483706#L3649
> Probable culprit: bc15f46a10dc ("serial: pl011: Fix DMA ->flush_buffer()")
> Issue log:
> 3649 drivers/tty/serial/amba-pl011.c: In function 'pl011_dma_flush_buffer':
> 3650 drivers/tty/serial/amba-pl011.c:697:2: error: implicit declaration of function 'dmaengine_terminate_async'; did you mean 'dmaengine_terminate_all'? [-Werror=implicit-function-declaration]
> 3651   dmaengine_terminate_async(uap->dmatx.chan);
> 3652   ^~~~~~~~~~~~~~~~~~~~~~~~~

I'll go drop the offending patch now, thanks for letting me know.

greg k-h
