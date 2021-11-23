Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44D045A2AA
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 13:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbhKWMex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 07:34:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234773AbhKWMex (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 07:34:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CF9D61028;
        Tue, 23 Nov 2021 12:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637670705;
        bh=Cj4yS3X1LdZzdf2zrAxhsLzcVw4iFb7d3801jnQaCME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UpRFwQH6N0bkCd9CxintKO3NEwCWIuasZc25Mzspk8AUU+caPgR7Oaw25m85nEyky
         dd1ziBBY5wQaC/nuPeCNgw6wBTVdflhyfamSGDOpgH5IbhfTfQlFXxKwGjGO0Yn/lU
         70JxWXsDEDxJcn/f0t7psZvFlpxy8Xlu3BEQBqeE=
Date:   Tue, 23 Nov 2021 13:31:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Greg Thelen <gthelen@google.com>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Kan Liang <kan.liang@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: Re: [PATCH 4.14] perf/core: Avoid put_page() when GUP fails
Message-ID: <YZzfLmJQKguowfoM@kroah.com>
References: <20211122171825.1582436-1-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122171825.1582436-1-gthelen@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 22, 2021 at 09:18:25AM -0800, Greg Thelen wrote:
> commit 4716023a8f6a0f4a28047f14dd7ebdc319606b84 upstream.
> 
> PEBS PERF_SAMPLE_PHYS_ADDR events use perf_virt_to_phys() to convert PMU
> sampled virtual addresses to physical using get_user_page_fast_only()
> and page_to_phys().
> 
> Some get_user_page_fast_only() error cases return false, indicating no
> page reference, but still initialize the output page pointer with an
> unreferenced page. In these error cases perf_virt_to_phys() calls
> put_page(). This causes page reference count underflow, which can lead
> to unintentional page sharing.
> 
> Fix perf_virt_to_phys() to only put_page() if get_user_page_fast_only()
> returns a referenced page.
> 
> Fixes: fc7ce9c74c3ad ("perf/core, x86: Add PERF_SAMPLE_PHYS_ADDR")
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Link: https://lkml.kernel.org/r/20211111021814.757086-1-gthelen@google.com
> [gthelen: manual backport to 4.14]
> ---
>  kernel/events/core.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

All now queued up,t hanks.

greg k-h
