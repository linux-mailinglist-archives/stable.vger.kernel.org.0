Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1156D464B93
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 11:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348619AbhLAK3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 05:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348642AbhLAK3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 05:29:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430DEC061574
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 02:25:54 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1msMoC-0003rN-8s; Wed, 01 Dec 2021 11:25:52 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1msMoA-00Cv5r-Sq; Wed, 01 Dec 2021 11:25:50 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     stable@vger.kernel.org
Cc:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH v1] can: j1939: j1939_tp_cmd_recv(): check the dst address of TP.CM_BAM
Date:   Wed,  1 Dec 2021 11:25:49 +0100
Message-Id: <20211201102549.3079360-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

commit 164051a6ab5445bd97f719f50b16db8b32174269 upstream.

The TP.CM_BAM message must be sent to the global address [1], so add a
check to drop TP.CM_BAM sent to a non-global address.

Without this patch, the receiver will treat the following packets as
normal RTS/CTS transport:
18EC0102#20090002FF002301
18EB0102#0100000000000000
18EB0102#020000FFFFFFFFFF

[1] SAE-J1939-82 2015 A.3.3 Row 1.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/all/1635431907-15617-4-git-send-email-zhangchangzhong@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
changes:
 - rebase against v5.10.82

 net/can/j1939/transport.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index fe35fdad35c9..9c39b0f5d6e0 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -2004,6 +2004,12 @@ static void j1939_tp_cmd_recv(struct j1939_priv *priv, struct sk_buff *skb)
 		extd = J1939_ETP;
 		fallthrough;
 	case J1939_TP_CMD_BAM:
+		if (cmd == J1939_TP_CMD_BAM && !j1939_cb_is_broadcast(skcb)) {
+			netdev_err_once(priv->ndev, "%s: BAM to unicast (%02x), ignoring!\n",
+					__func__, skcb->addr.sa);
+			return;
+		}
+		fallthrough;
 	case J1939_TP_CMD_RTS: /* fall through */
 		if (skcb->addr.type != extd)
 			return;
-- 
2.30.2

