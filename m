Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B55A55E682
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 18:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348299AbiF1QCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 12:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348235AbiF1QBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 12:01:52 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAA937A8F;
        Tue, 28 Jun 2022 09:01:21 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id w24so13002233pjg.5;
        Tue, 28 Jun 2022 09:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tPyidp/Hbkt+IJjfFTUdDt2y5LsToJzbXu5kGwBQPk8=;
        b=GoqPIJDP3JwcgU1hQWu9Ia7nr5/MstYHT9QXBez7nQMnd2oNUS9PL8MChFcGnnkM2M
         pn1z7Lu4kPF5/CHFNaJa+tVtP5VszAGgkcE6qbE/8nHwKUtuaAWrR6UmJzC78OjPSo9W
         aw5iXG2v9Lz+bqqRbYRDJcDU/rEBxUBWj8373kSkqHpn8PfrEN0YijJMq5A8ynjzQnwF
         LtSR3+X8YSbWzScDJ/1+EEqlb+Av5D620JhI6BhxDuWEHyDVYGumT64fTmg3CkiGjtgo
         WvXHJwI3hytT5Okmed4NYa0aSCJD7KWj/2t//tXISQ5ZflLaP07e+sdLYdeFPikPPqGi
         Zn/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tPyidp/Hbkt+IJjfFTUdDt2y5LsToJzbXu5kGwBQPk8=;
        b=BELnHEGC2s4HLVSjIDLV8ZbUPjdp/6YBmBmhX/HDwdpj5H905Gql+ddIVUUnU94del
         NVJ8shj+7w+uO19BGApsWBTfV0FXWrPojr1vkYTR2bxnGGTEJ6tvSeR6BsQjLzhUtIWz
         q0A0j6sHBoMRWSIOiLdGU1ixiU/PHzbwrVrWmRNQuXlDKwP+bVqaaA5fbKnzzlFqnRR/
         77Yvq4x9t3oX05t85sjTi7rS6StVo0CBXZejYHEhrPsmsP98SsKnzEgOLznnEWO+P+vL
         gP+Bq7Kd/SF5etvQEdiQFc26CLL3ApviYMt/NgF5FZPW2rTQxzGaSB34UZsRtjabvzl+
         23Rw==
X-Gm-Message-State: AJIora/l7feqZGYfFM+KmfWA0K5i6znEz/0jknq36+HRSHX9PHY2HzML
        uQXDyWIXxnNal04sN+Kcd1a3ltwFU5M=
X-Google-Smtp-Source: AGRyM1v7KuEphQefjfEn/Hzgy26MwtZ7a3Gh/HlT4a418YYHoCyRJts31SCzRGuAsjEAyRphzChN9w==
X-Received: by 2002:a17:902:f543:b0:16a:54c6:78d0 with SMTP id h3-20020a170902f54300b0016a54c678d0mr4384140plf.28.1656432080829;
        Tue, 28 Jun 2022 09:01:20 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t5-20020a17090a4e4500b001ef12855acdsm7885pjl.19.2022.06.28.09.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:01:20 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Hsin-Yi Wang <hsinyi@chromium.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Will Deacon <will@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH stable 4.19] fdt: Update CRC check for rng-seed
Date:   Tue, 28 Jun 2022 09:01:11 -0700
Message-Id: <20220628160111.2237376-3-f.fainelli@gmail.com>
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
index 2e9ea7f1e719..9fecac72c358 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1119,6 +1119,10 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 
 		/* try to clear seed so it won't be found. */
 		fdt_nop_property(initial_boot_params, node, "rng-seed");
+
+		/* update CRC check value */
+		of_fdt_crc32 = crc32_be(~0, initial_boot_params,
+				fdt_totalsize(initial_boot_params));
 	}
 
 	/* break now */
@@ -1223,6 +1227,8 @@ bool __init early_init_dt_verify(void *params)
 
 	/* Setup flat device-tree pointer */
 	initial_boot_params = params;
+	of_fdt_crc32 = crc32_be(~0, initial_boot_params,
+				fdt_totalsize(initial_boot_params));
 	return true;
 }
 
@@ -1248,8 +1254,6 @@ bool __init early_init_dt_scan(void *params)
 		return false;
 
 	early_init_dt_scan_nodes();
-	of_fdt_crc32 = crc32_be(~0, initial_boot_params,
-				fdt_totalsize(initial_boot_params));
 	return true;
 }
 
-- 
2.25.1

