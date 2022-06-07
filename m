Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73CF540639
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbiFGRdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347750AbiFGRbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:31:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A2D11B696;
        Tue,  7 Jun 2022 10:28:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7282FB82285;
        Tue,  7 Jun 2022 17:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC875C385A5;
        Tue,  7 Jun 2022 17:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622894;
        bh=oO4LYSgGxXdMf4Wf1lkUNBzkU4g7sGH0x1F5PBK5a5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4TCu+7uki6VKRtfZCLgVtc54lAuqkPnrKPkpC7NUaL/feb9497PfWkKG6LRnpbUu
         osWmBFGsPaP+UmmNfBJMDzC2eL9ZXsPCZkrFE6mL06OVIfItPsUD9et8+Twik4yfjr
         7wCbQEQ3RpOmgJuKaXip4cRr8nirCbF0LRSQD3tU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 221/452] Bluetooth: use hdev lock for accept_list and reject_list in conn req
Date:   Tue,  7 Jun 2022 19:01:18 +0200
Message-Id: <20220607164915.147931627@linuxfoundation.org>
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

From: Niels Dossche <dossche.niels@gmail.com>

[ Upstream commit fb048cae51bacdfbbda2954af3c213fdb1d484f4 ]

All accesses (both reads and modifications) to
hdev->{accept,reject}_list are protected by hdev lock,
except the ones in hci_conn_request_evt. This can cause a race
condition in the form of a list corruption.
The solution is to protect these lists in hci_conn_request_evt as well.

I was unable to find the exact commit that introduced the issue for the
reject list, I was only able to find it for the accept list.

Fixes: a55bd29d5227 ("Bluetooth: Add white list lookup for incoming connection requests")
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index f75869835e3e..954b29605c94 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2709,10 +2709,12 @@ static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		return;
 	}
 
+	hci_dev_lock(hdev);
+
 	if (hci_bdaddr_list_lookup(&hdev->reject_list, &ev->bdaddr,
 				   BDADDR_BREDR)) {
 		hci_reject_conn(hdev, &ev->bdaddr);
-		return;
+		goto unlock;
 	}
 
 	/* Require HCI_CONNECTABLE or an accept list entry to accept the
@@ -2724,13 +2726,11 @@ static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	    !hci_bdaddr_list_lookup_with_flags(&hdev->accept_list, &ev->bdaddr,
 					       BDADDR_BREDR)) {
 		hci_reject_conn(hdev, &ev->bdaddr);
-		return;
+		goto unlock;
 	}
 
 	/* Connection accepted */
 
-	hci_dev_lock(hdev);
-
 	ie = hci_inquiry_cache_lookup(hdev, &ev->bdaddr);
 	if (ie)
 		memcpy(ie->data.dev_class, ev->dev_class, 3);
@@ -2742,8 +2742,7 @@ static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 				    HCI_ROLE_SLAVE);
 		if (!conn) {
 			bt_dev_err(hdev, "no memory for new connection");
-			hci_dev_unlock(hdev);
-			return;
+			goto unlock;
 		}
 	}
 
@@ -2783,6 +2782,10 @@ static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		conn->state = BT_CONNECT2;
 		hci_connect_cfm(conn, 0);
 	}
+
+	return;
+unlock:
+	hci_dev_unlock(hdev);
 }
 
 static u8 hci_to_mgmt_reason(u8 err)
-- 
2.35.1



