Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBE76DEA51
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjDLEU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDLEUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:20:24 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850DE268A;
        Tue, 11 Apr 2023 21:20:23 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id y11-20020a17090a600b00b0024693e96b58so9267722pji.1;
        Tue, 11 Apr 2023 21:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681273223; x=1683865223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y4IOmy3b56e4fr9kImeRiAKyUprXNmIrwZPgWk/ZeOk=;
        b=dafrD2NrCOk26li468Xsgot84smh8BLDTUdYDWr3D/p55vYOuemvPTHGnZygXfR2M2
         fQ5C6T83yKDDfhLgjgRVXbU+1PfKDbFig7d7461nNb2hBAQ6rUwckfxk/lBT9mJOoU6x
         9N+MbmA8znk1NnZe8GfV2y8PLAzK7u2k8dB2ZutKoDcCmeTg8VY5uThJ0xGW/79S9XEG
         RyUcCCAuGOipOf0ikQkHkrPB+WB0IpfNi5T/E3sqhzMTOlhLdr5mfC5EI+G9z5htv8rG
         N2Vm4k84+bdtYDKf071fHK8+kzm7j/iPrawTGisLB1vOFhJgtnDRv39dbe5QnzbY773j
         Z6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681273223; x=1683865223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y4IOmy3b56e4fr9kImeRiAKyUprXNmIrwZPgWk/ZeOk=;
        b=u7OaJTMT++am1hVplJnBtXG++KzVzYeBjvwZooLSTOX1PiqaS5X2FtXZTZldEFdURZ
         EbXkjs1X3dOLBI8BGHyoeTv6NtL6LVZwTY5+AjZghrq+vOa++kptdF4HHSpvwup4E/bI
         NQqxv8s6PAXfWBxMQNlWAmmxliMgZ5LdWcH73Y8MYSpFsNEVJrrri6O90cIvf0can7/G
         +QzJyzVc1RJSN2O8h4vzjmp9y1JkwPIi7UZrJSJozN8u+hO6h8MiEUOTlcD5Cax2tIwr
         mU9kQshhaRHuxWej1KJJQb4+OKjyFqHsrzM9N8PEMZrmiWI3LGI/98tnMfwUSwywVLCi
         3Dzg==
X-Gm-Message-State: AAQBX9cuI9kqbq3+PMI6tseepgYhg4Wxxd4ZHe75Sohg9xhGqbGTe5gv
        3L7x1MkN0JH2aYtBJmDPwWqc0eQ5K9lVIA==
X-Google-Smtp-Source: AKy350anle5fekcfSDTPpaFOciAdChyPE+/RMnJfCpMLBXYaAOVzt1S5VhispkFplPQV7yqKnYU9RA==
X-Received: by 2002:a17:903:186:b0:19d:20a:a219 with SMTP id z6-20020a170903018600b0019d020aa219mr5229941plg.66.1681273222785;
        Tue, 11 Apr 2023 21:20:22 -0700 (PDT)
Received: from virtualbox.www.tendawifi.com ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id t13-20020a1709028c8d00b001a19196af48sm10412381plo.64.2023.04.11.21.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 21:20:22 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 4/6] fuse: fix attr version comparison in fuse_read_update_size()
Date:   Wed, 12 Apr 2023 12:19:33 +0800
Message-Id: <20230412041935.1556-5-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412041935.1556-1-yb203166@antfin.com>
References: <20230412041935.1556-1-yb203166@antfin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

