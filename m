Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2D138F004
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbhEXQAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234401AbhEXP6T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:58:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 957CA613FE;
        Mon, 24 May 2021 15:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871053;
        bh=2DtR95kMMVrs0ObbwoJNHyN/T4f7yxNTruw2/V0yOGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSw6g7tuKisma1P5Lifq5l6Yny+uOUbYkz4t8ShIjZzyW0kvv7cgb0bQfvhD2Mz8H
         b5fubHgb86qLhh6EaQZ95PNyrH5e3RVB6NuUINv9dL2f4JVLj0hP7hdmAFphtW/3Gu
         3o9tGFkC4VRsqR3MJS8GWik1WwBs+OuxobitRTxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.12 044/127] ALSA: firewire-lib: fix amdtp_packet tracepoints event for packet_index field
Date:   Mon, 24 May 2021 17:26:01 +0200
Message-Id: <20210524152336.337223870@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 814b43127f4ac69332e809152e30773941438aff upstream.

The snd_firewire_lib:amdtp_packet tracepoints event includes index of
packet processed in a context handling. However in IR context, it is not
calculated as expected.

Cc: <stable@vger.kernel.org>
Fixes: 753e717986c2 ("ALSA: firewire-lib: use packet descriptor for IR context")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20210513125652.110249-6-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/amdtp-stream-trace.h |    6 +++---
 sound/firewire/amdtp-stream.c       |   15 +++++++++------
 2 files changed, 12 insertions(+), 9 deletions(-)

--- a/sound/firewire/amdtp-stream-trace.h
+++ b/sound/firewire/amdtp-stream-trace.h
@@ -14,8 +14,8 @@
 #include <linux/tracepoint.h>
 
 TRACE_EVENT(amdtp_packet,
-	TP_PROTO(const struct amdtp_stream *s, u32 cycles, const __be32 *cip_header, unsigned int payload_length, unsigned int data_blocks, unsigned int data_block_counter, unsigned int index),
-	TP_ARGS(s, cycles, cip_header, payload_length, data_blocks, data_block_counter, index),
+	TP_PROTO(const struct amdtp_stream *s, u32 cycles, const __be32 *cip_header, unsigned int payload_length, unsigned int data_blocks, unsigned int data_block_counter, unsigned int packet_index, unsigned int index),
+	TP_ARGS(s, cycles, cip_header, payload_length, data_blocks, data_block_counter, packet_index, index),
 	TP_STRUCT__entry(
 		__field(unsigned int, second)
 		__field(unsigned int, cycle)
@@ -48,7 +48,7 @@ TRACE_EVENT(amdtp_packet,
 		__entry->payload_quadlets = payload_length / sizeof(__be32);
 		__entry->data_blocks = data_blocks;
 		__entry->data_block_counter = data_block_counter,
-		__entry->packet_index = s->packet_index;
+		__entry->packet_index = packet_index;
 		__entry->irq = !!in_interrupt();
 		__entry->index = index;
 	),
--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -526,7 +526,7 @@ static void build_it_pkt_header(struct a
 	}
 
 	trace_amdtp_packet(s, cycle, cip_header, payload_length, data_blocks,
-			   data_block_counter, index);
+			   data_block_counter, s->packet_index, index);
 }
 
 static int check_cip_header(struct amdtp_stream *s, const __be32 *buf,
@@ -630,7 +630,7 @@ static int parse_ir_ctx_header(struct am
 			       unsigned int *payload_length,
 			       unsigned int *data_blocks,
 			       unsigned int *data_block_counter,
-			       unsigned int *syt, unsigned int index)
+			       unsigned int *syt, unsigned int packet_index, unsigned int index)
 {
 	const __be32 *cip_header;
 	int err;
@@ -662,7 +662,7 @@ static int parse_ir_ctx_header(struct am
 	}
 
 	trace_amdtp_packet(s, cycle, cip_header, *payload_length, *data_blocks,
-			   *data_block_counter, index);
+			   *data_block_counter, packet_index, index);
 
 	return err;
 }
@@ -701,12 +701,13 @@ static int generate_device_pkt_descs(str
 				     unsigned int packets)
 {
 	unsigned int dbc = s->data_block_counter;
+	unsigned int packet_index = s->packet_index;
+	unsigned int queue_size = s->queue_size;
 	int i;
 	int err;
 
 	for (i = 0; i < packets; ++i) {
 		struct pkt_desc *desc = descs + i;
-		unsigned int index = (s->packet_index + i) % s->queue_size;
 		unsigned int cycle;
 		unsigned int payload_length;
 		unsigned int data_blocks;
@@ -715,7 +716,7 @@ static int generate_device_pkt_descs(str
 		cycle = compute_cycle_count(ctx_header[1]);
 
 		err = parse_ir_ctx_header(s, cycle, ctx_header, &payload_length,
-					  &data_blocks, &dbc, &syt, i);
+					  &data_blocks, &dbc, &syt, packet_index, i);
 		if (err < 0)
 			return err;
 
@@ -723,13 +724,15 @@ static int generate_device_pkt_descs(str
 		desc->syt = syt;
 		desc->data_blocks = data_blocks;
 		desc->data_block_counter = dbc;
-		desc->ctx_payload = s->buffer.packets[index].buffer;
+		desc->ctx_payload = s->buffer.packets[packet_index].buffer;
 
 		if (!(s->flags & CIP_DBC_IS_END_EVENT))
 			dbc = (dbc + desc->data_blocks) & 0xff;
 
 		ctx_header +=
 			s->ctx_data.tx.ctx_header_size / sizeof(*ctx_header);
+
+		packet_index = (packet_index + 1) % queue_size;
 	}
 
 	s->data_block_counter = dbc;


