Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A921423056
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 20:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhJESug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 14:50:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhJESuf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 14:50:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D81161215;
        Tue,  5 Oct 2021 18:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633459724;
        bh=hCoAuyF/nkHW3JTEAUZsqWtyDBaOH1b3pfFiHSJf4a4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gPrgersmIkFfN68r28fwVnMrIh6HtM+19pLPOfnTam7xQwaOyggpArLgHSqGcmKKK
         yy+TVR/xxu4bs8FOHI16uY9rjlOrg+fPX4i+NLRGQhAQR45Oymsd/rM1UDsC/7BKh3
         tBO3XQ9jakmqpkaGv2dzMxBHZS7r3v9v1x0i8TABVt7M+mM3d0cXaw2M6vsqi/JWQE
         iwjbv/isV3QM1h0Hu3q8YosJOOs1Ol+EtDe/i6F2mJ5LTEtcK9QUslt1/iv93/lOG0
         S0PEakWTscz0rkNvj83PzsA90oS3IZzuxe1W5C4RtCtmKjHdG+GqktnSDjYtmyJmKt
         zJuUyhWN7Dx6A==
Received: by pali.im (Postfix)
        id D5834812; Tue,  5 Oct 2021 20:48:41 +0200 (CEST)
Date:   Tue, 5 Oct 2021 20:48:41 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 06/13] PCI: aardvark: Do not clear status bits of masked
 interrupts
Message-ID: <20211005184841.46p3vrcmngkr73or@pali>
References: <20211001195856.10081-1-kabel@kernel.org>
 <20211001195856.10081-7-kabel@kernel.org>
 <20211004140653.GB24914@lpieralisi>
 <871r50st5h.wl-maz@kernel.org>
 <20211005141340.48c8c0f6@dellmb>
 <87mtnnr6cl.wl-maz@kernel.org>
 <20211005131545.ol3rb3zzgzze67uf@pali>
 <87lf37qxzu.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lf37qxzu.wl-maz@kernel.org>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday 05 October 2021 16:42:29 Marc Zyngier wrote:
> As I said, feel free to write something better.

Marek now sent a new version, I hope it is better:
https://lore.kernel.org/linux-pci/20211005180952.6812-7-kabel@kernel.org/


Anyway, I was thinking more if it is possible to end up in state when
*_status variables are zero also after applying patch 7/13.

I do not know how precisely are bits 8-11 of ISR1 reg handled in HW as
description is completely missing in all documentations which I read.
These bits represents events for legacy INTx interrupts.

And maybe it is possible that driver for endpoint card run some function
in context when all CPU interrupts are disabled and do something which
cause card to send Assert_INTA message followed by Deassert_INTA (e.g.
poke some register and immediately process event which deassert intx).
After endpoint driver function finish its execution then CPU receive
PCIe summary interrupt and pci controller driver would see that no event
is pending and noting to process.
