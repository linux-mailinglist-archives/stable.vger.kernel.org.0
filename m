Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840761D48CD
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 10:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgEOIvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 04:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgEOIvM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 04:51:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69442206B6;
        Fri, 15 May 2020 08:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589532671;
        bh=3C/WE/cLJYbcqBfJ1AYsMlIORvaJH6kbT1mGEA0kYNI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ziEQqEDtrmYpajYvmeQSqFp4Lo2q7rqxK5UG8YP8o56yDcSR8L9SiF1CLrs6AmnGD
         EZ1fklCkNQkSiF4eeUHorJdv6JgwnkjBEqXmCXNjKrx3YwySRlsbFQHI1n5N0ipMK0
         rv7qSMg4vay98Ubnmy7b424zB8PGsKJL+01kZVZs=
Date:   Fri, 15 May 2020 10:51:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, "wuxu.wu" <wuxu.wu@huawei.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 for 4.4, 4.9] spi: spi-dw: Add lock protect dw_spi
 rx/tx to prevent concurrent calls
Message-ID: <20200515085109.GC1474499@kroah.com>
References: <20200515004245.1069864-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515004245.1069864-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 15, 2020 at 09:42:45AM +0900, Nobuhiro Iwamatsu wrote:
> From: "wuxu.wu" <wuxu.wu@huawei.com>
> 
> commit 19b61392c5a852b4e8a0bf35aecb969983c5932d upstream.
> 
> dw_spi_irq() and dw_spi_transfer_one concurrent calls.
> 
> I find a panic in dw_writer(): txw = *(u8 *)(dws->tx), when dw->tx==null,
> dw->len==4, and dw->tx_end==1.
> 
> When tpm driver's message overtime dw_spi_irq() and dw_spi_transfer_one
> may concurrent visit dw_spi, so I think dw_spi structure lack of protection.
> 
> Otherwise dw_spi_transfer_one set dw rx/tx buffer and then open irq,
> store dw rx/tx instructions and other cores handle irq load dw rx/tx
> instructions may out of order.
> 
> 	[ 1025.321302] Call trace:
> 	...
> 	[ 1025.321319]  __crash_kexec+0x98/0x148
> 	[ 1025.321323]  panic+0x17c/0x314
> 	[ 1025.321329]  die+0x29c/0x2e8
> 	[ 1025.321334]  die_kernel_fault+0x68/0x78
> 	[ 1025.321337]  __do_kernel_fault+0x90/0xb0
> 	[ 1025.321346]  do_page_fault+0x88/0x500
> 	[ 1025.321347]  do_translation_fault+0xa8/0xb8
> 	[ 1025.321349]  do_mem_abort+0x68/0x118
> 	[ 1025.321351]  el1_da+0x20/0x8c
> 	[ 1025.321362]  dw_writer+0xc8/0xd0
> 	[ 1025.321364]  interrupt_transfer+0x60/0x110
> 	[ 1025.321365]  dw_spi_irq+0x48/0x70
> 	...
> 
> Signed-off-by: wuxu.wu <wuxu.wu@huawei.com>
> Link: https://lore.kernel.org/r/1577849981-31489-1-git-send-email-wuxu.wu@huawei.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/spi/spi-dw.c | 15 ++++++++++++---
>  drivers/spi/spi-dw.h |  1 +
>  2 files changed, 13 insertions(+), 3 deletions(-)

Now queued up, thanks.

greg k-h
