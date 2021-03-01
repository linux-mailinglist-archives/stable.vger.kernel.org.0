Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82DB329140
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243164AbhCAUXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:23:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:40994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242736AbhCAUQM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:16:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF31165164;
        Mon,  1 Mar 2021 18:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621745;
        bh=drLlJvlSfwAeKnvGYCbhCoG2wefxD2R9+izg7SVj/Tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2Sq+lUvL4Hx/4qdNJ0kMevbkfeUENLAh5j4hHuWJdUTJIyMgh3wsXPsq6aeYQ5A3
         cidE5Bf/oLoShKWsOuFaJ5slnjPlhlKtE9hNDhu9vu62iuiue1Ti1SXQN6ZUHEwHhE
         qpWGA6aK/f/Z1dlipwf/m9qO0Ccd4gOVCL80svUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 598/775] ALSA: fireface: fix to parse sync status register of latter protocol
Date:   Mon,  1 Mar 2021 17:12:46 +0100
Message-Id: <20210301161230.973019071@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit c50bfc8a6866775be39d7e747e83e8a5a9051e2e upstream.

Fireface UCX, UFX, and FF802 are categorized for latter protocol of the
series. Current support for FF802 (and UFX) includes failure to parse
sync status register and results in EIO.

Further investigation figures out that the content of register differs
depending on models. This commit adds tables specific to FF802 and UFX
to fix it.

Fixes: 062bb452b078b ("ALSA: fireface: add support for RME FireFace 802")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20210207154736.229551-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/fireface/ff-protocol-latter.c |  118 ++++++++++++++++++++++-----
 1 file changed, 100 insertions(+), 18 deletions(-)

--- a/sound/firewire/fireface/ff-protocol-latter.c
+++ b/sound/firewire/fireface/ff-protocol-latter.c
@@ -15,6 +15,61 @@
 #define LATTER_FETCH_MODE	0xffff00000010ULL
 #define LATTER_SYNC_STATUS	0x0000801c0000ULL
 
+// The content of sync status register differs between models.
+//
+// Fireface UCX:
+//  0xf0000000: (unidentified)
+//  0x0f000000: effective rate of sampling clock
+//  0x00f00000: detected rate of word clock on BNC interface
+//  0x000f0000: detected rate of ADAT or S/PDIF on optical interface
+//  0x0000f000: detected rate of S/PDIF on coaxial interface
+//  0x00000e00: effective source of sampling clock
+//    0x00000e00: Internal
+//    0x00000800: (unidentified)
+//    0x00000600: Word clock on BNC interface
+//    0x00000400: ADAT on optical interface
+//    0x00000200: S/PDIF on coaxial or optical interface
+//  0x00000100: Optical interface is used for ADAT signal
+//  0x00000080: (unidentified)
+//  0x00000040: Synchronized to word clock on BNC interface
+//  0x00000020: Synchronized to ADAT or S/PDIF on optical interface
+//  0x00000010: Synchronized to S/PDIF on coaxial interface
+//  0x00000008: (unidentified)
+//  0x00000004: Lock word clock on BNC interface
+//  0x00000002: Lock ADAT or S/PDIF on optical interface
+//  0x00000001: Lock S/PDIF on coaxial interface
+//
+// Fireface 802 (and perhaps UFX):
+//   0xf0000000: effective rate of sampling clock
+//   0x0f000000: detected rate of ADAT-B on 2nd optical interface
+//   0x00f00000: detected rate of ADAT-A on 1st optical interface
+//   0x000f0000: detected rate of AES/EBU on XLR or coaxial interface
+//   0x0000f000: detected rate of word clock on BNC interface
+//   0x00000e00: effective source of sampling clock
+//     0x00000e00: internal
+//     0x00000800: ADAT-B
+//     0x00000600: ADAT-A
+//     0x00000400: AES/EBU
+//     0x00000200: Word clock
+//   0x00000080: Synchronized to ADAT-B on 2nd optical interface
+//   0x00000040: Synchronized to ADAT-A on 1st optical interface
+//   0x00000020: Synchronized to AES/EBU on XLR or 2nd optical interface
+//   0x00000010: Synchronized to word clock on BNC interface
+//   0x00000008: Lock ADAT-B on 2nd optical interface
+//   0x00000004: Lock ADAT-A on 1st optical interface
+//   0x00000002: Lock AES/EBU on XLR or 2nd optical interface
+//   0x00000001: Lock word clock on BNC interface
+//
+// The pattern for rate bits:
+//   0x00: 32.0 kHz
+//   0x01: 44.1 kHz
+//   0x02: 48.0 kHz
+//   0x04: 64.0 kHz
+//   0x05: 88.2 kHz
+//   0x06: 96.0 kHz
+//   0x08: 128.0 kHz
+//   0x09: 176.4 kHz
+//   0x0a: 192.0 kHz
 static int parse_clock_bits(u32 data, unsigned int *rate,
 			    enum snd_ff_clock_src *src,
 			    enum snd_ff_unit_version unit_version)
@@ -23,35 +78,48 @@ static int parse_clock_bits(u32 data, un
 		unsigned int rate;
 		u32 flag;
 	} *rate_entry, rate_entries[] = {
-		{ 32000,	0x00000000, },
-		{ 44100,	0x01000000, },
-		{ 48000,	0x02000000, },
-		{ 64000,	0x04000000, },
-		{ 88200,	0x05000000, },
-		{ 96000,	0x06000000, },
-		{ 128000,	0x08000000, },
-		{ 176400,	0x09000000, },
-		{ 192000,	0x0a000000, },
+		{ 32000,	0x00, },
+		{ 44100,	0x01, },
+		{ 48000,	0x02, },
+		{ 64000,	0x04, },
+		{ 88200,	0x05, },
+		{ 96000,	0x06, },
+		{ 128000,	0x08, },
+		{ 176400,	0x09, },
+		{ 192000,	0x0a, },
 	};
 	static const struct {
 		enum snd_ff_clock_src src;
 		u32 flag;
-	} *clk_entry, clk_entries[] = {
+	} *clk_entry, *clk_entries, ucx_clk_entries[] = {
 		{ SND_FF_CLOCK_SRC_SPDIF,	0x00000200, },
 		{ SND_FF_CLOCK_SRC_ADAT1,	0x00000400, },
 		{ SND_FF_CLOCK_SRC_WORD,	0x00000600, },
 		{ SND_FF_CLOCK_SRC_INTERNAL,	0x00000e00, },
+	}, ufx_ff802_clk_entries[] = {
+		{ SND_FF_CLOCK_SRC_WORD,	0x00000200, },
+		{ SND_FF_CLOCK_SRC_SPDIF,	0x00000400, },
+		{ SND_FF_CLOCK_SRC_ADAT1,	0x00000600, },
+		{ SND_FF_CLOCK_SRC_ADAT2,	0x00000800, },
+		{ SND_FF_CLOCK_SRC_INTERNAL,	0x00000e00, },
 	};
+	u32 rate_bits;
+	unsigned int clk_entry_count;
 	int i;
 
-	if (unit_version != SND_FF_UNIT_VERSION_UCX) {
-		// e.g. 0x00fe0f20 but expected 0x00eff002.
-		data = ((data & 0xf0f0f0f0) >> 4) | ((data & 0x0f0f0f0f) << 4);
+	if (unit_version == SND_FF_UNIT_VERSION_UCX) {
+		rate_bits = (data & 0x0f000000) >> 24;
+		clk_entries = ucx_clk_entries;
+		clk_entry_count = ARRAY_SIZE(ucx_clk_entries);
+	} else {
+		rate_bits = (data & 0xf0000000) >> 28;
+		clk_entries = ufx_ff802_clk_entries;
+		clk_entry_count = ARRAY_SIZE(ufx_ff802_clk_entries);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(rate_entries); ++i) {
 		rate_entry = rate_entries + i;
-		if ((data & 0x0f000000) == rate_entry->flag) {
+		if (rate_bits == rate_entry->flag) {
 			*rate = rate_entry->rate;
 			break;
 		}
@@ -59,14 +127,14 @@ static int parse_clock_bits(u32 data, un
 	if (i == ARRAY_SIZE(rate_entries))
 		return -EIO;
 
-	for (i = 0; i < ARRAY_SIZE(clk_entries); ++i) {
+	for (i = 0; i < clk_entry_count; ++i) {
 		clk_entry = clk_entries + i;
 		if ((data & 0x000e00) == clk_entry->flag) {
 			*src = clk_entry->src;
 			break;
 		}
 	}
-	if (i == ARRAY_SIZE(clk_entries))
+	if (i == clk_entry_count)
 		return -EIO;
 
 	return 0;
@@ -249,16 +317,22 @@ static void latter_dump_status(struct sn
 		char *const label;
 		u32 locked_mask;
 		u32 synced_mask;
-	} *clk_entry, clk_entries[] = {
+	} *clk_entry, *clk_entries, ucx_clk_entries[] = {
 		{ "S/PDIF",	0x00000001, 0x00000010, },
 		{ "ADAT",	0x00000002, 0x00000020, },
 		{ "WDClk",	0x00000004, 0x00000040, },
+	}, ufx_ff802_clk_entries[] = {
+		{ "WDClk",	0x00000001, 0x00000010, },
+		{ "AES/EBU",	0x00000002, 0x00000020, },
+		{ "ADAT-A",	0x00000004, 0x00000040, },
+		{ "ADAT-B",	0x00000008, 0x00000080, },
 	};
 	__le32 reg;
 	u32 data;
 	unsigned int rate;
 	enum snd_ff_clock_src src;
 	const char *label;
+	unsigned int clk_entry_count;
 	int i;
 	int err;
 
@@ -270,7 +344,15 @@ static void latter_dump_status(struct sn
 
 	snd_iprintf(buffer, "External source detection:\n");
 
-	for (i = 0; i < ARRAY_SIZE(clk_entries); ++i) {
+	if (ff->unit_version == SND_FF_UNIT_VERSION_UCX) {
+		clk_entries = ucx_clk_entries;
+		clk_entry_count = ARRAY_SIZE(ucx_clk_entries);
+	} else {
+		clk_entries = ufx_ff802_clk_entries;
+		clk_entry_count = ARRAY_SIZE(ufx_ff802_clk_entries);
+	}
+
+	for (i = 0; i < clk_entry_count; ++i) {
 		clk_entry = clk_entries + i;
 		snd_iprintf(buffer, "%s: ", clk_entry->label);
 		if (data & clk_entry->locked_mask) {


