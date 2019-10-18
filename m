Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7C0DC565
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 14:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391193AbfJRMt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 08:49:58 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:43470 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbfJRMt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 08:49:58 -0400
Received: by mail-io1-f65.google.com with SMTP id v2so7250694iob.10;
        Fri, 18 Oct 2019 05:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vt2yevto8JpVokDOAHk/MhpPGOGQv2lzrfEs5YW1bcs=;
        b=iJ5TSOPL6guDtN+KkWvp7kq9fmbhR6QT7qC4fHwOqs6WlpIcdWtK+D90h8pl8wzGny
         5nsnGSra/XZ0yKI/66CRCG1s24VKLQRy5yojj19uhmeiwyAo57k3UsCw5uix68W3in0A
         at0rdp0RXaNp9DxEbO7zIpYwuODy8CoIhrzhntfzoe0vorcEmCTPyGAGv1B13FlCDVEF
         rdSY0+i/aDWZMJHBYTnPNw+S8WyT3pOELkI/ToEjxHOz7aC7uTxiLz2N4LV00uMC7Vvk
         rE/BdRxCBEAv13ZASSKL1Cl85btRQOTnGOGK11X0rcbL/o7TroRihlv9are58zGZu12y
         CBeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vt2yevto8JpVokDOAHk/MhpPGOGQv2lzrfEs5YW1bcs=;
        b=eA5mIjQEaA/9ajeYsLIPCVQanr9sFz99zxALAN+H4NNaYokf3/j3xozOAjKjyjivkG
         X2n9rInEFZMAGyl2NZCQykVH4Oot++asArL99uoLy1DoVF0PnDWTFMZagcJd4S7DLdnG
         k5tDNsA4CkLUZl9TcOalMNzfDujd3xOlArd6bIb16Av0fRtlEUL1IIxNTlK/rwfidUQG
         PGft/X008jgcLeDBgcRIPuoJvRT3QAvyVjSAs0/R5AOgQRwNcCumIqGDh2YCQAoBVeMv
         llDV78i/bYJhu7aphDa26MQ+a1/VOiWj2QekmlJz9QzUKy2cMtsiTkNV1pgoDnm/NCnD
         7hjA==
X-Gm-Message-State: APjAAAUzbRVP5HfXSBycPIz/ydsKATGNS3+ARM2ej0nCtqnijN+ZPwlY
        NSp8eoX0kCyP5EVh3nTBm0OaJMjB44A=
X-Google-Smtp-Source: APXvYqyzzvszH1UbTyYx0NKA2hnNmpf8BjkjTNbKO7/3o54SB64EMA8N5/EMTTSPCcKrWfhQGNSgZg==
X-Received: by 2002:a5e:9e0a:: with SMTP id i10mr8199609ioq.172.1571402996741;
        Fri, 18 Oct 2019 05:49:56 -0700 (PDT)
Received: from localhost.localdomain (c-73-37-219-234.hsd1.mn.comcast.net. [73.37.219.234])
        by smtp.gmail.com with ESMTPSA id q74sm2003992iod.72.2019.10.18.05.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 05:49:55 -0700 (PDT)
From:   Adam Ford <aford173@gmail.com>
To:     linux-fbdev@vger.kernel.org
Cc:     linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        tomi.valkeinen@ti.com, adam.ford@logicpd.com,
        Adam Ford <aford173@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] fbdev/omap: fix max fclk divider for omap36xx
Date:   Fri, 18 Oct 2019 07:49:38 -0500
Message-Id: <20191018124938.29313-1-aford173@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The OMAP36xx and AM/DM37x TRMs say that the maximum divider for DSS fclk
(in CM_CLKSEL_DSS) is 32. Experimentation shows that this is not
correct, and using divider of 32 breaks DSS with a flood or underflows
and sync losts. Dividers up to 31 seem to work fine.

There is another patch to the DT files to limit the divider correctly,
but as the DSS driver also needs to know the maximum divider to be able
to iteratively find good rates, we also need to do the fix in the DSS
driver.

Signed-off-by: Adam Ford <aford173@gmail.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: stable@vger.kernel.org #linux-4.9.y+

diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dss.c b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
index 48c6500c24e1..4429ad37b64c 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/dss.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
@@ -843,7 +843,7 @@ static const struct dss_features omap34xx_dss_feats = {
 };
 
 static const struct dss_features omap3630_dss_feats = {
-	.fck_div_max		=	32,
+	.fck_div_max		=	31,
 	.dss_fck_multiplier	=	1,
 	.parent_clk_name	=	"dpll4_ck",
 	.dpi_select_source	=	&dss_dpi_select_source_omap2_omap3,
-- 
2.17.1

