Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42A742127F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 17:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbhJDPUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 11:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233561AbhJDPUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 11:20:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3B3961248;
        Mon,  4 Oct 2021 15:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633360707;
        bh=YCumSfZ/dbeZ4OPqKY/gryHPhfKvWqhTZ2tQRhwz7fE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DsJQDfXlE+N06KUEB403Inv0dnbSzPZzQ6A0vfRSbByuN2Qt+TiLn90gfnhQTSyJP
         YdKatr8dwfaFlAtjycIprLdflZPKkrx0ydeJHvt9aGpi0mvgw8YV6f4eufW8KhdgbE
         j/BEQ6U6vCLq8kv1QcMo3YhqKN8rrZEehLQV8ux9XRJRGNzoZvjGP5hfCrY6PxKeIT
         qahcZXdWmH7ENesSjboacp9vRAfACnILKVrEG7R9sCkQMq2fdQkMHAKi7e3y11MzOM
         XzDGbCbNJmvc/X60Zk+W6YKHGEARjS2UOiv9iMpIThBIIjr8hlXAp8LkmQ5ZBjPXpk
         fsmpBDx6zdJUA==
Date:   Mon, 4 Oct 2021 17:18:23 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        pali@kernel.org, stable@vger.kernel.org, maz@kernel.org
Subject: Re: [PATCH 06/13] PCI: aardvark: Do not clear status bits of masked
 interrupts
Message-ID: <20211004171823.0288684e@thinkpad>
In-Reply-To: <20211004140653.GB24914@lpieralisi>
References: <20211001195856.10081-1-kabel@kernel.org>
        <20211001195856.10081-7-kabel@kernel.org>
        <20211004140653.GB24914@lpieralisi>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 4 Oct 2021 15:06:53 +0100
Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:

> [+Marc - always better to have his eyes on IRQ handling code]
> 
> > -	if (!isr0_status && !isr1_status) {
> > -		advk_writel(pcie, isr0_val, PCIE_ISR0_REG);
> > -		advk_writel(pcie, isr1_val, PCIE_ISR1_REG);  
> 
> This looks fine - on the other hand if no interrupt is set in the status
> registers (that are filtered with the masks) we are dealing with a
> spurious IRQ right ? Just gauging how severe this is.

Yes, spurious IRQ can really happen.

Patch 7 in this series fixes an issue where aardvark does not mask all
interrupts, and then kernel can think that an interrupt is masked but
it really isn't.

Also, some interrupts may be masked by the user of the emulated bridge
(some other driver), so that they can be polled. But if we clear all of
them in the status, even the masked ones, then the other driver which
is polling will always get a zero.

Marek
