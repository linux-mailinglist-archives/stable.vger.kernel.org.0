Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3695DECF
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 09:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfGCHYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 03:24:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbfGCHYU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 03:24:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2DB321881;
        Wed,  3 Jul 2019 07:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562138659;
        bh=oKLiX+noAGMAX3ZpKVTLVn9b2ZYDuHOziGSU1+gstKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rLh+yYfz/nRaPHeiqDg1glKx2Cy7AtwWnvYxbfuMNcfK/3479K8YaolFNL6iG88uI
         es8AkxUt8kfHyiJ7ZeDugjBOxhcT2XdH2URPgNC+NYOxXbSatRdLqXMuwESPtDbM/b
         AuKCcRQ/T+sE5VamnY7oazoPR3EFPjSYuHPfRTJw=
Date:   Wed, 3 Jul 2019 09:24:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 5.1 51/55] bpf, arm64: use more scalable stadd over ldxr
 / stxr loop in xadd
Message-ID: <20190703072416.GD3033@kroah.com>
References: <20190702080124.103022729@linuxfoundation.org>
 <20190702080126.728030225@linuxfoundation.org>
 <20190703020200.GR11506@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703020200.GR11506@sasha-vm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 02, 2019 at 10:02:00PM -0400, Sasha Levin wrote:
> On Tue, Jul 02, 2019 at 10:01:59AM +0200, Greg Kroah-Hartman wrote:
> > From: Daniel Borkmann <daniel@iogearbox.net>
> > 
> > commit 34b8ab091f9ef57a2bb3c8c8359a0a03a8abf2f9 upstream.
> > 
> > Since ARMv8.1 supplement introduced LSE atomic instructions back in 2016,
> > lets add support for STADD and use that in favor of LDXR / STXR loop for
> > the XADD mapping if available. STADD is encoded as an alias for LDADD with
> > XZR as the destination register, therefore add LDADD to the instruction
> > encoder along with STADD as special case and use it in the JIT for CPUs
> > that advertise LSE atomics in CPUID register. If immediate offset in the
> > BPF XADD insn is 0, then use dst register directly instead of temporary
> > one.
> > 
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > Acked-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> > Acked-by: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This one has a fix upstream: c5e2edeb01ae9ffbdde95bdcdb6d3614ba1eb195
> ("arm64: insn: Fix ldadd instruction encoding").

Good catch, now queued up, thanks.

greg k-h
