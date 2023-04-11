Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6C46DD7CA
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 12:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjDKKWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 06:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDKKWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 06:22:17 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3094F2D61;
        Tue, 11 Apr 2023 03:22:09 -0700 (PDT)
X-UUID: b467e4dad85211eda9a90f0bb45854f4-20230411
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=0NtnqZs2P9N8mSYcOTQ44Mza0LeqD4/w26LdwETFfqg=;
        b=mpwTKkQFNUUoptZe1QXFNKL2KpdmLn+xO4hDUYhYnnMULktUATSW3hHUmeq1R4wjbotr64YPVsH3lnUBFF1o2QXa9ZgZqm9jb7lDzK1vsYd7VmdZDmBlh43ts284Xp45yQ2drVJ2VRB7YoFuYSOIO1pW6KId9SoP3PtIyGG0CZs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:18fd0a10-ad8d-4820-8d83-52a4ef39f813,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:120426c,CLOUDID:0ce2f4a0-8fcb-430b-954a-ba3f00fa94a5,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
        l,URL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 1,FCT|NGT
X-CID-BAS: 1,FCT|NGT,0,_
X-UUID: b467e4dad85211eda9a90f0bb45854f4-20230411
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <mark-pk.tsai@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 938440688; Tue, 11 Apr 2023 18:22:04 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Tue, 11 Apr 2023 18:22:03 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Tue, 11 Apr 2023 18:22:03 +0800
From:   Mark-PK Tsai <mark-pk.tsai@mediatek.com>
To:     <mark-pk.tsai@mediatek.com>
CC:     <gregkh@linuxfoundation.org>, <johan+linaro@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <maz@kernel.org>, <stable@vger.kernel.org>, <tglx@linutronix.de>
Subject: [PATCH 5.4 3/3] irqdomain: Fix mapping-creation race
Date:   Tue, 11 Apr 2023 18:22:03 +0800
Message-ID: <20230411102203.29646-1-mark-pk.tsai@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20230322124550.29812-1-mark-pk.tsai@mediatek.com>
References: <20230322124550.29812-1-mark-pk.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=0.2 required=5.0 tests=DKIM_INVALID,DKIM_SIGNED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Johan Hovold <johan+linaro@kernel.org>
> 
> [ Upstream commit 601363cc08da25747feb87c55573dd54de91d66a ]
> 
> Parallel probing of devices that share interrupts (e.g. when a driver
> uses asynchronous probing) can currently result in two mappings for the
> same hardware interrupt to be created due to missing serialisation.
> 
> Make sure to hold the irq_domain_mutex when creating mappings so that
> looking for an existing mapping before creating a new one is done
> atomically.
> 
> Fixes: 765230b5f084 ("driver-core: add asynchronous probing support for drivers")
> Fixes: b62b2cf5759b ("irqdomain: Fix handling of type settings for existing mappings")
> Link: https://lore.kernel.org/r/YuJXMHoT4ijUxnRb@hovoldconsulting.com
> Cc: stable@vger.kernel.org      # 4.8
> Cc: Dmitry Torokhov <dtor@chromium.org>
> Cc: Jon Hunter <jonathanh@nvidia.com>
> Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
> Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20230213104302.17307-7-johan+linaro@kernel.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>

5.4 also need this patch.
Could someone please help to review it?

Thanks,
Mark-PK Tsai
