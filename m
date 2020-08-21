Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE7724D22C
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 12:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgHUKWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 06:22:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:55230 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728611AbgHUKWH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 06:22:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 07861B5E2;
        Fri, 21 Aug 2020 10:22:34 +0000 (UTC)
Date:   Fri, 21 Aug 2020 12:22:04 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-mm@kvack.org, Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Vrabel <david.vrabel@citrix.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] mm: Export flush_vm_area() to sync the PTEs upon
 construction
Message-ID: <20200821102204.GH3354@suse.de>
References: <20200821085011.28878-1-chris@chris-wilson.co.uk>
 <20200821095129.GF3354@suse.de>
 <159800366215.29194.8455636122843151159@build.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159800366215.29194.8455636122843151159@build.alporthouse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 10:54:22AM +0100, Chris Wilson wrote:
> Ok. I thought it had to be after assigning the *ptep. If we apply the
> sync first, do not have to worry about PGTBL_PTE_MODIFIED from the
> *ptep?

Hmm, if I understand the code correctly, you are re-implementing some
generic ioremap/vmalloc mapping logic in the i915 driver. I don't know
the reason, but if it is valid you need to manually call
arch_sync_kernel_mappings() from your driver like this to be correct:

	if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PTE_MODIFIED)
		arch_sync_kernel_mappings();

In practice this is a no-op, because nobody sets PGTBL_PTE_MODIFIED in
ARCH_PAGE_TABLE_SYNC_MASK, so the above code would be optimized away.

But what you really care about is the tracking in apply_to_page_range(),
as that allocates the !pte levels of your page-table, which needs
synchronization on x86-32.

Btw, what are the reasons you can't use generic vmalloc/ioremap
interfaces to map the range?

Regards,

	Joerg
