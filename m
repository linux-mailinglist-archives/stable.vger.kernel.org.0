Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF544D742
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbfFTSRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:17:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729050AbfFTSRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:17:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3C7A2082C;
        Thu, 20 Jun 2019 18:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054632;
        bh=SJE9LZ9YHhAAp7GuxHcP/85NZDSBqP1o+ERQa94aOk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sk5AMo6lvrzWg113RWGZAEG0aG55HaeEEXtSxp3tzBshoPNI5jrvVhCbatdccHm5C
         Ljw2J1k13v6fQNEnKJc1UHcuqwTXvG66TvMsLygdUi7SaGjWHlivlIqSfND4oE6PXk
         YBjDNRMOusA0UMdg4vOnbcDXi+iyT3ewO00J3K6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 78/98] ALSA: fireface: Use ULL suffixes for 64-bit constants
Date:   Thu, 20 Jun 2019 19:57:45 +0200
Message-Id: <20190620174353.177190471@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



