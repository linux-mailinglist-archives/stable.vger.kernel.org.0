Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492E94418D6
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbhKAJwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233408AbhKAJu3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:50:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B91B61439;
        Mon,  1 Nov 2021 09:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759115;
        bh=efPM579YBLHKAAj/br+sc6qYylEhtLHcHwhrAYG7VTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W306T/Ew2ZBfUOKtcjWVDH0kNjYfzsu1FllZBkn+OvnRLIQGgl2RmlGsmyukx8O+g
         6GYUdGBshg1zuegzvU51AjQxBXXXzlYaFGAU6Ayhv1Av8hV19BGZwvDprU2NMlM1Qi
         div+oeA5ORD2LKbdIkcYoUf+U2pl1bBQgIhWjo20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 104/125] sctp: add vtag check in sctp_sf_do_8_5_1_E_sa
Date:   Mon,  1 Nov 2021 10:17:57 +0100
Message-Id: <20211101082552.790765313@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit ef16b1734f0a176277b7bb9c71a6d977a6ef3998 ]

sctp_sf_do_8_5_1_E_sa() is called when processing SHUTDOWN_ACK chunk
in cookie_wait and cookie_echoed state.

The vtag in the chunk's sctphdr should be verified, otherwise, as
later in chunk length check, it may send abort with the existent
asoc's vtag, which can be exploited by one to cook a malicious
chunk to terminate a SCTP asoc.

Note that when fails to verify the vtag from SHUTDOWN-ACK chunk,
SHUTDOWN COMPLETE message will still be sent back to peer, but
with the vtag from SHUTDOWN-ACK chunk, as said in 5) of
rfc4960#section-8.4.

While at it, also remove the unnecessary chunk length check from
sctp_sf_shut_8_4_5(), as it's already done in both places where
it calls sctp_sf_shut_8_4_5().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 36328ab88bdd..a3545498a038 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3803,12 +3803,6 @@ static enum sctp_disposition sctp_sf_shut_8_4_5(
 
 	SCTP_INC_STATS(net, SCTP_MIB_OUTCTRLCHUNKS);
 
-	/* If the chunk length is invalid, we don't want to process
-	 * the reset of the packet.
-	 */
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_chunkhdr)))
-		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
-
 	/* We need to discard the rest of the packet to prevent
 	 * potential boomming attacks from additional bundled chunks.
 	 * This is documented in SCTP Threats ID.
@@ -3836,6 +3830,9 @@ enum sctp_disposition sctp_sf_do_8_5_1_E_sa(struct net *net,
 {
 	struct sctp_chunk *chunk = arg;
 
+	if (!sctp_vtag_verify(chunk, asoc))
+		asoc = NULL;
+
 	/* Make sure that the SHUTDOWN_ACK chunk has a valid length. */
 	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_chunkhdr)))
 		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-- 
2.33.0



