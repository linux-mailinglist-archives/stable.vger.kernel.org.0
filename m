Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819DC593683
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343643AbiHOTJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245591AbiHOTHo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:07:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AEAEE05;
        Mon, 15 Aug 2022 11:35:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28E9061120;
        Mon, 15 Aug 2022 18:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311EAC433C1;
        Mon, 15 Aug 2022 18:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588528;
        bh=Q/tETnobzZqDR+69uGKPP1XKeVrj0B67172MBzgR9fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmKkjuiAuBafGcQmQboOroVB96ULjw7/1Y/fQBXwuy08X7AYBYf0WAOPO4+CvtLwa
         pkpYcyaHiJiyAjOkl+gRFNJLxqVd5qRALgs2UpG6cEnCrREU23e+d5PkPwGoWDsgdp
         B5e2GOhP01WrEnzbhe+1bKo8LsgqLUSN4d9yOV8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 433/779] mwifiex: Ignore BTCOEX events from the 88W8897 firmware
Date:   Mon, 15 Aug 2022 20:01:17 +0200
Message-Id: <20220815180355.792123787@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Dreßler <verdre@v0yd.nl>

[ Upstream commit 84d94e16efa268e4f2887d858cd67ee37b870f25 ]

The firmware of the 88W8897 PCIe+USB card sends those events very
unreliably, sometimes bluetooth together with 2.4ghz-wifi is used and no
COEX event comes in, and sometimes bluetooth is disabled but the
coexistance mode doesn't get disabled.

This means we sometimes end up capping the rx/tx window size while
bluetooth is not enabled anymore, artifically limiting wifi speeds even
though bluetooth is not being used.

Since we can't fix the firmware, let's just ignore those events on the
88W8897 device. From some Wireshark capture sessions it seems that the
Windows driver also doesn't change the rx/tx window sizes when bluetooth
gets enabled or disabled, so this is fairly consistent with the Windows
driver.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211103205827.14559-1-verdre@v0yd.nl
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/main.h      | 2 ++
 drivers/net/wireless/marvell/mwifiex/pcie.c      | 3 +++
 drivers/net/wireless/marvell/mwifiex/sta_event.c | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 5923c5c14c8d..f4e3dce10d65 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1054,6 +1054,8 @@ struct mwifiex_adapter {
 	void *devdump_data;
 	int devdump_len;
 	struct timer_list devdump_timer;
+
+	bool ignore_btcoex_events;
 };
 
 void mwifiex_process_tx_queue(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index c3f5583ea70d..d5fb29400bad 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -3152,6 +3152,9 @@ static int mwifiex_init_pcie(struct mwifiex_adapter *adapter)
 	if (ret)
 		goto err_alloc_buffers;
 
+	if (pdev->device == PCIE_DEVICE_ID_MARVELL_88W8897)
+		adapter->ignore_btcoex_events = true;
+
 	return 0;
 
 err_alloc_buffers:
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 2b2e6e0166e1..7d42c5d2dbf6 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -1062,6 +1062,9 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 	case EVENT_BT_COEX_WLAN_PARA_CHANGE:
 		dev_dbg(adapter->dev, "EVENT: BT coex wlan param update\n");
+		if (adapter->ignore_btcoex_events)
+			break;
+
 		mwifiex_bt_coex_wlan_param_update_event(priv,
 							adapter->event_skb);
 		break;
-- 
2.35.1



