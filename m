Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57B40C149A
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 15:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfI2N4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbfI2N4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:56:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 118A62082F;
        Sun, 29 Sep 2019 13:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765401;
        bh=pQnPTaXWlv1+WPL9VBSNvzL6JYxtjDaI93PENrp7EaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpR/5+fOnrFGNhTcNkW9qopuHBOgQqbOykk2UU9PZgh+98vQaaTRD9f4GFjPZPPpB
         vJylT+PQWykwig+YPXsMHk47t+UmOYD/roaxcnT+nlLpBZfy7HLknPKf7GrPChmVzG
         yzgzEwJwxN02UcPug8WDLJFVjBUBIlEPzMAqqfHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/63] Revert "Bluetooth: validate BLE connection interval updates"
Date:   Sun, 29 Sep 2019 15:53:34 +0200
Message-Id: <20190929135031.579923557@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
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
index 0adcddb211fa5..3e7badb3ac2d5 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5545,11 +5545,6 @@ static void hci_le_remote_conn_param_req_evt(struct hci_dev *hdev,
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
index a54dadf4a6ca0..260ef5426e0ca 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5287,14 +5287,7 @@ static inline int l2cap_conn_param_update_req(struct l2cap_conn *conn,
 
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



