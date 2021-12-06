Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52BB469D20
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356736AbhLFP2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350634AbhLFPXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:23:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A55C07E5F9;
        Mon,  6 Dec 2021 07:15:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3009961353;
        Mon,  6 Dec 2021 15:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1572BC341C5;
        Mon,  6 Dec 2021 15:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803711;
        bh=SRQgfmhUdPPUWBu/YOOKlFGF+Dsqe8daOxTHu7Rg9FA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WW7HWaySjJ4uc2R+e/Hdi8+WsioFcWKqwejU2qN6o3eglHM/jhS0NPZHmyBq1o61X
         X/qxMbGRMgq2qInhq7X+u/Pm2YaEh/dqvcVwtVZw0Kh9lSm3gxx6dptqkfiDQLboCD
         BqdmgbWa2Q5wIlFUXFbPMQklnSXlWSBWn+GCagLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 002/130] can: j1939: j1939_tp_cmd_recv(): check the dst address of TP.CM_BAM
Date:   Mon,  6 Dec 2021 15:55:19 +0100
Message-Id: <20211206145559.698838843@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/can/j1939/transport.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -2004,6 +2004,12 @@ static void j1939_tp_cmd_recv(struct j19
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


