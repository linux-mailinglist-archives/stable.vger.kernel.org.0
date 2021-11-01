Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C5F441711
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbhKAJcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232824AbhKAJaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:30:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5755610CF;
        Mon,  1 Nov 2021 09:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758630;
        bh=nb4W6rpvlwnBtQmWNsvT+tBNSfraqz74zKDUZ2J1/DE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhXLmmiJi10hrgwPk/9O2RcfR5bw7IC3NW+w3XieT7Us1uSsWibKzIPa+aOhQBKbk
         /cZzJ2y2UFrHZYted7cwu1oY+t3BLqNclBxYp1K/KxRFnW6rhCbKHpKvNEuMaPWMEL
         jXNeaIsU7FsLj2XbZPWYGwBJtQUFooIDGEACTEOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 43/51] sctp: fix the processing for COOKIE_ECHO chunk
Date:   Mon,  1 Nov 2021 10:17:47 +0100
Message-Id: <20211101082510.757130560@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit a64b341b8695e1c744dd972b39868371b4f68f83 ]

1. In closed state: in sctp_sf_do_5_1D_ce():

  When asoc is NULL, making packet for abort will use chunk's vtag
  in sctp_ootb_pkt_new(). But when asoc exists, vtag from the chunk
  should be verified before using peer.i.init_tag to make packet
  for abort in sctp_ootb_pkt_new(), and just discard it if vtag is
  not correct.

2. In the other states: in sctp_sf_do_5_2_4_dupcook():

  asoc always exists, but duplicate cookie_echo's vtag will be
  handled by sctp_tietags_compare() and then take actions, so before
  that we only verify the vtag for the abort sent for invalid chunk
  length.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 80e19f5d1738..1e3f6be5bab9 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -697,6 +697,9 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 	struct sock *sk;
 	int error = 0;
 
+	if (asoc && !sctp_vtag_verify(chunk, asoc))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* If the packet is an OOTB packet which is temporarily on the
 	 * control endpoint, respond with an ABORT.
 	 */
@@ -711,7 +714,8 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 	 * in sctp_unpack_cookie().
 	 */
 	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_chunkhdr)))
-		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
+						  commands);
 
 	/* If the endpoint is not listening or if the number of associations
 	 * on the TCP-style socket exceed the max backlog, respond with an
@@ -2141,9 +2145,11 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
 	 * enough for the chunk header.  Cookie length verification is
 	 * done later.
 	 */
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_chunkhdr)))
-		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-						  commands);
+	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_chunkhdr))) {
+		if (!sctp_vtag_verify(chunk, asoc))
+			asoc = NULL;
+		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg, commands);
+	}
 
 	/* "Decode" the chunk.  We have no optional parameters so we
 	 * are in good shape.
-- 
2.33.0



