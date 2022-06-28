Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD9455E6C2
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 18:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348210AbiF1QCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 12:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348217AbiF1QBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 12:01:51 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B69E18351;
        Tue, 28 Jun 2022 09:01:19 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id b2so4464580plx.7;
        Tue, 28 Jun 2022 09:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NcCKExdCSACDLxaiOPpHRGUHg4hxXS4fdcOHrejw/IQ=;
        b=MI0AbkYM424hWLJpfblnIT9ghE31yHJGw4HkPF9wSS5JT3jMvlY23KLUFojVw15LI2
         KFoYJgzhrcCzDO2MJiOanFTwZ1ZWvsdQH8e/vdzrFtvgl8s2aOQJrH5LebJuCVOHl6nl
         GnL7hyJ/ZNwoPpZdnXEe+oLRat9vKj75mzhjU0aTx2XiiU6ciBmd948hg/sGYEv6WJDG
         7D/1uoEu9rQro06JUBSdnt3Jv8+vQ5AwNOGiJzrUjqciJgxcSxmh46Gj7dzG/VlS1jmz
         5qVXOv0any+RnbWVC8JIy3vAKp8Gu/l80Rk/+rcgzlltqGoCH0wzv2ucBuJfeeUZXiuG
         t41w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NcCKExdCSACDLxaiOPpHRGUHg4hxXS4fdcOHrejw/IQ=;
        b=fkp+k9V2R1X+GTIvQsELWUiviqVy42ltUtnLqpnxdMswgul5SOTBLqRxoGgpLVgMwk
         SLqsD1QTHu9EojA9xPwppqyzqxvFygm4rVsBpmMIVL9ilO0Gn9CURu0LU1HIfwtb1cpA
         Lr5Xf77pc/yl6wYElISmLsjdGN7S3rWJ98bnOZD+PihgbJ+vIRAiUs3qJGJ7ud+Zpz82
         wzYPyqBJBTjhG0naXtioJckAtwNL10sVRXSxt70FjWc29KRlz1X8OLT7+bOyDlVU8pvI
         +IpPjKzqWBTClRTqP0jcYHjHIUJmQ23Fhi/wO8qIKPOMV6s6cQKOA0KxDY1gpFuto+d2
         TuWA==
X-Gm-Message-State: AJIora8MEybmxEBNB6zPJSshSF/6pdzhIdKBqD9eYZejC/cz1LV6C7Ne
        QgFy+5Ls0dwyZI2rD5rD12TWyzMI9R0=
X-Google-Smtp-Source: AGRyM1s39TNtXjQ7rRwYz1B/rJocAtDAFXP6ydGQD7KRpvYPWNKL72ptibdW3ztsFaqlXSazML2YOQ==
X-Received: by 2002:a17:90b:2785:b0:1ef:ff9:4f4c with SMTP id pw5-20020a17090b278500b001ef0ff94f4cmr360339pjb.132.1656432078047;
        Tue, 28 Jun 2022 09:01:18 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t5-20020a17090a4e4500b001ef12855acdsm7885pjl.19.2022.06.28.09.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:01:17 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Hsin-Yi Wang <hsinyi@chromium.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Will Deacon <will@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH stable 4.9] fdt: Update CRC check for rng-seed
Date:   Tue, 28 Jun 2022 09:01:09 -0700
Message-Id: <20220628160111.2237376-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsin-Yi Wang <hsinyi@chromium.org>

commit dd753d961c4844a39f947be115b3d81e10376ee5 upstream

Commit 428826f5358c ("fdt: add support for rng-seed") moves of_fdt_crc32
from early_init_dt_verify() to early_init_dt_scan() since
early_init_dt_scan_chosen() may modify fdt to erase rng-seed.

However, arm and some other arch won't call early_init_dt_scan(), they
call early_init_dt_verify() then early_init_dt_scan_nodes().

Restore of_fdt_crc32 to early_init_dt_verify() then update it in
early_init_dt_scan_chosen() if fdt if updated.

Fixes: 428826f5358c ("fdt: add support for rng-seed")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/of/fdt.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index e797fa92c90d..513558eecfd6 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1110,6 +1110,10 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 
 		/* try to clear seed so it won't be found. */
 		fdt_nop_property(initial_boot_params, node, "rng-seed");
+
+		/* update CRC check value */
+		of_fdt_crc32 = crc32_be(~0, initial_boot_params,
+				fdt_totalsize(initial_boot_params));
 	}
 
 	/* break now */
@@ -1213,6 +1217,8 @@ bool __init early_init_dt_verify(void *params)
 
 	/* Setup flat device-tree pointer */
 	initial_boot_params = params;
+	of_fdt_crc32 = crc32_be(~0, initial_boot_params,
+				fdt_totalsize(initial_boot_params));
 	return true;
 }
 
@@ -1238,8 +1244,6 @@ bool __init early_init_dt_scan(void *params)
 		return false;
 
 	early_init_dt_scan_nodes();
-	of_fdt_crc32 = crc32_be(~0, initial_boot_params,
-				fdt_totalsize(initial_boot_params));
 	return true;
 }
 
-- 
2.25.1

