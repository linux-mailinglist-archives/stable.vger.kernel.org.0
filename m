Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4C629DB03
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 00:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbgJ1Xmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 19:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbgJ1XlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 19:41:07 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F09C0613CF
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 16:41:06 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w27so1369565ejb.3
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 16:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ORjAmXFNbA8sjUlFAeqJzueYsTW6Da7gRCx6HUe+og8=;
        b=VJsa0z5kZ+s01cwlxvNqzmYyQKdorOOUaToPYYDqKANbp2Ri31yfVXz1lSNlTEB25+
         Lfu0KDVqFhw3PBM5wOzPwKGx2Lnl1uev1VI+Wzheo5AJ1lzVDIwlOOSAyAg21FjPsRA+
         rsP1WWd0nS6Hevk9XBV4V5YBgWEY75gFW6GXJF9JfD+7pIFu8cIYWSWIFLda86oZeTzW
         YexUGUFp7V5dLeolFplLq9AngpcethHLu7iqiCN0g9f2ibrd2PVtP4TjyypBMHy2PmS5
         xVXXrLjd+Vfy/Lk9z4aub0YE80RmkqCaHoz1ZpAn9ikGHcNICroUP+k6N79gVVRU5KWr
         bYmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ORjAmXFNbA8sjUlFAeqJzueYsTW6Da7gRCx6HUe+og8=;
        b=Pok8E1sk8THEY3o/bR5nbvx6TBMbQB3m5EJRE271ofVWQtIEI9/X/OHO9HhfQLXccy
         tbBVivLGzdOcvQ2od5NlZY+4jRXDiW9/Aj0QbgvFDvqB9WUm7f+82UO7QosuxALcZlBD
         rd83y2/cx0NmbveWRk6mGwl1GijC5//siOCTlABxORGG4feB4TMg2XM3D5i2v7htRzAa
         THr93qG21CyCZdBAA6hwdElR757kwW2UkxsOxbe12XW14oe/NukGUBDUERWrIT9N4o65
         bF9Kt6slVROeTTrF2VYcQOD6NhccOow9Z7+Hmi/gL1CIvZP3cctBtvFE/aOYTmLJqw+N
         MzSg==
X-Gm-Message-State: AOAM533Lpzq4QbBnObqLpybWqSOI2kCNotnrzHuFH+68AcU9IvYjYgm0
        dctRmoqCHkckVZpcCtf1jRhOyr3n12BbU60A
X-Google-Smtp-Source: ABdhPJyhw7s1iIfdFLvwmXcYfeuO6SSJjXm13OAy+LQQDIyT9jZ2znoVS3kTBa+YjxSVN6rZtzqSAQ==
X-Received: by 2002:a2e:8709:: with SMTP id m9mr2696904lji.290.1603878596744;
        Wed, 28 Oct 2020 02:49:56 -0700 (PDT)
Received: from saproj-LIN.yandex.net ([2a02:6b8:0:408:3648:edff:fe3b:1baa])
        by smtp.gmail.com with ESMTPSA id y15sm33091lfl.83.2020.10.28.02.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 02:49:56 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     linux-mtd@lists.infradead.org
Cc:     miquel.raynal@bootlin.com, jianxin.pan@amlogic.com,
        liang.yang@amlogic.com, stable@vger.kernel.org
Subject: [PATCH] mtd: meson: fix meson_nfc_dma_buffer_release() arguments
Date:   Wed, 28 Oct 2020 12:49:40 +0300
Message-Id: <20201028094940.11765-1-saproj@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Arguments 'infolen' and 'datalen' to meson_nfc_dma_buffer_release() were mixed up.

Fixes: 8fae856c53500 ("mtd: rawnand: meson: add support for Amlogic NAND flash controller")
Cc: stable@vger.kernel.org
Signed-off-by: Sergei Antonov <saproj@gmail.com>
---
 drivers/mtd/nand/raw/meson_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index 48e6dac96be6..a76afea6ea77 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -510,7 +510,7 @@ static int meson_nfc_dma_buffer_setup(struct nand_chip *nand, void *databuf,
 }
 
 static void meson_nfc_dma_buffer_release(struct nand_chip *nand,
-					 int infolen, int datalen,
+					 int datalen, int infolen,
 					 enum dma_data_direction dir)
 {
 	struct meson_nfc *nfc = nand_get_controller_data(nand);
-- 
2.17.1

