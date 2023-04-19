Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6A06E76D6
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbjDSJza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbjDSJz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:55:29 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706D113868;
        Wed, 19 Apr 2023 02:55:07 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63d4595d60fso5724245b3a.0;
        Wed, 19 Apr 2023 02:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681898106; x=1684490106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SjCwWYwdch5oa4SOXINi7ir+mrHEqAwf3o+VWPWXjXA=;
        b=GPMB1iig8VOHx5/K8OITVR7YRxFOEOt0+l1hOojfI9XcmM9v0H3R6ZOQE/zrEX9zqM
         GagO2yp7icyiXdsa690Y68UT21nZl+Ehz7Y/FCziKCFHeaGZ4F2oqSdl+6F8oBnW1HJM
         aoJdpy2d4g2g59ZESi69ZxhPSy6GVUkKuW7LNMVoKt9WnDUeDKxtLqIww26G63ezrhfI
         YU8VGbapRjDAop7t0DdEMLLWrX/XTYoCg+6vG5UO6Cd6PLfPqOz5/Un61CP7MvlVDvWw
         fZunvCOJY0/PTKGTls+9sD22V5rxfn5I7rLkuyyujxFHBpCrtMN8s/KBD3FiNVhOyOtM
         08Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681898106; x=1684490106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SjCwWYwdch5oa4SOXINi7ir+mrHEqAwf3o+VWPWXjXA=;
        b=UVERvxrwg/I2cllWXg4g7T4lcceUTIF8wFNPCvodB7RSDqZ3Hy/ZLglQ4j4vz3MwfN
         v0dOSoFRY4HMB73Ts/OAxuZv4dwUUmXrBMi7UGcuTj86QrI1JxOHByjsZ7SceOR//AZy
         wE5MDMhqxoKc3HVwB0WPvXYJ+x9+yJ5Y7Gt94AT0JekL9etPcMlhRj9yf9OES1GsPyJT
         Bc6XmMgrMkSQP/FC5Clm8Y4WEmJORjSfGwHHHZL1Bm3iLR29sAYOM6g5Pd75mEAbiHlM
         lUb8SgNGi5gdvhC5GDNjnfwNcFXPp0F3xg3zbjGDpkfUtbcxAKLeS5c81ULT5TcbinQK
         4e/w==
X-Gm-Message-State: AAQBX9fMWdDE2ZfCUXNBxf/yYcMmOzbDWCc79uMAn/Qrk8MEPPfQl2WZ
        0bsFn9z+VLRov4kaqhI/AWpgDRPCD3w6uw==
X-Google-Smtp-Source: AKy350bJ6OHpEJzDz2FZSmTKhLts6RHsHj8njAi7qmkFgeuOrcTwnviuLodEPdp8IPL8QfesBNJbig==
X-Received: by 2002:a17:903:192:b0:1a0:7584:f46f with SMTP id z18-20020a170903019200b001a07584f46fmr2067012plg.9.1681898106657;
        Wed, 19 Apr 2023 02:55:06 -0700 (PDT)
Received: from localhost.localdomain ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id h12-20020a170902f7cc00b0019f9fd10f62sm11108357plw.70.2023.04.19.02.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 02:55:06 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 1/3] fuse: fix attr version comparison in fuse_read_update_size()
Date:   Wed, 19 Apr 2023 17:54:22 +0800
Message-Id: <20230419095424.51328-2-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230419095424.51328-1-yb203166@antfin.com>
References: <20230419095424.51328-1-yb203166@antfin.com>
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

[backport for 5.15.y]

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
index 2b19d281351e..ab994ecdaf38 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -793,7 +793,7 @@ static void fuse_read_update_size(struct inode *inode, loff_t size,
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	spin_lock(&fi->lock);
-	if (attr_ver == fi->attr_version && size < inode->i_size &&
+	if (attr_ver >= fi->attr_version && size < inode->i_size &&
 	    !test_bit(FUSE_I_SIZE_UNSTABLE, &fi->state)) {
 		fi->attr_version = atomic64_inc_return(&fc->attr_version);
 		i_size_write(inode, size);
-- 
2.40.0

