Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1714417C6
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbhKAJkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233269AbhKAJiB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:38:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5195460C40;
        Mon,  1 Nov 2021 09:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758830;
        bh=Jvpik9FvINvRHA6J9D7wbfFQIuxv3Q3TRsZeMkd0GXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L9LvMGVn1qBeO+lqbrSHKubix/FO4cZ4BO/fr3yUJ2JGvoYn/1HMxuZ8iFL9D4Wi8
         0sJY1xxT8NiRdk/1d7rOaLMUcqHj2Y+GuD7ff1b4I/eq2M2jPz180MtPygUVyyKpMh
         38zbJAj13GUP87UDHi4TvhYREZv0cXxo+Vj2IWZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 69/77] sctp: add vtag check in sctp_sf_do_8_5_1_E_sa
Date:   Mon,  1 Nov 2021 10:17:57 +0100
Message-Id: <20211101082526.027989800@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
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
index 324c0222d9e6..82a76fda226b 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3683,12 +3683,6 @@ static enum sctp_disposition sctp_sf_shut_8_4_5(
 
 	SCTP_INC_STATS(net, SCTP_MIB_OUTCTRLCHUNKS);
 
-	/* If the chunk length is invalid, we don't want to process
-	 * the reset of the packet.
-	 */
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_chunkhdr)))
-		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
-
 	/* We need to discard the rest of the packet to prevent
 	 * potential bomming attacks from additional bundled chunks.
 	 * This is documented in SCTP Threats ID.
@@ -3716,6 +3710,9 @@ enum sctp_disposition sctp_sf_do_8_5_1_E_sa(struct net *net,
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



