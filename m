Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906CF450D17
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238605AbhKORt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:49:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:57918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238673AbhKORrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:47:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0199563297;
        Mon, 15 Nov 2021 17:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997381;
        bh=y+M0CDoxqRUTAzlF3RvjbE5fPWu7c1FTBhFIt1JLHbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dteWIVYEyGUtkNyTVKH7ZWIMr+vmw6ymitR2FK5ISD9k/TEdicrwtzBCTEZcQzcrW
         TpuHvKgymaqKYTTzkVDFUYv+4QLj7LmryMEp0b0kLhdXVb3Fcw87k5D+CFeF2dnvQ0
         a9saOpOryKJM1gNS4Ux43dG+4UPJNLya+ghY27iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 128/575] can: j1939: j1939_tp_cmd_recv(): ignore abort message in the BAM transport
Date:   Mon, 15 Nov 2021 17:57:33 +0100
Message-Id: <20211115165348.142101929@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

commit c0f49d98006f2db3333b917caac65bce2af9865c upstream.

This patch prevents BAM transport from being closed by receiving abort
message, as specified in SAE-J1939-82 2015 (A.3.3 Row 4).

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/all/1635431907-15617-2-git-send-email-zhangchangzhong@huawei.com
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
@@ -2065,6 +2065,12 @@ static void j1939_tp_cmd_recv(struct j19
 		break;
 
 	case J1939_ETP_CMD_ABORT: /* && J1939_TP_CMD_ABORT */
+		if (j1939_cb_is_broadcast(skcb)) {
+			netdev_err_once(priv->ndev, "%s: abort to broadcast (%02x), ignoring!\n",
+					__func__, skcb->addr.sa);
+			return;
+		}
+
 		if (j1939_tp_im_transmitter(skcb))
 			j1939_xtp_rx_abort(priv, skb, true);
 


