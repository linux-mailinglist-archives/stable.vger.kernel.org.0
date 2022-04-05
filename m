Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6784F270C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbiDEIDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235838AbiDEIA2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:00:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B0E3D4A8;
        Tue,  5 Apr 2022 00:58:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61CB961725;
        Tue,  5 Apr 2022 07:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7405FC340EE;
        Tue,  5 Apr 2022 07:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145509;
        bh=vHQjIyodvSNE/8GncM3QAk2FrhwvFw6zUYkbN+IhmRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GhLsoVhN31255E4F6E3NQ3pEoKWJ7X+sQf0dDJ5bV1xCZ2txRZlFy5XiWNiXInf2q
         378pio1eccd8be2L44vMhHwRZnL8R5MboqCkAhsXk8bp8WpJ0hMHuNiVTdjoFquuIw
         fzmQK/p+o9ytYDg91mci9NpC+Zr2Je3puhiWtk18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0432/1126] Bluetooth: hci_sync: unlock on error in hci_inquiry_result_with_rssi_evt()
Date:   Tue,  5 Apr 2022 09:19:39 +0200
Message-Id: <20220405070420.304930215@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit c07ba878ca199a6089cdb323bf526adbeeb4201f ]

Add unlocks to two error paths in hci_inquiry_result_with_rssi_evt().

Fixes: fee645033e2c ("Bluetooth: hci_event: Use skb_pull_data when processing inquiry results")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index fc30f4c03d29..05997dff5666 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4534,7 +4534,7 @@ static void hci_inquiry_result_with_rssi_evt(struct hci_dev *hdev, void *edata,
 			if (!info) {
 				bt_dev_err(hdev, "Malformed HCI Event: 0x%2.2x",
 					   HCI_EV_INQUIRY_RESULT_WITH_RSSI);
-				return;
+				goto unlock;
 			}
 
 			bacpy(&data.bdaddr, &info->bdaddr);
@@ -4565,7 +4565,7 @@ static void hci_inquiry_result_with_rssi_evt(struct hci_dev *hdev, void *edata,
 			if (!info) {
 				bt_dev_err(hdev, "Malformed HCI Event: 0x%2.2x",
 					   HCI_EV_INQUIRY_RESULT_WITH_RSSI);
-				return;
+				goto unlock;
 			}
 
 			bacpy(&data.bdaddr, &info->bdaddr);
@@ -4587,7 +4587,7 @@ static void hci_inquiry_result_with_rssi_evt(struct hci_dev *hdev, void *edata,
 		bt_dev_err(hdev, "Malformed HCI Event: 0x%2.2x",
 			   HCI_EV_INQUIRY_RESULT_WITH_RSSI);
 	}
-
+unlock:
 	hci_dev_unlock(hdev);
 }
 
-- 
2.34.1



