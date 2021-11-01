Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165BE4417C2
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbhKAJjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:39:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232556AbhKAJhs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:37:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE038611CA;
        Mon,  1 Nov 2021 09:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758807;
        bh=uSR3PZPp5qtAhh3J7+ecbG6Ur4HJljEGrS071nObm7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbZJ72VeeEq7fqdjHp4ZSvTzhhhywlpAUPj6GhSZUg64CM6xbyvs06OLtfPwpAI4t
         uQFSMS9RIe5JvOaI75C0siIXUPNIhlVJFXxVve8lbgnck/DjkDNcRCAhWVaI/NpkDa
         odj3hakIt0mS9a8yQb6vvjOLF4f1E2NBHsyxx+bI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 66/77] sctp: fix the processing for INIT_ACK chunk
Date:   Mon,  1 Nov 2021 10:17:54 +0100
Message-Id: <20211101082525.458195463@linuxfoundation.org>
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

[ Upstream commit 438b95a7c98f77d51cbf4db021f41b602d750a3f ]

Currently INIT_ACK chunk in non-cookie_echoed state is processed in
sctp_sf_discard_chunk() to send an abort with the existent asoc's
vtag if the chunk length is not valid. But the vtag in the chunk's
sctphdr is not verified, which may be exploited by one to cook a
malicious chunk to terminal a SCTP asoc.

sctp_sf_discard_chunk() also is called in many other places to send
an abort, and most of those have this problem. This patch is to fix
it by sending abort with the existent asoc's vtag only if the vtag
from the chunk's sctphdr is verified in sctp_sf_discard_chunk().

Note on sctp_sf_do_9_1_abort() and sctp_sf_shutdown_pending_abort(),
the chunk length has been verified before sctp_sf_discard_chunk(),
so replace it with sctp_sf_discard(). On sctp_sf_do_asconf_ack() and
sctp_sf_do_asconf(), move the sctp_chunk_length_valid check ahead of
sctp_sf_discard_chunk(), then replace it with sctp_sf_discard().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 89a86728184d..5063f9884367 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2280,7 +2280,7 @@ enum sctp_disposition sctp_sf_shutdown_pending_abort(
 	 */
 	if (SCTP_ADDR_DEL ==
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	if (!sctp_err_chunk_valid(chunk))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -2326,7 +2326,7 @@ enum sctp_disposition sctp_sf_shutdown_sent_abort(
 	 */
 	if (SCTP_ADDR_DEL ==
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	if (!sctp_err_chunk_valid(chunk))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -2596,7 +2596,7 @@ enum sctp_disposition sctp_sf_do_9_1_abort(
 	 */
 	if (SCTP_ADDR_DEL ==
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	if (!sctp_err_chunk_valid(chunk))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -3745,6 +3745,11 @@ enum sctp_disposition sctp_sf_do_asconf(struct net *net,
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
 
+	/* Make sure that the ASCONF ADDIP chunk has a valid length.  */
+	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_addip_chunk)))
+		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
+						  commands);
+
 	/* ADD-IP: Section 4.1.1
 	 * This chunk MUST be sent in an authenticated way by using
 	 * the mechanism defined in [I-D.ietf-tsvwg-sctp-auth]. If this chunk
@@ -3753,13 +3758,7 @@ enum sctp_disposition sctp_sf_do_asconf(struct net *net,
 	 */
 	if (!asoc->peer.asconf_capable ||
 	    (!net->sctp.addip_noauth && !chunk->auth))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg,
-					     commands);
-
-	/* Make sure that the ASCONF ADDIP chunk has a valid length.  */
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_addip_chunk)))
-		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-						  commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	hdr = (struct sctp_addiphdr *)chunk->skb->data;
 	serial = ntohl(hdr->serial);
@@ -3888,6 +3887,12 @@ enum sctp_disposition sctp_sf_do_asconf_ack(struct net *net,
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
 
+	/* Make sure that the ADDIP chunk has a valid length.  */
+	if (!sctp_chunk_length_valid(asconf_ack,
+				     sizeof(struct sctp_addip_chunk)))
+		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
+						  commands);
+
 	/* ADD-IP, Section 4.1.2:
 	 * This chunk MUST be sent in an authenticated way by using
 	 * the mechanism defined in [I-D.ietf-tsvwg-sctp-auth]. If this chunk
@@ -3896,14 +3901,7 @@ enum sctp_disposition sctp_sf_do_asconf_ack(struct net *net,
 	 */
 	if (!asoc->peer.asconf_capable ||
 	    (!net->sctp.addip_noauth && !asconf_ack->auth))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg,
-					     commands);
-
-	/* Make sure that the ADDIP chunk has a valid length.  */
-	if (!sctp_chunk_length_valid(asconf_ack,
-				     sizeof(struct sctp_addip_chunk)))
-		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-						  commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	addip_hdr = (struct sctp_addiphdr *)asconf_ack->skb->data;
 	rcvd_serial = ntohl(addip_hdr->serial);
@@ -4475,6 +4473,9 @@ enum sctp_disposition sctp_sf_discard_chunk(struct net *net,
 {
 	struct sctp_chunk *chunk = arg;
 
+	if (asoc && !sctp_vtag_verify(chunk, asoc))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* Make sure that the chunk has a valid length.
 	 * Since we don't know the chunk type, we use a general
 	 * chunkhdr structure to make a comparison.
-- 
2.33.0



