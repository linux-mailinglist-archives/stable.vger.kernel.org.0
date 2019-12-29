Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 348F612C6BE
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731783AbfL2RuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:50:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:34226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731400AbfL2RuE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:50:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE61F206A4;
        Sun, 29 Dec 2019 17:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641804;
        bh=adnTbLNbCgc7r4M44ql6h79pWXDDmFVkyj8/+tHGYUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0/fVhR8VkpzM78PG8pvEWCi6Vj8P+3wjiQ1xi2zfEUhqsL/UreXaFHSnIeAFmX0O4
         JYTpP3L5XKVl5keM0M91MnMBAl7TF5BLeDxizbnhsnz7JSln8/UsaCZPLYQQp0Md6l
         lIOvuCaQPAgxghQf9NZj9P4hdfIrAjumm7wEei9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 217/434] ALSA: bebob: expand sleep just after breaking connections for protocol version 1
Date:   Sun, 29 Dec 2019 18:24:30 +0100
Message-Id: <20191229172716.251491974@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit d3eabe939aee3ffd5b133766a932629a9746298c ]

As long as I investigated, some devices with BeBoB protocol version 1
can be freezed during several hundreds milliseconds after breaking
connections. When accessing during the freezed time, any transaction
is corrupted. In the worst case, the device is going to reboot.

I can see this issue in:
 * Roland FA-66
 * M-Audio FireWire Solo

This commit expands sleep just after breaking connections to avoid
the freezed time as much as possible. I note that the freeze/reboot
behaviour is similar to below models:
 * Focusrite Saffire Pro 10 I/O
 * Focusrite Saffire Pro 26 I/O

The above models certainly reboot after breaking connections.

Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20191101131323.17300-2-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/bebob/bebob_stream.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/sound/firewire/bebob/bebob_stream.c b/sound/firewire/bebob/bebob_stream.c
index 6c1497d9f52b..ce07ea0d4e71 100644
--- a/sound/firewire/bebob/bebob_stream.c
+++ b/sound/firewire/bebob/bebob_stream.c
@@ -415,15 +415,16 @@ static int make_both_connections(struct snd_bebob *bebob)
 	return 0;
 }
 
-static void
-break_both_connections(struct snd_bebob *bebob)
+static void break_both_connections(struct snd_bebob *bebob)
 {
 	cmp_connection_break(&bebob->in_conn);
 	cmp_connection_break(&bebob->out_conn);
 
-	/* These models seems to be in transition state for a longer time. */
-	if (bebob->maudio_special_quirk != NULL)
-		msleep(200);
+	// These models seem to be in transition state for a longer time. When
+	// accessing in the state, any transactions is corrupted. In the worst
+	// case, the device is going to reboot.
+	if (bebob->version < 2)
+		msleep(600);
 }
 
 static int
-- 
2.20.1



