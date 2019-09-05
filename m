Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B72AA894
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfIEQTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:19:34 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:33380 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388061AbfIEQSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 12:18:10 -0400
Received: by mail-pg1-f182.google.com with SMTP id n190so1698376pgn.0
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 09:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/ld8MsvJyHX4xiXhT/vACY8V+T9SsrvyxVWLxkWmOHw=;
        b=XT3Az7zzBbgbLvMexBlhl28H1zweak4MTFSDW4Z2X3Ha/QND0Bs7fu1GlJQslffzeB
         LWlUlyWIAmzVk/+mUyPdD+4nZwAO9nk1ji12txKMyNEST223rFfRlFB6AeFPMZvq7wy/
         tXFpIGd7WBH3k/q538r3XaFEMh0s3bPPDl3wPolk9LypaKTfGB6UzVKsLLeAS07gj1rn
         fdweJBOKtEZq8Zmfgu1NcESYEF48FPKrzvVBBc5+gyUyrbJ//dUWwgy6OH85myV+ToOC
         HgL1kn+e4YWS/JFJ4yB6alQ12JjDhFV87for4spwtn7BdUdPfyqfJYpWsYs/lzpIIiIM
         3BKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/ld8MsvJyHX4xiXhT/vACY8V+T9SsrvyxVWLxkWmOHw=;
        b=nwh2jt3W65t4oCIk/uH1/9qPAFIl8zvLyGgQmXQRcPTMoohZyge6qh85ufv0OikZJ/
         L/zPZQf3gXXjqfOZP+Fa2I0xJGFKK2sy+Ncb4aDCIsW8JNMOJUfluYLGBF8HA06WnTTt
         WCMPgSHiOTgbOcWuxZAq/9Ss9XiazD4oi9xDkW4lGBrFe+HOV/LVYDiV8xuna61VnCzB
         rS4GkhVPFDKfnGYdHavqzn4056Q7+JHxf50CyG1b6IkKuwJ/WrSjcBqhX17ZwAiZey4R
         CjFxx7Io1K21dH1rXRjG+4/7SVLPagnAMkJNCaQFNrZFCXyXYI/331cJNZ6tXGW1zH0M
         /kLA==
X-Gm-Message-State: APjAAAUFedOcU422ZQNMPD54G2k1RYQcZ1x0gmM3/tYMZ4utMDNoNUQ0
        wRd8ti0siSFC0FmkvZGi4Ezdx0263k0=
X-Google-Smtp-Source: APXvYqwbHY2l3Y3RI4VI6wb4Zy7sVNDjcmdxm+p9Gx0FC6W1QaFVP9fXezb7/YJ8ZduZPS1+K7YUJg==
X-Received: by 2002:a63:2364:: with SMTP id u36mr3780682pgm.449.1567700289680;
        Thu, 05 Sep 2019 09:18:09 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m129sm6324005pga.39.2019.09.05.09.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 09:18:09 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [BACKPORT 4.14.y 07/18] mtd: spi-nor: enable 4B opcodes for mx66l51235l
Date:   Thu,  5 Sep 2019 10:17:48 -0600
Message-Id: <20190905161759.28036-8-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905161759.28036-1-mathieu.poirier@linaro.org>
References: <20190905161759.28036-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Yeryomin <leroi.lists@gmail.com>

commit d342b6a973af459f6104cad6effc8efc71a0558d upstream

Signed-off-by: Roman Yeryomin <roman@advem.lv>
Signed-off-by: Cyrille Pitchen <cyrille.pitchen@wedev4u.fr>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/mtd/spi-nor/spi-nor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c
index 34ecc12ee3d9..6c013341ef09 100644
--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -1030,7 +1030,7 @@ static const struct flash_info spi_nor_ids[] = {
 	{ "mx25l25635e", INFO(0xc22019, 0, 64 * 1024, 512, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ) },
 	{ "mx25u25635f", INFO(0xc22539, 0, 64 * 1024, 512, SECT_4K | SPI_NOR_4B_OPCODES) },
 	{ "mx25l25655e", INFO(0xc22619, 0, 64 * 1024, 512, 0) },
-	{ "mx66l51235l", INFO(0xc2201a, 0, 64 * 1024, 1024, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ) },
+	{ "mx66l51235l", INFO(0xc2201a, 0, 64 * 1024, 1024, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | SPI_NOR_4B_OPCODES) },
 	{ "mx66u51235f", INFO(0xc2253a, 0, 64 * 1024, 1024, SECT_4K | SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | SPI_NOR_4B_OPCODES) },
 	{ "mx66l1g45g",  INFO(0xc2201b, 0, 64 * 1024, 2048, SECT_4K | SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ) },
 	{ "mx66l1g55g",  INFO(0xc2261b, 0, 64 * 1024, 2048, SPI_NOR_QUAD_READ) },
-- 
2.17.1

