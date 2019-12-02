Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D59410E82C
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfLBKEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:04:06 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37058 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbfLBKEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:04:06 -0500
Received: by mail-wr1-f68.google.com with SMTP id w15so12448742wru.4
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PQ3vTayhg9dI4DRY5KzmFS+ZI1OUJq8YM60IUamu6Zk=;
        b=CkSMeFFbfFnffmFzGIlUI+GKcfJPkVXNI2+6h6m9loRymOdPG6H6G2SO7iq7yV9o33
         Wio9M8K3VLKAJBEMeKj1VUyjzwq3iosLDBcGO42JOVu0K+xrPyXcFhPOGOmh+/CBQEhB
         FPISibRfHjAI8dK5d7L5c9rYLY4gvqc/l1BF4fq927Nk+Y/GiokyGco8Zp4qa5NnwJvY
         OrwSXYrqIADN3QbL79z9U9aesYSnLGN2Um7xS/0Tavy6fom4vtth03rZvTWv71AxaQHx
         sFukBRwMmJoRcQvNWfeBclM1TU/05QLNXR6jTm74HTDb1uwVVP+qX7OgWV51LecBUNuO
         Jwow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PQ3vTayhg9dI4DRY5KzmFS+ZI1OUJq8YM60IUamu6Zk=;
        b=HvYb95B+hRV61sd1biRaN/v7iwt4TnBBLl1fHB1eayzRsDnAO91D3f2Rq0BhsS3DL6
         soBS9dgyFQrhhVI/R5P6EFwFAG0MTNatInFGwjdYh7X0q14WqqoA2Hi7k3wyu51z65hv
         25ZpDBVP/2d1eFmXhAdNS5AjLMMPXb7a9iqNYl6UlYDLcLvjEdgElGA11e1IMxGIc6hn
         9eKGW3/X+k0091ZWEtq65FbkHT5T1Opdv3sC4EN7D/7fZqU6HWPNAzNhUpEBPsa/8SfN
         65b2iirDqgf+iHw1DtxvHaNzbvLRnMPFoDXN7JQUQTgZIVD/xQ/dpZKzbUKK+xjuXv4O
         DbDw==
X-Gm-Message-State: APjAAAXJtnDSLfL4F+EjXXrkkNTb/DYWSp97dvtGcJldHlxi8EA8mcjC
        B3bv9lBiMOH+/jlrgUkWJvLFq0mzSZ0=
X-Google-Smtp-Source: APXvYqx1YgMKQmsCocmngQVCn0lzt/DothEZlcMsxtwyxjpfKMuQT/aGj8o92cnH8wqkY5gdhk0dAw==
X-Received: by 2002:adf:9c81:: with SMTP id d1mr66931386wre.144.1575281044118;
        Mon, 02 Dec 2019 02:04:04 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id h8sm22975665wrx.63.2019.12.02.02.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:04:03 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 13/14] mtd: spi-nor: cast to u64 to avoid uint overflows
Date:   Mon,  2 Dec 2019 10:03:11 +0000
Message-Id: <20191202100312.1397-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202100312.1397-1-lee.jones@linaro.org>
References: <20191202100312.1397-1-lee.jones@linaro.org>
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
index 6c013341ef09..d550148177a0 100644
--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -2382,7 +2382,7 @@ static int spi_nor_init_params(struct spi_nor *nor,
 	memset(params, 0, sizeof(*params));
 
 	/* Set SPI NOR sizes. */
-	params->size = info->sector_size * info->n_sectors;
+	params->size = (u64)info->sector_size * info->n_sectors;
 	params->page_size = info->page_size;
 
 	/* (Fast) Read settings. */
-- 
2.24.0

