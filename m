Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58ADE6DD015
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 05:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjDKDVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 23:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDKDVi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 23:21:38 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFB3E5A
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 20:21:37 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id w11so6550621plp.13
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 20:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681183297; x=1683775297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AXFcHPUSc4UyLEtpIlp65DRwTRFVuyBWzxkI5bk8xH4=;
        b=cBVo8U4E16lng2hHaeeeoL9t+lcyizTMVUisW7fA89202ua5at0VSjPBmnebetepNQ
         H8VfrqQaPuTIxK2+iEYa8/PO6M/9tNOJ+lNpukBFbz9OXTOI8uWByBMmb0hGMYBYxLY4
         Mp10oSri9dBiHvr3nqAe+H47B2zsxc0VL1eKCdnusOieIpsIH5hpZMpUmdyDIwwcG+Fv
         85u8ewvwNQnvqDHwd2X4naN8LnXdTEtlPtgyNEXNqmaSqQPQ4hjTowIIxN0melc78rtV
         XyiPM2u0kRPHhf7VSK1evW5IMXflW1KnBFD00ZvMxvCci/2e90nlVo1yyHiAWfCkMXSq
         MvdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681183297; x=1683775297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AXFcHPUSc4UyLEtpIlp65DRwTRFVuyBWzxkI5bk8xH4=;
        b=csYSnJeqVmFUL9FqeVEOJ5DVg/Rw/AOrInZZQ3KcvPwHB8HSEaDhEUPlNOerFEgY94
         rwuLg96zT9O6LPlUqYAPHTlShJwdg0BI4PQvzJ+xgjXCASUc7ewd01Wa6ThZcvYOBMGW
         r8L//VeJMADMRxR3w0/exvqXEoR1+LhObaq7Fgx/VNrunpfLpxkdj0XARSedU9FOCGX0
         9ZHdcrdhldhUF1m256aBbgdbyiYILahgA/t0DTSqlb8BEmpYuXeiBhPCGKdFJokQLd7w
         jSmiDWxc0R+YCAWHP7LqSF4BfbdWIuvQcSvOi+lvzs6IvZSA/MN6Mx5+HG5j9EhU0Ryc
         fEww==
X-Gm-Message-State: AAQBX9eB5KXL02SULGjM4Aa/e3NWYBpMLP7N9UkjJUYzzngC82jfQS7+
        EwisjOghac+5RzT+DESbUgR/gpn0X5H6ag==
X-Google-Smtp-Source: AKy350aQ2ZkxnpShT+qtr3AVf4lDDG0TPzynL2QlqzVeBlgBM+WLzYAxWL3Rv79x65Iq4XSlykB58g==
X-Received: by 2002:a05:6a20:b88:b0:d6:26a3:98d with SMTP id i8-20020a056a200b8800b000d626a3098dmr11935039pzh.46.1681183296737;
        Mon, 10 Apr 2023 20:21:36 -0700 (PDT)
Received: from localhost.localdomain ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id m4-20020a63fd44000000b004ff6b744248sm7743195pgj.48.2023.04.10.20.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 20:21:36 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 3/6] fuse: check s_root when destroying sb
Date:   Tue, 11 Apr 2023 11:21:08 +0800
Message-Id: <20230411032111.1213-3-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230411032111.1213-1-yb203166@antfin.com>
References: <20230411032111.1213-1-yb203166@antfin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit d534d31d6a45d71de61db22090b4820afb68fddc upstream.

[backport for 5.10.y]

Checking "fm" works because currently sb->s_fs_info is cleared on error
paths; however, sb->s_root is what generic_shutdown_super() checks to
determine whether the sb was fully initialized or not.

This change will allow cleanup of sb setup error paths.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/inode.c     | 2 +-
 fs/fuse/virtio_fs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 058bb82dee40..7a86db768117 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1572,7 +1572,7 @@ static void fuse_kill_sb_anon(struct super_block *sb)
 	struct fuse_mount *fm = get_fuse_mount_super(sb);
 	bool last;
 
-	if (fm) {
+	if (sb->s_root) {
 		last = fuse_mount_remove(fm);
 		if (last)
 			fuse_conn_destroy(fm);
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 6aaaa74438f3..faadc80485e7 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1399,7 +1399,7 @@ static void virtio_kill_sb(struct super_block *sb)
 	bool last;
 
 	/* If mount failed, we can still be called without any fc */
-	if (fm) {
+	if (sb->s_root) {
 		last = fuse_mount_remove(fm);
 		if (last)
 			virtio_fs_conn_destroy(fm);
-- 
2.40.0

