Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9714CF076
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 04:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235151AbiCGDkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 22:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbiCGDkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 22:40:33 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025255D196;
        Sun,  6 Mar 2022 19:39:07 -0800 (PST)
X-UUID: f7e21676e1fd457d8434de712293e217-20220307
X-UUID: f7e21676e1fd457d8434de712293e217-20220307
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <yf.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 801078150; Mon, 07 Mar 2022 11:39:03 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Mon, 7 Mar 2022 11:39:01 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Mar 2022 11:38:47 +0800
From:   <yf.wang@mediatek.com>
To:     <robin.murphy@arm.com>
CC:     <Libo.Kang@mediatek.com>, <Ning.Li@mediatek.com>,
        <iommu@lists.linux-foundation.org>, <joro@8bytes.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <stable@vger.kernel.org>, <will@kernel.org>,
        <wsd_upstream@mediatek.com>, <yf.wang@mediatek.com>
Subject: RE: [PATCH] iommu/iova: Free all CPU rcache for retry when iova alloc failure
Date:   Mon, 7 Mar 2022 11:32:46 +0800
Message-ID: <20220307033246.23051-1-yf.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <906a446e-3e25-5813-d380-de699a84b6f4@arm.com>
References: <906a446e-3e25-5813-d380-de699a84b6f4@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,PDS_OTHER_BAD_TLD,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-03-04 at 14:03 +0000, Robin Murphy wrote:
> 
> OK, so either there's a mystery bug where IOVAs somehow get freed on 
> offline CPUs, or the hotplug notifier isn't working correctly, or
> you've 
> contrived a situation where alloc_iova_fast() is actually racing
> against 
> iova_cpuhp_dead(). In the latter case, the solution is "don't do
> that".
> 
> This change should not be necessary.
> 
> Thanks,
> Robin.

Hi Robin,

1.As long as iova domain is not destroyed, the cached iovas will always
exist, the only chance to free the cache is the retry flushing
mechanism when alloc fail, but not free cached iova of not online CPU.

2.Iova rcache mechanism is by cpu, but there is no free rcache
mechanism when the CPU state switch.

3.iova.c does not know about CPU state switching, eg.online <--> offline.

Based on the above basic information, this is not a user bug, it is
more like a defect of the iova rcache mechanism.

Thanks,
Yunfei.
