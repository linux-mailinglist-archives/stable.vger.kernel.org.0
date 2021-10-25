Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7ED43A13E
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236168AbhJYThy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236622AbhJYTfA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:35:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8A8961106;
        Mon, 25 Oct 2021 19:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190301;
        bh=NrQgn9bc0tPgd+GccU8516edMKipbeF9wiI+ndUsYBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bv/nIwjYE2qRc+5WnnbYnBX/PkodYAYjugV6S8LGJqjsX3NKa9LkH9P03nEEp4XUG
         8QErLlx7AUH/+AKpr3ORq8YzkNPkakVkzToU79OsNeqERv1DMZ2HuX8dm82CZsdN7+
         dDzAOi5nluywoGUNu5R/TUt03fnppyatbz2nHRJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 41/95] can: j1939: j1939_xtp_rx_dat_one(): cancel session if receive TP.DT with error length
Date:   Mon, 25 Oct 2021 21:14:38 +0200
Message-Id: <20211025191002.726895026@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

commit 379743985ab6cfe2cbd32067cf4ed497baca6d06 upstream.

According to SAE-J1939-21, the data length of TP.DT must be 8 bytes, so
cancel session when receive unexpected TP.DT message.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/all/1632972800-45091-1-git-send-email-zhangchangzhong@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/transport.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1770,6 +1770,7 @@ static void j1939_xtp_rx_dpo(struct j193
 static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 				 struct sk_buff *skb)
 {
+	enum j1939_xtp_abort abort = J1939_XTP_ABORT_FAULT;
 	struct j1939_priv *priv = session->priv;
 	struct j1939_sk_buff_cb *skcb;
 	struct sk_buff *se_skb = NULL;
@@ -1784,9 +1785,11 @@ static void j1939_xtp_rx_dat_one(struct
 
 	skcb = j1939_skb_to_cb(skb);
 	dat = skb->data;
-	if (skb->len <= 1)
+	if (skb->len != 8) {
 		/* makes no sense */
+		abort = J1939_XTP_ABORT_UNEXPECTED_DATA;
 		goto out_session_cancel;
+	}
 
 	switch (session->last_cmd) {
 	case 0xff:
@@ -1884,7 +1887,7 @@ static void j1939_xtp_rx_dat_one(struct
  out_session_cancel:
 	kfree_skb(se_skb);
 	j1939_session_timers_cancel(session);
-	j1939_session_cancel(session, J1939_XTP_ABORT_FAULT);
+	j1939_session_cancel(session, abort);
 	j1939_session_put(session);
 }
 


