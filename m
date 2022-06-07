Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5606541899
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379535AbiFGVMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380142AbiFGVLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:11:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB9E2178AF;
        Tue,  7 Jun 2022 11:53:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8C6DB82018;
        Tue,  7 Jun 2022 18:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2351FC3411C;
        Tue,  7 Jun 2022 18:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627994;
        bh=uBf4ntkHBfzEN3956XOhHHxqoIIf5aiUP6GYJPkD3to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0QpoEznOYP5yxAdLSh9vOZqfF1Mn1nOLvUqZhB91lzr4Yy7giZaekQE0uc/YjdY8k
         PKX2/YP+4DRPJsohR3ZiPOG+k6gTetYtpEtjXjzKFIbfbfZmGYaFPa5Q9nSRFbIgI/
         HqDzABGaPCEh3tO5QfC/kbV5g4admizo4jaeRsVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 169/879] Bluetooth: HCI: Add HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN quirk
Date:   Tue,  7 Jun 2022 18:54:47 +0200
Message-Id: <20220607165007.615036012@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 05abad857277dda198063017b00ba5b9fed2c0cb ]

This adds HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN quirk which can be
used to mark HCI_Enhanced_Setup_Synchronous_Connection as broken even
if its support command bit are set since some controller report it as
supported but the command don't work properly with some configurations
(e.g. BT_VOICE_TRANSPARENT/mSBC).

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h      | 9 +++++++++
 include/net/bluetooth/hci_core.h | 8 ++++++--
 net/bluetooth/hci_conn.c         | 2 +-
 net/bluetooth/sco.c              | 2 +-
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 69ef31cea582..62a9bb022aed 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -265,6 +265,15 @@ enum {
 	 * runtime suspend, because event filtering takes place there.
 	 */
 	HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL,
+
+	/*
+	 * When this quirk is set, disables the use of
+	 * HCI_OP_ENHANCED_SETUP_SYNC_CONN command to setup SCO connections.
+	 *
+	 * This quirk can be set before hci_register_dev is called or
+	 * during the hdev->setup vendor callback.
+	 */
+	HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN,
 };
 
 /* HCI device flags */
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 62d7b81b1cb7..5a52a2018b56 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1495,8 +1495,12 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 #define privacy_mode_capable(dev) (use_ll_privacy(dev) && \
 				   (hdev->commands[39] & 0x04))
 
-/* Use enhanced synchronous connection if command is supported */
-#define enhanced_sco_capable(dev) ((dev)->commands[29] & 0x08)
+/* Use enhanced synchronous connection if command is supported and its quirk
+ * has not been set.
+ */
+#define enhanced_sync_conn_capable(dev) \
+	(((dev)->commands[29] & 0x08) && \
+	 !test_bit(HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN, &(dev)->quirks))
 
 /* Use ext scanning if set ext scan param and ext scan enable is supported */
 #define use_ext_scan(dev) (((dev)->commands[37] & 0x20) && \
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index fe803bee419a..882a7df13005 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -481,7 +481,7 @@ static bool hci_setup_sync_conn(struct hci_conn *conn, __u16 handle)
 
 bool hci_setup_sync(struct hci_conn *conn, __u16 handle)
 {
-	if (enhanced_sco_capable(conn->hdev))
+	if (enhanced_sync_conn_capable(conn->hdev))
 		return hci_enhanced_setup_sync_conn(conn, handle);
 
 	return hci_setup_sync_conn(conn, handle);
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 8eabf41b2993..2a58c7d88433 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -885,7 +885,7 @@ static int sco_sock_setsockopt(struct socket *sock, int level, int optname,
 			err = -EBADFD;
 			break;
 		}
-		if (enhanced_sco_capable(hdev) &&
+		if (enhanced_sync_conn_capable(hdev) &&
 		    voice.setting == BT_VOICE_TRANSPARENT)
 			sco_pi(sk)->codec.id = BT_CODEC_TRANSPARENT;
 		hci_dev_put(hdev);
-- 
2.35.1



