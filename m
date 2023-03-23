Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA086C61B0
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 09:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbjCWIaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 04:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbjCWIaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 04:30:09 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBBB1420A;
        Thu, 23 Mar 2023 01:30:03 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32N8TRl74007667, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32N8TRl74007667
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Thu, 23 Mar 2023 16:29:27 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 23 Mar 2023 16:29:42 +0800
Received: from localhost (172.21.69.188) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.7; Thu, 23 Mar
 2023 16:29:42 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     <kvalo@kernel.org>
CC:     <stable@vger.kernel.org>, <42.hyeyoo@gmail.com>,
        <Larry.Finger@lwfinger.net>, <jonas.gorski@gmail.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH] wifi: rtw89: fix potential race condition between napi_init and napi_enable
Date:   Thu, 23 Mar 2023 16:28:39 +0800
Message-ID: <20230323082839.20474-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.69.188]
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A race condition can happen if netdev is registered, but NAPI isn't
initialized yet, and meanwhile user space starts the netdev that will
enable NAPI. Then, it hits BUG_ON():

 kernel BUG at net/core/dev.c:6423!
 invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
 CPU: 0 PID: 417 Comm: iwd Not tainted 6.2.7-slab-dirty #3 eb0f5a8a9d91
 Hardware name: LENOVO 21DL/LNVNB161216, BIOS JPCN20WW(V1.06) 09/20/2022
 RIP: 0010:napi_enable+0x3f/0x50
 Code: 48 89 c2 48 83 e2 f6 f6 81 89 08 00 00 02 74 0d 48 83 ...
 RSP: 0018:ffffada1414f3548 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: ffffa01425802080 RCX: 0000000000000000
 RDX: 00000000000002ff RSI: ffffada14e50c614 RDI: ffffa01425808dc0
 RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000001 R11: 0000000000000100 R12: ffffa01425808f58
 R13: 0000000000000000 R14: ffffa01423498940 R15: 0000000000000001
 FS:  00007f5577c0a740(0000) GS:ffffa0169fc00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f5577a19972 CR3: 0000000125a7a000 CR4: 0000000000750ef0
 PKRU: 55555554
 Call Trace:
  <TASK>
  rtw89_pci_ops_start+0x1c/0x70 [rtw89_pci 6cbc75429515c181cbc386478d5cfb32ffc5a0f8]
  rtw89_core_start+0xbe/0x160 [rtw89_core fe07ecb874820b6d778370d4acb6ef8a37847f22]
  rtw89_ops_start+0x26/0x40 [rtw89_core fe07ecb874820b6d778370d4acb6ef8a37847f22]
  drv_start+0x42/0x100 [mac80211 c07fa22af8c3cf3f7d7ab3884ca990784d72e2d2]
  ieee80211_do_open+0x311/0x7d0 [mac80211 c07fa22af8c3cf3f7d7ab3884ca990784d72e2d2]
  ieee80211_open+0x6a/0x90 [mac80211 c07fa22af8c3cf3f7d7ab3884ca990784d72e2d2]
  __dev_open+0xe0/0x180
  __dev_change_flags+0x1da/0x250
  dev_change_flags+0x26/0x70
  do_setlink+0x37c/0x12c0
  ? ep_poll_callback+0x246/0x290
  ? __nla_validate_parse+0x61/0xd00
  ? __wake_up_common_lock+0x8f/0xd0

To fix this, follow Jonas' suggestion to switch the order of these
functions and move register netdev to be the last step of PCI probe.
Also, correct the error handling of rtw89_core_register_hw().

Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
Cc: stable@vger.kernel.org
Reported-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Link: https://lore.kernel.org/linux-wireless/CAOiHx=n7EwK2B9CnBR07FVA=sEzFagb8TkS4XC_qBNq8OwcYUg@mail.gmail.com/T/#t
Suggested-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Larry Finger<Larry.Finger@lwfinger.net>
Reviewed-by: Larry Finger<Larry.Finger@lwfinger.net>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.c | 10 +++++++---
 drivers/net/wireless/realtek/rtw89/pci.c  | 19 ++++++++++---------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 489fa7a86160d..1efe008706669 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -3434,18 +3434,22 @@ static int rtw89_core_register_hw(struct rtw89_dev *rtwdev)
 	ret = ieee80211_register_hw(hw);
 	if (ret) {
 		rtw89_err(rtwdev, "failed to register hw\n");
-		goto err;
+		goto err_free_supported_band;
 	}
 
 	ret = rtw89_regd_init(rtwdev, rtw89_regd_notifier);
 	if (ret) {
 		rtw89_err(rtwdev, "failed to init regd\n");
-		goto err;
+		goto err_unregister_hw;
 	}
 
 	return 0;
 
-err:
+err_unregister_hw:
+	ieee80211_unregister_hw(hw);
+err_free_supported_band:
+	rtw89_core_clr_supported_band(rtwdev);
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index ec8bb5f10482e..4025aabe06042 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -3874,25 +3874,26 @@ int rtw89_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	rtw89_pci_link_cfg(rtwdev);
 	rtw89_pci_l1ss_cfg(rtwdev);
 
-	ret = rtw89_core_register(rtwdev);
-	if (ret) {
-		rtw89_err(rtwdev, "failed to register core\n");
-		goto err_clear_resource;
-	}
-
 	rtw89_core_napi_init(rtwdev);
 
 	ret = rtw89_pci_request_irq(rtwdev, pdev);
 	if (ret) {
 		rtw89_err(rtwdev, "failed to request pci irq\n");
-		goto err_unregister;
+		goto err_deinit_napi;
+	}
+
+	ret = rtw89_core_register(rtwdev);
+	if (ret) {
+		rtw89_err(rtwdev, "failed to register core\n");
+		goto err_free_irq;
 	}
 
 	return 0;
 
-err_unregister:
+err_free_irq:
+	rtw89_pci_free_irq(rtwdev, pdev);
+err_deinit_napi:
 	rtw89_core_napi_deinit(rtwdev);
-	rtw89_core_unregister(rtwdev);
 err_clear_resource:
 	rtw89_pci_clear_resource(rtwdev, pdev);
 err_declaim_pci:
-- 
2.25.1

