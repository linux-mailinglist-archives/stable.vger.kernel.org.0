Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5BD194D17
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbgCZX2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbgCZXY1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:24:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0EB420409;
        Thu, 26 Mar 2020 23:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265066;
        bh=E3QsCnsuUDRRo8kdeYSkq2UO7hjxNljMU6+avIz5qQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5WPdLBsy6h7BQt+qrRdVU1aNVvd7qzF3xq54JymKqeP/jGkgudyFYArb/PioMYFj
         2nSCx3wUlqewRytnrJ2UsoF4xaEZWAbe6byj2lqeBdGu2pGBGIIVPzi1523PP+TckC
         F0tJ6Rpv/HGilCuv6o+ivpA/W84o9S1vr/PxiD/E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        syzbot+cce32521ee0a824c21f7@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.5 25/28] ALSA: line6: Fix endless MIDI read loop
Date:   Thu, 26 Mar 2020 19:23:54 -0400
Message-Id: <20200326232357.7516-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232357.7516-1-sashal@kernel.org>
References: <20200326232357.7516-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit d683469b3c93d7e2afd39e6e1970f24700eb7a68 ]

The MIDI input event parser of the LINE6 driver may enter into an
endless loop when the unexpected data sequence is given, as it tries
to continue the secondary bytes without termination.  Also, when the
input data is too short, the parser returns a negative error, while
the caller doesn't handle it properly.  This would lead to the
unexpected behavior as well.

This patch addresses those issues by checking the return value
correctly and handling the one-byte event in the parser properly.

The bug was reported by syzkaller.

Reported-by: syzbot+cce32521ee0a824c21f7@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/000000000000033087059f8f8fa3@google.com
Link: https://lore.kernel.org/r/20200309095922.30269-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/line6/driver.c  | 2 +-
 sound/usb/line6/midibuf.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/usb/line6/driver.c b/sound/usb/line6/driver.c
index b5a3f754a4f13..4f096685ed654 100644
--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -305,7 +305,7 @@ static void line6_data_received(struct urb *urb)
 				line6_midibuf_read(mb, line6->buffer_message,
 						LINE6_MIDI_MESSAGE_MAXLEN);
 
-			if (done == 0)
+			if (done <= 0)
 				break;
 
 			line6->message_length = done;
diff --git a/sound/usb/line6/midibuf.c b/sound/usb/line6/midibuf.c
index 8d6eefa0d9362..6a70463f82c4e 100644
--- a/sound/usb/line6/midibuf.c
+++ b/sound/usb/line6/midibuf.c
@@ -159,7 +159,7 @@ int line6_midibuf_read(struct midi_buffer *this, unsigned char *data,
 			int midi_length_prev =
 			    midibuf_message_length(this->command_prev);
 
-			if (midi_length_prev > 0) {
+			if (midi_length_prev > 1) {
 				midi_length = midi_length_prev - 1;
 				repeat = 1;
 			} else
-- 
2.20.1

