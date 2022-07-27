Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187DA581CB8
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 02:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbiG0APg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 20:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbiG0APf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 20:15:35 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7402019C2E;
        Tue, 26 Jul 2022 17:15:33 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b7-20020a17090a12c700b001f20eb82a08so504730pjg.3;
        Tue, 26 Jul 2022 17:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=3RSdu/ftksH2kRInjQ7CZe/PjouCCOaY6R6ufSLyASQ=;
        b=f41v0gASRs2LjNLebJYIoYGWdNbcVY8lv8LN8tQ+PTdDq0Urge2d0L6C8cVHnaTv8D
         f6E7yF1xorMNuLPPljCe1JOZ4/NEU5Tlo61Yd22WX+X6U4jB9Vb4+xa8v1wiBTppAVBa
         5NAoLJrpeou6wOHiBxpZQLxfanle34MvNySVnXsmFqkuq/TnQelZk/vodXcWx47pYw/j
         YCyH2F2ib040lYlZU7uiiG3s0WPrizg6ocD1f60ITQ+PRZuCKu2/exloxEl9jRVXu5/o
         QWEyEN7ToWRTmDnkNJCaXZRc7AouklgkLN36Lw2QHbZaByD5wh0suSYhrwbfc0/zNH3V
         GWsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3RSdu/ftksH2kRInjQ7CZe/PjouCCOaY6R6ufSLyASQ=;
        b=qHMnplEyXBOlORIxhWCQzMkuHB6YapMQfTcJ/HJleJyVlLrwK2xF2eF1C5dhcQbfYk
         49X163/c7czrRQEQFweGUHEr45Yy24L2CEo1h1HuZBecbUXNfBpNecd5/+HVog5sD19i
         zx/BzCNOHbIehISh6YTzFpT0i5hzJ2X/q9zkSNEWMxBbxZW7iLGbMXQ0xhnIWJuMuxnr
         fB3ca5rhwUwxOLu6moQtR4TRuh3PQty278Ul9unKO2G7YkRq8A2uG1oS0JqLDufY3yG4
         S0P2Gkk8WbbDCzYs3A+7Cv3mx9LN7MsB2swzlz+o6cAhsPcc8gwLClc8isKOXXYipJrE
         nv6A==
X-Gm-Message-State: AJIora+d5CTFjdYIZXK1fzRKgbkrwvYiWP1fGxLbsoGseZb7J6cTlPFW
        ZrtHUjfAJiCJqOnB0qN2T1gPF7t/7rEyOw==
X-Google-Smtp-Source: AGRyM1u/LwAsCEZMgKu58cdfbc6X+rmkg7cqtKiuXRSrO5N9j0sBr+6aBlnWLpe1hpNWMkNbTvncBA==
X-Received: by 2002:a17:903:110e:b0:16c:defc:a092 with SMTP id n14-20020a170903110e00b0016cdefca092mr19142661plh.143.1658880932457;
        Tue, 26 Jul 2022 17:15:32 -0700 (PDT)
Received: from Negi ([68.181.16.133])
        by smtp.gmail.com with ESMTPSA id u5-20020a627905000000b005259578e8fcsm12298305pfc.181.2022.07.26.17.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 17:15:31 -0700 (PDT)
From:   Soumya Negi <soumya.negi97@gmail.com>
To:     Anton Altaparmakov <anton@tuxera.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Cc:     Soumya Negi <soumya.negi97@gmail.com>,
        linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        stable@vger.kernel.org
Subject: [PATCH v2] ntfs: Ensure $Extend is a directory
Date:   Tue, 26 Jul 2022 17:15:13 -0700
Message-Id: <20220727001513.11902-1-soumya.negi97@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix Syzbot bug: kernel BUG in ntfs_lookup_inode_by_name
https://syzkaller.appspot.com/bug?id=32cf53b48c1846ffc25a185a2e92e170d1a95d71

Check whether $Extend is a directory or not( for NTFS3.0+) while
loading system files. If it isn't(as in the case of this bug where the
mft record for $Extend contains a regular file), load_system_files()
returns false.

Reported-by: syzbot+30b7f850c6d98ea461d2@syzkaller.appspotmail.com
CC: stable@vger.kernel.org # 4.9+
Signed-off-by: Soumya Negi <soumya.negi97@gmail.com>
---
Changes since v1:
* Added CC tag for stable
* Formatted changelog to fit within 72 cols

---
 fs/ntfs/super.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 5ae8de09b271..18e2902531f9 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2092,10 +2092,15 @@ static bool load_system_files(ntfs_volume *vol)
 	// TODO: Initialize security.
 	/* Get the extended system files' directory inode. */
 	vol->extend_ino = ntfs_iget(sb, FILE_Extend);
-	if (IS_ERR(vol->extend_ino) || is_bad_inode(vol->extend_ino)) {
+	if (IS_ERR(vol->extend_ino) || is_bad_inode(vol->extend_ino) ||
+	    !S_ISDIR(vol->extend_ino->i_mode)) {
+		static const char *es1 = "$Extend is not a directory";
+		static const char *es2 = "Failed to load $Extend";
+		const char *es = !S_ISDIR(vol->extend_ino->i_mode) ? es1 : es2;
+
 		if (!IS_ERR(vol->extend_ino))
 			iput(vol->extend_ino);
-		ntfs_error(sb, "Failed to load $Extend.");
+		ntfs_error(sb, "%s.", es);
 		goto iput_sec_err_out;
 	}
 #ifdef NTFS_RW
-- 
2.17.1

