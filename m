Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E324CCA22
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 00:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237253AbiCCXj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 18:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235893AbiCCXjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 18:39:25 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24BF3F31C;
        Thu,  3 Mar 2022 15:38:38 -0800 (PST)
X-UUID: e9352919be7d4247b49524b61b6ece65-20220304
X-UUID: e9352919be7d4247b49524b61b6ece65-20220304
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 775196386; Fri, 04 Mar 2022 07:38:33 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 4 Mar 2022 07:38:32 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 4 Mar 2022 07:38:32 +0800
From:   Miles Chen <miles.chen@mediatek.com>
To:     <robin.murphy@arm.com>
CC:     <iommu@lists.linux-foundation.org>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <miles.chen@mediatek.com>,
        <will@kernel.org>, <wsd_upstream@mediatek.com>,
        <yf.wang@mediatek.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] iommu/iova: Improve 32-bit free space estimate
Date:   Fri, 4 Mar 2022 07:36:46 +0800
Message-ID: <20220303233646.13773-1-miles.chen@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <033815732d83ca73b13c11485ac39336f15c3b40.1646318408.git.robin.murphy@arm.com>
References: <033815732d83ca73b13c11485ac39336f15c3b40.1646318408.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Robin,

> For various reasons based on the allocator behaviour and typical
> use-cases at the time, when the max32_alloc_size optimisation was
> introduced it seemed reasonable to couple the reset of the tracked
> size to the update of cached32_node upon freeing a relevant IOVA.
> However, since subsequent optimisations focused on helping genuine
> 32-bit devices make best use of even more limited address spaces, it
> is now a lot more likely for cached32_node to be anywhere in a "full"
> 32-bit address space, and as such more likely for space to become
> available from IOVAs below that node being freed.
> 
> At this point, the short-cut in __cached_rbnode_delete_update() really
> doesn't hold up any more, and we need to fix the logic to reliably
> provide the expected behaviour. We still want cached32_node to only move
> upwards, but we should reset the allocation size if *any* 32-bit space
> has become available.
> 
> Reported-by: Yunfei Wang <yf.wang@mediatek.com>
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>

Would you mind adding:

Cc: <stable@vger.kernel.org> 

to this path? I checked and I think the patch can be applied to
5.4 and later.

thanks,
Miles
