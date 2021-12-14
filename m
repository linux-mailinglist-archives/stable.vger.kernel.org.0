Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB92A474817
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 17:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhLNQb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 11:31:28 -0500
Received: from verein.lst.de ([213.95.11.211]:53114 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232043AbhLNQb2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Dec 2021 11:31:28 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8628268AFE; Tue, 14 Dec 2021 17:31:24 +0100 (CET)
Date:   Tue, 14 Dec 2021 17:31:24 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Baoquan He <bhe@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hch@lst.de, cl@linux.com,
        John.p.donnelly@oracle.com, kexec@lists.infradead.org,
        stable@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no
 managed pages in DMA zone
Message-ID: <20211214163124.GA21762@lst.de>
References: <20211213122712.23805-1-bhe@redhat.com> <20211213122712.23805-6-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213122712.23805-6-bhe@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 08:27:12PM +0800, Baoquan He wrote:
> Dma-kmalloc will be created as long as CONFIG_ZONE_DMA is enabled.
> However, it will fail if DMA zone has no managed pages. The failure
> can be seen in kdump kernel of x86_64 as below:

Please just switch the sr allocation to use GFP_KERNEL without GFP_DMA.
The block layer will do the proper bounce buffering underneath for the
very unlikely case that we're actually using the single HBA driver that
has ISA DMA addressing limitations.

Same for the ch drive, btw.
