Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F9A37BA16
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhELKMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230134AbhELKMR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 06:12:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FAAE6134F;
        Wed, 12 May 2021 10:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620814269;
        bh=0C0eGZaks+Fyc2VtMfQIx6h8qZzie3m0M8udxrGn3Jw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YjuzfBLvF+JM2a6+GMrUyZGGXj7QhJpyNj2g8yrWOh7/S3Lyix+RAuRgVv6u2gPZ+
         5NVHnGIauwIoBc+e+2D1DPgZsmIrb5yJGWD4REdzv9h534fX0SP05/q7Ar+ZULbvgg
         Zbi3oOVgEedVEzJ7Q0xHhXrRG0HN1h6doysteNig=
Date:   Wed, 12 May 2021 12:10:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     seanjc@google.com, stable@vger.kernel.org
Subject: Re: [PATCH] x86/cpu: Initialize MSR_TSC_AUX if RDTSCP *or* RDPID is
 supported
Message-ID: <YJupgF/Q44atA+Pq@kroah.com>
References: <1620632578184221@kroah.com>
 <875yzofenz.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yzofenz.ffs@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 12:08:00PM +0200, Thomas Gleixner wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> commit b6b4fbd90b155a0025223df2c137af8a701d53b3 upstream
> 
> Initialize MSR_TSC_AUX with CPU node information if RDTSCP or RDPID is
> supported.  This fixes a bug where vdso_read_cpunode() will read garbage
> via RDPID if RDPID is supported but RDTSCP is not.  While no known CPU
> supports RDPID but not RDTSCP, both Intel's SDM and AMD's APM allow for
> RDPID to exist without RDTSCP, e.g. it's technically a legal CPU model
> for a virtual machine.
> 
> Note, technically MSR_TSC_AUX could be initialized if and only if RDPID
> is supported since RDTSCP is currently not used to retrieve the CPU node.
> But, the cost of the superfluous WRMSR is negigible, whereas leaving
> MSR_TSC_AUX uninitialized is just asking for future breakage if someone
> decides to utilize RDTSCP.
> 
> [ tglx: Backport for 4.14/4.19 ]

Now queued up, thanks!

greg k-h
