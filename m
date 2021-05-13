Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DE03800F9
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 01:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbhEMXnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 19:43:55 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34072 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhEMXny (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 19:43:54 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9E3366415A;
        Fri, 14 May 2021 01:41:52 +0200 (CEST)
Date:   Fri, 14 May 2021 01:42:41 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_pipapo_avx2: Add irq_fpu_usable() check,
 fallback to non-AVX2 version
Message-ID: <20210513234241.GA31723@salvia>
References: <239c77ba924208373776f1b8d78be33d8dde95d3.1620608143.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <239c77ba924208373776f1b8d78be33d8dde95d3.1620608143.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 07:58:22AM +0200, Stefano Brivio wrote:
> Arturo reported this backtrace:
> 
> [709732.358791] WARNING: CPU: 3 PID: 456 at arch/x86/kernel/fpu/core.c:128 kernel_fpu_begin_mask+0xae/0xe0
[...]
> 
> that is, nft_pipapo_avx2_lookup() uses the FPU running from a softirq
> that interrupted a kthread, also using the FPU.
> 
> That's exactly the reason why irq_fpu_usable() is there: use it, and
> if we can't use the FPU, fall back to the non-AVX2 version of the
> lookup operation, i.e. nft_pipapo_lookup().

Applied to nf, thanks.
