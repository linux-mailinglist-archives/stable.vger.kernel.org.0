Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A1838EE8F
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbhEXPwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234858AbhEXPuC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:50:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C48AA61585;
        Mon, 24 May 2021 15:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870684;
        bh=cm7Tes5q7JSWslAR3+hzlASBI9+ebVmkT1VG5UktXy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAqeHlS9Ivtq2BXXSKe++kIEFZMzY3/iyTBRYIDyEkbL3z+WkiOWgnXROAm8Jn3LF
         /GnykuEXwnEfc7DAEu0/EGnpxxdVjxClKT88sAaB3rRJbqqkK1pc3dRPIGnHc+dv0k
         rC/Et4AmIxrNSkqwO+RjJXDr3ulo9bbvrzxhUB8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 27/71] ALSA: firewire-lib: fix check for the size of isochronous packet payload
Date:   Mon, 24 May 2021 17:25:33 +0200
Message-Id: <20210524152327.343017478@linuxfoundation.org>
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
@@ -617,18 +617,24 @@ static int parse_ir_ctx_header(struct am
 			       unsigned int *syt, unsigned int index)
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


