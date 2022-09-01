Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD335A8DA4
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 07:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbiIAFtu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 01:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbiIAFte (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 01:49:34 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62382117ACB;
        Wed, 31 Aug 2022 22:49:20 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id m16so20829486wru.9;
        Wed, 31 Aug 2022 22:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=M3jAT3YQCl4NufeW6oCkMl9aVNOp6TjzxP0+mQ9Dows=;
        b=q74S3j9a2DH2WQcHC5XMVxoVDw/gyodqLA0RLf2ByvyojIvpvtfmtB7Lu66e+pc6dL
         4Lxla631n8+TW2rNUGZ1tjXENxN+51Up7tPqyyXNXI/3fb3gdD82OTBua6nuvuQyowkC
         Vk2J+vl7h79XyH6g61NZMz7PjcmbYE2JFgdFNVusxZP3Jsj0t0D10HCB1DO07vVt+fqW
         psPCQg53dGojhx/sPTAwEggvbNR/PEe0IOkOM7hkG5xzMx2V8JHVVzabLaeLapWl7yfw
         AMYDnLf0ItvaasNmbdq6rTAX60GbcW7Oo/TUU0vSDPPbhM1kRNfWO1/NZzXcXfL0mQFl
         uerA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=M3jAT3YQCl4NufeW6oCkMl9aVNOp6TjzxP0+mQ9Dows=;
        b=GKtlr5kwT08qp3AQ8waVMfQgknrPV8VgHlBW+F+jZmBzpuLdZb2/j88Nq8fn3N4OZt
         IPFZeKQqpbaq0OH48TIGZVzpiS/jniXtTqdR1r2dMlwN+A7fnGinpokUbzO7z7waT3wj
         Kf65GJiNiGJAZEaxSrjDQmRc94Y7ARo9qlyw/CbNDQvlHKOf+eRLzR+iXjUIcyL3m8ih
         679cO+FWh69UFuzk3EMPjUN4BWO/zKd3k+6uc2zBC63X5mOZkAiyNpYZrKg5viV4pN9F
         HVy/cSS7YrOWTDldYNw8GTdxgD+lWezmf6f538YH7OGWtULCUVhACkmuAB+fVXQ2cfAF
         xiYw==
X-Gm-Message-State: ACgBeo24hgMY8EOBbYCJnG7vdAqaA4C6rC75frPDntcXglCaTi7V5JHY
        kMT+YOf3nNtXvlzxcfjdrkA=
X-Google-Smtp-Source: AA6agR5ylTkx2uA7K//Y5OfnOmGzIarMLx3C+fZn4k9NX2XzlPcp0IAPpeD+4lFd9V3BJkARXK41sQ==
X-Received: by 2002:a5d:598f:0:b0:220:8005:7def with SMTP id n15-20020a5d598f000000b0022080057defmr13924910wri.435.1662011354515;
        Wed, 31 Aug 2022 22:49:14 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id bg15-20020a05600c3c8f00b003a4f08495b7sm4447262wmb.34.2022.08.31.22.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 22:49:14 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.10 v2 7/7] xfs: validate inode fork size against fork format
Date:   Thu,  1 Sep 2022 08:48:54 +0300
Message-Id: <20220901054854.2449416-8-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220901054854.2449416-1-amir73il@gmail.com>
References: <20220901054854.2449416-1-amir73il@gmail.com>
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

From: Dave Chinner <dchinner@redhat.com>

commit 1eb70f54c445fcbb25817841e774adb3d912f3e8 upstream.

[backport for 5.10.y]

xfs_repair catches fork size/format mismatches, but the in-kernel
verifier doesn't, leading to null pointer failures when attempting
to perform operations on the fork. This can occur in the
xfs_dir_is_empty() where the in-memory fork format does not match
the size and so the fork data pointer is accessed incorrectly.

Note: this causes new failures in xfs/348 which is testing mode vs
ftype mismatches. We now detect a regular file that has been changed
to a directory or symlink mode as being corrupt because the data
fork is for a symlink or directory should be in local form when
there are only 3 bytes of data in the data fork. Hence the inode
verify for the regular file now fires w/ -EFSCORRUPTED because
the inode fork format does not match the format the corrupted mode
says it should be in.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index c667c63f2cb0..fa8aefe6b7ec 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -358,19 +358,36 @@ xfs_dinode_verify_fork(
 	int			whichfork)
 {
 	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	mode_t			mode = be16_to_cpu(dip->di_mode);
+	uint32_t		fork_size = XFS_DFORK_SIZE(dip, mp, whichfork);
+	uint32_t		fork_format = XFS_DFORK_FORMAT(dip, whichfork);
 
-	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
+	/*
+	 * For fork types that can contain local data, check that the fork
+	 * format matches the size of local data contained within the fork.
+	 *
+	 * For all types, check that when the size says the should be in extent
+	 * or btree format, the inode isn't claiming it is in local format.
+	 */
+	if (whichfork == XFS_DATA_FORK) {
+		if (S_ISDIR(mode) || S_ISLNK(mode)) {
+			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			    fork_format != XFS_DINODE_FMT_LOCAL)
+				return __this_address;
+		}
+
+		if (be64_to_cpu(dip->di_size) > fork_size &&
+		    fork_format == XFS_DINODE_FMT_LOCAL)
+			return __this_address;
+	}
+
+	switch (fork_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		/*
-		 * no local regular files yet
+		 * No local regular files yet.
 		 */
-		if (whichfork == XFS_DATA_FORK) {
-			if (S_ISREG(be16_to_cpu(dip->di_mode)))
-				return __this_address;
-			if (be64_to_cpu(dip->di_size) >
-					XFS_DFORK_SIZE(dip, mp, whichfork))
-				return __this_address;
-		}
+		if (S_ISREG(mode) && whichfork == XFS_DATA_FORK)
+			return __this_address;
 		if (di_nextents)
 			return __this_address;
 		break;
-- 
2.25.1

