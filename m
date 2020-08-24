Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77BD24F918
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgHXIp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726830AbgHXIpY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:45:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC76F2075B;
        Mon, 24 Aug 2020 08:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258723;
        bh=1I0FJfJlkGo4/bQRz+yIbSTD2q6adynUdm/vCXmFolc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=osLuVs6S/+Wpt4LKG0tREforHAVZWa8r8spvAiSdZIpRr1hrojCF59g8HPqu7EoLS
         UHc3ttLtpVnj2b6+M4tzK/sl0M1cqR5SwwCyFaYuoITBMe6aEYVP6EiHRo10Vxvf+l
         ciLQ/CXoGTZ5aaP7nYlbnY+Dlb6pGattNIFnkBMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5322482fe520b02aea30@syzkaller.appspotmail.com,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 023/107] can: j1939: transport: j1939_session_tx_dat(): fix use-after-free read in j1939_tp_txtimer()
Date:   Mon, 24 Aug 2020 10:29:49 +0200
Message-Id: <20200824082406.227876409@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit cd3b3636c99fcac52c598b64061f3fe4413c6a12 upstream.

The current stack implementation do not support ECTS requests of not
aligned TP sized blocks.

If ECTS will request a block with size and offset spanning two TP
blocks, this will cause memcpy() to read beyond the queued skb (which
does only contain one TP sized block).

Sometimes KASAN will detect this read if the memory region beyond the
skb was previously allocated and freed. In other situations it will stay
undetected. The ETP transfer in any case will be corrupted.

This patch adds a sanity check to avoid this kind of read and abort the
session with error J1939_XTP_ABORT_ECTS_TOO_BIG.

Reported-by: syzbot+5322482fe520b02aea30@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Cc: linux-stable <stable@vger.kernel.org> # >= v5.4
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20200807105200.26441-3-o.rempel@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/can/j1939/transport.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -787,6 +787,18 @@ static int j1939_session_tx_dat(struct j
 		if (len > 7)
 			len = 7;
 
+		if (offset + len > se_skb->len) {
+			netdev_err_once(priv->ndev,
+					"%s: 0x%p: requested data outside of queued buffer: offset %i, len %i, pkt.tx: %i\n",
+					__func__, session, skcb->offset, se_skb->len , session->pkt.tx);
+			return -EOVERFLOW;
+		}
+
+		if (!len) {
+			ret = -ENOBUFS;
+			break;
+		}
+
 		memcpy(&dat[1], &tpdat[offset], len);
 		ret = j1939_tp_tx_dat(session, dat, len + 1);
 		if (ret < 0) {
@@ -1120,6 +1132,9 @@ static enum hrtimer_restart j1939_tp_txt
 		 * cleanup including propagation of the error to user space.
 		 */
 		break;
+	case -EOVERFLOW:
+		j1939_session_cancel(session, J1939_XTP_ABORT_ECTS_TOO_BIG);
+		break;
 	case 0:
 		session->tx_retry = 0;
 		break;


