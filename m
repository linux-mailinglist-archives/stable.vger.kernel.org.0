Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A2012204D
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfLQAxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:53:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35404 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727102AbfLQAvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0003Ma-W5; Tue, 17 Dec 2019 00:51:35 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0005cc-De; Tue, 17 Dec 2019 00:51:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Takashi Sakamoto" <o-takashi@sakamocchi.jp>,
        "Takashi Iwai" <tiwai@suse.de>
Date:   Tue, 17 Dec 2019 00:47:27 +0000
Message-ID: <lsq.1576543535.459588578@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 113/136] ALSA: bebob: fix to detect configured source
 of sampling clock for Focusrite Saffire Pro i/o series
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 706ad6746a66546daf96d4e4a95e46faf6cf689a upstream.

For Focusrite Saffire Pro i/o, the lowest 8 bits of register represents
configured source of sampling clock. The next lowest 8 bits represents
whether the configured source is actually detected or not just after
the register is changed for the source.

Current implementation evaluates whole the register to detect configured
source. This results in failure due to the next lowest 8 bits when the
source is connected in advance.

This commit fixes the bug.

Fixes: 25784ec2d034 ("ALSA: bebob: Add support for Focusrite Saffire/SaffirePro series")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20191102150920.20367-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/firewire/bebob/bebob_focusrite.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/sound/firewire/bebob/bebob_focusrite.c
+++ b/sound/firewire/bebob/bebob_focusrite.c
@@ -28,6 +28,8 @@
 #define SAFFIRE_CLOCK_SOURCE_SPDIF		1
 
 /* clock sources as returned from register of Saffire Pro 10 and 26 */
+#define SAFFIREPRO_CLOCK_SOURCE_SELECT_MASK	0x000000ff
+#define SAFFIREPRO_CLOCK_SOURCE_DETECT_MASK	0x0000ff00
 #define SAFFIREPRO_CLOCK_SOURCE_INTERNAL	0
 #define SAFFIREPRO_CLOCK_SOURCE_SKIP		1 /* never used on hardware */
 #define SAFFIREPRO_CLOCK_SOURCE_SPDIF		2
@@ -184,6 +186,7 @@ saffirepro_both_clk_src_get(struct snd_b
 		map = saffirepro_clk_maps[1];
 
 	/* In a case that this driver cannot handle the value of register. */
+	value &= SAFFIREPRO_CLOCK_SOURCE_SELECT_MASK;
 	if (value >= SAFFIREPRO_CLOCK_SOURCE_COUNT || map[value] < 0) {
 		err = -EIO;
 		goto end;

