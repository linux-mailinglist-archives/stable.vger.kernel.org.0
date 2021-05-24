Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3558638EED2
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbhEXPzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235094AbhEXPy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:54:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FC5061876;
        Mon, 24 May 2021 15:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870829;
        bh=zcj1N2YsNW4jSa0/pwPpHGaac4BQZlaVdlLqA796S/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I35Eo/NAL/b84ddQaFMfY910147e3AYBT2FPH5o9lGvUODCbmjS8Yv1WBKSvGK/s2
         KVd9NHt9JhmJIJ3RShp0lsxnR6VEkq04cSP2mw4cMh/DEcQgRE70TdVvFqWojVq09W
         vLbwNkwm/sgkOY+XLmdahnXpK3E+vywY+jjFM0Jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 044/104] ALSA: firewire-lib: fix check for the size of isochronous packet payload
Date:   Mon, 24 May 2021 17:25:39 +0200
Message-Id: <20210524152334.281414775@linuxfoundation.org>
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

commit 395f41e2cdac63e7581fb9574e5ac0f02556e34a upstream.

The check for size of isochronous packet payload just cares of the size of
IR context payload without the size of CIP header.

Cc: <stable@vger.kernel.org>
Fixes: f11453c7cc01 ("ALSA: firewire-lib: use 16 bytes IR context header to separate CIP header")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20210513125652.110249-4-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/amdtp-stream.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -633,18 +633,24 @@ static int parse_ir_ctx_header(struct am
 			       unsigned int *syt, unsigned int packet_index, unsigned int index)
 {
 	const __be32 *cip_header;
+	unsigned int cip_header_size;
 	int err;
 
 	*payload_length = be32_to_cpu(ctx_header[0]) >> ISO_DATA_LENGTH_SHIFT;
-	if (*payload_length > s->ctx_data.tx.ctx_header_size +
-					s->ctx_data.tx.max_ctx_payload_length) {
+
+	if (!(s->flags & CIP_NO_HEADER))
+		cip_header_size = 8;
+	else
+		cip_header_size = 0;
+
+	if (*payload_length > cip_header_size + s->ctx_data.tx.max_ctx_payload_length) {
 		dev_err(&s->unit->device,
 			"Detect jumbo payload: %04x %04x\n",
-			*payload_length, s->ctx_data.tx.max_ctx_payload_length);
+			*payload_length, cip_header_size + s->ctx_data.tx.max_ctx_payload_length);
 		return -EIO;
 	}
 
-	if (!(s->flags & CIP_NO_HEADER)) {
+	if (cip_header_size > 0) {
 		cip_header = ctx_header + 2;
 		err = check_cip_header(s, cip_header, *payload_length,
 				       data_blocks, data_block_counter, syt);


