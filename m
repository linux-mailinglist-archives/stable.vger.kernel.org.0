Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE9755ECC9
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 20:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbiF1Sk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 14:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbiF1Sk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 14:40:28 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5B422B10;
        Tue, 28 Jun 2022 11:40:28 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h9-20020a17090a648900b001ecb8596e43so13568321pjj.5;
        Tue, 28 Jun 2022 11:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XnCkR6czOl4KFZMbaWAEpeNu+QzA92KobMCND0qAxMo=;
        b=Mi6mhjFvRsUxVq0d1EyHNw2cKe3LM/BCqzaay5kfXUUWogCqCv9tWEohRuKR0xSy2d
         LQdOsvuorN4m7gUBed4Y9oJCuOOJ50xwARJSBwqLbDeyP3DKRkA2YLlqHR38hyTdIN3s
         783+Y/SKO1+cFBqtqfFdOSPgLNYCiqyhBSW26GSeIbhI7guvVxuO9QGgmtkx3HiwhKZs
         IToJogvUDZZMOGAVuay0dp2Q6CQq++Sj2RSB80i63ziqQ5P0SRrxO3sBE5P+f7+9jejq
         J7zJ3IfIknHLkPy7aFRNGdP4+MremcHci3A6kmJWWh9U22yISa9iCcrSqJdV9ouyHH3c
         IHlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XnCkR6czOl4KFZMbaWAEpeNu+QzA92KobMCND0qAxMo=;
        b=OT2bT7MY6ijkpycdjzo5akDaZwuxGe+Jm9837OXMR1FJR9KAUJvo1LFxhBqLxtDrZb
         3C1bm7S6PmiokH5ds8amuUAjxlRiJghpainCdC9k10h0EYZUAsx9sV5/v8/sY3Ms6d5d
         dDLiwHER/ERNs5qOvwN7QfYAhDSviSVOl3w30HzWwTJjRUWWp7MevUIDAlo2bnvw4GNN
         Z7HggEG66MYjqkjsJBnVG/gp0B7C7zTJO+UQ77DNfn6Obx95FgYSXzw41N+s77NhGyv4
         aCVkHToKzL+Ofx/s0n26yhH2jkcm9GEBkeo3AgD2TZE8MlwxbSUfgVOUOoe2zxouin+H
         GK/w==
X-Gm-Message-State: AJIora9lJv/wCpeNh2p/HkJAbSh31L3tLwBeLTMzndMqIhevZOnxtdvv
        ohH9UKkQt9EasJ+F2BiDO5lPk6jJPZjdzw==
X-Google-Smtp-Source: AGRyM1tiRLwquML9F6IPwoQXq431qU+Klrf/xYXAe2kXQ47kHRJw2ursRkC1UADAzG6aGe0CihnFwA==
X-Received: by 2002:a17:90a:a08:b0:1ea:f03c:51f7 with SMTP id o8-20020a17090a0a0800b001eaf03c51f7mr1094960pjo.49.1656441627265;
        Tue, 28 Jun 2022 11:40:27 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:1d5d:7791:41a3:902a])
        by smtp.gmail.com with ESMTPSA id a20-20020a621a14000000b005251bea0d53sm9743498pfa.83.2022.06.28.11.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 11:40:26 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 v4 7/7] xfs: only bother with sync_filesystem during readonly remount
Date:   Tue, 28 Jun 2022 11:39:51 -0700
Message-Id: <20220628183951.3425528-8-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
In-Reply-To: <20220628183951.3425528-1-leah.rumancik@gmail.com>
References: <20220628183951.3425528-1-leah.rumancik@gmail.com>
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit b97cca3ba9098522e5a1c3388764ead42640c1a5 ]

In commit 02b9984d6408, we pushed a sync_filesystem() call from the VFS
into xfs_fs_remount.  The only time that we ever need to push dirty file
data or metadata to disk for a remount is if we're remounting the
filesystem read only, so this really could be moved to xfs_remount_ro.

Once we've moved the call site, actually check the return value from
sync_filesystem.

Fixes: 02b9984d6408 ("fs: push sync_filesystem() down to the file system's remount_fs()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 23673703618a..e8d19916ba99 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1773,6 +1773,11 @@ xfs_remount_ro(
 	};
 	int			error;
 
+	/* Flush all the dirty data to disk. */
+	error = sync_filesystem(mp->m_super);
+	if (error)
+		return error;
+
 	/*
 	 * Cancel background eofb scanning so it cannot race with the final
 	 * log force+buftarg wait and deadlock the remount.
@@ -1851,8 +1856,6 @@ xfs_fs_reconfigure(
 	if (error)
 		return error;
 
-	sync_filesystem(mp->m_super);
-
 	/* inode32 -> inode64 */
 	if (xfs_has_small_inums(mp) && !xfs_has_small_inums(new_mp)) {
 		mp->m_features &= ~XFS_FEAT_SMALL_INUMS;
-- 
2.37.0.rc0.161.g10f37bed90-goog

