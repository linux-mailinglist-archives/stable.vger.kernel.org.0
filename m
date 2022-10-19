Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E5F604728
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiJSNcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbiJSNbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:31:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EC21DCCE7;
        Wed, 19 Oct 2022 06:18:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C96F6617FE;
        Wed, 19 Oct 2022 08:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB36C433D6;
        Wed, 19 Oct 2022 08:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169555;
        bh=m67spaPwy6G0W7GWUEBmAnkxzPcnmPiPMNmD2VWVvX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nqy2lxy2ibtpCWSOtTGgTbyF/dQ6n90xaeTQtj46m0+z7aITG2BgPt3xshD3ZZF9Q
         UtpfmfzVl/JG5HDdnmVXETRKA1UOL+MMLW7eYw4aN2OayP5ifjr23rz0gjsXfVurIM
         cBACfyA/jnDKI0BW/wVlWVVCNlKGgNtjpnHdL/e4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        David Beinder <david@beinder.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 321/862] Bluetooth: hci_core: Fix not handling link timeouts propertly
Date:   Wed, 19 Oct 2022 10:26:48 +0200
Message-Id: <20221019083304.209428283@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 116523c8fac05d1d26f748fee7919a4ec5df67ea ]

Change that introduced the use of __check_timeout did not account for
link types properly, it always assumes ACL_LINK is used thus causing
hdev->acl_last_tx to be used even in case of LE_LINK and then again
uses ACL_LINK with hci_link_tx_to.

To fix this __check_timeout now takes the link type as parameter and
then procedure to use the right last_tx based on the link type and pass
it to hci_link_tx_to.

Fixes: 1b1d29e51499 ("Bluetooth: Make use of __check_timeout on hci_sched_le")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: David Beinder <david@beinder.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 9873d2e67988..e6be18eb7fe6 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3478,15 +3478,27 @@ static inline int __get_blocks(struct hci_dev *hdev, struct sk_buff *skb)
 	return DIV_ROUND_UP(skb->len - HCI_ACL_HDR_SIZE, hdev->block_len);
 }
 
-static void __check_timeout(struct hci_dev *hdev, unsigned int cnt)
+static void __check_timeout(struct hci_dev *hdev, unsigned int cnt, u8 type)
 {
-	if (!hci_dev_test_flag(hdev, HCI_UNCONFIGURED)) {
-		/* ACL tx timeout must be longer than maximum
-		 * link supervision timeout (40.9 seconds) */
-		if (!cnt && time_after(jiffies, hdev->acl_last_tx +
-				       HCI_ACL_TX_TIMEOUT))
-			hci_link_tx_to(hdev, ACL_LINK);
+	unsigned long last_tx;
+
+	if (hci_dev_test_flag(hdev, HCI_UNCONFIGURED))
+		return;
+
+	switch (type) {
+	case LE_LINK:
+		last_tx = hdev->le_last_tx;
+		break;
+	default:
+		last_tx = hdev->acl_last_tx;
+		break;
 	}
+
+	/* tx timeout must be longer than maximum link supervision timeout
+	 * (40.9 seconds)
+	 */
+	if (!cnt && time_after(jiffies, last_tx + HCI_ACL_TX_TIMEOUT))
+		hci_link_tx_to(hdev, type);
 }
 
 /* Schedule SCO */
@@ -3544,7 +3556,7 @@ static void hci_sched_acl_pkt(struct hci_dev *hdev)
 	struct sk_buff *skb;
 	int quote;
 
-	__check_timeout(hdev, cnt);
+	__check_timeout(hdev, cnt, ACL_LINK);
 
 	while (hdev->acl_cnt &&
 	       (chan = hci_chan_sent(hdev, ACL_LINK, &quote))) {
@@ -3587,8 +3599,6 @@ static void hci_sched_acl_blk(struct hci_dev *hdev)
 	int quote;
 	u8 type;
 
-	__check_timeout(hdev, cnt);
-
 	BT_DBG("%s", hdev->name);
 
 	if (hdev->dev_type == HCI_AMP)
@@ -3596,6 +3606,8 @@ static void hci_sched_acl_blk(struct hci_dev *hdev)
 	else
 		type = ACL_LINK;
 
+	__check_timeout(hdev, cnt, type);
+
 	while (hdev->block_cnt > 0 &&
 	       (chan = hci_chan_sent(hdev, type, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
@@ -3669,7 +3681,7 @@ static void hci_sched_le(struct hci_dev *hdev)
 
 	cnt = hdev->le_pkts ? hdev->le_cnt : hdev->acl_cnt;
 
-	__check_timeout(hdev, cnt);
+	__check_timeout(hdev, cnt, LE_LINK);
 
 	tmp = cnt;
 	while (cnt && (chan = hci_chan_sent(hdev, LE_LINK, &quote))) {
-- 
2.35.1



