Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61B938EEE7
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbhEXPzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235040AbhEXPy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:54:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78D8E6191F;
        Mon, 24 May 2021 15:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870818;
        bh=TM2KUuyDB8NaJB2CiidIrsob6FcjUAVXJa3HAnIJwWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FqJ3NFb25+n/SWmYr1VJOUu/nWSCk7UCZQUbgzoe6I4/4qN6lWReMUoecjPEDBSra
         7PsuwdNq2yMSSn8AetlppS8UHlf80uo4qfN0kVt+binwgkfeY/occ+dQ4IuUOCOi6Y
         l2dzwAxtJ4Ni7e6GBNVda9/cDs9QKszgK08D7W8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 039/104] ALSA: firewire-lib: fix calculation for size of IR context payload
Date:   Mon, 24 May 2021 17:25:34 +0200
Message-Id: <20210524152334.126028361@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
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
@@ -1068,23 +1068,22 @@ static int amdtp_stream_start(struct amd
 		s->data_block_counter = 0;
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


