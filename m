Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65BC7621562
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbiKHOLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbiKHOLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:11:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3619862E0
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:11:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61842B81B01
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F96EC433D6;
        Tue,  8 Nov 2022 14:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916662;
        bh=P6AJxUjjRryYD3kAoJY3Gnv2bok1RuoUoMdFn/EsW7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0I7djlDj/RDiCQWxxEsLguanGKnfo5wF2KkeUjFgsXrolCb//atM2zWsgdNrvRX1
         LHGVlOud6fslC7hUp88R5R2ZpbtuwbqQHyRdrKuiWI8Nqob4W9QQm5eNUD6iAoAGRr
         4ASzb82HSAMiNFiMNnmMglXHvr962O3ZpOvqLVAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Danis?= 
        <frederic.danis@collabora.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 054/197] Bluetooth: hci_conn: Fix not restoring ISO buffer count on disconnect
Date:   Tue,  8 Nov 2022 14:38:12 +0100
Message-Id: <20221108133357.267877717@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 5638d9ea9c01c77fc11693d48cf719bc7e88f224 ]

When disconnecting an ISO link the controller may not generate
HCI_EV_NUM_COMP_PKTS for unacked packets which needs to be restored in
hci_conn_del otherwise the host would assume they are still in use and
would not be able to use all the buffers available.

Fixes: 26afbd826ee3 ("Bluetooth: Add initial implementation of CIS connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Frédéric Danis <frederic.danis@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index f1263cdd71dd..f26ed278d9e3 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1003,10 +1003,21 @@ int hci_conn_del(struct hci_conn *conn)
 			hdev->acl_cnt += conn->sent;
 	} else {
 		struct hci_conn *acl = conn->link;
+
 		if (acl) {
 			acl->link = NULL;
 			hci_conn_drop(acl);
 		}
+
+		/* Unacked ISO frames */
+		if (conn->type == ISO_LINK) {
+			if (hdev->iso_pkts)
+				hdev->iso_cnt += conn->sent;
+			else if (hdev->le_pkts)
+				hdev->le_cnt += conn->sent;
+			else
+				hdev->acl_cnt += conn->sent;
+		}
 	}
 
 	if (conn->amp_mgr)
-- 
2.35.1



