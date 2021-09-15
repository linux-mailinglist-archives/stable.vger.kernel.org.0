Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8104940C495
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 13:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhIOLvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 07:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbhIOLvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 07:51:41 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1510C061574;
        Wed, 15 Sep 2021 04:50:22 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id F2A982FF; Wed, 15 Sep 2021 13:50:19 +0200 (CEST)
Date:   Wed, 15 Sep 2021 13:49:50 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, jroedel@suse.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/64/mm: Map all kernel memory into trampoline_pgd
Message-ID: <YUHd3kGUngaB758q@8bytes.org>
References: <20210913095236.24937-1-joro@8bytes.org>
 <YUBUx6KVwAp9b3b4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUBUx6KVwAp9b3b4@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mike,

On Tue, Sep 14, 2021 at 10:52:39AM +0300, Mike Rapoport wrote:
> On Mon, Sep 13, 2021 at 11:52:36AM +0200, Joerg Roedel wrote:
> > +	for (i = pgd_index(__PAGE_OFFSET); i < PTRS_PER_PGD; i++)
> > +		trampoline_pgd[i] = init_top_pgt[i].pgd;
> 
> Don't we need to update the trampoline_pgd in sync_global_pgds() as well?

No, the trampoline_pgd is setup after preallocate_vmalloc_pages(), so
everything that would need synchronization is already in the reference
page-table.

Regards,

	Joerg
