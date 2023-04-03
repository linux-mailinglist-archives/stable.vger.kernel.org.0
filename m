Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717336D4836
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbjDCO0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbjDCO0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:26:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B389EF3
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:26:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F593B81C0E
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21C0C433D2;
        Mon,  3 Apr 2023 14:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531993;
        bh=A/HeRJzBO++y8fhXAYaUN/zEJydntN/wr5K4/IIMCtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQxcQvEdcgnj8Cqx4l0u0LWdWQoghpCCljyHlkBFVU5UZxVo0X1eSTrpdIEoIiwCn
         lAZU1ZUx33gfhxc1bAzo/OKEmpAAw83nFpo0hvpWM1q9HFcg2yNnu65tkqGUUfgvFW
         jiOyjLQbyRG1w33s1Rz57sh9sYcIZadegR+AYCk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/173] Bluetooth: L2CAP: Fix not checking for maximum number of DCID
Date:   Mon,  3 Apr 2023 16:07:49 +0200
Message-Id: <20230403140416.193727368@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 7cf3b1dd6aa603fd80969e9e7160becf1455a0eb ]

When receiving L2CAP_CREDIT_BASED_CONNECTION_REQ the remote may request
more channels than allowed by the spec (10 octecs = 5 CIDs) so this
checks if the number of channels is bigger than the maximum allowed and
respond with an error.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Stable-dep-of: 9aa9d9473f15 ("Bluetooth: L2CAP: Fix responding with wrong PDU type")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/l2cap.h |  1 +
 net/bluetooth/l2cap_core.c    | 12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 9b8000869b078..7f9d0ab76b14f 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -493,6 +493,7 @@ struct l2cap_le_credits {
 
 #define L2CAP_ECRED_MIN_MTU		64
 #define L2CAP_ECRED_MIN_MPS		64
+#define L2CAP_ECRED_MAX_CID		5
 
 struct l2cap_ecred_conn_req {
 	__le16 psm;
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index bde90df6b4976..b01677882e38c 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5952,7 +5952,7 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 	struct l2cap_ecred_conn_req *req = (void *) data;
 	struct {
 		struct l2cap_ecred_conn_rsp rsp;
-		__le16 dcid[5];
+		__le16 dcid[L2CAP_ECRED_MAX_CID];
 	} __packed pdu;
 	struct l2cap_chan *chan, *pchan;
 	u16 mtu, mps;
@@ -5969,6 +5969,14 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 		goto response;
 	}
 
+	cmd_len -= sizeof(*req);
+	num_scid = cmd_len / sizeof(u16);
+
+	if (num_scid > ARRAY_SIZE(pdu.dcid)) {
+		result = L2CAP_CR_LE_INVALID_PARAMS;
+		goto response;
+	}
+
 	mtu  = __le16_to_cpu(req->mtu);
 	mps  = __le16_to_cpu(req->mps);
 
@@ -6013,8 +6021,6 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 	}
 
 	result = L2CAP_CR_LE_SUCCESS;
-	cmd_len -= sizeof(*req);
-	num_scid = cmd_len / sizeof(u16);
 
 	for (i = 0; i < num_scid; i++) {
 		u16 scid = __le16_to_cpu(req->scid[i]);
-- 
2.39.2



