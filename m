Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A8638EE74
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhEXPu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:50:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234073AbhEXPs0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:48:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0AAE6140C;
        Mon, 24 May 2021 15:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870643;
        bh=r+qOUP8I1x0Uf3zaMaSpwtVegyi7cRYHHzO84PIlcko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GRkp8SRpPCkP+QA+VMJO1uMreQhk/OKAzv105Xm0r9oLgMAu+xiK4JTSM6WLCSuS0
         9O28OXoYQ7jVI8GBGsEpk2SPZ+x3pf3wZcRusCwtvrW7AmkgEP/Wp1UkCkb7/tOGjC
         686agVVyPOPQnFvydbj/5l/PkvOd09e8DWfeORVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 22/71] ALSA: firewire-lib: fix calculation for size of IR context payload
Date:   Mon, 24 May 2021 17:25:28 +0200
Message-Id: <20210524152327.185524929@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 1be4f21d9984fa9835fae5411a29465dc5aece6f upstream.

The quadlets for CIP header is handled as a part of IR context header,
thus it doesn't join in IR context payload. However current calculation
includes the quadlets in IR context payload.

Cc: <stable@vger.kernel.org>
Fixes: f11453c7cc01 ("ALSA: firewire-lib: use 16 bytes IR context header to separate CIP header")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20210513125652.110249-5-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/amdtp-stream.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -932,23 +932,22 @@ static int amdtp_stream_start(struct amd
 		s->ctx_data.rx.last_syt_offset = TICKS_PER_CYCLE;
 	}
 
-	/* initialize packet buffer */
+	// initialize packet buffer.
+	max_ctx_payload_size = amdtp_stream_get_max_payload(s);
 	if (s->direction == AMDTP_IN_STREAM) {
 		dir = DMA_FROM_DEVICE;
 		type = FW_ISO_CONTEXT_RECEIVE;
-		if (!(s->flags & CIP_NO_HEADER))
+		if (!(s->flags & CIP_NO_HEADER)) {
+			max_ctx_payload_size -= 8;
 			ctx_header_size = IR_CTX_HEADER_SIZE_CIP;
-		else
+		} else {
 			ctx_header_size = IR_CTX_HEADER_SIZE_NO_CIP;
-
-		max_ctx_payload_size = amdtp_stream_get_max_payload(s) -
-				       ctx_header_size;
+		}
 	} else {
 		dir = DMA_TO_DEVICE;
 		type = FW_ISO_CONTEXT_TRANSMIT;
 		ctx_header_size = 0;	// No effect for IT context.
 
-		max_ctx_payload_size = amdtp_stream_get_max_payload(s);
 		if (!(s->flags & CIP_NO_HEADER))
 			max_ctx_payload_size -= IT_PKT_HEADER_SIZE_CIP;
 	}


