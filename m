Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8FF461ED95
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 09:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbiKGIxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 03:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiKGIxq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 03:53:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1E95F6C
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 00:53:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8987560F59
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 08:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9672AC4347C;
        Mon,  7 Nov 2022 08:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667811225;
        bh=TaVM4THuhuiFNpGxn7dvry18EySRXlPK+Ojy/eJkYnE=;
        h=Subject:To:Cc:From:Date:From;
        b=PXCfbWFMPhqFVlE/i0INZaIrlV93qAvsL7bRstp1Tu1LsgDOW55I6QoQ900edPmH7
         WX8td3RaMWP/MOyODXyW/FRPFEhTMAKOKSzym+DnFOdxZOPPWGpLtv5C4bdD5Mrk3V
         oWe6oIE/WOIEWHhh8sOVDXTEE/VQI2/oazP1tbhA=
Subject: FAILED: patch "[PATCH] Bluetooth: L2CAP: Fix accepting connection request for" failed to apply to 4.14-stable tree
To:     luiz.von.dentz@intel.com, poprdi@google.com, tedd.an@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Nov 2022 09:53:30 +0100
Message-ID: <16678112101218@kroah.com>
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

711f8c3fb3db ("Bluetooth: L2CAP: Fix accepting connection request for invalid SPSM")
15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
571f739083e2 ("Bluetooth: Use separate L2CAP LE credit based connection result values")
96cd8eaa131f ("Bluetooth: L2CAP: Derive rx credits from MTU and MPS")
fe1493101ac1 ("Bluetooth: L2CAP: Derive MPS from connection MTU")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 711f8c3fb3db61897080468586b970c87c61d9e4 Mon Sep 17 00:00:00 2001
From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Date: Mon, 31 Oct 2022 16:10:32 -0700
Subject: [PATCH] Bluetooth: L2CAP: Fix accepting connection request for
 invalid SPSM
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 1fbe087d6ae4..3eee915fb245 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5813,6 +5813,19 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
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
@@ -6001,6 +6014,18 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 
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

