Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C496CC2DE
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbjC1OtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbjC1OtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:49:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB0AD51D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:48:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D79D6181D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE7AC433EF;
        Tue, 28 Mar 2023 14:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014895;
        bh=YW6xEUszQnldtHv2N50H+cZlQvtz/OYFIXd00JPV99M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JR929yupJf00hZsoD+mLNMy2Uw1Mjv+0wRam+3+DVWLMbxOAzpQkPeSZVSNLPR2Se
         xHo9SKBqJQTXfjk7mdCiARK6fEzaa/57ra2Yb/mk5cU0H/6eZizWmTPxgKC9ZPw4gi
         nfMuXUrZHteP5XHTkhYSC58UDe9GoEaZ7vHfEg9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 091/240] Bluetooth: btusb: Remove detection of ISO packets over bulk
Date:   Tue, 28 Mar 2023 16:40:54 +0200
Message-Id: <20230328142623.562361376@linuxfoundation.org>
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
index 18bc947187115..5c536151ef836 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1050,21 +1050,11 @@ static int btusb_recv_bulk(struct btusb_data *data, void *buffer, int count)
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



