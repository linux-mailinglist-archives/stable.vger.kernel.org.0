Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2776533861
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 10:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiEYI1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 04:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiEYI1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 04:27:40 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013ED20BDD;
        Wed, 25 May 2022 01:27:37 -0700 (PDT)
X-UUID: 96467fc6f1d24a0da4c5d013fd2bf27e-20220525
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.5,REQID:ee338470-198f-485b-81e6-c01d91845684,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:-5
X-CID-META: VersionHash:2a19b09,CLOUDID:91236847-4fb1-496b-8f1d-39e733fed1ea,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:0,BEC:nil
X-UUID: 96467fc6f1d24a0da4c5d013fd2bf27e-20220525
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <mark-pk.tsai@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 741277775; Wed, 25 May 2022 16:27:34 +0800
Received: from mtkmbs07n1.mediatek.inc (172.21.101.16) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Wed, 25 May 2022 16:27:33 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 25 May 2022 16:27:33 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 May 2022 16:27:33 +0800
From:   Mark-PK Tsai <mark-pk.tsai@mediatek.com>
To:     <stable@vger.kernel.org>
CC:     <mchehab@kernel.org>, <matthias.bgg@gmail.com>,
        <hverkuil-cisco@xs4all.nl>, <mark-pk.tsai@mediatek.com>,
        <sakari.ailus@linux.intel.com>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <yj.chiang@mediatek.com>
Subject: [PATCH 5.4 0/2] media: vim2m: Fix potential NULL pointer dereference
Date:   Wed, 25 May 2022 16:27:29 +0800
Message-ID: <20220525082731.28235-1-mark-pk.tsai@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport upstream solution [1][2] to fix below kernel panic:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000208
...
pc : _raw_spin_lock_irqsave+0x50/0x90
lr : v4l2_m2m_cancel_job+0x38/0x1c4 [v4l2_mem2mem]
sp : ffffffc012d2bcb0
x29: ffffffc012d2bcb0 x28: ffffff8098d6bb00
x27: 0000000000000000 x26: ffffffc01009b5c8
x25: 00000000000e001f x24: ffffff808ff3eb50
x23: ffffffc01009f5a0 x22: 0000000000000000
x21: ffffff808ffef000 x20: 0000000000000208
x19: 0000000000000000 x18: ffffffc012b51048
x17: ffffffc011e0ef7c x16: 00000000000000c0
x15: ffffffc010fc78f4 x14: ffffffc0119dd790
x13: 0000000000001b26 x12: 0000000053555555
x11: 0000000000000002 x10: 0000000000000001
x9 : 0000000000000000 x8 : 0000000000000208
x7 : 2020202020202020 x6 : ffffffc011e313a6
x5 : 0000000000000000 x4 : 0000000000000008
x3 : 000000000000002e x2 : 0000000000000001
x1 : 0000000000000000 x0 : 0000000000000208
Call trace:
 _raw_spin_lock_irqsave+0x50/0x90
 v4l2_m2m_cancel_job+0x38/0x1c4 [v4l2_mem2mem]
 v4l2_m2m_ctx_release+0x38/0x60 [v4l2_mem2mem]
 vim2m_release+0x5c/0xe0 [vim2m]
 v4l2_release+0x90/0x18c
 __fput+0xdc/0x2cc
 ____fput+0x10/0x1c
 task_work_run+0xc4/0x130
 do_notify_resume+0xdc/0x158
 work_pending+0x8/0x10

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=cf7f34777a5b4100a3a44ff95f3d949c62892bdd
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1a28dce222a6ece725689ad58c0cf4a1b48894f4

Mark-PK Tsai (2):
  media: vim2m: Register video device after setting up internals
  media: vim2m: initialize the media device earlier

 drivers/media/platform/vim2m.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

-- 
2.18.0

