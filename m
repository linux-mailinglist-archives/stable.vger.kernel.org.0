Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993C9585349
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 18:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236813AbiG2QQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 12:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235697AbiG2QQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 12:16:25 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E39587C3E;
        Fri, 29 Jul 2022 09:16:24 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id o13so6457651edc.0;
        Fri, 29 Jul 2022 09:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Fnp3rQDfDPfNUaf1Fm5bYwRds6uFzTYO3zgwRlYj5WM=;
        b=aAcvkYcwyeCpNbc6022379DwkLYy1OncFZQXSznPjCpypqXWMA09GJ+J9rgRuSzFKs
         4+HCTbjkVSlyCBQHbYkCzC0bdX9/zP4mQr2DBwA2D8F3LHqRghE+L0fzQMARzZN2YUPP
         uskJCR+Z71hMvB9aMb+lwoWf8XUwcO/6z2PTDlZFQOtIdbb5fHVqXwUryGOY6EU5e4kp
         OrgsxQKPHNz+Cqnf+FOjzmeM1xymv/BnBNWfToXyeIb6iRnjlu8A5SXnLduYSrd5di4a
         zl99LoONZtiG7nG8gaGfvmbfr6ZrXD982K7Aia5gE3slpSzelYQDqlqXi4pMQw21OgHT
         WA5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Fnp3rQDfDPfNUaf1Fm5bYwRds6uFzTYO3zgwRlYj5WM=;
        b=ZIqsWB5zBl5HsgIqTsbfqORqKx2TzTNFtJesgxMAb3C7ynELfWjQ5gACUitFC3l4bx
         T+LKp5MmrSz25Wy+p9pPQte8b7dmob+SPl/BIt1jzTj9s1XUyIrEkaHNb8JTVDwTUV6+
         Fuk9z0Aho3VbSlYHrA0UKsvQWYpe9gG5iakj5C27ioqms3gTxSVrYOIQhAdOeUQWKSLT
         BZy8Lhv5X37/1DCc7+LUc18Cm72tkPOi+EmgkvYCC3Ws7BZ6z6HKBwzYWf1XGja24F6v
         F4WUQadeHW2yIanvm3acQqxMpNNcvwm1hDThuF50jbUc6qvT6Mj9MQQAWh7rRiz2JpV+
         X0TA==
X-Gm-Message-State: AJIora+a7cRlzG1fu47DiGcZQ55t0gp92gNn0Y8bte2AuGJVNFwCHslD
        dKwWE9GeMOS7ZQ2kaMGWrPCE4lGWFd061g==
X-Google-Smtp-Source: AGRyM1uY9G/aHwakm7JDzD/6DjYro2k9fnlZmRfBofPwNhx3+PDrrzIcmZPILtVZt0bV2Mo0AkowLA==
X-Received: by 2002:aa7:dc12:0:b0:43b:5d77:f0b with SMTP id b18-20020aa7dc12000000b0043b5d770f0bmr4322819edu.37.1659111382893;
        Fri, 29 Jul 2022 09:16:22 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan (4.196.107.92.dynamic.wline.res.cust.swisscom.ch. [92.107.196.4])
        by smtp.gmail.com with ESMTPSA id fm15-20020a1709072acf00b0072b14836087sm1870116ejc.103.2022.07.29.09.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 09:16:22 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 v2 5/9] xfs: force the log offline when log intent item recovery fails
Date:   Fri, 29 Jul 2022 18:16:05 +0200
Message-Id: <20220729161609.4071252-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220729161609.4071252-1-amir73il@gmail.com>
References: <20220729161609.4071252-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 4e6b8270c820c8c57a73f869799a0af2b56eff3e upstream.

If any part of log intent item recovery fails, we should shut down the
log immediately to stop the log from writing a clean unmount record to
disk, because the metadata is not consistent.  The inability to cancel a
dirty transaction catches most of these cases, but there are a few
things that have slipped through the cracks, such as ENOSPC from a
transaction allocation, or runtime errors that result in cancellation of
a non-dirty transaction.

This solves some weird behaviors reported by customers where a system
goes down, the first mount fails, the second succeeds, but then the fs
goes down later because of inconsistent metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c         | 3 +++
 fs/xfs/xfs_log_recover.c | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 05791456adbb..22d7d74231d4 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -765,6 +765,9 @@ xfs_log_mount_finish(
 	if (readonly)
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 
+	/* Make sure the log is dead if we're returning failure. */
+	ASSERT(!error || (mp->m_log->l_flags & XLOG_IO_ERROR));
+
 	return error;
 }
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 87886b7f77da..69408782019e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2457,8 +2457,10 @@ xlog_finish_defer_ops(
 
 		error = xfs_trans_alloc(mp, &resv, dfc->dfc_blkres,
 				dfc->dfc_rtxres, XFS_TRANS_RESERVE, &tp);
-		if (error)
+		if (error) {
+			xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
 			return error;
+		}
 
 		/*
 		 * Transfer to this new transaction all the dfops we captured
@@ -3454,6 +3456,7 @@ xlog_recover_finish(
 			 * this) before we get around to xfs_log_mount_cancel.
 			 */
 			xlog_recover_cancel_intents(log);
+			xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 			xfs_alert(log->l_mp, "Failed to recover intents");
 			return error;
 		}
-- 
2.25.1

