Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E907025B70
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 03:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfEVBD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 21:03:28 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33747 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbfEVBD2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 21:03:28 -0400
Received: by mail-pl1-f195.google.com with SMTP id g21so200443plq.0;
        Tue, 21 May 2019 18:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hZxOPx40sM31sXATrJWIrdV0RTZA1DlPQH1xR20a6EI=;
        b=jgen3ia4nDSmuFARPMsvjj7DWaO1iW//OuXl403j+o/G/TeeSqMiVvZ0ntMuQMMXz6
         dtYV3xJmd6l827CYLhYs0ByM6njiVjg79s2sLCEs10WDDns51gcmIiqVYfDp/6R1nW+G
         D7wCvEhSSQapr8PxP9ML32wzLwnQZxIdUggSCXCB7IypYUWUyr8i5evxZj6HPi+WRFmO
         yXzbdeJePZ2tMsOKiODoiM6UEvZefm+7ELDy419DUzcbnyj1I3a46oV0Ah5yp0TC7bIQ
         KccvvkiC4s8eBlLscwu0inRFcPY4XG+2RKJmEymnUlEEow92i0+LBjTtou2cCMaAb2x1
         Njgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hZxOPx40sM31sXATrJWIrdV0RTZA1DlPQH1xR20a6EI=;
        b=OJAUKqGqq4aaRwaVuH2DC1x35vFTK7Zsutx87MqDpZI92GQQSvHfoEg2ZgO2l15Rr+
         zbxYUHPDkDHCCQIEXBRCGICrRy5WmDjUuQc4V4++V4epiUPllZb8WbI7+9DVqNDnH9NT
         lLbLRn0gS4rB5KMxBdD3Kdfx2LFV3txV4Tr26CA1/H4QbxnJGAx33AHQvzjKO16NKYDm
         J17neVbnjcshxX9sayhI+k9YlUtJZ0VwEkFQOVG4pYkEj+GKvB3XHcEwPTIfxwtIiyfM
         IPk7e+e1S3PdVU6PrkZdIV/3QQrch8gdD9EDlEkaMavoXE0aFb/UHLDgCaPgWvZl/oCE
         MCcA==
X-Gm-Message-State: APjAAAUyc+uniQLgnDcDi/6cyEgnS7hCg548UmC2+m4fidZBWS5znWzN
        s/POu1kW96VWmaofAJf/82tjxCvB
X-Google-Smtp-Source: APXvYqxX3046Ypk/1iJeTlE7JccOi5IUU7WTFVOh31S6dnrg9pgR8igRa5NROi7akpn4K9HbrvEROQ==
X-Received: by 2002:a17:902:424:: with SMTP id 33mr87086594ple.102.1558487007261;
        Tue, 21 May 2019 18:03:27 -0700 (PDT)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id q193sm34291242pfc.52.2019.05.21.18.03.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 18:03:26 -0700 (PDT)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>, stable@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v8 1/5] gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM
Date:   Tue, 21 May 2019 18:03:13 -0700
Message-Id: <20190522010317.23710-2-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190522010317.23710-1-slongerbeam@gmail.com>
References: <20190522010317.23710-1-slongerbeam@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The saturation bit was being set at bit 9 in the second 32-bit word
of the TPMEM CSC. This isn't correct, the saturation bit is bit 42,
which is bit 10 of the second word.

Fixes: 1aa8ea0d2bd5d ("gpu: ipu-v3: Add Image Converter unit")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Cc: stable@vger.kernel.org
---
 drivers/gpu/ipu-v3/ipu-ic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
index 594c3cbc8291..18816ccf600e 100644
--- a/drivers/gpu/ipu-v3/ipu-ic.c
+++ b/drivers/gpu/ipu-v3/ipu-ic.c
@@ -257,7 +257,7 @@ static int init_csc(struct ipu_ic *ic,
 	writel(param, base++);
 
 	param = ((a[0] & 0x1fe0) >> 5) | (params->scale << 8) |
-		(params->sat << 9);
+		(params->sat << 10);
 	writel(param, base++);
 
 	param = ((a[1] & 0x1f) << 27) | ((c[0][1] & 0x1ff) << 18) |
-- 
2.17.1

