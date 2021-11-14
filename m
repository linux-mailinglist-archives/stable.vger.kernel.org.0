Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC7444F7D3
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 13:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhKNMYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 07:24:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:41402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230267AbhKNMYT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 07:24:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5873F61056;
        Sun, 14 Nov 2021 12:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636892484;
        bh=eDf6kf65uXOluMGfKc6Md8tU0pg1mZa0PdwMOmSFwE4=;
        h=Subject:To:Cc:From:Date:From;
        b=A6wNzH9XcD80ZZVw2lHpCB0KfyudOcXyxq8WdPvwSWcxNwC9jRu8PuMO1ttqZEMN2
         sUz496d69nuV+c5il1EvBSl+DQ3Ue8wVtXGMu2oLa+Llr0IAKf2M0hElf3SD4MgzE6
         DaTpCHw5HL0qMS79URz8q05X0c3YpWdiHnwv6Y9Y=
Subject: FAILED: patch "[PATCH] can: j1939: j1939_tp_cmd_recv(): check the dst address of" failed to apply to 5.14-stable tree
To:     zhangchangzhong@huawei.com, mkl@pengutronix.de,
        o.rempel@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Nov 2021 13:21:22 +0100
Message-ID: <16368924827684@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 164051a6ab5445bd97f719f50b16db8b32174269 Mon Sep 17 00:00:00 2001
From: Zhang Changzhong <zhangchangzhong@huawei.com>
Date: Thu, 28 Oct 2021 22:38:27 +0800
Subject: [PATCH] can: j1939: j1939_tp_cmd_recv(): check the dst address of
 TP.CM_BAM

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

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 05eb3d059e17..a271688780a2 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -2023,6 +2023,11 @@ static void j1939_tp_cmd_recv(struct j1939_priv *priv, struct sk_buff *skb)
 		extd = J1939_ETP;
 		fallthrough;
 	case J1939_TP_CMD_BAM:
+		if (cmd == J1939_TP_CMD_BAM && !j1939_cb_is_broadcast(skcb)) {
+			netdev_err_once(priv->ndev, "%s: BAM to unicast (%02x), ignoring!\n",
+					__func__, skcb->addr.sa);
+			return;
+		}
 		fallthrough;
 	case J1939_TP_CMD_RTS:
 		if (skcb->addr.type != extd)

