Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEA11380E2
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgAKKiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:38:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:56560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728999AbgAKKiN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:38:13 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81C6020848;
        Sat, 11 Jan 2020 10:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578739092;
        bh=z5+SqbdqGinhWk8sMlCTepknVOWj8EdUUdgwxhiX/D0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XGrTR62J9sIY2Nz39Owpc5ev1lKMzHaq3yG9j/0v7gG/AkLhXgDaQfNcPBZu/Xcqb
         heEGaOwXftOoxlAA0xxk4T6cJTv8IrT2zJ8eZJb2xqcWF1gA8QSVWXhhOpubvBbN+f
         yBOgN9WeOIJUGZSH48vcuqT4hIhu8uvSCP/TDynU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Chan Shu Tak, Alex" <alexchan@task.com.hk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 48/59] llc2: Fix return statement of llc_stat_ev_rx_null_dsap_xid_c (and _test_c)
Date:   Sat, 11 Jan 2020 10:49:57 +0100
Message-Id: <20200111094849.096755166@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
References: <20200111094835.417654274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chan Shu Tak, Alex <alexchan@task.com.hk>

[ Upstream commit af1c0e4e00f3cc76cb136ebf2e2c04e8b6446285 ]

When a frame with NULL DSAP is received, llc_station_rcv is called.
In turn, llc_stat_ev_rx_null_dsap_xid_c is called to check if it is a NULL
XID frame. The return statement of llc_stat_ev_rx_null_dsap_xid_c returns 1
when the incoming frame is not a NULL XID frame and 0 otherwise. Hence, a
NULL XID response is returned unexpectedly, e.g. when the incoming frame is
a NULL TEST command.

To fix the error, simply remove the conditional operator.

A similar error in llc_stat_ev_rx_null_dsap_test_c is also fixed.

Signed-off-by: Chan Shu Tak, Alex <alexchan@task.com.hk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/llc/llc_station.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/llc/llc_station.c
+++ b/net/llc/llc_station.c
@@ -32,7 +32,7 @@ static int llc_stat_ev_rx_null_dsap_xid_
 	return LLC_PDU_IS_CMD(pdu) &&			/* command PDU */
 	       LLC_PDU_TYPE_IS_U(pdu) &&		/* U type PDU */
 	       LLC_U_PDU_CMD(pdu) == LLC_1_PDU_CMD_XID &&
-	       !pdu->dsap ? 0 : 1;			/* NULL DSAP value */
+	       !pdu->dsap;				/* NULL DSAP value */
 }
 
 static int llc_stat_ev_rx_null_dsap_test_c(struct sk_buff *skb)
@@ -42,7 +42,7 @@ static int llc_stat_ev_rx_null_dsap_test
 	return LLC_PDU_IS_CMD(pdu) &&			/* command PDU */
 	       LLC_PDU_TYPE_IS_U(pdu) &&		/* U type PDU */
 	       LLC_U_PDU_CMD(pdu) == LLC_1_PDU_CMD_TEST &&
-	       !pdu->dsap ? 0 : 1;			/* NULL DSAP */
+	       !pdu->dsap;				/* NULL DSAP */
 }
 
 static int llc_station_ac_send_xid_r(struct sk_buff *skb)


