Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4484E6D18E8
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 09:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjCaHqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 03:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjCaHqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 03:46:23 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF53A1A97F
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 00:46:20 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id b6so2088172ljr.1
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 00:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680248779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Gpe4Snyz/bF2fGxRf14cYZlO6UgYfzmd/ba/DWV9Gk=;
        b=vPj7iUbeg6atcpAE6Rmc2T3cT1CuQ6hI5sL6TzGToU3udLUOVtkSFe4aAbQEDkauGg
         UOTaUcX/VA/YEwdi/Uv/0tHEEsz3my21x0o09Y5+MMxSeV3Y/+0nCm1n/za4OHVbejob
         il5LLGPceI3Dy2br6XN05H6fddm/OfImZXd4W4xidDzWOB6pt1sifY9JJ4uzltVdf7FO
         J+tUbVDGJkqyn4QRoMRN5GtuzXwaupf1wDIVjF+aIUdMXZHm5vOU8zpcRhXktOAREfan
         ctpopLklTeOkeiyciCJnb8Oydzxd2Okqvf75PKv8FGJe23RYfOBg6Vte/c5nRfrAkxfu
         xpDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680248779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Gpe4Snyz/bF2fGxRf14cYZlO6UgYfzmd/ba/DWV9Gk=;
        b=KYzJKCETfUSfph8ig68vhk2va0U2O3VtVBrjJAKPoZBNQxaXQoCniM8cNpAo9FDOZ1
         3jCxyGAXtRvy4xoOb4nVpipODioBR7Bg0YbgcUSYPyGnNk9r4DdytcsIcrVpNre24a+a
         qABCtJcu8PAV98uvi0CQI2YoD9IMi4KYb7E74kNMfGlHmaT+mqaMYJk7wsvQqKq4ahoK
         2Hnx1dOLqZAEoVtq6IyW5crvbmMj0rvA8u13+gM8X0o3ldSJFgLFZf89G26yu9WAKcE4
         edznl6XlaP3B09E4GxhMFT4ZpLk3RiZfodaF6+zMGUqUeIkdGWWj9P+DlwKCAwHPi1eU
         taow==
X-Gm-Message-State: AAQBX9fDnZeTJ9muSWcAFeEhbOlfTluvbwNOlXs16TQJMqt5XURrykqf
        1CNlQ+gWOHH0IdrYCzwVbsNTOw==
X-Google-Smtp-Source: AKy350bSzjL91WtFWl1PE43B7dIJUbkMTgBFFknQ0K7k/cM/h+/38F1qZmY/xMT76WPQrlNjZa1lJw==
X-Received: by 2002:a2e:984e:0:b0:293:4b60:419c with SMTP id e14-20020a2e984e000000b002934b60419cmr2359613ljj.18.1680248779228;
        Fri, 31 Mar 2023 00:46:19 -0700 (PDT)
Received: from ta1.c.googlers.com.com (61.215.228.35.bc.googleusercontent.com. [35.228.215.61])
        by smtp.gmail.com with ESMTPSA id n20-20020a2e8794000000b0029573844d03sm241201lji.109.2023.03.31.00.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 00:46:18 -0700 (PDT)
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     michael@walle.cc, pratyush@kernel.org
Cc:     miquel.raynal@bootlin.com, richard@nod.at,
        Takahiro.Kuwano@infineon.com, bacem.daassi@infineon.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v5 08/10] mtd: spi-nor: core: Update flash's current address mode when changing address mode
Date:   Fri, 31 Mar 2023 07:46:04 +0000
Message-Id: <20230331074606.3559258-9-tudor.ambarus@linaro.org>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
In-Reply-To: <20230331074606.3559258-1-tudor.ambarus@linaro.org>
References: <20230331074606.3559258-1-tudor.ambarus@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug was obswerved while reading code. There are not many users of
addr_mode_nbytes. Anyway, we should update the flash's current address
mode when changing the address mode, fix it. We don't care for now about
the set_4byte_addr_mode(nor, false) from spi_nor_restore(), as it is
used at driver remove and shutdown.

Fixes: d7931a215063 ("mtd: spi-nor: core: Track flash's internal address mode")
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: stable@vger.kernel.org
---
 drivers/mtd/spi-nor/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 0517a61975e4..4f0d90d3dad5 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -3135,6 +3135,7 @@ static int spi_nor_quad_enable(struct spi_nor *nor)
 
 static int spi_nor_init(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = nor->params;
 	int err;
 
 	err = spi_nor_octal_dtr_enable(nor, true);
@@ -3176,9 +3177,10 @@ static int spi_nor_init(struct spi_nor *nor)
 		 */
 		WARN_ONCE(nor->flags & SNOR_F_BROKEN_RESET,
 			  "enabling reset hack; may not recover from unexpected reboots\n");
-		err = nor->params->set_4byte_addr_mode(nor, true);
+		err = params->set_4byte_addr_mode(nor, true);
 		if (err && err != -ENOTSUPP)
 			return err;
+		params->addr_mode_nbytes = 4;
 	}
 
 	return 0;
-- 
2.40.0.348.gf938b09366-goog

