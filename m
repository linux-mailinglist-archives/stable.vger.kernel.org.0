Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4470A54062C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347268AbiFGReW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347739AbiFGRbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:31:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44AF11B691;
        Tue,  7 Jun 2022 10:28:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 08BB1CE0E13;
        Tue,  7 Jun 2022 17:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E905CC385A5;
        Tue,  7 Jun 2022 17:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622891;
        bh=dCAvIXWKjBh4isllWcsRZ2hqf50goYLV8q7VKvNwqIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FqOvWYiUD3b6a53zV5BwTNWldUY9U23BI140E+Z+vFlstYvUJYspyc3L1mgkIaMRm
         zYUtYx9WGOuMwfaRD8xfmIf/fLQrAidWPadrS2htLxNDYwWfGCBmZsEFTiDz3Wtoe6
         D0Y6xvVoLCsNHO5CFDEpuinhB2gEhY2PzCYawQdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 220/452] Bluetooth: use inclusive language when filtering devices
Date:   Tue,  7 Jun 2022 19:01:17 +0200
Message-Id: <20220607164915.117692733@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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

From: Archie Pusaka <apusaka@chromium.org>

[ Upstream commit 3d4f9c00492b4e21641e5140a5e78cb50b58d60b ]

This patch replaces some non-inclusive terms based on the appropriate
language mapping table compiled by the Bluetooth SIG:
https://specificationrefs.bluetooth.com/language-mapping/Appropriate_Language_Mapping_Table.pdf

Specifically, these terms are replaced:
blacklist -> reject list
whitelist -> accept list

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h      | 16 +++---
 include/net/bluetooth/hci_core.h |  8 +--
 net/bluetooth/hci_core.c         | 24 ++++-----
 net/bluetooth/hci_debugfs.c      |  8 +--
 net/bluetooth/hci_event.c        | 70 ++++++++++++-------------
 net/bluetooth/hci_request.c      | 89 ++++++++++++++++----------------
 net/bluetooth/hci_sock.c         | 12 ++---
 net/bluetooth/l2cap_core.c       |  4 +-
 net/bluetooth/mgmt.c             | 14 ++---
 9 files changed, 123 insertions(+), 122 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 243de74e118e..ede7a153c69a 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -1503,7 +1503,7 @@ struct hci_cp_le_set_scan_enable {
 } __packed;
 
 #define HCI_LE_USE_PEER_ADDR		0x00
-#define HCI_LE_USE_WHITELIST		0x01
+#define HCI_LE_USE_ACCEPT_LIST		0x01
 
 #define HCI_OP_LE_CREATE_CONN		0x200d
 struct hci_cp_le_create_conn {
@@ -1523,22 +1523,22 @@ struct hci_cp_le_create_conn {
 
 #define HCI_OP_LE_CREATE_CONN_CANCEL	0x200e
 
-#define HCI_OP_LE_READ_WHITE_LIST_SIZE	0x200f
-struct hci_rp_le_read_white_list_size {
+#define HCI_OP_LE_READ_ACCEPT_LIST_SIZE	0x200f
+struct hci_rp_le_read_accept_list_size {
 	__u8	status;
 	__u8	size;
 } __packed;
 
-#define HCI_OP_LE_CLEAR_WHITE_LIST	0x2010
+#define HCI_OP_LE_CLEAR_ACCEPT_LIST	0x2010
 
-#define HCI_OP_LE_ADD_TO_WHITE_LIST	0x2011
-struct hci_cp_le_add_to_white_list {
+#define HCI_OP_LE_ADD_TO_ACCEPT_LIST	0x2011
+struct hci_cp_le_add_to_accept_list {
 	__u8     bdaddr_type;
 	bdaddr_t bdaddr;
 } __packed;
 
-#define HCI_OP_LE_DEL_FROM_WHITE_LIST	0x2012
-struct hci_cp_le_del_from_white_list {
+#define HCI_OP_LE_DEL_FROM_ACCEPT_LIST	0x2012
+struct hci_cp_le_del_from_accept_list {
 	__u8     bdaddr_type;
 	bdaddr_t bdaddr;
 } __packed;
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 0520c550086e..11a92bb4d7a9 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -308,7 +308,7 @@ struct hci_dev {
 	__u8		max_page;
 	__u8		features[HCI_MAX_PAGES][8];
 	__u8		le_features[8];
-	__u8		le_white_list_size;
+	__u8		le_accept_list_size;
 	__u8		le_resolv_list_size;
 	__u8		le_num_of_adv_sets;
 	__u8		le_states[8];
@@ -499,14 +499,14 @@ struct hci_dev {
 	struct hci_conn_hash	conn_hash;
 
 	struct list_head	mgmt_pending;
-	struct list_head	blacklist;
-	struct list_head	whitelist;
+	struct list_head	reject_list;
+	struct list_head	accept_list;
 	struct list_head	uuids;
 	struct list_head	link_keys;
 	struct list_head	long_term_keys;
 	struct list_head	identity_resolving_keys;
 	struct list_head	remote_oob_data;
-	struct list_head	le_white_list;
+	struct list_head	le_accept_list;
 	struct list_head	le_resolv_list;
 	struct list_head	le_conn_params;
 	struct list_head	pend_le_conns;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 99657c1e66ba..2cb0cf035476 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -742,14 +742,14 @@ static int hci_init3_req(struct hci_request *req, unsigned long opt)
 		}
 
 		if (hdev->commands[26] & 0x40) {
-			/* Read LE White List Size */
-			hci_req_add(req, HCI_OP_LE_READ_WHITE_LIST_SIZE,
+			/* Read LE Accept List Size */
+			hci_req_add(req, HCI_OP_LE_READ_ACCEPT_LIST_SIZE,
 				    0, NULL);
 		}
 
 		if (hdev->commands[26] & 0x80) {
-			/* Clear LE White List */
-			hci_req_add(req, HCI_OP_LE_CLEAR_WHITE_LIST, 0, NULL);
+			/* Clear LE Accept List */
+			hci_req_add(req, HCI_OP_LE_CLEAR_ACCEPT_LIST, 0, NULL);
 		}
 
 		if (hdev->commands[34] & 0x40) {
@@ -3548,13 +3548,13 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 		/* Suspend consists of two actions:
 		 *  - First, disconnect everything and make the controller not
 		 *    connectable (disabling scanning)
-		 *  - Second, program event filter/whitelist and enable scan
+		 *  - Second, program event filter/accept list and enable scan
 		 */
 		ret = hci_change_suspend_state(hdev, BT_SUSPEND_DISCONNECT);
 		if (!ret)
 			state = BT_SUSPEND_DISCONNECT;
 
-		/* Only configure whitelist if disconnect succeeded and wake
+		/* Only configure accept list if disconnect succeeded and wake
 		 * isn't being prevented.
 		 */
 		if (!ret && !(hdev->prevent_wake && hdev->prevent_wake(hdev))) {
@@ -3657,14 +3657,14 @@ struct hci_dev *hci_alloc_dev(void)
 	mutex_init(&hdev->req_lock);
 
 	INIT_LIST_HEAD(&hdev->mgmt_pending);
-	INIT_LIST_HEAD(&hdev->blacklist);
-	INIT_LIST_HEAD(&hdev->whitelist);
+	INIT_LIST_HEAD(&hdev->reject_list);
+	INIT_LIST_HEAD(&hdev->accept_list);
 	INIT_LIST_HEAD(&hdev->uuids);
 	INIT_LIST_HEAD(&hdev->link_keys);
 	INIT_LIST_HEAD(&hdev->long_term_keys);
 	INIT_LIST_HEAD(&hdev->identity_resolving_keys);
 	INIT_LIST_HEAD(&hdev->remote_oob_data);
-	INIT_LIST_HEAD(&hdev->le_white_list);
+	INIT_LIST_HEAD(&hdev->le_accept_list);
 	INIT_LIST_HEAD(&hdev->le_resolv_list);
 	INIT_LIST_HEAD(&hdev->le_conn_params);
 	INIT_LIST_HEAD(&hdev->pend_le_conns);
@@ -3880,8 +3880,8 @@ void hci_cleanup_dev(struct hci_dev *hdev)
 	destroy_workqueue(hdev->req_workqueue);
 
 	hci_dev_lock(hdev);
-	hci_bdaddr_list_clear(&hdev->blacklist);
-	hci_bdaddr_list_clear(&hdev->whitelist);
+	hci_bdaddr_list_clear(&hdev->reject_list);
+	hci_bdaddr_list_clear(&hdev->accept_list);
 	hci_uuids_clear(hdev);
 	hci_link_keys_clear(hdev);
 	hci_smp_ltks_clear(hdev);
@@ -3889,7 +3889,7 @@ void hci_cleanup_dev(struct hci_dev *hdev)
 	hci_remote_oob_data_clear(hdev);
 	hci_adv_instances_clear(hdev);
 	hci_adv_monitors_clear(hdev);
-	hci_bdaddr_list_clear(&hdev->le_white_list);
+	hci_bdaddr_list_clear(&hdev->le_accept_list);
 	hci_bdaddr_list_clear(&hdev->le_resolv_list);
 	hci_conn_params_clear_all(hdev);
 	hci_discovery_filter_clear(hdev);
diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
index 5e8af2658e44..338833f12365 100644
--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -125,7 +125,7 @@ static int device_list_show(struct seq_file *f, void *ptr)
 	struct bdaddr_list *b;
 
 	hci_dev_lock(hdev);
-	list_for_each_entry(b, &hdev->whitelist, list)
+	list_for_each_entry(b, &hdev->accept_list, list)
 		seq_printf(f, "%pMR (type %u)\n", &b->bdaddr, b->bdaddr_type);
 	list_for_each_entry(p, &hdev->le_conn_params, list) {
 		seq_printf(f, "%pMR (type %u) %u\n", &p->addr, p->addr_type,
@@ -144,7 +144,7 @@ static int blacklist_show(struct seq_file *f, void *p)
 	struct bdaddr_list *b;
 
 	hci_dev_lock(hdev);
-	list_for_each_entry(b, &hdev->blacklist, list)
+	list_for_each_entry(b, &hdev->reject_list, list)
 		seq_printf(f, "%pMR (type %u)\n", &b->bdaddr, b->bdaddr_type);
 	hci_dev_unlock(hdev);
 
@@ -734,7 +734,7 @@ static int white_list_show(struct seq_file *f, void *ptr)
 	struct bdaddr_list *b;
 
 	hci_dev_lock(hdev);
-	list_for_each_entry(b, &hdev->le_white_list, list)
+	list_for_each_entry(b, &hdev->le_accept_list, list)
 		seq_printf(f, "%pMR (type %u)\n", &b->bdaddr, b->bdaddr_type);
 	hci_dev_unlock(hdev);
 
@@ -1145,7 +1145,7 @@ void hci_debugfs_create_le(struct hci_dev *hdev)
 				    &force_static_address_fops);
 
 	debugfs_create_u8("white_list_size", 0444, hdev->debugfs,
-			  &hdev->le_white_list_size);
+			  &hdev->le_accept_list_size);
 	debugfs_create_file("white_list", 0444, hdev->debugfs, hdev,
 			    &white_list_fops);
 	debugfs_create_u8("resolv_list_size", 0444, hdev->debugfs,
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 061ef20e135e..f75869835e3e 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -236,7 +236,7 @@ static void hci_cc_reset(struct hci_dev *hdev, struct sk_buff *skb)
 
 	hdev->ssp_debug_mode = 0;
 
-	hci_bdaddr_list_clear(&hdev->le_white_list);
+	hci_bdaddr_list_clear(&hdev->le_accept_list);
 	hci_bdaddr_list_clear(&hdev->le_resolv_list);
 }
 
@@ -1456,21 +1456,21 @@ static void hci_cc_le_read_num_adv_sets(struct hci_dev *hdev,
 	hdev->le_num_of_adv_sets = rp->num_of_sets;
 }
 
-static void hci_cc_le_read_white_list_size(struct hci_dev *hdev,
-					   struct sk_buff *skb)
+static void hci_cc_le_read_accept_list_size(struct hci_dev *hdev,
+					    struct sk_buff *skb)
 {
-	struct hci_rp_le_read_white_list_size *rp = (void *) skb->data;
+	struct hci_rp_le_read_accept_list_size *rp = (void *)skb->data;
 
 	BT_DBG("%s status 0x%2.2x size %u", hdev->name, rp->status, rp->size);
 
 	if (rp->status)
 		return;
 
-	hdev->le_white_list_size = rp->size;
+	hdev->le_accept_list_size = rp->size;
 }
 
-static void hci_cc_le_clear_white_list(struct hci_dev *hdev,
-				       struct sk_buff *skb)
+static void hci_cc_le_clear_accept_list(struct hci_dev *hdev,
+					struct sk_buff *skb)
 {
 	__u8 status = *((__u8 *) skb->data);
 
@@ -1479,13 +1479,13 @@ static void hci_cc_le_clear_white_list(struct hci_dev *hdev,
 	if (status)
 		return;
 
-	hci_bdaddr_list_clear(&hdev->le_white_list);
+	hci_bdaddr_list_clear(&hdev->le_accept_list);
 }
 
-static void hci_cc_le_add_to_white_list(struct hci_dev *hdev,
-					struct sk_buff *skb)
+static void hci_cc_le_add_to_accept_list(struct hci_dev *hdev,
+					 struct sk_buff *skb)
 {
-	struct hci_cp_le_add_to_white_list *sent;
+	struct hci_cp_le_add_to_accept_list *sent;
 	__u8 status = *((__u8 *) skb->data);
 
 	BT_DBG("%s status 0x%2.2x", hdev->name, status);
@@ -1493,18 +1493,18 @@ static void hci_cc_le_add_to_white_list(struct hci_dev *hdev,
 	if (status)
 		return;
 
-	sent = hci_sent_cmd_data(hdev, HCI_OP_LE_ADD_TO_WHITE_LIST);
+	sent = hci_sent_cmd_data(hdev, HCI_OP_LE_ADD_TO_ACCEPT_LIST);
 	if (!sent)
 		return;
 
-	hci_bdaddr_list_add(&hdev->le_white_list, &sent->bdaddr,
-			   sent->bdaddr_type);
+	hci_bdaddr_list_add(&hdev->le_accept_list, &sent->bdaddr,
+			    sent->bdaddr_type);
 }
 
-static void hci_cc_le_del_from_white_list(struct hci_dev *hdev,
-					  struct sk_buff *skb)
+static void hci_cc_le_del_from_accept_list(struct hci_dev *hdev,
+					   struct sk_buff *skb)
 {
-	struct hci_cp_le_del_from_white_list *sent;
+	struct hci_cp_le_del_from_accept_list *sent;
 	__u8 status = *((__u8 *) skb->data);
 
 	BT_DBG("%s status 0x%2.2x", hdev->name, status);
@@ -1512,11 +1512,11 @@ static void hci_cc_le_del_from_white_list(struct hci_dev *hdev,
 	if (status)
 		return;
 
-	sent = hci_sent_cmd_data(hdev, HCI_OP_LE_DEL_FROM_WHITE_LIST);
+	sent = hci_sent_cmd_data(hdev, HCI_OP_LE_DEL_FROM_ACCEPT_LIST);
 	if (!sent)
 		return;
 
-	hci_bdaddr_list_del(&hdev->le_white_list, &sent->bdaddr,
+	hci_bdaddr_list_del(&hdev->le_accept_list, &sent->bdaddr,
 			    sent->bdaddr_type);
 }
 
@@ -2331,7 +2331,7 @@ static void cs_le_create_conn(struct hci_dev *hdev, bdaddr_t *peer_addr,
 	/* We don't want the connection attempt to stick around
 	 * indefinitely since LE doesn't have a page timeout concept
 	 * like BR/EDR. Set a timer for any connection that doesn't use
-	 * the white list for connecting.
+	 * the accept list for connecting.
 	 */
 	if (filter_policy == HCI_LE_USE_PEER_ADDR)
 		queue_delayed_work(conn->hdev->workqueue,
@@ -2587,7 +2587,7 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		 * only used during suspend.
 		 */
 		if (ev->link_type == ACL_LINK &&
-		    hci_bdaddr_list_lookup_with_flags(&hdev->whitelist,
+		    hci_bdaddr_list_lookup_with_flags(&hdev->accept_list,
 						      &ev->bdaddr,
 						      BDADDR_BREDR)) {
 			conn = hci_conn_add(hdev, ev->link_type, &ev->bdaddr,
@@ -2709,19 +2709,19 @@ static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		return;
 	}
 
-	if (hci_bdaddr_list_lookup(&hdev->blacklist, &ev->bdaddr,
+	if (hci_bdaddr_list_lookup(&hdev->reject_list, &ev->bdaddr,
 				   BDADDR_BREDR)) {
 		hci_reject_conn(hdev, &ev->bdaddr);
 		return;
 	}
 
-	/* Require HCI_CONNECTABLE or a whitelist entry to accept the
+	/* Require HCI_CONNECTABLE or an accept list entry to accept the
 	 * connection. These features are only touched through mgmt so
 	 * only do the checks if HCI_MGMT is set.
 	 */
 	if (hci_dev_test_flag(hdev, HCI_MGMT) &&
 	    !hci_dev_test_flag(hdev, HCI_CONNECTABLE) &&
-	    !hci_bdaddr_list_lookup_with_flags(&hdev->whitelist, &ev->bdaddr,
+	    !hci_bdaddr_list_lookup_with_flags(&hdev->accept_list, &ev->bdaddr,
 					       BDADDR_BREDR)) {
 		hci_reject_conn(hdev, &ev->bdaddr);
 		return;
@@ -3481,20 +3481,20 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
 		hci_cc_le_set_scan_enable(hdev, skb);
 		break;
 
-	case HCI_OP_LE_READ_WHITE_LIST_SIZE:
-		hci_cc_le_read_white_list_size(hdev, skb);
+	case HCI_OP_LE_READ_ACCEPT_LIST_SIZE:
+		hci_cc_le_read_accept_list_size(hdev, skb);
 		break;
 
-	case HCI_OP_LE_CLEAR_WHITE_LIST:
-		hci_cc_le_clear_white_list(hdev, skb);
+	case HCI_OP_LE_CLEAR_ACCEPT_LIST:
+		hci_cc_le_clear_accept_list(hdev, skb);
 		break;
 
-	case HCI_OP_LE_ADD_TO_WHITE_LIST:
-		hci_cc_le_add_to_white_list(hdev, skb);
+	case HCI_OP_LE_ADD_TO_ACCEPT_LIST:
+		hci_cc_le_add_to_accept_list(hdev, skb);
 		break;
 
-	case HCI_OP_LE_DEL_FROM_WHITE_LIST:
-		hci_cc_le_del_from_white_list(hdev, skb);
+	case HCI_OP_LE_DEL_FROM_ACCEPT_LIST:
+		hci_cc_le_del_from_accept_list(hdev, skb);
 		break;
 
 	case HCI_OP_LE_READ_SUPPORTED_STATES:
@@ -5154,7 +5154,7 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 
 		/* If we didn't have a hci_conn object previously
 		 * but we're in central role this must be something
-		 * initiated using a white list. Since white list based
+		 * initiated using an accept list. Since accept list based
 		 * connections are not "first class citizens" we don't
 		 * have full tracking of them. Therefore, we go ahead
 		 * with a "best effort" approach of determining the
@@ -5204,7 +5204,7 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 		addr_type = BDADDR_LE_RANDOM;
 
 	/* Drop the connection if the device is blocked */
-	if (hci_bdaddr_list_lookup(&hdev->blacklist, &conn->dst, addr_type)) {
+	if (hci_bdaddr_list_lookup(&hdev->reject_list, &conn->dst, addr_type)) {
 		hci_conn_drop(conn);
 		goto unlock;
 	}
@@ -5372,7 +5372,7 @@ static struct hci_conn *check_pending_le_conn(struct hci_dev *hdev,
 		return NULL;
 
 	/* Ignore if the device is blocked */
-	if (hci_bdaddr_list_lookup(&hdev->blacklist, addr, addr_type))
+	if (hci_bdaddr_list_lookup(&hdev->reject_list, addr, addr_type))
 		return NULL;
 
 	/* Most controller will fail if we try to create new connections
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index eb4c1c18eb01..a0f980e61505 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -736,17 +736,17 @@ void hci_req_add_le_scan_disable(struct hci_request *req, bool rpa_le_conn)
 	}
 }
 
-static void del_from_white_list(struct hci_request *req, bdaddr_t *bdaddr,
-				u8 bdaddr_type)
+static void del_from_accept_list(struct hci_request *req, bdaddr_t *bdaddr,
+				 u8 bdaddr_type)
 {
-	struct hci_cp_le_del_from_white_list cp;
+	struct hci_cp_le_del_from_accept_list cp;
 
 	cp.bdaddr_type = bdaddr_type;
 	bacpy(&cp.bdaddr, bdaddr);
 
-	bt_dev_dbg(req->hdev, "Remove %pMR (0x%x) from whitelist", &cp.bdaddr,
+	bt_dev_dbg(req->hdev, "Remove %pMR (0x%x) from accept list", &cp.bdaddr,
 		   cp.bdaddr_type);
-	hci_req_add(req, HCI_OP_LE_DEL_FROM_WHITE_LIST, sizeof(cp), &cp);
+	hci_req_add(req, HCI_OP_LE_DEL_FROM_ACCEPT_LIST, sizeof(cp), &cp);
 
 	if (use_ll_privacy(req->hdev) &&
 	    hci_dev_test_flag(req->hdev, HCI_ENABLE_LL_PRIVACY)) {
@@ -765,31 +765,31 @@ static void del_from_white_list(struct hci_request *req, bdaddr_t *bdaddr,
 	}
 }
 
-/* Adds connection to white list if needed. On error, returns -1. */
-static int add_to_white_list(struct hci_request *req,
-			     struct hci_conn_params *params, u8 *num_entries,
-			     bool allow_rpa)
+/* Adds connection to accept list if needed. On error, returns -1. */
+static int add_to_accept_list(struct hci_request *req,
+			      struct hci_conn_params *params, u8 *num_entries,
+			      bool allow_rpa)
 {
-	struct hci_cp_le_add_to_white_list cp;
+	struct hci_cp_le_add_to_accept_list cp;
 	struct hci_dev *hdev = req->hdev;
 
-	/* Already in white list */
-	if (hci_bdaddr_list_lookup(&hdev->le_white_list, &params->addr,
+	/* Already in accept list */
+	if (hci_bdaddr_list_lookup(&hdev->le_accept_list, &params->addr,
 				   params->addr_type))
 		return 0;
 
 	/* Select filter policy to accept all advertising */
-	if (*num_entries >= hdev->le_white_list_size)
+	if (*num_entries >= hdev->le_accept_list_size)
 		return -1;
 
-	/* White list can not be used with RPAs */
+	/* Accept list can not be used with RPAs */
 	if (!allow_rpa &&
 	    !hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY) &&
 	    hci_find_irk_by_addr(hdev, &params->addr, params->addr_type)) {
 		return -1;
 	}
 
-	/* During suspend, only wakeable devices can be in whitelist */
+	/* During suspend, only wakeable devices can be in accept list */
 	if (hdev->suspended && !hci_conn_test_flag(HCI_CONN_FLAG_REMOTE_WAKEUP,
 						   params->current_flags))
 		return 0;
@@ -798,9 +798,9 @@ static int add_to_white_list(struct hci_request *req,
 	cp.bdaddr_type = params->addr_type;
 	bacpy(&cp.bdaddr, &params->addr);
 
-	bt_dev_dbg(hdev, "Add %pMR (0x%x) to whitelist", &cp.bdaddr,
+	bt_dev_dbg(hdev, "Add %pMR (0x%x) to accept list", &cp.bdaddr,
 		   cp.bdaddr_type);
-	hci_req_add(req, HCI_OP_LE_ADD_TO_WHITE_LIST, sizeof(cp), &cp);
+	hci_req_add(req, HCI_OP_LE_ADD_TO_ACCEPT_LIST, sizeof(cp), &cp);
 
 	if (use_ll_privacy(hdev) &&
 	    hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY)) {
@@ -828,15 +828,15 @@ static int add_to_white_list(struct hci_request *req,
 	return 0;
 }
 
-static u8 update_white_list(struct hci_request *req)
+static u8 update_accept_list(struct hci_request *req)
 {
 	struct hci_dev *hdev = req->hdev;
 	struct hci_conn_params *params;
 	struct bdaddr_list *b;
 	u8 num_entries = 0;
 	bool pend_conn, pend_report;
-	/* We allow whitelisting even with RPAs in suspend. In the worst case,
-	 * we won't be able to wake from devices that use the privacy1.2
+	/* We allow usage of accept list even with RPAs in suspend. In the worst
+	 * case, we won't be able to wake from devices that use the privacy1.2
 	 * features. Additionally, once we support privacy1.2 and IRK
 	 * offloading, we can update this to also check for those conditions.
 	 */
@@ -846,13 +846,13 @@ static u8 update_white_list(struct hci_request *req)
 	    hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY))
 		allow_rpa = true;
 
-	/* Go through the current white list programmed into the
+	/* Go through the current accept list programmed into the
 	 * controller one by one and check if that address is still
 	 * in the list of pending connections or list of devices to
 	 * report. If not present in either list, then queue the
 	 * command to remove it from the controller.
 	 */
-	list_for_each_entry(b, &hdev->le_white_list, list) {
+	list_for_each_entry(b, &hdev->le_accept_list, list) {
 		pend_conn = hci_pend_le_action_lookup(&hdev->pend_le_conns,
 						      &b->bdaddr,
 						      b->bdaddr_type);
@@ -861,14 +861,14 @@ static u8 update_white_list(struct hci_request *req)
 							b->bdaddr_type);
 
 		/* If the device is not likely to connect or report,
-		 * remove it from the whitelist.
+		 * remove it from the accept list.
 		 */
 		if (!pend_conn && !pend_report) {
-			del_from_white_list(req, &b->bdaddr, b->bdaddr_type);
+			del_from_accept_list(req, &b->bdaddr, b->bdaddr_type);
 			continue;
 		}
 
-		/* White list can not be used with RPAs */
+		/* Accept list can not be used with RPAs */
 		if (!allow_rpa &&
 		    !hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY) &&
 		    hci_find_irk_by_addr(hdev, &b->bdaddr, b->bdaddr_type)) {
@@ -878,27 +878,27 @@ static u8 update_white_list(struct hci_request *req)
 		num_entries++;
 	}
 
-	/* Since all no longer valid white list entries have been
+	/* Since all no longer valid accept list entries have been
 	 * removed, walk through the list of pending connections
 	 * and ensure that any new device gets programmed into
 	 * the controller.
 	 *
 	 * If the list of the devices is larger than the list of
-	 * available white list entries in the controller, then
+	 * available accept list entries in the controller, then
 	 * just abort and return filer policy value to not use the
-	 * white list.
+	 * accept list.
 	 */
 	list_for_each_entry(params, &hdev->pend_le_conns, action) {
-		if (add_to_white_list(req, params, &num_entries, allow_rpa))
+		if (add_to_accept_list(req, params, &num_entries, allow_rpa))
 			return 0x00;
 	}
 
 	/* After adding all new pending connections, walk through
 	 * the list of pending reports and also add these to the
-	 * white list if there is still space. Abort if space runs out.
+	 * accept list if there is still space. Abort if space runs out.
 	 */
 	list_for_each_entry(params, &hdev->pend_le_reports, action) {
-		if (add_to_white_list(req, params, &num_entries, allow_rpa))
+		if (add_to_accept_list(req, params, &num_entries, allow_rpa))
 			return 0x00;
 	}
 
@@ -915,7 +915,7 @@ static u8 update_white_list(struct hci_request *req)
 	    hdev->interleave_scan_state != INTERLEAVE_SCAN_ALLOWLIST)
 		return 0x00;
 
-	/* Select filter policy to use white list */
+	/* Select filter policy to use accept list */
 	return 0x01;
 }
 
@@ -1069,20 +1069,20 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 		return;
 
 	bt_dev_dbg(hdev, "interleave state %d", hdev->interleave_scan_state);
-	/* Adding or removing entries from the white list must
+	/* Adding or removing entries from the accept list must
 	 * happen before enabling scanning. The controller does
-	 * not allow white list modification while scanning.
+	 * not allow accept list modification while scanning.
 	 */
-	filter_policy = update_white_list(req);
+	filter_policy = update_accept_list(req);
 
 	/* When the controller is using random resolvable addresses and
 	 * with that having LE privacy enabled, then controllers with
 	 * Extended Scanner Filter Policies support can now enable support
 	 * for handling directed advertising.
 	 *
-	 * So instead of using filter polices 0x00 (no whitelist)
-	 * and 0x01 (whitelist enabled) use the new filter policies
-	 * 0x02 (no whitelist) and 0x03 (whitelist enabled).
+	 * So instead of using filter polices 0x00 (no accept list)
+	 * and 0x01 (accept list enabled) use the new filter policies
+	 * 0x02 (no accept list) and 0x03 (accept list enabled).
 	 */
 	if (hci_dev_test_flag(hdev, HCI_PRIVACY) &&
 	    (hdev->le_features[0] & HCI_LE_EXT_SCAN_POLICY))
@@ -1102,7 +1102,8 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 		interval = hdev->le_scan_interval;
 	}
 
-	bt_dev_dbg(hdev, "LE passive scan with whitelist = %d", filter_policy);
+	bt_dev_dbg(hdev, "LE passive scan with accept list = %d",
+		   filter_policy);
 	hci_req_start_scan(req, LE_SCAN_PASSIVE, interval, window,
 			   own_addr_type, filter_policy, addr_resolv);
 }
@@ -1150,7 +1151,7 @@ static void hci_req_set_event_filter(struct hci_request *req)
 	/* Always clear event filter when starting */
 	hci_req_clear_event_filter(req);
 
-	list_for_each_entry(b, &hdev->whitelist, list) {
+	list_for_each_entry(b, &hdev->accept_list, list) {
 		if (!hci_conn_test_flag(HCI_CONN_FLAG_REMOTE_WAKEUP,
 					b->current_flags))
 			continue;
@@ -2562,11 +2563,11 @@ int hci_update_random_address(struct hci_request *req, bool require_privacy,
 	return 0;
 }
 
-static bool disconnected_whitelist_entries(struct hci_dev *hdev)
+static bool disconnected_accept_list_entries(struct hci_dev *hdev)
 {
 	struct bdaddr_list *b;
 
-	list_for_each_entry(b, &hdev->whitelist, list) {
+	list_for_each_entry(b, &hdev->accept_list, list) {
 		struct hci_conn *conn;
 
 		conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &b->bdaddr);
@@ -2598,7 +2599,7 @@ void __hci_req_update_scan(struct hci_request *req)
 		return;
 
 	if (hci_dev_test_flag(hdev, HCI_CONNECTABLE) ||
-	    disconnected_whitelist_entries(hdev))
+	    disconnected_accept_list_entries(hdev))
 		scan = SCAN_PAGE;
 	else
 		scan = SCAN_DISABLED;
@@ -3087,7 +3088,7 @@ static int active_scan(struct hci_request *req, unsigned long opt)
 	uint16_t interval = opt;
 	struct hci_dev *hdev = req->hdev;
 	u8 own_addr_type;
-	/* White list is not used for discovery */
+	/* Accept list is not used for discovery */
 	u8 filter_policy = 0x00;
 	/* Discovery doesn't require controller address resolution */
 	bool addr_resolv = false;
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 53f85d7c5f9e..71d18d3295f5 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -897,7 +897,7 @@ static int hci_sock_release(struct socket *sock)
 	return 0;
 }
 
-static int hci_sock_blacklist_add(struct hci_dev *hdev, void __user *arg)
+static int hci_sock_reject_list_add(struct hci_dev *hdev, void __user *arg)
 {
 	bdaddr_t bdaddr;
 	int err;
@@ -907,14 +907,14 @@ static int hci_sock_blacklist_add(struct hci_dev *hdev, void __user *arg)
 
 	hci_dev_lock(hdev);
 
-	err = hci_bdaddr_list_add(&hdev->blacklist, &bdaddr, BDADDR_BREDR);
+	err = hci_bdaddr_list_add(&hdev->reject_list, &bdaddr, BDADDR_BREDR);
 
 	hci_dev_unlock(hdev);
 
 	return err;
 }
 
-static int hci_sock_blacklist_del(struct hci_dev *hdev, void __user *arg)
+static int hci_sock_reject_list_del(struct hci_dev *hdev, void __user *arg)
 {
 	bdaddr_t bdaddr;
 	int err;
@@ -924,7 +924,7 @@ static int hci_sock_blacklist_del(struct hci_dev *hdev, void __user *arg)
 
 	hci_dev_lock(hdev);
 
-	err = hci_bdaddr_list_del(&hdev->blacklist, &bdaddr, BDADDR_BREDR);
+	err = hci_bdaddr_list_del(&hdev->reject_list, &bdaddr, BDADDR_BREDR);
 
 	hci_dev_unlock(hdev);
 
@@ -964,12 +964,12 @@ static int hci_sock_bound_ioctl(struct sock *sk, unsigned int cmd,
 	case HCIBLOCKADDR:
 		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
-		return hci_sock_blacklist_add(hdev, (void __user *)arg);
+		return hci_sock_reject_list_add(hdev, (void __user *)arg);
 
 	case HCIUNBLOCKADDR:
 		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
-		return hci_sock_blacklist_del(hdev, (void __user *)arg);
+		return hci_sock_reject_list_del(hdev, (void __user *)arg);
 	}
 
 	return -ENOIOCTLCMD;
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 6c80e62cea0c..2557cd917f5e 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7652,7 +7652,7 @@ static void l2cap_recv_frame(struct l2cap_conn *conn, struct sk_buff *skb)
 	 * at least ensure that we ignore incoming data from them.
 	 */
 	if (hcon->type == LE_LINK &&
-	    hci_bdaddr_list_lookup(&hcon->hdev->blacklist, &hcon->dst,
+	    hci_bdaddr_list_lookup(&hcon->hdev->reject_list, &hcon->dst,
 				   bdaddr_dst_type(hcon))) {
 		kfree_skb(skb);
 		return;
@@ -8108,7 +8108,7 @@ static void l2cap_connect_cfm(struct hci_conn *hcon, u8 status)
 	dst_type = bdaddr_dst_type(hcon);
 
 	/* If device is blocked, do not create channels for it */
-	if (hci_bdaddr_list_lookup(&hdev->blacklist, &hcon->dst, dst_type))
+	if (hci_bdaddr_list_lookup(&hdev->reject_list, &hcon->dst, dst_type))
 		return;
 
 	/* Find fixed channels and notify them of the new connection. We
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 08f67f91d427..878bf7382244 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4041,7 +4041,7 @@ static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 	memset(&rp, 0, sizeof(rp));
 
 	if (cp->addr.type == BDADDR_BREDR) {
-		br_params = hci_bdaddr_list_lookup_with_flags(&hdev->whitelist,
+		br_params = hci_bdaddr_list_lookup_with_flags(&hdev->accept_list,
 							      &cp->addr.bdaddr,
 							      cp->addr.type);
 		if (!br_params)
@@ -4109,7 +4109,7 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 	hci_dev_lock(hdev);
 
 	if (cp->addr.type == BDADDR_BREDR) {
-		br_params = hci_bdaddr_list_lookup_with_flags(&hdev->whitelist,
+		br_params = hci_bdaddr_list_lookup_with_flags(&hdev->accept_list,
 							      &cp->addr.bdaddr,
 							      cp->addr.type);
 
@@ -4979,7 +4979,7 @@ static int block_device(struct sock *sk, struct hci_dev *hdev, void *data,
 
 	hci_dev_lock(hdev);
 
-	err = hci_bdaddr_list_add(&hdev->blacklist, &cp->addr.bdaddr,
+	err = hci_bdaddr_list_add(&hdev->reject_list, &cp->addr.bdaddr,
 				  cp->addr.type);
 	if (err < 0) {
 		status = MGMT_STATUS_FAILED;
@@ -5015,7 +5015,7 @@ static int unblock_device(struct sock *sk, struct hci_dev *hdev, void *data,
 
 	hci_dev_lock(hdev);
 
-	err = hci_bdaddr_list_del(&hdev->blacklist, &cp->addr.bdaddr,
+	err = hci_bdaddr_list_del(&hdev->reject_list, &cp->addr.bdaddr,
 				  cp->addr.type);
 	if (err < 0) {
 		status = MGMT_STATUS_INVALID_PARAMS;
@@ -6506,7 +6506,7 @@ static int add_device(struct sock *sk, struct hci_dev *hdev,
 			goto unlock;
 		}
 
-		err = hci_bdaddr_list_add_with_flags(&hdev->whitelist,
+		err = hci_bdaddr_list_add_with_flags(&hdev->accept_list,
 						     &cp->addr.bdaddr,
 						     cp->addr.type, 0);
 		if (err)
@@ -6604,7 +6604,7 @@ static int remove_device(struct sock *sk, struct hci_dev *hdev,
 		}
 
 		if (cp->addr.type == BDADDR_BREDR) {
-			err = hci_bdaddr_list_del(&hdev->whitelist,
+			err = hci_bdaddr_list_del(&hdev->accept_list,
 						  &cp->addr.bdaddr,
 						  cp->addr.type);
 			if (err) {
@@ -6675,7 +6675,7 @@ static int remove_device(struct sock *sk, struct hci_dev *hdev,
 			goto unlock;
 		}
 
-		list_for_each_entry_safe(b, btmp, &hdev->whitelist, list) {
+		list_for_each_entry_safe(b, btmp, &hdev->accept_list, list) {
 			device_removed(sk, hdev, &b->bdaddr, b->bdaddr_type);
 			list_del(&b->list);
 			kfree(b);
-- 
2.35.1



