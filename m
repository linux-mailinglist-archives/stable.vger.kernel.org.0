Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89D659A59E
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349972AbiHSSPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 14:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350621AbiHSSPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 14:15:30 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45E113CDA;
        Fri, 19 Aug 2022 11:14:41 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id bf22so5348164pjb.4;
        Fri, 19 Aug 2022 11:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=C5lgC4kpzep5Mv+Wwyxx7oLNV95NU6fFpgEONgVs94g=;
        b=Gu8mk3GV1O5QAtdWHeCnTwIteSntblr7LMikhynBNeB8XDNUlzaDyAM+yufdgudeJc
         64PYVZlfg0tAcvU3cN5TufQcAFl5GZuqwbgsHOzwCwFE8rhCJMtaIH2oo13PuHhiTsjH
         VcjJhrJFwQZevY6mEJQRUXDvEMhGkewAp6r/Ui2uqmvzoQKknqaL6plioJlhNBdr/aSJ
         suWRxbphigdSKYlSxLXNCAQJiNcrZPBZZ5N1w+ki/j61gbSAdqlKoOY1klMI2JdrCxAJ
         Zh4Mt3mT04y6xzd3sH8edcJjlo4YTOOpIdJTy7dT+236QM5ngfUOaJOvowG48tx9J3i6
         ubqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=C5lgC4kpzep5Mv+Wwyxx7oLNV95NU6fFpgEONgVs94g=;
        b=ruFjAS+FJ5Tp1rHi9NY7y1f3HBIwmEFdgkV/mKXG1zqMgwF+uKqR+po92mUecwsdXe
         9Id1LxaYF++QHIDcSXCBVHazKkNVAk7U2DnsgejhyRcL9vL1dYdqhBNrnBmmmqsvF+jS
         VRMCddmqNYxd+yWS84I2gRkLcumpW8lgJ6ZMRIjC/Be/DabGgu90OkFkvDWKr6NeG1UD
         MSwQ0JozzP78C0vkAQb4RL/pI7QyqEDYzMMto2+ViJpOPED6NKqeHWoSDFXvvmeL4Wkw
         LE5OziFseepBfUdAc8l2LVgeHYFgB1XKVL4sSsWKJj5bCfqJIseTkZuM9Aa35OQEeCIj
         2KCA==
X-Gm-Message-State: ACgBeo19XZxx4iolIZHTneLoCVn406BXJy5LGz5zD68tFw2UpG9QfOFS
        2IcSuiOnmquqwGKYebYPK52OH5MVV9b/hQ==
X-Google-Smtp-Source: AA6agR6KYRhLTxVu+2c1A98fMP6mc4F8Wn23lN3HXoqfyRvUKMCz3DJ9m2N7uwjwbWZT1YzmX6VFbw==
X-Received: by 2002:a17:90a:e586:b0:1fa:d28b:ab9b with SMTP id g6-20020a17090ae58600b001fad28bab9bmr8225271pjz.47.1660932880810;
        Fri, 19 Aug 2022 11:14:40 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:3995:f9b1:1e6b:e373])
        by smtp.gmail.com with ESMTPSA id t14-20020a170902e84e00b0015ee60ef65bsm3460918plg.260.2022.08.19.11.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 11:14:40 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 3/9] xfs: reserve quota for target dir expansion when renaming files
Date:   Fri, 19 Aug 2022 11:14:25 -0700
Message-Id: <20220819181431.4113819-4-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220819181431.4113819-1-leah.rumancik@gmail.com>
References: <20220819181431.4113819-1-leah.rumancik@gmail.com>
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

[ Upstream commit 41667260bc84db4dfe566e3f6ab6da5293d60d8d ]

XFS does not reserve quota for directory expansion when renaming
children into a directory.  This means that we don't reject the
expansion with EDQUOT when we're at or near a hard limit, which means
that unprivileged userspace can use rename() to exceed quota.

Rename operations don't always expand the target directory, and we allow
a rename to proceed with no space reservation if we don't need to add a
block to the target directory to handle the addition.  Moreover, the
unlink operation on the source directory generally does not expand the
directory (you'd have to free a block and then cause a btree split) and
it's probably of little consequence to leave the corner case that
renaming a file out of a directory can increase its size.

As with link and unlink, there is a further bug in that we do not
trigger the blockgc workers to try to clear space when we're out of
quota.

Because rename is its own special tricky animal, we'll patch xfs_rename
directly to reserve quota to the rename transaction.  We'll leave
cleaning up the rest of xfs_rename for the metadata directory tree
patchset.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f4dec7f6c6d0..fb7a97cdf99f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3103,7 +3103,8 @@ xfs_rename(
 	bool			new_parent = (src_dp != target_dp);
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
 	int			spaceres;
-	int			error;
+	bool			retried = false;
+	int			error, nospace_error = 0;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -3127,9 +3128,12 @@ xfs_rename(
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
 
+retry:
+	nospace_error = 0;
 	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, spaceres, 0, 0, &tp);
 	if (error == -ENOSPC) {
+		nospace_error = error;
 		spaceres = 0;
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, 0, 0, 0,
 				&tp);
@@ -3183,6 +3187,31 @@ xfs_rename(
 					target_dp, target_name, target_ip,
 					spaceres);
 
+	/*
+	 * Try to reserve quota to handle an expansion of the target directory.
+	 * We'll allow the rename to continue in reservationless mode if we hit
+	 * a space usage constraint.  If we trigger reservationless mode, save
+	 * the errno if there isn't any free space in the target directory.
+	 */
+	if (spaceres != 0) {
+		error = xfs_trans_reserve_quota_nblks(tp, target_dp, spaceres,
+				0, false);
+		if (error == -EDQUOT || error == -ENOSPC) {
+			if (!retried) {
+				xfs_trans_cancel(tp);
+				xfs_blockgc_free_quota(target_dp, 0);
+				retried = true;
+				goto retry;
+			}
+
+			nospace_error = error;
+			spaceres = 0;
+			error = 0;
+		}
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * Check for expected errors before we dirty the transaction
 	 * so we can return an error without a transaction abort.
@@ -3429,6 +3458,8 @@ xfs_rename(
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);
+	if (error == -ENOSPC && nospace_error)
+		error = nospace_error;
 	return error;
 }
 
-- 
2.37.1.595.g718a3a8f04-goog

