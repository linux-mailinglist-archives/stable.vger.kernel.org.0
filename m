Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E38416757C
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388448AbgBUI2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:28:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:59784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732385AbgBUIUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:20:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BA7A2469E;
        Fri, 21 Feb 2020 08:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273237;
        bh=sRSHDjt1zfYM/QXsil6XobwK6csvrwRtCUObDsVdiHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rTIIaRBYFNJXf/yrO4yi0rpdX02+bSEwv9sSrU6EyZiEsys5KIWfkIqwn17w/+wd/
         qWZbTT8I6JGzhp/GXxESrgT5rQ1Dbaw5kPCR+fSgvbxldtwnTTEASw6T7o7/UBGTjl
         iROkXKkUhWObvjNJSMWvySdCznuKVayE2eXrS/f8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 097/191] ALSA: sh: Fix compile warning wrt const
Date:   Fri, 21 Feb 2020 08:41:10 +0100
Message-Id: <20200221072302.830601727@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f1dd4795b1523fbca7ab4344dd5a8bb439cc770d ]

A long-standing compile warning was seen during build test:
  sound/sh/aica.c: In function 'load_aica_firmware':
  sound/sh/aica.c:521:25: warning: passing argument 2 of 'spu_memload' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]

Fixes: 198de43d758c ("[ALSA] Add ALSA support for the SEGA Dreamcast PCM device")
Link: https://lore.kernel.org/r/20200105144823.29547-69-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/sh/aica.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/sh/aica.c b/sound/sh/aica.c
index ad3f71358486a..69ac44b335602 100644
--- a/sound/sh/aica.c
+++ b/sound/sh/aica.c
@@ -117,10 +117,10 @@ static void spu_memset(u32 toi, u32 what, int length)
 }
 
 /* spu_memload - write to SPU address space */
-static void spu_memload(u32 toi, void *from, int length)
+static void spu_memload(u32 toi, const void *from, int length)
 {
 	unsigned long flags;
-	u32 *froml = from;
+	const u32 *froml = from;
 	u32 __iomem *to = (u32 __iomem *) (SPU_MEMORY_BASE + toi);
 	int i;
 	u32 val;
-- 
2.20.1



