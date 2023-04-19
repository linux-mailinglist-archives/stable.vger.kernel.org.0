Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7A16E76B5
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbjDSJtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232601AbjDSJth (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:49:37 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB94659F8;
        Wed, 19 Apr 2023 02:49:35 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id lh8so15450299plb.1;
        Wed, 19 Apr 2023 02:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681897775; x=1684489775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y4IOmy3b56e4fr9kImeRiAKyUprXNmIrwZPgWk/ZeOk=;
        b=nPFxQCq2edAFgtV05Q0mIy1oiag+qJD6rmobFoNdH5suB/s0UYBPokpg77q1uQrweW
         wrVZCN8P20MqahgJuO7thLBdrULiLx422jsk6GjEl3J51C0NvnQL4VsEsVMPR3zZ++0l
         FYwJbdVrAbRvCJRAT9wDQj9FBP6A4z49m46xMBDC5GbX2SoYR41pTqigaASKOYcva9uo
         LLdYVLf/G8cMKLh7E3U2gm+WTza1q5niRI8ls37uCXkq//VsXaIInMZUMfAFx1nPdJ1e
         mPVW4MxrfpqlX0DCpwuZNsYW17e+YcToeqD9DadQy9HltLj7IgaeUjcbGxgxuGT0B+ZD
         x1aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681897775; x=1684489775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y4IOmy3b56e4fr9kImeRiAKyUprXNmIrwZPgWk/ZeOk=;
        b=DYhpWiML4B6qHk+W7lkGVX0Kdcap+KvucXKGnUHMp7SZrI2QZwTia+BimPgbfl3bmP
         AaQ1KfVkPlyFesNxl4l7W6dUru04CfL4iRU2EWXg2GfEpJ80djMjPDGzWFsrL4CJxCf0
         ygIjcIGKw5Q92K29UUdMcI7Afqg9Mapdd97umWLhB+PsgJSKP2Cy24p9lu+yaY4yGqiP
         ducLefPWEt53KTVC+Bf+53MEQp/Kb1Pinqru58SBWNu1Av9ooZS7Q7CDIHI5ST/ZVts+
         hznQB3p4AOkdF6Gu3+uydLvPkZk9lc3ZnRRBIOWMYrqXyvEVQ7noDWSm8ERYHaHCnzL+
         2iYQ==
X-Gm-Message-State: AAQBX9e3spZWOzl31JGXlmvCRea0iLaGGNkrCDoXRFxa0iWfaR6G3QOR
        MACnWXUppIDENo3XKlpuNhcUPSDXAvOpVA==
X-Google-Smtp-Source: AKy350b28MCx5TF9zGpR1bYy2HYuPM3E0U3FqPwOFZyK66I58a2P006S1pWmr1PFZvVY58RsTkUoZA==
X-Received: by 2002:a05:6a21:380e:b0:f0:5c64:265c with SMTP id yi14-20020a056a21380e00b000f05c64265cmr2339584pzb.16.1681897775070;
        Wed, 19 Apr 2023 02:49:35 -0700 (PDT)
Received: from localhost.localdomain ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id g15-20020a62e30f000000b0063b86aff031sm6231207pfh.108.2023.04.19.02.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 02:49:34 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 4/6] fuse: fix attr version comparison in fuse_read_update_size()
Date:   Wed, 19 Apr 2023 17:48:42 +0800
Message-Id: <20230419094844.51110-5-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230419094844.51110-1-yb203166@antfin.com>
References: <20230419094844.51110-1-yb203166@antfin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 484ce65715b06aead8c4901f01ca32c5a240bc71 upstream.

[backport for 5.10.y]

A READ request returning a short count is taken as indication of EOF, and
the cached file size is modified accordingly.

Fix the attribute version checking to allow for changes to fc->attr_version
on other inodes.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Yang Bo <yb203166@antfin.com>
---
 fs/fuse/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 504389568dac..94fe2c690676 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -782,7 +782,7 @@ static void fuse_read_update_size(struct inode *inode, loff_t size,
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	spin_lock(&fi->lock);
-	if (attr_ver == fi->attr_version && size < inode->i_size &&
+	if (attr_ver >= fi->attr_version && size < inode->i_size &&
 	    !test_bit(FUSE_I_SIZE_UNSTABLE, &fi->state)) {
 		fi->attr_version = atomic64_inc_return(&fc->attr_version);
 		i_size_write(inode, size);
-- 
2.40.0

