Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1F525C4C4
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 17:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgICPRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Sep 2020 11:17:47 -0400
Received: from 8bytes.org ([81.169.241.247]:40720 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728810AbgICPRq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Sep 2020 11:17:46 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id C4746847; Thu,  3 Sep 2020 17:17:40 +0200 (CEST)
Date:   Thu, 3 Sep 2020 17:17:39 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     X86 ML <x86@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <jroedel@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/mm/32: Bring back vmalloc faulting on x86_32
Message-ID: <20200903151739.GA28508@8bytes.org>
References: <20200902155904.17544-1-joro@8bytes.org>
 <CALCETrWAk-zVKKjvrq+fRAX5HKhdHF36h+jY+91_tQOa67xozA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWAk-zVKKjvrq+fRAX5HKhdHF36h+jY+91_tQOa67xozA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andy,

On Thu, Sep 03, 2020 at 07:52:35AM -0700, Andy Lutomirski wrote:
> Does this mean we can get rid of arch_sync_kernel_mappings()?  Or
> should we consider adding some locking to make it non-racy again?

Well, removing arch_sync_kernel_mappings() would mean to re-introduce
vmalloc_sync_all() calls all over the place, I am not in favour for
that.

I also thought about locking, but that is not easily doable without
destroying performance/scalability of the vmalloc alloc/free path for
other architectures too. It _could_ be done, but the effort is large and
touches a lot of generic page-table allocation code just for x86-32.
This seemed not worth it while thinking about it.

Regards,

	Joerg

