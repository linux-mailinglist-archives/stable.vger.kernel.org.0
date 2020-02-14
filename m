Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5151215E729
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404791AbgBNQw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:52:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389164AbgBNQTX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:19:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E90924713;
        Fri, 14 Feb 2020 16:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697162;
        bh=+Ts59TTOA1rvaRdu5/xxg8OWUnAZMchTrOzvI7sDYtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VjFG9OTfKMBohdQJQfCvCEoLUdSCrcn5be+oZaNEgCF+qP7TXuMLQLNytHvLXoyDK
         HKHDAGyN+IFEDAPj44gvpvrMyBpM2qcnPQ7Xylupd0qABkah7dZWLBLTGwYHZM0QuQ
         Wwp0uNoixPWl+azYlHYvU9Ubc9ZvVZhlGtIhogZk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 099/186] ALSA: sh: Fix compile warning wrt const
Date:   Fri, 14 Feb 2020 11:15:48 -0500
Message-Id: <20200214161715.18113-99-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index fdc680ae8aa09..d9acf551a8985 100644
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

