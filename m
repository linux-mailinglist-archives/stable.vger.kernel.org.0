Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2018C43A281
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbhJYTtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:49:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237968AbhJYTq6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:46:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80E9D6120D;
        Mon, 25 Oct 2021 19:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190802;
        bh=TD6/T9X43wYxT6EJ6NjhoPf92aJMxzpa2w4AK3IGcK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D66x0aR2vXUoxVvkb/pMtTVxJAt3RT8L8tGclhpGCdTJ89ASm3crcM2aZ1sHhC4nN
         ux1wbYSmlvIrQPDPlfJ5IkxiRll+BaMh1gYGqQnk9GkKKHJnvqiTb80qLFBydoFjrf
         fURx44FovDsEiBYWUfk+YW4uI1r7Bao1cSdYLMUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.14 074/169] can: j1939: j1939_xtp_rx_rts_session_new(): abort TP less than 9 bytes
Date:   Mon, 25 Oct 2021 21:14:15 +0200
Message-Id: <20211025191026.761790773@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

commit a4fbe70c5cb746441d56b28cf88161d9e0e25378 upstream.

The receiver should abort TP if 'total message size' in TP.CM_RTS and
TP.CM_BAM is less than 9 or greater than 1785 [1], but currently the
j1939 stack only checks the upper bound and the receiver will accept
the following broadcast message:

  vcan1  18ECFF00   [8]  20 08 00 02 FF 00 23 01
  vcan1  18EBFF00   [8]  01 00 00 00 00 00 00 00
  vcan1  18EBFF00   [8]  02 00 FF FF FF FF FF FF

This patch adds check for the lower bound and abort illegal TP.

[1] SAE-J1939-82 A.3.4 Row 2 and A.3.6 Row 6.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/all/1634203601-3460-1-git-send-email-zhangchangzhong@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/j1939-priv.h |    1 +
 net/can/j1939/transport.c  |    2 ++
 2 files changed, 3 insertions(+)

--- a/net/can/j1939/j1939-priv.h
+++ b/net/can/j1939/j1939-priv.h
@@ -326,6 +326,7 @@ int j1939_session_activate(struct j1939_
 void j1939_tp_schedule_txtimer(struct j1939_session *session, int msec);
 void j1939_session_timers_cancel(struct j1939_session *session);
 
+#define J1939_MIN_TP_PACKET_SIZE 9
 #define J1939_MAX_TP_PACKET_SIZE (7 * 0xff)
 #define J1939_MAX_ETP_PACKET_SIZE (7 * 0x00ffffff)
 
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1596,6 +1596,8 @@ j1939_session *j1939_xtp_rx_rts_session_
 			abort = J1939_XTP_ABORT_FAULT;
 		else if (len > priv->tp_max_packet_size)
 			abort = J1939_XTP_ABORT_RESOURCE;
+		else if (len < J1939_MIN_TP_PACKET_SIZE)
+			abort = J1939_XTP_ABORT_FAULT;
 	}
 
 	if (abort != J1939_XTP_NO_ABORT) {


