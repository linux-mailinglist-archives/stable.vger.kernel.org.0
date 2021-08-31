Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30FF3FCD30
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 21:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbhHaSuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 14:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbhHaStg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Aug 2021 14:49:36 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4F1C061575;
        Tue, 31 Aug 2021 11:48:40 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id u15so94568wmj.1;
        Tue, 31 Aug 2021 11:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ssx/Du/IP+VJ6yRDjCWSrw9PFpibgX8+LOfvx0arrC0=;
        b=puHwvGy27ZCKW1/hb24T4TxdTwdhH8hvACG5TZRQSpyCBIIMky52bBklkqr9uJutP9
         P0wNNsLYBf1rjLSkYPzkH9uMmpQw22uPzb75brSLN9IoR/EySrsjS3gV+thkKOc8/H82
         DI3D7LnOxXZVwTOxYbmAGqepG19w67uxdr+UqtuKgQlAouvhp3shcbNh69RePVDN7xVj
         WLCwur8FuuCsy2nyBXl015EN7380NvJAK3gPDqMFBvPm9y+8MyNgk67elQ7sxGSnioVa
         bz6G4tYRWV/i22lvNZPWSLbZFkZstVT/Xrky1y3wroe9W8wxlSJZn3OiE4MwLdI7la+B
         yM9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ssx/Du/IP+VJ6yRDjCWSrw9PFpibgX8+LOfvx0arrC0=;
        b=sOlqf8NadyCQ58VuN4nQH9HKhZiBkZt9NcCf490yJw/CpO5nGEUoOsuG3VBN65HGJY
         XdIurWJEbDrkql45tUFd296RrOiKEFe7bVjl9vIM/XM+HzCCbFopLKb8qKNxg+gJod6T
         zEF/4eN4Kd8FsMv+jtYJW8oq6wR1CDlXDKKQ0k1knukiLAXdAkhpBIhTFkwnWQUIo6hl
         H7eOvCB0W5APWs8f+UGKGvNlcp6VtEgTsnWxFr0f4cUz2F16Ig9W4ANWmDiIL2PN3/Zw
         wxUmG5Hf6ObrZlPVBcn2gBYJd7myixHbatsRyBNkwiJrqAFVYFAL5muCRX3+8o89Zo/p
         HBYg==
X-Gm-Message-State: AOAM530enukdWxk1YknLmahmD8vFMGRB2dP+AdpDhQgqqmKUgWuKA9CX
        zdcJbwsKrH/+/VW8hkySAqEpiOWN5lfA1Q==
X-Google-Smtp-Source: ABdhPJxpHtUrxMXrtWzNzUZfT5NDgfPAC3iEvcgbop4yUZWCq6uU0jUnfin9kUgN30R0dGd3QoArGw==
X-Received: by 2002:a1c:e904:: with SMTP id q4mr5857630wmc.26.1630435719011;
        Tue, 31 Aug 2021 11:48:39 -0700 (PDT)
Received: from kista.localdomain (cpe-86-58-29-253.static.triera.net. [86.58.29.253])
        by smtp.gmail.com with ESMTPSA id d145sm3111884wmd.3.2021.08.31.11.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 11:48:38 -0700 (PDT)
From:   Jernej Skrabec <jernej.skrabec@gmail.com>
To:     mripard@kernel.org, wens@csie.org
Cc:     airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        stable@vger.kernel.org, Roman Stratiienko <r.stratiienko@gmail.com>
Subject: [PATCH] drm/sun4i: Fix macros in sun8i_csc.h
Date:   Tue, 31 Aug 2021 20:48:19 +0200
Message-Id: <20210831184819.93670-1-jernej.skrabec@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Macros SUN8I_CSC_CTRL() and SUN8I_CSC_COEFF() don't follow usual
recommendation of having arguments enclosed in parenthesis. While that
didn't change anything for quiet sometime, it actually become important
after CSC code rework with commit ea067aee45a8 ("drm/sun4i: de2/de3:
Remove redundant CSC matrices").

Without this fix, colours are completely off for supported YVU formats
on SoCs with DE2 (A64, H3, R40, etc.).

Fix the issue by enclosing macro arguments in parenthesis.

Cc: stable@vger.kernel.org # 5.12+
Fixes: 883029390550 ("drm/sun4i: Add DE2 CSC library")
Reported-by: Roman Stratiienko <r.stratiienko@gmail.com>
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
---
 drivers/gpu/drm/sun4i/sun8i_csc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_csc.h b/drivers/gpu/drm/sun4i/sun8i_csc.h
index a55a38ad849c..022cafa6c06c 100644
--- a/drivers/gpu/drm/sun4i/sun8i_csc.h
+++ b/drivers/gpu/drm/sun4i/sun8i_csc.h
@@ -16,8 +16,8 @@ struct sun8i_mixer;
 #define CCSC10_OFFSET 0xA0000
 #define CCSC11_OFFSET 0xF0000
 
-#define SUN8I_CSC_CTRL(base)		(base + 0x0)
-#define SUN8I_CSC_COEFF(base, i)	(base + 0x10 + 4 * i)
+#define SUN8I_CSC_CTRL(base)		((base) + 0x0)
+#define SUN8I_CSC_COEFF(base, i)	((base) + 0x10 + 4 * (i))
 
 #define SUN8I_CSC_CTRL_EN		BIT(0)
 
-- 
2.33.0

