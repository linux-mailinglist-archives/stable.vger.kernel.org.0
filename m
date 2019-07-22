Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 310236FE08
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 12:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbfGVKqb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 22 Jul 2019 06:46:31 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:59434 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727547AbfGVKqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 06:46:31 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 17502112-1500050 
        for multiple; Mon, 22 Jul 2019 11:46:25 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Robin Murphy <robin.murphy@arm.com>,
        iommu@lists.linux-foundation.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <b0325309-02ea-2284-d3e1-fa78ea62ad1a@arm.com>
Cc:     intel-gfx@lists.freedesktop.org, Joerg Roedel <jroedel@suse.de>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
References: <20190720180848.15192-1-chris@chris-wilson.co.uk>
 <b0325309-02ea-2284-d3e1-fa78ea62ad1a@arm.com>
Message-ID: <156379238258.24728.11112424033468968352@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [PATCH] iommu/iova: Remove stale cached32_node
Date:   Mon, 22 Jul 2019 11:46:22 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Robin Murphy (2019-07-22 11:13:49)
> Hi Chris,
> 
> On 20/07/2019 19:08, Chris Wilson wrote:
> > Since the cached32_node is allowed to be advanced above dma_32bit_pfn
> > (to provide a shortcut into the limited range), we need to be careful to
> > remove the to be freed node if it is the cached32_node.
> 
> Thanks for digging in - just to confirm my understanding, the 
> problematic situation is where both 32-bit and 64-bit nodes have been 
> allocated, the topmost 32-bit node is freed, then the lowest 64-bit node 
> is freed, which leaves the pointer dangling because the second free 
> fails the "free->pfn_hi < iovad->dma_32bit_pfn" check. Does that match 
> your reasoning?

Yes. Once cached32_node is set to the right of dma_32bit_pfn it fails
to be picked up in the next cycle through __cached_rbnode_delete_update
should cached32_node be the next victim.
 
> Assuming I haven't completely misread the problem, I can't think of a 
> more appropriate way to fix it, so;
> 
> Reviewed-by: Robin Murphy <robin.murphy@arm.com>
> 
> I could swear I did consider that corner case at some point, but since 
> Leizhen and I rewrote this stuff about 5 times between us I'm not 
> entirely surprised such a subtlety could have got lost again along the way.

I admit to being impressed that rb_prev() does not appear high in the
profiles -- though I guess that is more an artifact of the scary layers
of caching above it.
-Chris
