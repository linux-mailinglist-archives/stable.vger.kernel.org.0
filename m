Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6A244165D
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbhKAJYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:24:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232419AbhKAJXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:23:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1814861184;
        Mon,  1 Nov 2021 09:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758436;
        bh=II7iTCVLEc2al9USodFxVDseblv1psbvsiNLubtJpHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lq1nE0Uf7Bs3rznp+/swCpfpH38v5+yy9GGLc6g29ptCjU162u1hi137QESIw27er
         fe4uPxujHa95IAPtUMuC+Ig6V3XOcSr8qB/MJj2ngBiWKS7Ky/G/lB4XqXV3Hknyam
         wpMLdErtMMRy8eIM7WJ6vEU3meLsggJIxGw/s0AQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 22/25] sctp: fix the processing for COOKIE_ECHO chunk
Date:   Mon,  1 Nov 2021 10:17:34 +0100
Message-Id: <20211101082452.217520170@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082447.070493993@linuxfoundation.org>
References: <20211101082447.070493993@linuxfoundation.org>
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
index b1200c4122b0..4b519ec35ab7 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -704,6 +704,9 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 	struct sock *sk;
 	int error = 0;
 
+	if (asoc && !sctp_vtag_verify(chunk, asoc))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* If the packet is an OOTB packet which is temporarily on the
 	 * control endpoint, respond with an ABORT.
 	 */
@@ -718,7 +721,8 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 	 * in sctp_unpack_cookie().
 	 */
 	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_chunkhdr)))
-		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
+						  commands);
 
 	/* If the endpoint is not listening or if the number of associations
 	 * on the TCP-style socket exceed the max backlog, respond with an
@@ -2080,9 +2084,11 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
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



