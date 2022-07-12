Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E9B5710A1
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 05:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiGLDGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 23:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbiGLDGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 23:06:11 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A8D93692;
        Mon, 11 Jul 2022 20:05:56 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id g4so6444245pgc.1;
        Mon, 11 Jul 2022 20:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XHe/kvvVGFhgWQMCPO6zbNMWlQyc0h0nxCqB63k2dO4=;
        b=bAWZXTicAiKioBs6p5Qo1FSct9sDAC0hraQxZCh9BgHlV/O/575wDQGaEkxGcAnSdh
         wJqNHTuP9kXSGQjJraTvmBRhw1BS/fJJh/3+o3zd7fggr3Jt8SuoBjt8QkDTyt7DioGo
         S844dJWTrEMBNnS7KlBTR6VvtHXMcPb1hhQdmKs/JboEVB8olz+detHL64JCxPaqHbYz
         sFSB4Kr6QaG/6mWTaE5ltHeglPEg+QVdPbcVUGxjO92ABBS3pmKrKctC46P4OjsCkiNR
         cfBnZ/al7e5hGFQRyMfeGnJQX/AmGw82IF9HxzkuT2a9MD1K8Ib5BvJFIJI2IXooiKZN
         xbqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XHe/kvvVGFhgWQMCPO6zbNMWlQyc0h0nxCqB63k2dO4=;
        b=qog9zQtWnh506oglI3buRPiBbfA5qBs+61pBtmjJqFUy7EL/0CzVqO4L8oRJGks+ZK
         TWTsE4MvXWdqnYfIcK+fcPTyJdcY1ggiv9Jd2ZHfV+yzYoQsPVY3WkiyDJ5t7wRgSf0x
         QXtDqp2xNzSrWtoxPlJF/ooRnAYZyJsVorcqGCSQYGDYNe2rrY9thaWII0RvJGFGcGKF
         0HYP1o/dyfxUOA7PbRlDqh5sXVCBbTJt4goUMJKAiGKkPOZjSnfjtt3gOFJ7E/L8h1Qn
         8wwP2wj/CmNFGrzcBmoNfpCQNSguX5KqnfgvhujMudcCRIm1QXEZkv/36x1Tzeuyu39+
         U42A==
X-Gm-Message-State: AJIora+EEpsAUcbxmuFA5elmz6NTfJdkiAFqiBOXEMGGA/kYFgiLMvFR
        YqwX1yh0IjGbicDSUItAAIM=
X-Google-Smtp-Source: AGRyM1uwmc4DGL3IXgwmiDmeLyj/RE6oQFxI7IzUnnuOZfjA5+wGBZWRK/IuSVbpUu3eXXzrKnPo0g==
X-Received: by 2002:a05:6a00:1d26:b0:528:31c2:5243 with SMTP id a38-20020a056a001d2600b0052831c25243mr20881620pfx.28.1657595156158;
        Mon, 11 Jul 2022 20:05:56 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id j14-20020a170903024e00b0016a5384071bsm5534076plh.1.2022.07.11.20.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 20:05:55 -0700 (PDT)
From:   xu xin <cgel.zte@gmail.com>
X-Google-Original-From: xu xin <xu.xin16@zte.com.cn>
To:     xu.xin16@zte.com.cn, anton@tuxera.com
Cc:     linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Songyi Zhang <zhang.songyi@zte.com.cn>,
        Yang Yang <yang.yang29@zte.com.cn>,
        Jiang Xuexin <jiang.xuexin@zte.com.cn>,
        Zhang wenya <zhang.wenya1@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH v3] fs/ntfs: fix BUG_ON of ntfs_read_block()
Date:   Tue, 12 Jul 2022 03:05:32 +0000
Message-Id: <20220712030532.1312455-1-xu.xin16@zte.com.cn>
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

As the bug description at
https://lore.kernel.org/lkml/20220623033635.973929-1-xu.xin16@zte.com.cn/
attckers can use this bug to crash the system.

So to avoid panic, remove the BUG_ON, and use ntfs_warning to output a
warning to the syslog and return ERR.

Cc: stable@vger.kernel.org
Cc: Songyi Zhang <zhang.songyi@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Jiang Xuexin<jiang.xuexin@zte.com.cn>
Cc: Zhang wenya<zhang.wenya1@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---

Changelog for v3:
- Use IS_ERR_OR_NULL to check runlist.rl in ntfs_read_block
- Modify ntfs error log.

Changelog for v2:
- Use ntfs_warning instead of WARN().
- Add the tag Cc: stable@vger.kernel.org.

---
 fs/ntfs/aops.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index 5f4fb6ca6f2e..b9421552686a 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -183,7 +183,14 @@ static int ntfs_read_block(struct page *page)
 	vol = ni->vol;
 
 	/* $MFT/$DATA must have its complete runlist in memory at all times. */
-	BUG_ON(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni));
+	if (IS_ERR_OR_NULL(ni->runlist.rl) && !ni->mft_no && !NInoAttr(ni)) {
+		ntfs_error(vol->sb, "Runlist of $MFT/$DATA is not cached. "
+				    "$MFT is corrupt.");
+		unlock_page(page);
+		if (IS_ERR(ni->runlist.rl))
+			return PTR_ERR(ni->runlist.rl);
+		return -EFAULT;
+	}
 
 	blocksize = vol->sb->s_blocksize;
 	blocksize_bits = vol->sb->s_blocksize_bits;
-- 
2.25.1

