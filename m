Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A0364A1AD
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbiLLNoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbiLLNnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:43:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620DCF36
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:43:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 185D4B8068B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28F2C43392;
        Mon, 12 Dec 2022 13:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852581;
        bh=xfJWD5IjMo4LJ2Bh7ac6RqUh6wxQdfK+zB4Yd9HzDag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GD3ezgq6EGu7ys3ktdqOOh1tcS9cPJdvh9ll0iR61V7Fi4yNNgek3vz6gvfoM0dj9
         5vtm14RbjmKyarc+nMXSUNOykSr+uFabqa8lVl3e38gulEWnXepGYaOa5bSs4AtWuI
         Dzp1Q8Lgm4YOIIxmQ1gRyrYRsltAHt20ltrHjcBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Chethan T N <chethan.tumkur.narayan@intel.com>,
        Kiran K <kiran.k@intel.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 109/157] Bluetooth: Fix support for Read Local Supported Codecs V2
Date:   Mon, 12 Dec 2022 14:17:37 +0100
Message-Id: <20221212130939.225039021@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chethan T N <chethan.tumkur.narayan@intel.com>

[ Upstream commit 828cea2b71de501827f62d3c92d149f6052ad01e ]

Handling of Read Local Supported Codecs was broken during the
HCI serialization design change patches.

Fixes: d0b137062b2d ("Bluetooth: hci_sync: Rework init stages")
Signed-off-by: Chethan T N <chethan.tumkur.narayan@intel.com>
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_codec.c | 19 ++++++++++---------
 net/bluetooth/hci_sync.c  | 10 ++++++----
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/net/bluetooth/hci_codec.c b/net/bluetooth/hci_codec.c
index 38201532f58e..3cc135bb1d30 100644
--- a/net/bluetooth/hci_codec.c
+++ b/net/bluetooth/hci_codec.c
@@ -72,9 +72,8 @@ static void hci_read_codec_capabilities(struct hci_dev *hdev, __u8 transport,
 				continue;
 			}
 
-			skb = __hci_cmd_sync(hdev, HCI_OP_READ_LOCAL_CODEC_CAPS,
-					     sizeof(*cmd), cmd,
-					     HCI_CMD_TIMEOUT);
+			skb = __hci_cmd_sync_sk(hdev, HCI_OP_READ_LOCAL_CODEC_CAPS,
+						sizeof(*cmd), cmd, 0, HCI_CMD_TIMEOUT, NULL);
 			if (IS_ERR(skb)) {
 				bt_dev_err(hdev, "Failed to read codec capabilities (%ld)",
 					   PTR_ERR(skb));
@@ -127,8 +126,8 @@ void hci_read_supported_codecs(struct hci_dev *hdev)
 	struct hci_op_read_local_codec_caps caps;
 	__u8 i;
 
-	skb = __hci_cmd_sync(hdev, HCI_OP_READ_LOCAL_CODECS, 0, NULL,
-			     HCI_CMD_TIMEOUT);
+	skb = __hci_cmd_sync_sk(hdev, HCI_OP_READ_LOCAL_CODECS, 0, NULL,
+				0, HCI_CMD_TIMEOUT, NULL);
 
 	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Failed to read local supported codecs (%ld)",
@@ -158,7 +157,8 @@ void hci_read_supported_codecs(struct hci_dev *hdev)
 	for (i = 0; i < std_codecs->num; i++) {
 		caps.id = std_codecs->codec[i];
 		caps.direction = 0x00;
-		hci_read_codec_capabilities(hdev, LOCAL_CODEC_ACL_MASK, &caps);
+		hci_read_codec_capabilities(hdev,
+					    LOCAL_CODEC_ACL_MASK | LOCAL_CODEC_SCO_MASK, &caps);
 	}
 
 	skb_pull(skb, flex_array_size(std_codecs, codec, std_codecs->num)
@@ -178,7 +178,8 @@ void hci_read_supported_codecs(struct hci_dev *hdev)
 		caps.cid = vnd_codecs->codec[i].cid;
 		caps.vid = vnd_codecs->codec[i].vid;
 		caps.direction = 0x00;
-		hci_read_codec_capabilities(hdev, LOCAL_CODEC_ACL_MASK, &caps);
+		hci_read_codec_capabilities(hdev,
+					    LOCAL_CODEC_ACL_MASK | LOCAL_CODEC_SCO_MASK, &caps);
 	}
 
 error:
@@ -194,8 +195,8 @@ void hci_read_supported_codecs_v2(struct hci_dev *hdev)
 	struct hci_op_read_local_codec_caps caps;
 	__u8 i;
 
-	skb = __hci_cmd_sync(hdev, HCI_OP_READ_LOCAL_CODECS_V2, 0, NULL,
-			     HCI_CMD_TIMEOUT);
+	skb = __hci_cmd_sync_sk(hdev, HCI_OP_READ_LOCAL_CODECS_V2, 0, NULL,
+				0, HCI_CMD_TIMEOUT, NULL);
 
 	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Failed to read local supported codecs (%ld)",
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 831e816e1d20..a5e89e1b5452 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -12,6 +12,7 @@
 #include <net/bluetooth/mgmt.h>
 
 #include "hci_request.h"
+#include "hci_codec.h"
 #include "hci_debugfs.h"
 #include "smp.h"
 #include "eir.h"
@@ -3918,11 +3919,12 @@ static int hci_set_event_mask_page_2_sync(struct hci_dev *hdev)
 /* Read local codec list if the HCI command is supported */
 static int hci_read_local_codecs_sync(struct hci_dev *hdev)
 {
-	if (!(hdev->commands[29] & 0x20))
-		return 0;
+	if (hdev->commands[45] & 0x04)
+		hci_read_supported_codecs_v2(hdev);
+	else if (hdev->commands[29] & 0x20)
+		hci_read_supported_codecs(hdev);
 
-	return __hci_cmd_sync_status(hdev, HCI_OP_READ_LOCAL_CODECS, 0, NULL,
-				     HCI_CMD_TIMEOUT);
+	return 0;
 }
 
 /* Read local pairing options if the HCI command is supported */
-- 
2.35.1



