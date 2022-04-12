Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29CCD4FDAD8
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356089AbiDLHeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355398AbiDLH1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:27:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BEA4993E;
        Tue, 12 Apr 2022 00:07:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 465BB616AB;
        Tue, 12 Apr 2022 07:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A4FC385AB;
        Tue, 12 Apr 2022 07:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747255;
        bh=ZuW3LbMRkPBggKInlOR/HRj2jRcbYPd7tb9NvbuI2Fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDzW+jcCguy0DGeeJZNxCThE9rwWYQZ+P6SPm8bjPopNUj/iJ1Nykime7hwU4O+wi
         u9fkIEqIA/7XeB8CCPWS6q6OUchQgbiIJhcWk8PiilYDLA1Cr+DJGQW8xYjjKBBKnv
         XDzunFVL4XPmAJ0ko0p/906jZwp+S4cIv+JmLD9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Soenke Huster <soenke.huster@eknoes.de>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 014/343] Bluetooth: fix null ptr deref on hci_sync_conn_complete_evt
Date:   Tue, 12 Apr 2022 08:27:12 +0200
Message-Id: <20220412062951.516538389@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Soenke Huster <soenke.huster@eknoes.de>

[ Upstream commit 3afee2118132e93e5f6fa636dfde86201a860ab3 ]

This event is just specified for SCO and eSCO link types.
On the reception of a HCI_Synchronous_Connection_Complete for a BDADDR
of an existing LE connection, LE link type and a status that triggers the
second case of the packet processing a NULL pointer dereference happens,
as conn->link is NULL.

Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index a105b7317560..519f5906ee98 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4661,6 +4661,19 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev, void *data,
 	struct hci_ev_sync_conn_complete *ev = data;
 	struct hci_conn *conn;
 
+	switch (ev->link_type) {
+	case SCO_LINK:
+	case ESCO_LINK:
+		break;
+	default:
+		/* As per Core 5.3 Vol 4 Part E 7.7.35 (p.2219), Link_Type
+		 * for HCI_Synchronous_Connection_Complete is limited to
+		 * either SCO or eSCO
+		 */
+		bt_dev_err(hdev, "Ignoring connect complete event for invalid link type");
+		return;
+	}
+
 	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
-- 
2.35.1



