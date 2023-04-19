Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C55B6E76B2
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbjDSJth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbjDSJte (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:49:34 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064B35FFD;
        Wed, 19 Apr 2023 02:49:33 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-63b509fe13eso2314700b3a.1;
        Wed, 19 Apr 2023 02:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681897772; x=1684489772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uGMbkSZGnB4vRnSioRaJ2s6u2Xm9RnldP/euTgVDyHc=;
        b=XnM0isyLvAerY/F+On1hv88PyPDCG4yRcL3XXnB1C11StoYu5D1TSqY4fHGAtmPGBp
         NK280Y9MMX7TdH5U7kDMt5J2L+CZ+ggZU5fdEF+PdP9UV055P2BvmjtRV311RatSchVv
         pwRd6NISU6EDoN+6dNBrfFSgZndbhvy2e1TUIUU0iHGSPKbBDidkKbVzZrBwKVKlOIBT
         V/khfY8lGOOrBgaXRPCCzdnknCuiRhpCPMCtPtUjjaymi/CTwsRwBKpC0scm8QjNv8DJ
         ZLgwJ3jzN4nnyHn3DTs1yjVW0l2ErlKw3MtkNsTmU4ROybryHSpMP/XWccBv9931lqE9
         Rtmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681897772; x=1684489772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uGMbkSZGnB4vRnSioRaJ2s6u2Xm9RnldP/euTgVDyHc=;
        b=Z3hdIErkkrPs6WfTZvlzYFzwQWMj8HzNSIUa1jqLI1Bb508id6SiB9YiLNBurIp+cg
         iiWdR8fr6Onm6Xw0h4d4qnnTH2ltWORom/+08Tc7+PP3ZKcbhrgu+Xky0NXuQpDjnXXv
         8I/fAQDEsOwr6nYeWFRxdtMa4/G8iHRRJXtY9muCRsJVPvFo6HQazB411UnzbApXfiw+
         MKi6RVBbYuuxoRo/Dkn82f02xt2nTTTY/S/Pg7jERiVvyW/z97boBk0HK8akxHgOIDqr
         +B+TYOsomZC2JtCF850xPEWHBI9FocifYPFS4FYvtI/yFeg9rjDZrEosF1CEqIOK/bPM
         wh9g==
X-Gm-Message-State: AAQBX9eaUvamepOOT5gMXICa6rdRTFhI+3pDPOf+xgpwCkxZO5RNRtiy
        uK/evt83oqOKJ/0/PtO1XNIcjuvlHzjcFw==
X-Google-Smtp-Source: AKy350aihbZGueRDagOtyZ1BZLfpr1UcJjwTE8zylraBo8Gs/1+hTh4aYN6EX1BQWZWwc//D60h+YA==
X-Received: by 2002:a05:6a00:2e01:b0:637:253a:531c with SMTP id fc1-20020a056a002e0100b00637253a531cmr3579192pfb.27.1681897772179;
        Wed, 19 Apr 2023 02:49:32 -0700 (PDT)
Received: from localhost.localdomain ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id g15-20020a62e30f000000b0063b86aff031sm6231207pfh.108.2023.04.19.02.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 02:49:31 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 3/6] fuse: check s_root when destroying sb
Date:   Wed, 19 Apr 2023 17:48:41 +0800
Message-Id: <20230419094844.51110-4-yb203166@antfin.com>
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

