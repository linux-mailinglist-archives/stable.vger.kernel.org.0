Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856BD635859
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236395AbiKWJzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237227AbiKWJyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:54:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041BE114BB2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:50:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5C7CB81EF1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90A1C433C1;
        Wed, 23 Nov 2022 09:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197030;
        bh=1ZvjUImlXalUCBDKfH6n1MDHgSoTmVO8CGYNmVsqsR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nasZyiBUVTtZ0MIkBU5VTHPRd9hhSS4+/SpimSsy7H0G5e9X8/lIVLYCj8s/Er2eJ
         Hi0QG5zbx102FbZrDQSLYpP5fGb89kfzy1xDuD1E1Rf4WUGd8+XxtkGty3NAXqsxcH
         djG5dy9pVqalQDMMJbMsGNkeUgOAXzEfTtS2hzfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 179/314] platform/surface: aggregator: Do not check for repeated unsequenced packets
Date:   Wed, 23 Nov 2022 09:50:24 +0100
Message-Id: <20221123084633.676911013@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit d9a477f643eb3de71fbea5ae6103b800ceb8f547 ]

Currently, we check any received packet whether we have already seen it
previously, regardless of the packet type (sequenced / unsequenced). We
do this by checking the sequence number. This assumes that sequence
numbers are valid for both sequenced and unsequenced packets. However,
this assumption appears to be incorrect.

On some devices, the sequence number field of unsequenced packets (in
particular HID input events on the Surface Pro 9) is always zero. As a
result, the current retransmission check kicks in and discards all but
the first unsequenced packet, breaking (among other things) keyboard and
touchpad input.

Note that we have, so far, only seen packets being retransmitted in
sequenced communication. In particular, this happens when there is an
ACK timeout, causing the EC (or us) to re-send the packet waiting for an
ACK. Arguably, retransmission / duplication of unsequenced packets
should not be an issue as there is no logical condition (such as an ACK
timeout) to determine when a packet should be sent again.

Therefore, remove the retransmission check for unsequenced packets
entirely to resolve the issue.

Fixes: c167b9c7e3d6 ("platform/surface: Add Surface Aggregator subsystem")
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20221113185951.224759-1-luzmaximilian@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../surface/aggregator/ssh_packet_layer.c     | 24 +++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/surface/aggregator/ssh_packet_layer.c b/drivers/platform/surface/aggregator/ssh_packet_layer.c
index 6748fe4ac5d5..def8d7ac541f 100644
--- a/drivers/platform/surface/aggregator/ssh_packet_layer.c
+++ b/drivers/platform/surface/aggregator/ssh_packet_layer.c
@@ -1596,16 +1596,32 @@ static void ssh_ptl_timeout_reap(struct work_struct *work)
 		ssh_ptl_tx_wakeup_packet(ptl);
 }
 
-static bool ssh_ptl_rx_retransmit_check(struct ssh_ptl *ptl, u8 seq)
+static bool ssh_ptl_rx_retransmit_check(struct ssh_ptl *ptl, const struct ssh_frame *frame)
 {
 	int i;
 
+	/*
+	 * Ignore unsequenced packets. On some devices (notably Surface Pro 9),
+	 * unsequenced events will always be sent with SEQ=0x00. Attempting to
+	 * detect retransmission would thus just block all events.
+	 *
+	 * While sequence numbers would also allow detection of retransmitted
+	 * packets in unsequenced communication, they have only ever been used
+	 * to cover edge-cases in sequenced transmission. In particular, the
+	 * only instance of packets being retransmitted (that we are aware of)
+	 * is due to an ACK timeout. As this does not happen in unsequenced
+	 * communication, skip the retransmission check for those packets
+	 * entirely.
+	 */
+	if (frame->type == SSH_FRAME_TYPE_DATA_NSQ)
+		return false;
+
 	/*
 	 * Check if SEQ has been seen recently (i.e. packet was
 	 * re-transmitted and we should ignore it).
 	 */
 	for (i = 0; i < ARRAY_SIZE(ptl->rx.blocked.seqs); i++) {
-		if (likely(ptl->rx.blocked.seqs[i] != seq))
+		if (likely(ptl->rx.blocked.seqs[i] != frame->seq))
 			continue;
 
 		ptl_dbg(ptl, "ptl: ignoring repeated data packet\n");
@@ -1613,7 +1629,7 @@ static bool ssh_ptl_rx_retransmit_check(struct ssh_ptl *ptl, u8 seq)
 	}
 
 	/* Update list of blocked sequence IDs. */
-	ptl->rx.blocked.seqs[ptl->rx.blocked.offset] = seq;
+	ptl->rx.blocked.seqs[ptl->rx.blocked.offset] = frame->seq;
 	ptl->rx.blocked.offset = (ptl->rx.blocked.offset + 1)
 				  % ARRAY_SIZE(ptl->rx.blocked.seqs);
 
@@ -1624,7 +1640,7 @@ static void ssh_ptl_rx_dataframe(struct ssh_ptl *ptl,
 				 const struct ssh_frame *frame,
 				 const struct ssam_span *payload)
 {
-	if (ssh_ptl_rx_retransmit_check(ptl, frame->seq))
+	if (ssh_ptl_rx_retransmit_check(ptl, frame))
 		return;
 
 	ptl->ops.data_received(ptl, payload);
-- 
2.35.1



