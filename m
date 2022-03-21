Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70AFD4E2866
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348266AbiCUN4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 09:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348288AbiCUNzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:55:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2DE1AD87;
        Mon, 21 Mar 2022 06:54:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF3856125C;
        Mon, 21 Mar 2022 13:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0938AC340ED;
        Mon, 21 Mar 2022 13:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647870862;
        bh=2R5EdeFliltwruAyLjLbDPZfvDIF2S8mV0+QpoUR9Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vxq/ZkvOrbgfgdwdZG+kPsVbMdy2epY9NA6Z3lVmCZ1HJx+zKxKgR5k+o2XcXveu7
         RkNdFeSPrZDIjAe9GvtKXeNJf1zaVQw0+NHKEiwMMr36n+NIbm23ncBL4Q3HfCVdJd
         73USDoF/mYnz3+bIUmBzbHTFxV4E2t2fYlVIqLoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 02/22] sctp: fix the processing for INIT_ACK chunk
Date:   Mon, 21 Mar 2022 14:51:33 +0100
Message-Id: <20220321133217.676409404@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133217.602054917@linuxfoundation.org>
References: <20220321133217.602054917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 438b95a7c98f77d51cbf4db021f41b602d750a3f upstream.

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
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_statefuns.c |   37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2221,7 +2221,7 @@ enum sctp_disposition sctp_sf_shutdown_p
 	 */
 	if (SCTP_ADDR_DEL ==
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	if (!sctp_err_chunk_valid(chunk))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -2267,7 +2267,7 @@ enum sctp_disposition sctp_sf_shutdown_s
 	 */
 	if (SCTP_ADDR_DEL ==
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	if (!sctp_err_chunk_valid(chunk))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -2537,7 +2537,7 @@ enum sctp_disposition sctp_sf_do_9_1_abo
 	 */
 	if (SCTP_ADDR_DEL ==
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	if (!sctp_err_chunk_valid(chunk))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -3702,6 +3702,11 @@ enum sctp_disposition sctp_sf_do_asconf(
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
@@ -3709,13 +3714,7 @@ enum sctp_disposition sctp_sf_do_asconf(
 	 * described in [I-D.ietf-tsvwg-sctp-auth].
 	 */
 	if (!net->sctp.addip_noauth && !chunk->auth)
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
@@ -3844,6 +3843,12 @@ enum sctp_disposition sctp_sf_do_asconf_
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
@@ -3851,14 +3856,7 @@ enum sctp_disposition sctp_sf_do_asconf_
 	 * described in [I-D.ietf-tsvwg-sctp-auth].
 	 */
 	if (!net->sctp.addip_noauth && !asconf_ack->auth)
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
@@ -4435,6 +4433,9 @@ enum sctp_disposition sctp_sf_discard_ch
 {
 	struct sctp_chunk *chunk = arg;
 
+	if (asoc && !sctp_vtag_verify(chunk, asoc))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* Make sure that the chunk has a valid length.
 	 * Since we don't know the chunk type, we use a general
 	 * chunkhdr structure to make a comparison.


