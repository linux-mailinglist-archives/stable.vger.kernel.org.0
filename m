Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D640150C83
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731301AbgBCQhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:37:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731298AbgBCQhN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:37:13 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BCD62082E;
        Mon,  3 Feb 2020 16:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747832;
        bh=PnGhYvZwFi0lcWRXayC8zBhGlbnyQ7u8vlcKAZSNZvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vO9tmJSbDULrsbmS8H4dvpy5XvWbWAxhwwPr9Gy9Fl8vivgnONvGxPcFpDjUcsDZ/
         MABNEz3EtA3HZDBY/3r8TGzGj/QNuBBMBQRzhChcWZVncNe/VG75dyOjep0f+Zhmz6
         bkWfsxJPLAcG67yXtjW4hPxF+TeKTZ5XERGCvWmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Wiesner <jwiesner@suse.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 88/90] netfilter: conntrack: sctp: use distinct states for new SCTP connections
Date:   Mon,  3 Feb 2020 16:20:31 +0000
Message-Id: <20200203161927.735006699@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Wiesner <jwiesner@suse.com>

[ Upstream commit ab658b9fa7a2c467f79eac8b53ea308b8f98113d ]

The netlink notifications triggered by the INIT and INIT_ACK chunks
for a tracked SCTP association do not include protocol information
for the corresponding connection - SCTP state and verification tags
for the original and reply direction are missing. Since the connection
tracking implementation allows user space programs to receive
notifications about a connection and then create a new connection
based on the values received in a notification, it makes sense that
INIT and INIT_ACK notifications should contain the SCTP state
and verification tags available at the time when a notification
is sent. The missing verification tags cause a newly created
netfilter connection to fail to verify the tags of SCTP packets
when this connection has been created from the values previously
received in an INIT or INIT_ACK notification.

A PROTOINFO event is cached in sctp_packet() when the state
of a connection changes. The CLOSED and COOKIE_WAIT state will
be used for connections that have seen an INIT and INIT_ACK chunk,
respectively. The distinct states will cause a connection state
change in sctp_packet().

Signed-off-by: Jiri Wiesner <jwiesner@suse.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 0399ae8f1188f..4f897b14b6069 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -114,7 +114,7 @@ static const u8 sctp_conntracks[2][11][SCTP_CONNTRACK_MAX] = {
 	{
 /*	ORIGINAL	*/
 /*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA */
-/* init         */ {sCW, sCW, sCW, sCE, sES, sSS, sSR, sSA, sCW, sHA},
+/* init         */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCW, sHA},
 /* init_ack     */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA},
 /* abort        */ {sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL},
 /* shutdown     */ {sCL, sCL, sCW, sCE, sSS, sSS, sSR, sSA, sCL, sSS},
@@ -130,7 +130,7 @@ static const u8 sctp_conntracks[2][11][SCTP_CONNTRACK_MAX] = {
 /*	REPLY	*/
 /*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA */
 /* init         */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA},/* INIT in sCL Big TODO */
-/* init_ack     */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA},
+/* init_ack     */ {sIV, sCW, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA},
 /* abort        */ {sIV, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sIV, sCL},
 /* shutdown     */ {sIV, sCL, sCW, sCE, sSR, sSS, sSR, sSA, sIV, sSR},
 /* shutdown_ack */ {sIV, sCL, sCW, sCE, sES, sSA, sSA, sSA, sIV, sHA},
@@ -316,7 +316,7 @@ sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 			ct->proto.sctp.vtag[IP_CT_DIR_REPLY] = sh->vtag;
 		}
 
-		ct->proto.sctp.state = new_state;
+		ct->proto.sctp.state = SCTP_CONNTRACK_NONE;
 	}
 
 	return true;
-- 
2.20.1



