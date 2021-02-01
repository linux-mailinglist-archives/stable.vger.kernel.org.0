Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B839630A2B5
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 08:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhBAHcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 02:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbhBAHb4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 02:31:56 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD84FC061574;
        Sun, 31 Jan 2021 23:31:15 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d13so9484272plg.0;
        Sun, 31 Jan 2021 23:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fOg7NWxlgI9fk19UGiz6BE85HU1DmQkqRLvnGT+SkjI=;
        b=bNo/kmEXV9fhUVZiiLYJ4Gpis9YsOgZMtdJIQrcnFx/JBoKU6BP5Hv6IRi/3Y6ve18
         vwD3YiWnTnIlyYPv9wItzojVQTPaV8rks2Ken9wxA/IzBvB2Ys6MsB/b+20BwSG+o88J
         XL2SVjaZ0jfK6lqdZmi/nlqgtHnTigdu42111qXa+gLBzlqnMh0FxGdU1I0EUdu8VQOQ
         VmgclcoMRcLWEHb20Mi4LKTjPRj+BOR1oF+ajcvODSAM2Nf17CY7ojf3s6yjalvL8Xg2
         bX/8wSmtMTMYYfcdKy2Nef2vEeRxb+ZGhJhS3P2bFg+Im0YjSyiztFPQYqtlfz8vUv5I
         KNyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fOg7NWxlgI9fk19UGiz6BE85HU1DmQkqRLvnGT+SkjI=;
        b=pRQr8Bv2QInT0QnQ98HNl3l4nupT1w9C7Hd8Pka7wluEhI3hs0pjmUqczlew0TP53j
         iXNdnWQvjAxaUxTcpxmwFjoNtVGDHySLUBJP8kZPAzU1790OMZTfO6VNFBGN7wADvkLR
         NZeDc/dCnUkk2kQY3IIkgvQNjM0XohmAz9JSlc7RHy7aqfG48QNAiLD5eoSx10W30L1E
         MZg5zxvblhX+XSyaQsrGKx3pHKMZKK2Fjef6mMLDVVHWkI77hqyvAa7t4aWyLVZ1Q1Jb
         FaNDeQPxLV81x905EOnVT8K//WFhlVwv6/TVCN8qb7tnstBtVDnObQfZDx0v4WQ99Vtl
         JRhg==
X-Gm-Message-State: AOAM531zv0F9G7vKGGNXUgsRhXQia9b2yWCwE/Xp9G5WwqX4bj6glXbc
        eDVAPFe6j3G5ufplv9xmTPgjuJaPAhB7PA==
X-Google-Smtp-Source: ABdhPJy+2GHd/CnRKq2oRIQLRH2tz6xi6uxUOnQm4TFNzvzA+tZTjosneORFPPnYbikawRLiO8EVSQ==
X-Received: by 2002:a17:902:9d8d:b029:df:e5a6:1ef7 with SMTP id c13-20020a1709029d8db02900dfe5a61ef7mr16394895plq.77.1612164675319;
        Sun, 31 Jan 2021 23:31:15 -0800 (PST)
Received: from localhost.localdomain (S0106d80d17472dbd.wp.shawcable.net. [24.79.253.190])
        by smtp.gmail.com with ESMTPSA id m4sm17131511pfa.53.2021.01.31.23.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 23:31:14 -0800 (PST)
From:   jassisinghbrar@gmail.com
To:     linux-spi@vger.kernel.org
Cc:     broonie@kernel.org, Masahisa Kojima <masahisa.kojima@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>, stable@vger.kernel.org
Subject: [PATCH] spi: spi-synquacer: fix set_cs handling
Date:   Mon,  1 Feb 2021 01:31:09 -0600
Message-Id: <20210201073109.9036-1-jassisinghbrar@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahisa Kojima <masahisa.kojima@linaro.org>

When the slave chip select is deasserted, DMSTOP bit
must be set.

Fixes: b0823ee35cf9 ("spi: Add spi driver for Socionext SynQuacer platform")
Signed-off-by: Masahisa Kojima <masahisa.kojima@linaro.org>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Cc: stable@vger.kernel.org
---
 drivers/spi/spi-synquacer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/spi/spi-synquacer.c b/drivers/spi/spi-synquacer.c
index 42e82dbe3d41..a3344f1cc8ff 100644
--- a/drivers/spi/spi-synquacer.c
+++ b/drivers/spi/spi-synquacer.c
@@ -490,6 +490,10 @@ static void synquacer_spi_set_cs(struct spi_device *spi, bool enable)
 	val &= ~(SYNQUACER_HSSPI_DMPSEL_CS_MASK <<
 		 SYNQUACER_HSSPI_DMPSEL_CS_SHIFT);
 	val |= spi->chip_select << SYNQUACER_HSSPI_DMPSEL_CS_SHIFT;
+
+	if (!enable)
+		val |= SYNQUACER_HSSPI_DMSTOP_STOP;
+
 	writel(val, sspi->regs + SYNQUACER_HSSPI_REG_DMSTART);
 }
 
-- 
2.20.1

