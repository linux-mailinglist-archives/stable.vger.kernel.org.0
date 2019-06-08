Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F03539D8F
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbfFHLlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbfFHLlm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:41:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77B49214AF;
        Sat,  8 Jun 2019 11:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994101;
        bh=P8w6/Cwz4mwp85ulO1bL7leDulXyhT/8ea6HkJTtEdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQlCdqbwSeTXDoHNCSP/IfITBnOxjhwVXwhTf9QS6XWfNDx/6uQ7h6prKjgbtN8D5
         Gu6sglqF0XVXxJrkIlzUSY1b+2b5jeFNex30on/KcMV68ImXc78YZB9CyF1hXvcyVL
         uMUAov/2OX5YWQILVusn0BIJZKtwyF7eRG3YfgbQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 55/70] ALSA: fireface: Use ULL suffixes for 64-bit constants
Date:   Sat,  8 Jun 2019 07:39:34 -0400
Message-Id: <20190608113950.8033-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 6954158a16404e7091cea494cd0a435ca2f90388 ]

With gcc 4.1:

    sound/firewire/fireface/ff-protocol-latter.c: In function ‘latter_switch_fetching_mode’:
    sound/firewire/fireface/ff-protocol-latter.c:97: warning: integer constant is too large for ‘long’ type
    sound/firewire/fireface/ff-protocol-latter.c: In function ‘latter_begin_session’:
    sound/firewire/fireface/ff-protocol-latter.c:170: warning: integer constant is too large for ‘long’ type
    sound/firewire/fireface/ff-protocol-latter.c:197: warning: integer constant is too large for ‘long’ type
    sound/firewire/fireface/ff-protocol-latter.c:205: warning: integer constant is too large for ‘long’ type
    sound/firewire/fireface/ff-protocol-latter.c: In function ‘latter_finish_session’:
    sound/firewire/fireface/ff-protocol-latter.c:214: warning: integer constant is too large for ‘long’ type

Fix this by adding the missing "ULL" suffixes.
Add the same suffix to the last constant, to maintain consistency.

Fixes: fd1cc9de64c2ca6c ("ALSA: fireface: add support for Fireface UCX")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/fireface/ff-protocol-latter.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/firewire/fireface/ff-protocol-latter.c b/sound/firewire/fireface/ff-protocol-latter.c
index c8236ff89b7f..b30d02d359b1 100644
--- a/sound/firewire/fireface/ff-protocol-latter.c
+++ b/sound/firewire/fireface/ff-protocol-latter.c
@@ -9,11 +9,11 @@
 
 #include "ff.h"
 
-#define LATTER_STF		0xffff00000004
-#define LATTER_ISOC_CHANNELS	0xffff00000008
-#define LATTER_ISOC_START	0xffff0000000c
-#define LATTER_FETCH_MODE	0xffff00000010
-#define LATTER_SYNC_STATUS	0x0000801c0000
+#define LATTER_STF		0xffff00000004ULL
+#define LATTER_ISOC_CHANNELS	0xffff00000008ULL
+#define LATTER_ISOC_START	0xffff0000000cULL
+#define LATTER_FETCH_MODE	0xffff00000010ULL
+#define LATTER_SYNC_STATUS	0x0000801c0000ULL
 
 static int parse_clock_bits(u32 data, unsigned int *rate,
 			    enum snd_ff_clock_src *src)
-- 
2.20.1

