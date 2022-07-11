Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6500E56FD68
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbiGKJzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234225AbiGKJy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:54:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818F9B0269;
        Mon, 11 Jul 2022 02:26:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7A42B80E84;
        Mon, 11 Jul 2022 09:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179C8C34115;
        Mon, 11 Jul 2022 09:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531557;
        bh=cklb2sVuuc/uXDDNwPufVaIA5HGokBkhDzSFJjd6AJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FyZ4Ixu2yoKE8c3LtIKYLA7YglwAOgc/QS8ywGJy8J/dPQaYWVaSb9kJE716qT9J5
         ALK19IxynYZPnf4WyxeWukLlQue8olCpTGf6KBHgKejQh7P9BKWduoHkvZX6tgLbv1
         NEQTIc2C7vHRqk2GGYKRKx5h/VNjdP5inSLab5iA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/230] Bluetooth: protect le accept and resolv lists with hdev->lock
Date:   Mon, 11 Jul 2022 11:06:45 +0200
Message-Id: <20220711090608.287671349@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niels Dossche <dossche.niels@gmail.com>

[ Upstream commit 5e2b6064cbc5fd582396768c5f9583f65085e368 ]

Concurrent operations from events on le_{accept,resolv}_list are
currently unprotected by hdev->lock.
Most existing code do already protect the lists with that lock.
This can be observed in hci_debugfs and hci_sync.
Add the protection for these events too.

Fixes: b950aa88638c ("Bluetooth: Add definitions and track LE resolve list modification")
Fixes: 0f36b589e4ee ("Bluetooth: Track LE white list modification via HCI commands")
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 5ac3aca6deeb..2337e9275863 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1559,7 +1559,9 @@ static void hci_cc_le_clear_accept_list(struct hci_dev *hdev,
 	if (status)
 		return;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_clear(&hdev->le_accept_list);
+	hci_dev_unlock(hdev);
 }
 
 static void hci_cc_le_add_to_accept_list(struct hci_dev *hdev,
@@ -1577,8 +1579,10 @@ static void hci_cc_le_add_to_accept_list(struct hci_dev *hdev,
 	if (!sent)
 		return;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_add(&hdev->le_accept_list, &sent->bdaddr,
 			    sent->bdaddr_type);
+	hci_dev_unlock(hdev);
 }
 
 static void hci_cc_le_del_from_accept_list(struct hci_dev *hdev,
@@ -1596,8 +1600,10 @@ static void hci_cc_le_del_from_accept_list(struct hci_dev *hdev,
 	if (!sent)
 		return;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_del(&hdev->le_accept_list, &sent->bdaddr,
 			    sent->bdaddr_type);
+	hci_dev_unlock(hdev);
 }
 
 static void hci_cc_le_read_supported_states(struct hci_dev *hdev,
@@ -1661,9 +1667,11 @@ static void hci_cc_le_add_to_resolv_list(struct hci_dev *hdev,
 	if (!sent)
 		return;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_add_with_irk(&hdev->le_resolv_list, &sent->bdaddr,
 				sent->bdaddr_type, sent->peer_irk,
 				sent->local_irk);
+	hci_dev_unlock(hdev);
 }
 
 static void hci_cc_le_del_from_resolv_list(struct hci_dev *hdev,
@@ -1681,8 +1689,10 @@ static void hci_cc_le_del_from_resolv_list(struct hci_dev *hdev,
 	if (!sent)
 		return;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_del_with_irk(&hdev->le_resolv_list, &sent->bdaddr,
 			    sent->bdaddr_type);
+	hci_dev_unlock(hdev);
 }
 
 static void hci_cc_le_clear_resolv_list(struct hci_dev *hdev,
@@ -1695,7 +1705,9 @@ static void hci_cc_le_clear_resolv_list(struct hci_dev *hdev,
 	if (status)
 		return;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_clear(&hdev->le_resolv_list);
+	hci_dev_unlock(hdev);
 }
 
 static void hci_cc_le_read_resolv_list_size(struct hci_dev *hdev,
-- 
2.35.1



