Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770BE53E61E
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239769AbiFFOdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239732AbiFFOdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:33:16 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C3D2BB1B;
        Mon,  6 Jun 2022 07:33:15 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id d5-20020a05600c34c500b0039776acee62so7262809wmq.1;
        Mon, 06 Jun 2022 07:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H8xbwTR16tvG4U/ddVZgdCLGD5EiTHqSz9fp9YwAxOk=;
        b=FXdeYNKMfp+gJSwO9mbfKLVfWObqC6NgNrZ7zFrCml4j+L8qsc+wNZzX7T7sFz0vh/
         nHnf4e1tVkgF5QG+5PS5uoAWch4HIBhNUo0gW19IfIof0ThXbauTxVH/3WjhEdj02Nei
         oHz+TP5WsYJlOZEslT1yqyBemXzOgwIMWZf6gqwzy/o6SWzatmdP02EZcvmq4pJwb8q7
         vcM+qvmYUzKvSMko6bsxn25d4RJoPAznVc/8vyNnht+DVLbIXHCxQ5Pj4dtohGvXWEih
         5N5ph5SpAkb0DVqe0yFWCY1/7uCtX2PPKQFMlkaVSmx8lX4V+P/Nq1A9OHeA/DOeDgiR
         9kYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H8xbwTR16tvG4U/ddVZgdCLGD5EiTHqSz9fp9YwAxOk=;
        b=Ll3LgZuvUH/ry62Xt7YjxwOKe43em8RkvUQl8BcXzXAxT+zQJAoVTN8UHGIa9imLW/
         Y4VW3PO8L/KGLxuQc4ks8p36Gr8z/7ChHyxTa6bGfK5a4dkcMgicTEjV5zGhrkB25AUB
         r0ssin9+XioCspxisaNE5/+fAFxq0Fc3M2qU8AiskmwyTbG/Pyszh2hJFUu+9GgAl2rT
         xikoBmoqEQMBNcVloAq9Z/lVsD7Lfqqlc8lGEz2g64/FqtAJ5tNpY31nMFmKkyOsWo0n
         7DYkt4z/WxqbwN5yQ6hlDSY9KrWmUMvmA3wRv+crDFNdxZdiRMmdOG/sFrKDBEZ97Wma
         h4Zg==
X-Gm-Message-State: AOAM531l97Pj1IZ0t9R+mdwlFKlZqme8pEomjamlkVZ4CCQxmmVAAtmr
        YFA4DYmwrQgFoK6Ut/YchJk=
X-Google-Smtp-Source: ABdhPJyaTYvxYliaA9PJPhTp779qgoAR8pWs0axIijaQA40qR6W1oUXK1V27x3BigtBSNzS5KhyVTQ==
X-Received: by 2002:a05:600c:354a:b0:39c:4ebf:fb4c with SMTP id i10-20020a05600c354a00b0039c4ebffb4cmr6121926wmq.142.1654525993737;
        Mon, 06 Jun 2022 07:33:13 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id h24-20020a05600c145800b0039c54bb28f2sm1622958wmi.36.2022.06.06.07.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 07:33:13 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 v2 7/8] xfs: consider shutdown in bmapbt cursor delete assert
Date:   Mon,  6 Jun 2022 17:32:54 +0300
Message-Id: <20220606143255.685988-8-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220606143255.685988-1-amir73il@gmail.com>
References: <20220606143255.685988-1-amir73il@gmail.com>
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

From: Brian Foster <bfoster@redhat.com>

commit 1cd738b13ae9b29e03d6149f0246c61f76e81fcf upstream.

The assert in xfs_btree_del_cursor() checks that the bmapbt block
allocation field has been handled correctly before the cursor is
freed. This field is used for accurate calculation of indirect block
reservation requirements (for delayed allocations), for example.
generic/019 reproduces a scenario where this assert fails because
the filesystem has shutdown while in the middle of a bmbt record
insertion. This occurs after a bmbt block has been allocated via the
cursor but before the higher level bmap function (i.e.
xfs_bmap_add_extent_hole_real()) completes and resets the field.

Update the assert to accommodate the transient state if the
filesystem has shutdown. While here, clean up the indentation and
comments in the function.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_btree.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2d25bab68764..9f9f9feccbcd 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -353,20 +353,17 @@ xfs_btree_free_block(
  */
 void
 xfs_btree_del_cursor(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	int		error)		/* del because of error */
+	struct xfs_btree_cur	*cur,		/* btree cursor */
+	int			error)		/* del because of error */
 {
-	int		i;		/* btree level */
+	int			i;		/* btree level */
 
 	/*
-	 * Clear the buffer pointers, and release the buffers.
-	 * If we're doing this in the face of an error, we
-	 * need to make sure to inspect all of the entries
-	 * in the bc_bufs array for buffers to be unlocked.
-	 * This is because some of the btree code works from
-	 * level n down to 0, and if we get an error along
-	 * the way we won't have initialized all the entries
-	 * down to 0.
+	 * Clear the buffer pointers and release the buffers. If we're doing
+	 * this because of an error, inspect all of the entries in the bc_bufs
+	 * array for buffers to be unlocked. This is because some of the btree
+	 * code works from level n down to 0, and if we get an error along the
+	 * way we won't have initialized all the entries down to 0.
 	 */
 	for (i = 0; i < cur->bc_nlevels; i++) {
 		if (cur->bc_bufs[i])
@@ -374,17 +371,11 @@ xfs_btree_del_cursor(
 		else if (!error)
 			break;
 	}
-	/*
-	 * Can't free a bmap cursor without having dealt with the
-	 * allocated indirect blocks' accounting.
-	 */
-	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP ||
-	       cur->bc_ino.allocated == 0);
-	/*
-	 * Free the cursor.
-	 */
+
+	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 ||
+	       XFS_FORCED_SHUTDOWN(cur->bc_mp));
 	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
-		kmem_free((void *)cur->bc_ops);
+		kmem_free(cur->bc_ops);
 	kmem_cache_free(xfs_btree_cur_zone, cur);
 }
 
-- 
2.25.1

