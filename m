Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E124416B2
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhKAJ2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:28:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232965AbhKAJ0Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:26:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEA54611AF;
        Mon,  1 Nov 2021 09:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758520;
        bh=5/o/pT/eZZ7WrVQ6WCqgQ4oHKoB2BEi3Wa0cV7xv3vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h7brehgfa9IGfHQg9AcYedlkDO/xQkdubBWJ7I4kY86GSICnBHUNQlYYi3Dlta+P5
         Eu/HJLgvFPxRaRRwT94KJ9XXM1+TCRrEy5qrzCGyXqKcuIuMdz+R9sVoH9W9JrltJo
         V6pzqi8S4vHdaZPYoLsvKcmFeB3gcF3ciadO3WEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 32/35] sctp: fix the processing for COOKIE_ECHO chunk
Date:   Mon,  1 Nov 2021 10:17:44 +0100
Message-Id: <20211101082459.276937455@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082451.430720900@linuxfoundation.org>
References: <20211101082451.430720900@linuxfoundation.org>
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
index f57fbe79490a..e93aa08d2a78 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -712,6 +712,9 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 	struct sock *sk;
 	int error = 0;
 
+	if (asoc && !sctp_vtag_verify(chunk, asoc))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* If the packet is an OOTB packet which is temporarily on the
 	 * control endpoint, respond with an ABORT.
 	 */
@@ -726,7 +729,8 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 	 * in sctp_unpack_cookie().
 	 */
 	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_chunkhdr)))
-		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
+						  commands);
 
 	/* If the endpoint is not listening or if the number of associations
 	 * on the TCP-style socket exceed the max backlog, respond with an
@@ -2156,9 +2160,11 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
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



