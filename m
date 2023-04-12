Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BE86DEA4F
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjDLEUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjDLEUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:20:14 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDD4268A;
        Tue, 11 Apr 2023 21:20:13 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id m18so10057570plx.5;
        Tue, 11 Apr 2023 21:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681273212; x=1683865212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uGMbkSZGnB4vRnSioRaJ2s6u2Xm9RnldP/euTgVDyHc=;
        b=Mbcd7M9MHOPCJIIkTdXgGzwe5v9KK948NEv1C2hvbOBBvNwYSKBQJshjLky9UPK3l9
         O3zTzqVuAI03TLd8/T/CoKSVf8MvKqESifNZ6DpFeJ/AmRTpxC+tXmcWbDGlwfmOcH41
         y9o/f2xmFoHE2L5U6vg+YCphxLAY5bdpg75elZEd2HRDqrqFU6IMBOqsom0196X/KBFP
         oDp1o3pfBif6VyYJ1woeJpWSqcKgitbYa78athdorO7VH5QVkeJlRyVj+BC7mSL4sWGA
         cVvGFKrqIj9U7MdweqVxI1g/Mwz7NZ/rPsIUTxDZERku+o0zY1CE56YNmap6lHJacJAD
         g62g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681273212; x=1683865212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uGMbkSZGnB4vRnSioRaJ2s6u2Xm9RnldP/euTgVDyHc=;
        b=SyuCkCk3lxeVDO4sERjebI3qci8KFdipgepZ+EZyHvjCK2+6zM5NJr9uy0A/78u8aM
         gJym/Kwf9gZuoI8+RUyJrcjrz/H5IS6sE6EzH5OdfVgf1l62fq+gjv0G4PHTgxYrV91w
         kJz+rtaZVH0LTSsO+4uudNAuAomjpIx5BWy84bZvWbBI31kpckVae1PQDOcohznuuWUh
         uwmSzaOhUw+PDh+6eTzk+8Q2W1skdznaVJ1AZMGGs5lhHbjWhiHsl3Lb8+a72aVghUja
         uW8eaKqFKPoFH5p96ddG1Y4RP+RKobulzEvP0wcAuzTbZDL3gV0dct7b11UoWijkz3/P
         nOJQ==
X-Gm-Message-State: AAQBX9dFbc/bSaG8toC1za8XXZyNcOIcxzH5CEPSO99Frtxt1mFnqQ70
        JgP6pZsGaFes4s2js0f4e3lLRpCAeXocgQ==
X-Google-Smtp-Source: AKy350aMRdBzdgg0H41GtB5Vn39rhilewLc4HCasggLcP70Y3g7ViBcFA2/wiQd2ViNXGcMgNb6STQ==
X-Received: by 2002:a17:902:fb50:b0:1a5:5927:2232 with SMTP id lf16-20020a170902fb5000b001a559272232mr4006482plb.53.1681273212441;
        Tue, 11 Apr 2023 21:20:12 -0700 (PDT)
Received: from virtualbox.www.tendawifi.com ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id t13-20020a1709028c8d00b001a19196af48sm10412381plo.64.2023.04.11.21.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 21:20:11 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 3/6] fuse: check s_root when destroying sb
Date:   Wed, 12 Apr 2023 12:19:32 +0800
Message-Id: <20230412041935.1556-4-yb203166@antfin.com>
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

commit d534d31d6a45d71de61db22090b4820afb68fddc upstream.

[backport for 5.10.y]

Checking "fm" works because currently sb->s_fs_info is cleared on error
paths; however, sb->s_root is what generic_shutdown_super() checks to
determine whether the sb was fully initialized or not.

This change will allow cleanup of sb setup error paths.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Yang Bo <yb203166@antfin.com>
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

