Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F175E6696
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 17:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbiIVPPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 11:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbiIVPPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 11:15:11 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC4D8287A;
        Thu, 22 Sep 2022 08:15:10 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q3so10072873pjg.3;
        Thu, 22 Sep 2022 08:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=NxspQXAnOPXdOcsoGGcm2jmpUfq1/5tS5wtqThXN2nM=;
        b=SoYUhgHaVeP4UbQW7xnaBGhKWiEHMek4YpDkg4eSBlj6kukaSmYw7wdSo3sURD7Ksz
         EPsJfcI2L64uawR8h9nMLqHJg6NQmHho1F3Np+9fVcev++6Tlvn4+w9yFrYhA0QHH+tK
         Y+LakEDwuar6VxwjckN2e94G3gWRTK+5bP38DUqOayT6p+z0hkE0x9tJ9D/J76bcqraV
         Gy9RFMQyFUFLruADWrmp6pF/B7Ib6FLP875peOLJaYi0yEBki8ZgaUJ2Gt76wLHBq2CD
         awAJ9CIkrNpU4Y8MjoSZCFBknYvzmYrzrvhQbt9iH7Gzob2Af/ugWEiPcnkD8Uk0XSX+
         bZFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=NxspQXAnOPXdOcsoGGcm2jmpUfq1/5tS5wtqThXN2nM=;
        b=NVtXD4tAiALSdsVQdmRIWsQw0iYVteC9JyPHtvq0KyFe9Y16oeyzpBMijA7IbeGDgO
         cvNFnec846fBvkmXlFQX2SmKz2oBLIKIMbUDIhGcf1YOjH8B/exUmh1TOLQeHghNEFb6
         tGetFXFMrJ+CPsw0oWq9aoOmCaXKETJP8gTLKUgQzgNClJxEBQ/KQNZROWOmlT7HH2dc
         qZPWgrE97XHjTydRRqbebWOZHtPVBnyI/V42IPZ+ZUvSW6cN1aiXpqzre9LXroy0NDzR
         ajY5CGawnW4AOTd+VFvlAJze1uL2max2jY6idek/9Gyn4osENzL0H/HxCdsWilfOf8hD
         lHSQ==
X-Gm-Message-State: ACrzQf3ARVvkYTBnlfdyvz+8mFlcE1RYK66CFBKR+ysL+VwkpEsX4C+w
        50qaXSb0+ve8yt3JHSYVk2xXRGjge6pfZg==
X-Google-Smtp-Source: AMsMyM5TJDh9782yTwk+EH0ta7zhtY1igrSjty3AQGwoy6moYFGiHP9u2AY0+keX9+F++XXR4Lpf6g==
X-Received: by 2002:a17:902:d2c2:b0:177:ed66:798 with SMTP id n2-20020a170902d2c200b00177ed660798mr3737603plc.76.1663859709117;
        Thu, 22 Sep 2022 08:15:09 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:500f:884a:5cc3:35d4])
        by smtp.gmail.com with ESMTPSA id m10-20020a170902db0a00b001745662d568sm4226042plx.278.2022.09.22.08.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 08:15:08 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 v2 3/3] xfs: validate inode fork size against fork format
Date:   Thu, 22 Sep 2022 08:15:01 -0700
Message-Id: <20220922151501.2297190-4-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
In-Reply-To: <20220922151501.2297190-1-leah.rumancik@gmail.com>
References: <20220922151501.2297190-1-leah.rumancik@gmail.com>
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

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 1eb70f54c445fcbb25817841e774adb3d912f3e8 ]

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
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 3932b4ebf903..f84d3fbb9d3d 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -337,19 +337,36 @@ xfs_dinode_verify_fork(
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
2.37.3.968.ga6b4b080e4-goog

