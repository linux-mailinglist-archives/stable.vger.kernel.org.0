Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1DF54FD178
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351451AbiDLG6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352283AbiDLGza (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:55:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF7D39BB2;
        Mon, 11 Apr 2022 23:45:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C52A560C1B;
        Tue, 12 Apr 2022 06:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5593C385AB;
        Tue, 12 Apr 2022 06:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745914;
        bh=ZnTZ42DPMBoQ75SCZiE8sntMwYXskuJKw8g3vyalkdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVXkED/38y2RVxFZ1Kysjmfq+5pnawY1ZwhIf8Q28vZbwCPoqAC+Q5UgVDyaDP2ra
         gEGYpLjgVdnqB1JA/3K9uujC3VWLRSKXbqqCWKh25GlEJQiPpgHjlUmzYDBDQPf3l4
         moEHdUH8jhMFlAbXhTGAt1bbpymQXffE2jFoNxBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/277] can: isotp: set default value for N_As to 50 micro seconds
Date:   Tue, 12 Apr 2022 08:28:14 +0200
Message-Id: <20220412062944.677765637@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit 530e0d46c61314c59ecfdb8d3bcb87edbc0f85d3 ]

The N_As value describes the time a CAN frame needs on the wire when
transmitted by the CAN controller. Even very short CAN FD frames need
arround 100 usecs (bitrate 1Mbit/s, data bitrate 8Mbit/s).

Having N_As to be zero (the former default) leads to 'no CAN frame
separation' when STmin is set to zero by the receiving node. This 'burst
mode' should not be enabled by default as it could potentially dump a high
number of CAN frames into the netdev queue from the soft hrtimer context.
This does not affect the system stability but is just not nice and
cooperative.

With this N_As/frame_txtime value the 'burst mode' is disabled by default.

As user space applications usually do not set the frame_txtime element
of struct can_isotp_options the new in-kernel default is very likely
overwritten with zero when the sockopt() CAN_ISOTP_OPTS is invoked.
To make sure that a N_As value of zero is only set intentional the
value '0' is now interpreted as 'do not change the current value'.
When a frame_txtime of zero is required for testing purposes this
CAN_ISOTP_FRAME_TXTIME_ZERO u32 value has to be set in frame_txtime.

Link: https://lore.kernel.org/all/20220309120416.83514-2-socketcan@hartkopp.net
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/can/isotp.h | 28 ++++++++++++++++++++++------
 net/can/isotp.c                | 12 +++++++++++-
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/can/isotp.h b/include/uapi/linux/can/isotp.h
index c55935b64ccc..590f8aea2b6d 100644
--- a/include/uapi/linux/can/isotp.h
+++ b/include/uapi/linux/can/isotp.h
@@ -137,20 +137,16 @@ struct can_isotp_ll_options {
 #define CAN_ISOTP_WAIT_TX_DONE	0x400	/* wait for tx completion */
 #define CAN_ISOTP_SF_BROADCAST	0x800	/* 1-to-N functional addressing */
 
-/* default values */
+/* protocol machine default values */
 
 #define CAN_ISOTP_DEFAULT_FLAGS		0
 #define CAN_ISOTP_DEFAULT_EXT_ADDRESS	0x00
 #define CAN_ISOTP_DEFAULT_PAD_CONTENT	0xCC /* prevent bit-stuffing */
-#define CAN_ISOTP_DEFAULT_FRAME_TXTIME	0
+#define CAN_ISOTP_DEFAULT_FRAME_TXTIME	50000 /* 50 micro seconds */
 #define CAN_ISOTP_DEFAULT_RECV_BS	0
 #define CAN_ISOTP_DEFAULT_RECV_STMIN	0x00
 #define CAN_ISOTP_DEFAULT_RECV_WFTMAX	0
 
-#define CAN_ISOTP_DEFAULT_LL_MTU	CAN_MTU
-#define CAN_ISOTP_DEFAULT_LL_TX_DL	CAN_MAX_DLEN
-#define CAN_ISOTP_DEFAULT_LL_TX_FLAGS	0
-
 /*
  * Remark on CAN_ISOTP_DEFAULT_RECV_* values:
  *
@@ -162,4 +158,24 @@ struct can_isotp_ll_options {
  * consistency and copied directly into the flow control (FC) frame.
  */
 
+/* link layer default values => make use of Classical CAN frames */
+
+#define CAN_ISOTP_DEFAULT_LL_MTU	CAN_MTU
+#define CAN_ISOTP_DEFAULT_LL_TX_DL	CAN_MAX_DLEN
+#define CAN_ISOTP_DEFAULT_LL_TX_FLAGS	0
+
+/*
+ * The CAN_ISOTP_DEFAULT_FRAME_TXTIME has become a non-zero value as
+ * it only makes sense for isotp implementation tests to run without
+ * a N_As value. As user space applications usually do not set the
+ * frame_txtime element of struct can_isotp_options the new in-kernel
+ * default is very likely overwritten with zero when the sockopt()
+ * CAN_ISOTP_OPTS is invoked.
+ * To make sure that a N_As value of zero is only set intentional the
+ * value '0' is now interpreted as 'do not change the current value'.
+ * When a frame_txtime of zero is required for testing purposes this
+ * CAN_ISOTP_FRAME_TXTIME_ZERO u32 value has to be set in frame_txtime.
+ */
+#define CAN_ISOTP_FRAME_TXTIME_ZERO	0xFFFFFFFF
+
 #endif /* !_UAPI_CAN_ISOTP_H */
diff --git a/net/can/isotp.c b/net/can/isotp.c
index a95d171b3a64..5bce7c66c121 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -141,6 +141,7 @@ struct isotp_sock {
 	struct can_isotp_options opt;
 	struct can_isotp_fc_options rxfc, txfc;
 	struct can_isotp_ll_options ll;
+	u32 frame_txtime;
 	u32 force_tx_stmin;
 	u32 force_rx_stmin;
 	struct tpcon rx, tx;
@@ -360,7 +361,7 @@ static int isotp_rcv_fc(struct isotp_sock *so, struct canfd_frame *cf, int ae)
 
 		so->tx_gap = ktime_set(0, 0);
 		/* add transmission time for CAN frame N_As */
-		so->tx_gap = ktime_add_ns(so->tx_gap, so->opt.frame_txtime);
+		so->tx_gap = ktime_add_ns(so->tx_gap, so->frame_txtime);
 		/* add waiting time for consecutive frames N_Cs */
 		if (so->opt.flags & CAN_ISOTP_FORCE_TXSTMIN)
 			so->tx_gap = ktime_add_ns(so->tx_gap,
@@ -1247,6 +1248,14 @@ static int isotp_setsockopt_locked(struct socket *sock, int level, int optname,
 		/* no separate rx_ext_address is given => use ext_address */
 		if (!(so->opt.flags & CAN_ISOTP_RX_EXT_ADDR))
 			so->opt.rx_ext_address = so->opt.ext_address;
+
+		/* check for frame_txtime changes (0 => no changes) */
+		if (so->opt.frame_txtime) {
+			if (so->opt.frame_txtime == CAN_ISOTP_FRAME_TXTIME_ZERO)
+				so->frame_txtime = 0;
+			else
+				so->frame_txtime = so->opt.frame_txtime;
+		}
 		break;
 
 	case CAN_ISOTP_RECV_FC:
@@ -1448,6 +1457,7 @@ static int isotp_init(struct sock *sk)
 	so->opt.rxpad_content = CAN_ISOTP_DEFAULT_PAD_CONTENT;
 	so->opt.txpad_content = CAN_ISOTP_DEFAULT_PAD_CONTENT;
 	so->opt.frame_txtime = CAN_ISOTP_DEFAULT_FRAME_TXTIME;
+	so->frame_txtime = CAN_ISOTP_DEFAULT_FRAME_TXTIME;
 	so->rxfc.bs = CAN_ISOTP_DEFAULT_RECV_BS;
 	so->rxfc.stmin = CAN_ISOTP_DEFAULT_RECV_STMIN;
 	so->rxfc.wftmax = CAN_ISOTP_DEFAULT_RECV_WFTMAX;
-- 
2.35.1



