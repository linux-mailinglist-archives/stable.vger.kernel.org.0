Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC975F4040
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 11:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiJDJsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 05:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiJDJsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 05:48:14 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EB55A8A7
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 02:45:46 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id kg6so12310384ejc.9
        for <stable@vger.kernel.org>; Tue, 04 Oct 2022 02:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pZYPVUL/QSpSgeRCqfSco3hgUPige10agfu312NmJpU=;
        b=gsX0Fg7WWHQkD7Nk+24KkVFT8RpEct+Mfefdc+0pgyH56Qit8YnvtvnSJudj00JNqN
         nW3r+4kmn7azcFrUiurDUJL7ZPbWeqctmDs6LywDLemMhQVOXByPqYBHouX+xS5al4yE
         YOIZngS5dxWch0NwC82lp/zDlTZeZXkp0Jo2kM2sNvJWANmD/TQxOIgw6haGXsVwbXbN
         9fcKRFuQfsuUQ4dMBfVAmlbqxeNkpm7zcgIalSKoHR4V//hvjl6oX5OVT9tOi+eG1S+S
         /SOeXGTeBM4wOL1IRAh5+ot3mm4SeHfDpBELKjhDK41ZOTaM3xilZ27Fp80UVWUACK/3
         MlNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pZYPVUL/QSpSgeRCqfSco3hgUPige10agfu312NmJpU=;
        b=wt090m1yuYfTUbPe7yUAlJQ7mVgw3rSQ+tyAw2n6DH9/vjy+a1PuQH+OQJb7bIiSPt
         iqAYIBydtoE3uqldKPnKUp2xpuDVfkwl8AGAhhhDygvuFPpC2Cj/n2gV80ydKkMKjMlE
         e6T9Q2+8LFQuD2oFh1KkGQiB/kHp6eNBIMMqlIVDJXTfWxikUfIC2tJNzC/8xDU7pFjD
         sT1v08Kc522jBvQKWKbWhbQyDjXhujZo/iHow7mwzjY3ipQDuOh8dAWQw6Nt9dZTk403
         DDpSmF7OH3b1CLKUaNOnh8JujT/ZovKPKUgGOpW7hYINEce4wwak4tctT6lDmI2gFBCo
         +Wfw==
X-Gm-Message-State: ACrzQf30qhy2lKtmJjbk96HDcLAi7oBtEB/NPh580rsXZkx/In0cTJDU
        ZL+0YJY+AL/2WYe/vlOvfRA3EKWjuQTVxQ==
X-Google-Smtp-Source: AMsMyM4OeVOsM/KULdxyIu3jNN3nyYS1aGJm7QHUK4ptaYb1vbG7c5/afEtvU+oUK1OBQwP+QHwDJQ==
X-Received: by 2002:a17:906:8144:b0:78a:ef70:2171 with SMTP id z4-20020a170906814400b0078aef702171mr7678730ejw.95.1664876711687;
        Tue, 04 Oct 2022 02:45:11 -0700 (PDT)
Received: from lb02065.fritz.box ([2001:9e8:1428:3700:4f35:4902:fc79:8669])
        by smtp.gmail.com with ESMTPSA id d2-20020a50ea82000000b00457cdb5cf76sm1347928edo.50.2022.10.04.02.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 02:45:10 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     linux-raid@vger.kernel.org
Cc:     song@kernel.org, stable@vger.kernel.org
Subject: [PATCH] md/bitmap: Avoid chunksize overflow
Date:   Tue,  4 Oct 2022 11:45:09 +0200
Message-Id: <20221004094509.44171-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When grow an array with bitmap to 4 TiB, the bitmap chunksize
will be
head /sys/block/md0/md/bitmap/chunksize <==
18446744071562067968

with 8 Tib, the chunksize is 4, which lead to assemble failure.
The root cause is due to left shift count >= width of type and overflow.

The fix is simple, do a type cast before shift, the bug is pretty old
since kernel 4.0 at least.

Cc: stable@vger.kernel.org
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index bf6dffadbe6f..b4d7a606a9d8 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2150,7 +2150,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	bitmap->counts.missing_pages = pages;
 	bitmap->counts.chunkshift = chunkshift;
 	bitmap->counts.chunks = chunks;
-	bitmap->mddev->bitmap_info.chunksize = 1 << (chunkshift +
+	bitmap->mddev->bitmap_info.chunksize = 1UL << (chunkshift +
 						     BITMAP_BLOCK_SHIFT);
 
 	blocks = min(old_counts.chunks << old_counts.chunkshift,
-- 
2.34.1

