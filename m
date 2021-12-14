Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3C9474085
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 11:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhLNKgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 05:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbhLNKgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 05:36:35 -0500
X-Greylist: delayed 508 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Dec 2021 02:36:35 PST
Received: from gentwo.de (gentwo.de [IPv6:2a02:c206:2048:5042::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE61DC061574
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 02:36:35 -0800 (PST)
Received: by gentwo.de (Postfix, from userid 1001)
        id E26D1B0024C; Tue, 14 Dec 2021 11:28:01 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by gentwo.de (Postfix) with ESMTP id DC483B00038;
        Tue, 14 Dec 2021 11:28:01 +0100 (CET)
Date:   Tue, 14 Dec 2021 11:28:01 +0100 (CET)
From:   Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@gentwo.de
To:     Vlastimil Babka <vbabka@suse.cz>
cc:     Baoquan He <bhe@redhat.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hch@lst.de, John.p.donnelly@oracle.com,
        kexec@lists.infradead.org, stable@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no managed
 pages in DMA zone
In-Reply-To: <f5ff82eb-73b6-55b5-53d7-04ab73ce5035@suse.cz>
Message-ID: <alpine.DEB.2.22.394.2112141125290.370323@gentwo.de>
References: <20211213122712.23805-1-bhe@redhat.com> <20211213122712.23805-6-bhe@redhat.com> <20211213134319.GA997240@odroid> <20211214053253.GB2216@MiWiFi-R3L-srv> <f5ff82eb-73b6-55b5-53d7-04ab73ce5035@suse.cz>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 14 Dec 2021, Vlastimil Babka wrote:

> If doesn't feel right to me to fix (or rather workaround) this on the level
> of kmalloc caches just because the current reports come from there. If we
> decide it's acceptable for kdump kernel to return !ZONE_DMA memory for
> GFP_DMA requests, then it should apply at the page allocator level for all
> allocations, not just kmalloc().
>
> Also you mention above you'd prefer ZONE_DMA32 memory, while chances are
> this approach of using KMALLOC_NORMAL caches will end up giving you
> ZONE_NORMAL. On the page allocator level it would be much easier to
> implement a fallback from non-populated ZONE_DMA to ZONE_DMA32 specifically.

Well this only works if the restrictions on the physical memory addresses
of each platform make that possible.
