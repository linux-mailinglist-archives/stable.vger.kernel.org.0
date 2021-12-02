Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD986466743
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 16:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359249AbhLBP40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Dec 2021 10:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359274AbhLBP4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Dec 2021 10:56:23 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7855C06175C
        for <stable@vger.kernel.org>; Thu,  2 Dec 2021 07:53:00 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1msoOJ-0006tB-B2
        for stable@vger.kernel.org; Thu, 02 Dec 2021 16:52:59 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 50A506BAE98
        for <stable@vger.kernel.org>; Thu,  2 Dec 2021 15:52:58 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D33E86BAE92;
        Thu,  2 Dec 2021 15:52:57 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id b597a57e;
        Thu, 2 Dec 2021 15:52:57 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     stable@vger.kernel.org
Cc:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH] can: j1939: j1939_tp_cmd_recv(): check the dst address of TP.CM_BAM
Date:   Thu,  2 Dec 2021 16:52:56 +0100
Message-Id: <20211202155256.2405492-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
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
Link: https://lore.kernel.org/all/20211201102549.3079360-1-o.rempel@pengutronix.de
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
changes:
 - rebase against v5.4.162

 net/can/j1939/transport.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 811682e06951..22f4b798d385 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -2004,6 +2004,12 @@ static void j1939_tp_cmd_recv(struct j1939_priv *priv, struct sk_buff *skb)
 		extd = J1939_ETP;
 		/* fall through */
 	case J1939_TP_CMD_BAM: /* fall through */
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
2.33.0


