Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A30D6CC2CE
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbjC1OtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbjC1Osc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:48:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6C1D335
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8C70B81D73
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5778EC433EF;
        Tue, 28 Mar 2023 14:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014897;
        bh=7aZkUTZ/Knwr5i5ptz64TfiTRMbWRrnZmysVfju2/4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ipkjOO5LzpyUE9vruGN9NEJkNJEMJUg/aKuX9DfNd5/TXv3P+QPDgBkmeJzMFSsJp
         urPoyXhjIUfgdn+8Ic9IWF/ybqnUmy6dTUE/gyzGKoAbXVI6Sw8otkCRxOFJcYRddj
         M+NNRSJG2Tqruj6xTTrMCFKEiVXfpq0wzS+Ss99Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pauli Virtanen <pav@iki.fi>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 092/240] Bluetooth: ISO: fix timestamped HCI ISO data packet parsing
Date:   Tue, 28 Mar 2023 16:40:55 +0200
Message-Id: <20230328142623.606553127@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 2f10e40a948e8a2abe7f983df3959a333ca8955f ]

Use correct HCI ISO data packet header struct when the packet has
timestamp. The timestamp, when present, goes before the other fields
(Core v5.3 4E 5.4.5), so the structs are not compatible.

Fixes: ccf74f2390d6 ("Bluetooth: Add BTPROTO_ISO socket type")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 24444b502e586..8d136a7301630 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1620,7 +1620,6 @@ static void iso_disconn_cfm(struct hci_conn *hcon, __u8 reason)
 void iso_recv(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 {
 	struct iso_conn *conn = hcon->iso_data;
-	struct hci_iso_data_hdr *hdr;
 	__u16 pb, ts, len;
 
 	if (!conn)
@@ -1642,6 +1641,8 @@ void iso_recv(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 		}
 
 		if (ts) {
+			struct hci_iso_ts_data_hdr *hdr;
+
 			/* TODO: add timestamp to the packet? */
 			hdr = skb_pull_data(skb, HCI_ISO_TS_DATA_HDR_SIZE);
 			if (!hdr) {
@@ -1649,15 +1650,19 @@ void iso_recv(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 				goto drop;
 			}
 
+			len = __le16_to_cpu(hdr->slen);
 		} else {
+			struct hci_iso_data_hdr *hdr;
+
 			hdr = skb_pull_data(skb, HCI_ISO_DATA_HDR_SIZE);
 			if (!hdr) {
 				BT_ERR("Frame is too short (len %d)", skb->len);
 				goto drop;
 			}
+
+			len = __le16_to_cpu(hdr->slen);
 		}
 
-		len    = __le16_to_cpu(hdr->slen);
 		flags  = hci_iso_data_flags(len);
 		len    = hci_iso_data_len(len);
 
-- 
2.39.2



