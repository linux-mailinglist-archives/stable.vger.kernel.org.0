Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA363420F26
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236914AbhJDNbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237097AbhJDN3z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:29:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C914613AD;
        Mon,  4 Oct 2021 13:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353202;
        bh=/CSU1UQt3B9EPyyzD9OkcwMM9NnbyDRvBgclPSg/Km8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vp3cRoBaCLxnZG3N5HTwWG5mi23uE7c4g/f6Mdrx1TgXkGvbPmvucmsJBixeGj/NL
         WtK6PTFnGCUijOK593INWtmwaK0WBQ7MbUQUAq8/dmEWKsptPvpudZGaB+n+ED9rve
         FttESErzOMEiG8+cB6mRvj8UpPhoMMQrkR+Ss3Tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 036/172] ALSA: firewire-motu: fix truncated bytes in message tracepoints
Date:   Mon,  4 Oct 2021 14:51:26 +0200
Message-Id: <20211004125046.145124019@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit cb1bcf5ed536747013fe2b3f9bd56ce3242c295a upstream.

In MOTU protocol v2/v3, first two data chunks across 2nd and 3rd data
channels includes message bytes from device. The total size of message
is 48 bits per data block.

The 'data_block_message' tracepoints event produced by ALSA firewire-motu
driver exposes the sequence of messages to userspace in 64 bit storage,
however lower 32 bits are actually available since current implementation
truncates 16 bits in upper of the message as a result of bit shift
operation within 32 bit storage.

This commit fixes the bug by perform the bit shift in 64 bit storage.

Fixes: c6b0b9e65f09 ("ALSA: firewire-motu: add tracepoints for messages for unique protocol")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20210920110734.27161-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/motu/amdtp-motu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/firewire/motu/amdtp-motu.c
+++ b/sound/firewire/motu/amdtp-motu.c
@@ -276,10 +276,11 @@ static void __maybe_unused copy_message(
 
 	/* This is just for v2/v3 protocol. */
 	for (i = 0; i < data_blocks; ++i) {
-		*frames = (be32_to_cpu(buffer[1]) << 16) |
-			  (be32_to_cpu(buffer[2]) >> 16);
+		*frames = be32_to_cpu(buffer[1]);
+		*frames <<= 16;
+		*frames |= be32_to_cpu(buffer[2]) >> 16;
+		++frames;
 		buffer += data_block_quadlets;
-		frames++;
 	}
 }
 


