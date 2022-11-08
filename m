Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887F06213F3
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbiKHNzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234795AbiKHNzj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:55:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3141411827
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:55:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 81662CE1B95
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F04C433B5;
        Tue,  8 Nov 2022 13:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915734;
        bh=1TFoFERlL1aa9mtn9pNEL9qqOb/lp6Llv1AEn6Yj3dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IziCNQZ39dF1VNHI5DEBd7o+upj4OKhEe13FtN8iBKpZhaFgerTRV2CW1TVEa7Pcm
         63ruofWE46Lv1U4VRthPPk55k9DhQqvmgXNqA4l2b/07qCctkUF25M0h36vNA8Ta2a
         BsTGzkg4xlCnlRxJWOcS7x2p9teyqL5aTcBoAhWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Tam=C3=A1s=20Koczka?= <poprdi@google.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Tedd Ho-Jeong An <tedd.an@intel.com>
Subject: [PATCH 5.10 076/118] Bluetooth: L2CAP: Fix accepting connection request for invalid SPSM
Date:   Tue,  8 Nov 2022 14:39:14 +0100
Message-Id: <20221108133344.035834306@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

commit 711f8c3fb3db61897080468586b970c87c61d9e4 upstream.

The Bluetooth spec states that the valid range for SPSM is from
0x0001-0x00ff so it is invalid to accept values outside of this range:

  BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 3, Part A
  page 1059:
  Table 4.15: L2CAP_LE_CREDIT_BASED_CONNECTION_REQ SPSM ranges

CVE: CVE-2022-42896
CC: stable@vger.kernel.org
Reported-by: Tamás Koczka <poprdi@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5808,6 +5808,19 @@ static int l2cap_le_connect_req(struct l
 	BT_DBG("psm 0x%2.2x scid 0x%4.4x mtu %u mps %u", __le16_to_cpu(psm),
 	       scid, mtu, mps);
 
+	/* BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 3, Part A
+	 * page 1059:
+	 *
+	 * Valid range: 0x0001-0x00ff
+	 *
+	 * Table 4.15: L2CAP_LE_CREDIT_BASED_CONNECTION_REQ SPSM ranges
+	 */
+	if (!psm || __le16_to_cpu(psm) > L2CAP_PSM_LE_DYN_END) {
+		result = L2CAP_CR_LE_BAD_PSM;
+		chan = NULL;
+		goto response;
+	}
+
 	/* Check if we have socket listening on psm */
 	pchan = l2cap_global_chan_by_psm(BT_LISTEN, psm, &conn->hcon->src,
 					 &conn->hcon->dst, LE_LINK);
@@ -5988,6 +6001,18 @@ static inline int l2cap_ecred_conn_req(s
 
 	psm  = req->psm;
 
+	/* BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 3, Part A
+	 * page 1059:
+	 *
+	 * Valid range: 0x0001-0x00ff
+	 *
+	 * Table 4.15: L2CAP_LE_CREDIT_BASED_CONNECTION_REQ SPSM ranges
+	 */
+	if (!psm || __le16_to_cpu(psm) > L2CAP_PSM_LE_DYN_END) {
+		result = L2CAP_CR_LE_BAD_PSM;
+		goto response;
+	}
+
 	BT_DBG("psm 0x%2.2x mtu %u mps %u", __le16_to_cpu(psm), mtu, mps);
 
 	memset(&pdu, 0, sizeof(pdu));


