Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEA14F27D2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbiDEIJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236387AbiDEICK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:02:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B7F4B852;
        Tue,  5 Apr 2022 01:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 313D4B81B14;
        Tue,  5 Apr 2022 08:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B57AC340EE;
        Tue,  5 Apr 2022 08:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145608;
        bh=O0U3WEChpLfH8FzqsUX1BA3WYald5yMIMISKQkOwYFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wYOjsazcvL3Yq7kp6MbsJIoy27Z18CZsctY/4ufN4kZB5NqgaKs1HDdwxKIZhg5Pl
         o7ylnJpmsW3cjBwOxqPXn6sH1EjafSCzTFzoYlUd1zaZRr2Dym1WrXPMk/JrvhaoM/
         YUH/2CeM9c/M56pIMmCmbqTbFtvoYPKqxYHQDTOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0463/1126] Bluetooth: hci_event: Fix HCI_EV_VENDOR max_len
Date:   Tue,  5 Apr 2022 09:20:10 +0200
Message-Id: <20220405070421.216240743@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 314d8cd2787418c5ac6b02035c344644f47b292b ]

HCI_EV_VENDOR is in fact variable length since it acts as metaevent
where a vendor can implement their own event sets.

In addition to it this makes use of bt_dev_warn_ratelimited to supress
the amount of logging in case the event has more data than expected.

Fixes: 3e54c5890c87 ("Bluetooth: hci_event: Use of a function table to handle HCI event")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 05997dff5666..a105b7317560 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6798,7 +6798,7 @@ static const struct hci_ev {
 	HCI_EV(HCI_EV_NUM_COMP_BLOCKS, hci_num_comp_blocks_evt,
 	       sizeof(struct hci_ev_num_comp_blocks)),
 	/* [0xff = HCI_EV_VENDOR] */
-	HCI_EV(HCI_EV_VENDOR, msft_vendor_evt, 0),
+	HCI_EV_VL(HCI_EV_VENDOR, msft_vendor_evt, 0, HCI_MAX_EVENT_SIZE),
 };
 
 static void hci_event_func(struct hci_dev *hdev, u8 event, struct sk_buff *skb,
@@ -6823,8 +6823,9 @@ static void hci_event_func(struct hci_dev *hdev, u8 event, struct sk_buff *skb,
 	 * decide if that is acceptable.
 	 */
 	if (skb->len > ev->max_len)
-		bt_dev_warn(hdev, "unexpected event 0x%2.2x length: %u > %u",
-			    event, skb->len, ev->max_len);
+		bt_dev_warn_ratelimited(hdev,
+					"unexpected event 0x%2.2x length: %u > %u",
+					event, skb->len, ev->max_len);
 
 	data = hci_ev_skb_pull(hdev, skb, event, ev->min_len);
 	if (!data)
-- 
2.34.1



