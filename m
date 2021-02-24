Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3985E323CE4
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbhBXM6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:58:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:50930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235360AbhBXMy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:54:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4839164F24;
        Wed, 24 Feb 2021 12:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171090;
        bh=38Pu3wu3c7i+stw295uGqMWQuud9FpmztFKPE6KWWvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0ULOPrfl4kXEYuGZYvxxDbT36G67SqnL9lOx0FnX/YbxflEqSa7faCtJLfMYf5oh
         bw5Cu9Bax/GU+qTFyX+9n2sN4mS1bd8c+fuHmwDyJONaWvbITlN/Nie615dSb4k6dR
         rtxDi3/+Lm2GPHRwwJfwzK040Y5bPhcFaguJNtkUE+hBgwXuwv8NJ4GxKoPzmTrNR/
         ODAdODUlZumlCNGcBJG1EfmJmaMgqwLM/cId74RCS4k35rXr5ads5r7wJGE4iqzRqy
         SgrXnRq6r1EhkwfC1R8URucgy/8qeGQObQgPI1rDnHwQ7a/DT35pmrj5BCJfvrk3Sh
         24rXRJXxzqC8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olivia Mackintosh <livvy@base.nu>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.11 47/67] ALSA: usb-audio: Add DJM450 to Pioneer format quirk
Date:   Wed, 24 Feb 2021 07:50:05 -0500
Message-Id: <20210224125026.481804-47-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivia Mackintosh <livvy@base.nu>

[ Upstream commit 3b85f5fc75d564a9eb4171dcb6b8687b080cd4d5 ]

Like the DJM-750, ensure that the format control message is passed to
the device when opening a stream. It seems as though fmt->sync_ep is not
always set when this function is called hence the passing of the value
at the call site. If this can be fixed, fmt->sync_up should be used as
the wvalue.

There doesn't seem to be a "cpu_to_le24" type function defined hence for
the open code but I did see a similar thing done in Bluez lib. Perhaps
we can get these definitions defined in byteorder.h. See hci_cpu_to_le24
in include/net/bluetooth/hci.h:2543 for similar usage.

Signed-off-by: Olivia Mackintosh <livvy@base.nu>
Link: https://lore.kernel.org/r/20210202134225.3217-2-livvy@base.nu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index e196e364cef19..9ba4682ebc482 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1470,6 +1470,23 @@ static void set_format_emu_quirk(struct snd_usb_substream *subs,
 	subs->pkt_offset_adj = (emu_samplerate_id >= EMU_QUIRK_SR_176400HZ) ? 4 : 0;
 }
 
+static int pioneer_djm_set_format_quirk(struct snd_usb_substream *subs,
+					u16 windex)
+{
+	unsigned int cur_rate = subs->data_endpoint->cur_rate;
+	u8 sr[3];
+	// Convert to little endian
+	sr[0] = cur_rate & 0xff;
+	sr[1] = (cur_rate >> 8) & 0xff;
+	sr[2] = (cur_rate >> 16) & 0xff;
+	usb_set_interface(subs->dev, 0, 1);
+	// we should derive windex from fmt-sync_ep but it's not set
+	snd_usb_ctl_msg(subs->stream->chip->dev,
+		usb_rcvctrlpipe(subs->stream->chip->dev, 0),
+		0x01, 0x22, 0x0100, windex, &sr, 0x0003);
+	return 0;
+}
+
 void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
 			      const struct audioformat *fmt)
 {
@@ -1483,6 +1500,9 @@ void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
 	case USB_ID(0x534d, 0x2109): /* MacroSilicon MS2109 */
 		subs->stream_offset_adj = 2;
 		break;
+	case USB_ID(0x2b73, 0x0013): /* Pioneer DJM-450 */
+		pioneer_djm_set_format_quirk(subs, 0x0082);
+		break;
 	}
 }
 
-- 
2.27.0

