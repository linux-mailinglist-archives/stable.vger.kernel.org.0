Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33AB0CAC0B
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732432AbfJCQEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:04:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731354AbfJCQEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:04:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91E8B21D81;
        Thu,  3 Oct 2019 16:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118680;
        bh=fik+i5HOycM4aEtSccDBSMO6kukqh4PeAR2iNgi49dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7hRsOXDiP8/+sflkMNZLm03YA3HwJloms58S8Xe71mhlkLn4+TdZKISKy+Xi8jza
         qZotPSbIDEef+uA+3WgtxlhZBXs9mzbjqlrKPUddlomx5wBkWo2c7dBRbiodCq4y9F
         5TXPdn7IaF8J9LLl3MFDROWqv3Zj2avE5pKld8fY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 099/129] ALSA: firewire-tascam: check intermediate state of clock status and retry
Date:   Thu,  3 Oct 2019 17:53:42 +0200
Message-Id: <20191003154404.620288426@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit e1a00b5b253a4f97216b9a33199a863987075162 upstream.

2 bytes in MSB of register for clock status is zero during intermediate
state after changing status of sampling clock in models of TASCAM FireWire
series. The duration of this state differs depending on cases. During the
state, it's better to retry reading the register for current status of
the clock.

In current implementation, the intermediate state is checked only when
getting current sampling transmission frequency, then retry reading.
This care is required for the other operations to read the register.

This commit moves the codes of check and retry into helper function
commonly used for operations to read the register.

Fixes: e453df44f0d6 ("ALSA: firewire-tascam: add PCM functionality")
Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20190910135152.29800-3-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/tascam/tascam-stream.c |   42 ++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 14 deletions(-)

--- a/sound/firewire/tascam/tascam-stream.c
+++ b/sound/firewire/tascam/tascam-stream.c
@@ -9,20 +9,37 @@
 #include <linux/delay.h>
 #include "tascam.h"
 
+#define CLOCK_STATUS_MASK      0xffff0000
+#define CLOCK_CONFIG_MASK      0x0000ffff
+
 #define CALLBACK_TIMEOUT 500
 
 static int get_clock(struct snd_tscm *tscm, u32 *data)
 {
+	int trial = 0;
 	__be32 reg;
 	int err;
 
-	err = snd_fw_transaction(tscm->unit, TCODE_READ_QUADLET_REQUEST,
-				 TSCM_ADDR_BASE + TSCM_OFFSET_CLOCK_STATUS,
-				 &reg, sizeof(reg), 0);
-	if (err >= 0)
+	while (trial++ < 5) {
+		err = snd_fw_transaction(tscm->unit, TCODE_READ_QUADLET_REQUEST,
+				TSCM_ADDR_BASE + TSCM_OFFSET_CLOCK_STATUS,
+				&reg, sizeof(reg), 0);
+		if (err < 0)
+			return err;
+
 		*data = be32_to_cpu(reg);
+		if (*data & CLOCK_STATUS_MASK)
+			break;
+
+		// In intermediate state after changing clock status.
+		msleep(50);
+	}
 
-	return err;
+	// Still in the intermediate state.
+	if (trial >= 5)
+		return -EAGAIN;
+
+	return 0;
 }
 
 static int set_clock(struct snd_tscm *tscm, unsigned int rate,
@@ -35,7 +52,7 @@ static int set_clock(struct snd_tscm *ts
 	err = get_clock(tscm, &data);
 	if (err < 0)
 		return err;
-	data &= 0x0000ffff;
+	data &= CLOCK_CONFIG_MASK;
 
 	if (rate > 0) {
 		data &= 0x000000ff;
@@ -80,17 +97,14 @@ static int set_clock(struct snd_tscm *ts
 
 int snd_tscm_stream_get_rate(struct snd_tscm *tscm, unsigned int *rate)
 {
-	u32 data = 0x0;
-	unsigned int trials = 0;
+	u32 data;
 	int err;
 
-	while (data == 0x0 || trials++ < 5) {
-		err = get_clock(tscm, &data);
-		if (err < 0)
-			return err;
+	err = get_clock(tscm, &data);
+	if (err < 0)
+		return err;
 
-		data = (data & 0xff000000) >> 24;
-	}
+	data = (data & 0xff000000) >> 24;
 
 	/* Check base rate. */
 	if ((data & 0x0f) == 0x01)


