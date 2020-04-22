Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98201B3A03
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 10:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgDVI1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 04:27:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbgDVI1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 04:27:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 906D520663;
        Wed, 22 Apr 2020 08:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587544064;
        bh=9nPEUCr7SP5h8JspfKl0cqAh0KchfqzJhrBmJScvk98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N2Kd0CFMnUNEzctUveKaEibsEEqBa9DcDG4hGVTv8fZGK2TQnCOv7oQA+LpXWhdcM
         ZjjyoUZR7rQFM4BXY5h1Mkdb3GGyJLVybTDwtTUZFOuqoU6AYb1bWF6olOX/YcUEnn
         kH+Bj3lvxWVJA/B/mXDxyALdCj+6QxQDn+BpjUkQ=
Date:   Wed, 22 Apr 2020 10:27:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Evalds Iodzevics <evalds.iodzevics@gmail.com>
Cc:     linux-kernel@vger.kernel.org, tglx@linutronix.de,
        ben@decadent.org.uk, bp@suse.de, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/microcode/intel: replace sync_core() with
 native_cpuid_reg(eax)
Message-ID: <20200422082741.GA3017981@kroah.com>
References: <20200422081759.1632-1-evalds.iodzevics@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422081759.1632-1-evalds.iodzevics@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 11:17:59AM +0300, Evalds Iodzevics wrote:
> On Intel it is required to do CPUID(1) before reading the microcode
> revision MSR. Current code in 4.4 an 4.9 relies on sync_core() to call
> CPUID, unfortunately on 32 bit machines code inside sync_core() always
> jumps past CPUID instruction as it depends on data structure boot_cpu_data
> witch are not populated correctly so early in boot sequence.
> 
> It depends on:
> commit 5dedade6dfa2 ("x86/CPU: Add native CPUID variants returning a single
> datum")
> 
> This patch is for 4.4 but also should apply to 4.9
> 
> Signed-off-by: Evalds Iodzevics <evalds.iodzevics@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/include/asm/microcode_intel.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, much better, now queued up.

greg k-h
