Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096855B93F6
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 07:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiIOFcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 01:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiIOFcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 01:32:45 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D859B77577;
        Wed, 14 Sep 2022 22:32:43 -0700 (PDT)
X-UUID: 9e0e5349c19f4b78a83b8417397e9ed2-20220915
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=YkxDDvQTqV0T2kgqiwptXOrxnydc9XfbPvm55Lt05Q0=;
        b=ASFl1ntJ19L2r1GeyWqCH/VEpjcJpSPBKqPPaMRwYPiRL3eKRJlxPLF2e41v1FNjxQ6lxOVQIckNw7XGgFPqgDAO90OSjRfOPZvkbymD3e8vOeeJvA+EU/bC/wQGK8VmTHWZzeQdYKm04Po82lzf4nLjpELDp1iFNsew7dXH1ZI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:2b039e25-fdbd-4096-936c-9f185c2a0048,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:70
X-CID-INFO: VERSION:1.1.11,REQID:2b039e25-fdbd-4096-936c-9f185c2a0048,IP:0,URL
        :0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
        ON:quarantine,TS:70
X-CID-META: VersionHash:39a5ff1,CLOUDID:9fb4b85d-5ed4-4e28-8b00-66ed9f042fbd,B
        ulkID:2209151332395LCBLUT0,BulkQuantity:0,Recheck:0,SF:28|17|19|48,TC:nil,
        Content:0,EDM:-3,IP:nil,URL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 9e0e5349c19f4b78a83b8417397e9ed2-20220915
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <sean.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 751581607; Thu, 15 Sep 2022 13:32:37 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 15 Sep 2022 13:32:37 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 15 Sep 2022 13:32:36 +0800
From:   <sean.wang@mediatek.com>
To:     <stable@vger.kernel.org>
CC:     <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Deren Wu <deren.wu@mediatek.com>,
        "Johannes Berg" <johannes.berg@intel.com>
Subject: [PATCH 5.19] wifi: mt76: mt7921e: fix crash in chip reset fail
Date:   Thu, 15 Sep 2022 13:32:35 +0800
Message-ID: <404d2f5ec663128342541fa392a47226a46e5634.1663219530.git.objelf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,URIBL_CSS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deren Wu <deren.wu@mediatek.com>

commit fa3fbe64037839f448dc569212bafc5a495d8219 upstream.

In case of drv own fail in reset, we may need to run mac_reset several
times. The sequence would trigger system crash as the log below.

Because we do not re-enable/schedule "tx_napi" before disable it again,
the process would keep waiting for state change in napi_diable(). To
avoid the problem and keep status synchronize for each run, goto final
resource handling if drv own failed.

[ 5857.353423] mt7921e 0000:3b:00.0: driver own failed
[ 5858.433427] mt7921e 0000:3b:00.0: Timeout for driver own
[ 5859.633430] mt7921e 0000:3b:00.0: driver own failed
[ 5859.633444] ------------[ cut here ]------------
[ 5859.633446] WARNING: CPU: 6 at kernel/kthread.c:659 kthread_park+0x11d
[ 5859.633717] Workqueue: mt76 mt7921_mac_reset_work [mt7921_common]
[ 5859.633728] RIP: 0010:kthread_park+0x11d/0x150
[ 5859.633736] RSP: 0018:ffff8881b676fc68 EFLAGS: 00010202
......
[ 5859.633766] Call Trace:
[ 5859.633768]  <TASK>
[ 5859.633771]  mt7921e_mac_reset+0x176/0x6f0 [mt7921e]
[ 5859.633778]  mt7921_mac_reset_work+0x184/0x3a0 [mt7921_common]
[ 5859.633785]  ? mt7921_mac_set_timing+0x520/0x520 [mt7921_common]
[ 5859.633794]  ? __kasan_check_read+0x11/0x20
[ 5859.633802]  process_one_work+0x7ee/0x1320
[ 5859.633810]  worker_thread+0x53c/0x1240
[ 5859.633818]  kthread+0x2b8/0x370
[ 5859.633824]  ? process_one_work+0x1320/0x1320
[ 5859.633828]  ? kthread_complete_and_exit+0x30/0x30
[ 5859.633834]  ret_from_fork+0x1f/0x30
[ 5859.633842]  </TASK>

Cc: stable@vger.kernel.org
Fixes: 0efaf31dec57 ("mt76: mt7921: fix MT7921E reset failure")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Link: https://lore.kernel.org/r/727eb5ffd3c7c805245e512da150ecf0a7154020.1659452909.git.deren.wu@mediatek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
index b0f58bcf70cb..106c88b723b9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
@@ -345,7 +345,7 @@ int mt7921e_mac_reset(struct mt7921_dev *dev)
 
 	err = mt7921e_driver_own(dev);
 	if (err)
-		return err;
+		goto out;
 
 	err = mt7921_run_firmware(dev);
 	if (err)
-- 
2.25.1

