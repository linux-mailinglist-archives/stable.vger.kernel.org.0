Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F184CD17C
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 10:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239515AbiCDJnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 04:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239303AbiCDJmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 04:42:23 -0500
Received: from theia.8bytes.org (8bytes.org [81.169.241.247])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A97D18C799
        for <stable@vger.kernel.org>; Fri,  4 Mar 2022 01:41:35 -0800 (PST)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 4DEE39BF; Fri,  4 Mar 2022 10:41:32 +0100 (CET)
Date:   Fri, 4 Mar 2022 10:41:31 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Miles Chen <miles.chen@mediatek.com>
Cc:     robin.murphy@arm.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, will@kernel.org,
        wsd_upstream@mediatek.com, yf.wang@mediatek.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] iommu/iova: Improve 32-bit free space estimate
Message-ID: <YiHey3lGHAMUp+oC@8bytes.org>
References: <033815732d83ca73b13c11485ac39336f15c3b40.1646318408.git.robin.murphy@arm.com>
 <20220303233646.13773-1-miles.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303233646.13773-1-miles.chen@mediatek.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 04, 2022 at 07:36:46AM +0800, Miles Chen wrote:
> Hi Robin,
> 
> > For various reasons based on the allocator behaviour and typical
> > use-cases at the time, when the max32_alloc_size optimisation was
> > introduced it seemed reasonable to couple the reset of the tracked
> > size to the update of cached32_node upon freeing a relevant IOVA.
> > However, since subsequent optimisations focused on helping genuine
> > 32-bit devices make best use of even more limited address spaces, it
> > is now a lot more likely for cached32_node to be anywhere in a "full"
> > 32-bit address space, and as such more likely for space to become
> > available from IOVAs below that node being freed.
> > 
> > At this point, the short-cut in __cached_rbnode_delete_update() really
> > doesn't hold up any more, and we need to fix the logic to reliably
> > provide the expected behaviour. We still want cached32_node to only move
> > upwards, but we should reset the allocation size if *any* 32-bit space
> > has become available.
> > 
> > Reported-by: Yunfei Wang <yf.wang@mediatek.com>
> > Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> 
> Would you mind adding:
> 
> Cc: <stable@vger.kernel.org>

Applied without stable tag for now. If needed, please consider
re-sending it for stable when this patch is merged upstream.

Regards,

	Joerg
