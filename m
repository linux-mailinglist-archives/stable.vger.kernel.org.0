Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F7410E8EE
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfLBKbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:31:25 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32927 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727575AbfLBKbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:31:25 -0500
Received: by mail-wr1-f66.google.com with SMTP id b6so13900568wrq.0
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZgOVOUxciAvJcn32lc/Nhslk8imEa0i2gZFv1Qv8b9A=;
        b=drtuQ2ps/fJpXBdQG48oENHMFLL4ok05/xwAlGFrSD4RGZ+v93a5nj2pzS7+BEJsV3
         3G+FRQYKBDPgfMcScXvsNARNw203y1YE4ALeatNDaYL3dmBCx1neo25cePA/TDUgl3f8
         kkDPYqGADhToIU5KYpHgIJCx2n4f5+WWtehmvdGpHbNRuflXe0l5pKI5aCmoY0etbi7h
         U0esPWBdfiyPdeXDZ+/NwfVd+OAygmXc/z8sy2bfib1nTzdBp+xBONV1KiM94Wts1OBE
         WJGUJKp/0bd0op7rmhNbA7D2hHCfiDMHfZj4s9J9t26hp80cu6bEAqlgPvx0x7C4XHhc
         gp6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZgOVOUxciAvJcn32lc/Nhslk8imEa0i2gZFv1Qv8b9A=;
        b=GdZHnPxzcwHX+TFq5Ww4jWtC5ENKpr+iNNF+99dstgeIO7lXIdlM2irdwzQ5toYSp0
         tBSm2q4wc8zxlnojrsoTOQ2vC2Xg8P+/K4NT0Cc1LO1ZUHVVpnpfMCZ1XBE+yAx8OFE8
         XQJ5JaCcyNeFCU31Rx+5N84i4ooIqH9CaVxAxenbI1C8LeMKHl6NIkheY3kklHjSDfwC
         s9/jUt8YT1EEMl+9Nss9M4BgVNbq37AcUS8bfEyy++EG/J0oUzATUu/MFlPkwtftdioz
         zWIGSFaw28I02aeVg2/b9ZrRCyZJ8mljhEi1dKQJ3zCrIv/JunBzJHv1LvDrL69cFp6t
         74+w==
X-Gm-Message-State: APjAAAVM0fjrf9vQ7tbH63FVK2bPxHzOO4vIFyWEj/mcMh12zToHXBhh
        8gfP/Ccqsx5itydI5zEmnVCHq6tuiA8=
X-Google-Smtp-Source: APXvYqwRayrzEQTGmY9kHBRL0D7NwkIFKaWYHOsq5n43KygVAU2Sz+9w+HpNRG98+D3eVDQ/VotNTw==
X-Received: by 2002:adf:90e7:: with SMTP id i94mr2513688wri.47.1575282683601;
        Mon, 02 Dec 2019 02:31:23 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id r6sm26402860wrq.92.2019.12.02.02.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:31:23 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 14/15] mtd: spi-nor: cast to u64 to avoid uint overflows
Date:   Mon,  2 Dec 2019 10:30:49 +0000
Message-Id: <20191202103050.2668-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202103050.2668-1-lee.jones@linaro.org>
References: <20191202103050.2668-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "huijin.park" <huijin.park@samsung.com>

[ Upstream commit 84a1c2109d23df3543d96231c4fee1757299bb1a ]

The "params->size" is defined as "u64".
And "info->sector_size" and "info->n_sectors" are defined as
unsigned int and u16.
Thus, u64 data might have strange data(loss data) if the result
overflows an unsigned int.
This patch casts "info->sector_size" to an u64.

Signed-off-by: huijin.park <huijin.park@samsung.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/spi-nor/spi-nor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c
index f028277fb1ce..2e183425facd 100644
--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -2459,7 +2459,7 @@ static int spi_nor_init_params(struct spi_nor *nor,
 	memset(params, 0, sizeof(*params));
 
 	/* Set SPI NOR sizes. */
-	params->size = info->sector_size * info->n_sectors;
+	params->size = (u64)info->sector_size * info->n_sectors;
 	params->page_size = info->page_size;
 
 	/* (Fast) Read settings. */
-- 
2.24.0

