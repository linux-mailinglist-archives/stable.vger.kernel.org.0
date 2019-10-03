Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6E25CA16D
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 17:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbfJCPzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:55:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbfJCPzw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:55:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 870EE20700;
        Thu,  3 Oct 2019 15:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118151;
        bh=/mUCgtJyGz4DPng07kBY1gGf11ZttIpDb6KMtMyH+zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AfJbS2MSwzZeH5r7qGnu7HoSVqSTHONS7pRRSiUT0tMpPy8Wh0Fol7ALHtZMVvy9W
         OvHxoLKQYyJxLoDa102NSQdCzQCg1b8zt873A3I1ifvS8Gj8HEgLLyffUiSgQOTvrb
         PqS4tU5KG0+pWWUXx9JlTWyBN/F/lwNOCQV5dwW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 01/99] Revert "Bluetooth: validate BLE connection interval updates"
Date:   Thu,  3 Oct 2019 17:52:24 +0200
Message-Id: <20191003154253.184041960@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>

[ Upstream commit 68d19d7d995759b96169da5aac313363f92a9075 ]

This reverts commit c49a8682fc5d298d44e8d911f4fa14690ea9485e.

There are devices which require low connection intervals for usable operation
including keyboards and mice. Forcing a static connection interval for
these types of devices has an impact in latency and causes a regression.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c  | 5 -----
 net/bluetooth/l2cap_core.c | 9 +--------
 2 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index c4e94f34d0480..37fe2b158c2a7 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5062,11 +5062,6 @@ static void hci_le_remote_conn_param_req_evt(struct hci_dev *hdev,
 		return send_conn_param_neg_reply(hdev, handle,
 						 HCI_ERROR_UNKNOWN_CONN_ID);
 
-	if (min < hcon->le_conn_min_interval ||
-	    max > hcon->le_conn_max_interval)
-		return send_conn_param_neg_reply(hdev, handle,
-						 HCI_ERROR_INVALID_LL_PARAMS);
-
 	if (hci_check_conn_params(min, max, latency, timeout))
 		return send_conn_param_neg_reply(hdev, handle,
 						 HCI_ERROR_INVALID_LL_PARAMS);
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 8cfba78d26f61..c25f1e4846cde 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5266,14 +5266,7 @@ static inline int l2cap_conn_param_update_req(struct l2cap_conn *conn,
 
 	memset(&rsp, 0, sizeof(rsp));
 
-	if (min < hcon->le_conn_min_interval ||
-	    max > hcon->le_conn_max_interval) {
-		BT_DBG("requested connection interval exceeds current bounds.");
-		err = -EINVAL;
-	} else {
-		err = hci_check_conn_params(min, max, latency, to_multiplier);
-	}
-
+	err = hci_check_conn_params(min, max, latency, to_multiplier);
 	if (err)
 		rsp.result = cpu_to_le16(L2CAP_CONN_PARAM_REJECTED);
 	else
-- 
2.20.1



