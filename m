Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAF26CC426
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbjC1PAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbjC1PAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:00:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D8DE38A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E830B81D63
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3EAC4339E;
        Tue, 28 Mar 2023 15:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015621;
        bh=MB7WDN5adSUha9q65zFW4jVt0mM2k89/hQamKyAk090=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=InE72qcH1OuWEY+SlhSw9JlCkTeBRfZlOnaA6nNDGzCDQwZHh2tMD+RUoMi57oLfE
         Vkzx9D+G1QloMJEp1PqNvo0fPPTkUPwyk1SI62LKxk4P3t3aac2Tx/rSlT2Ja/C6XN
         AAbcbqipDWtvRuhpyosw9oHlgTn+NtKGCy+6BIqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pauli Virtanen <pav@iki.fi>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/224] Bluetooth: ISO: fix timestamped HCI ISO data packet parsing
Date:   Tue, 28 Mar 2023 16:41:19 +0200
Message-Id: <20230328142620.737702704@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
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
index 2dabef488eaae..cb959e8eac185 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1621,7 +1621,6 @@ static void iso_disconn_cfm(struct hci_conn *hcon, __u8 reason)
 void iso_recv(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 {
 	struct iso_conn *conn = hcon->iso_data;
-	struct hci_iso_data_hdr *hdr;
 	__u16 pb, ts, len;
 
 	if (!conn)
@@ -1643,6 +1642,8 @@ void iso_recv(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 		}
 
 		if (ts) {
+			struct hci_iso_ts_data_hdr *hdr;
+
 			/* TODO: add timestamp to the packet? */
 			hdr = skb_pull_data(skb, HCI_ISO_TS_DATA_HDR_SIZE);
 			if (!hdr) {
@@ -1650,15 +1651,19 @@ void iso_recv(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
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



