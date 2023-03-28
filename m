Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2DB26CC421
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbjC1PAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbjC1PAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:00:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA7CE053
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:00:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E4D7B81D63
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A55C433EF;
        Tue, 28 Mar 2023 15:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015606;
        bh=qmDcTsJAyzVhJMt0yZYUrZe6Lfl2jaFQf34TksOTO18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZoxrKfOwy9nlp80gcMUxsE1VnV+mESTxlaFnTv9QRm4lrH1xThFB7YZa5z1GQ4qm
         xN1KptnCViM9pbsldAEaNyn0+Rh6tD2KOdO5WO3A5J4OgbpXpik1ENAXTBgE7jrglf
         bM9y71gM19c5rS4231i6bnfcQQc0S5UflKr5dK8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/224] Bluetooth: btusb: Remove detection of ISO packets over bulk
Date:   Tue, 28 Mar 2023 16:41:18 +0200
Message-Id: <20230328142620.700858164@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit efe375b716c1c1c9b52a816f5b933a95421020a2 ]

This removes the code introduced by
14202eff214e1e941fefa0366d4c3bc4b1a0d500 as hci_recv_frame is now able
to detect ACL packets that are in fact ISO packets.

Fixes: 14202eff214e ("Bluetooth: btusb: Detect if an ACL packet is in fact an ISO packet")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 952dc9d2404ed..90b85dcb138df 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1020,21 +1020,11 @@ static int btusb_recv_bulk(struct btusb_data *data, void *buffer, int count)
 		hci_skb_expect(skb) -= len;
 
 		if (skb->len == HCI_ACL_HDR_SIZE) {
-			__u16 handle = __le16_to_cpu(hci_acl_hdr(skb)->handle);
 			__le16 dlen = hci_acl_hdr(skb)->dlen;
-			__u8 type;
 
 			/* Complete ACL header */
 			hci_skb_expect(skb) = __le16_to_cpu(dlen);
 
-			/* Detect if ISO packet has been sent over bulk */
-			if (hci_conn_num(data->hdev, ISO_LINK)) {
-				type = hci_conn_lookup_type(data->hdev,
-							    hci_handle(handle));
-				if (type == ISO_LINK)
-					hci_skb_pkt_type(skb) = HCI_ISODATA_PKT;
-			}
-
 			if (skb_tailroom(skb) < hci_skb_expect(skb)) {
 				kfree_skb(skb);
 				skb = NULL;
-- 
2.39.2



