Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1DB55E97C
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 18:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348281AbiF1QCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 12:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348223AbiF1QBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 12:01:52 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBAD369DA;
        Tue, 28 Jun 2022 09:01:20 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id r66so12633188pgr.2;
        Tue, 28 Jun 2022 09:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ms7vsCJ3KNMv6LkvIhOz6vCy+xk7uFLCFTiS1hc0XUY=;
        b=oiluIvNfVC0aTTssSHMYa5DHrjXqw5zNYZReKsP57s5cXxoTYvYybcLND0uzo7GcK4
         5SELX0IcKVBuxy+q7iNB2CuyYvItZwzXiSTag0xKu+athoGz29S3Wl90kYXzyQnfzLon
         IQjc6QtTGmtEgNZoax9978s0oJIayJkEnWNYJCVNBixY08y1z4boKoJM7h4FSwUo+ioj
         pZ999eG851G0FovkvfqI62MH8zzkfdQFvfZlliLfvO5vRQ5o6z6lvRJfxUc4HsezK6lZ
         EtDKrJI6J5d5iivDZA5mp9OrGrV6OFF385atTsXn4bSVft5oSt7JqCOdp970AjCfYA05
         bTIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ms7vsCJ3KNMv6LkvIhOz6vCy+xk7uFLCFTiS1hc0XUY=;
        b=a7hnxDlYuIh1fUVh57KvdeaZaoMMyvN7JZW5L2FXRCkBSAkCTFJWxmSRdKdCvoOvN1
         JaQ9U43Ck7meNzJAbomGnM96RBYG51AVWIVcgEhwWy3N6mwRDrsOcfLClHnDOrFYVuTl
         C7CBKQIMF2w5uEjizkH4x7C9jKwc5hCnQD4yrxzlaVUyBsaB5Yw+uhaXBsM2+dJjbJ2y
         cah1+IejbuglHaKYdmBX1jFJ6/K8qpCVpCmbE4pOpHUbUVDvTrpjMaAYA+icK/sFfcrg
         l5MpR/k9Jo/CSuqjNjYDZZraUGNacPVSBwdnOQZm8W10WcIFJ190XdXXOUuj/TLjLmuX
         yPDg==
X-Gm-Message-State: AJIora+GROBjqH/xUbxTZ74TwXCHm/WIxWFMFFXNbtYqG/3Aqfx9fMch
        B1WamtNrGDxfws+A4b7XoSfuJVxIFrw=
X-Google-Smtp-Source: AGRyM1vTNsXJat3pESWkFMNTzlJISpz5YpA4glw8kczw5EP+zySzBVZ36SiL9Gb+85VaC+rtAVO0zA==
X-Received: by 2002:a05:6a00:1a91:b0:525:a57c:25f3 with SMTP id e17-20020a056a001a9100b00525a57c25f3mr5428783pfv.75.1656432079503;
        Tue, 28 Jun 2022 09:01:19 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t5-20020a17090a4e4500b001ef12855acdsm7885pjl.19.2022.06.28.09.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:01:18 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Hsin-Yi Wang <hsinyi@chromium.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Will Deacon <will@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH stable 4.14] fdt: Update CRC check for rng-seed
Date:   Tue, 28 Jun 2022 09:01:10 -0700
Message-Id: <20220628160111.2237376-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628160111.2237376-1-f.fainelli@gmail.com>
References: <20220628160111.2237376-1-f.fainelli@gmail.com>
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
index 1d4090d2b91e..512d3a8439c9 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1159,6 +1159,10 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 
 		/* try to clear seed so it won't be found. */
 		fdt_nop_property(initial_boot_params, node, "rng-seed");
+
+		/* update CRC check value */
+		of_fdt_crc32 = crc32_be(~0, initial_boot_params,
+				fdt_totalsize(initial_boot_params));
 	}
 
 	/* break now */
@@ -1272,6 +1276,8 @@ bool __init early_init_dt_verify(void *params)
 
 	/* Setup flat device-tree pointer */
 	initial_boot_params = params;
+	of_fdt_crc32 = crc32_be(~0, initial_boot_params,
+				fdt_totalsize(initial_boot_params));
 	return true;
 }
 
@@ -1297,8 +1303,6 @@ bool __init early_init_dt_scan(void *params)
 		return false;
 
 	early_init_dt_scan_nodes();
-	of_fdt_crc32 = crc32_be(~0, initial_boot_params,
-				fdt_totalsize(initial_boot_params));
 	return true;
 }
 
-- 
2.25.1

