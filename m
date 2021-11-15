Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3102452194
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244297AbhKPBF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:05:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232985AbhKOTUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 365F563256;
        Mon, 15 Nov 2021 18:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001368;
        bh=WtFVKgepizaNAroPtwf0zcksE36XV6qXp0LKWyUWobk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e32eX7F4P1d2M+eMtlyzWSgbO4Az95iUga4zc71VV1fRBM3umnjjZDe5B3CpE0cJP
         D/Wc1Nzk/sG3amYMieQZjUlyxAhr4oxSEwe4IgzAeh7utsy1Be5i+bNqdE8m7DsPYg
         TOgz78YqHUn/+YObHLhta4ZVdBz/g+M7sxMyQJ0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 130/917] can: j1939: j1939_tp_cmd_recv(): check the dst address of TP.CM_BAM
Date:   Mon, 15 Nov 2021 17:53:45 +0100
Message-Id: <20211115165433.172918991@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
 net/can/j1939/transport.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -2023,6 +2023,11 @@ static void j1939_tp_cmd_recv(struct j19
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


