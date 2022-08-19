Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8319559A551
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350282AbiHSSPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 14:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350658AbiHSSPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 14:15:31 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF2729CA7;
        Fri, 19 Aug 2022 11:14:44 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id p125so5000642pfp.2;
        Fri, 19 Aug 2022 11:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=efHyiVC/LBZfOk0B9SIqlLuOFO1671uB7v4aNThPrT8=;
        b=ZCRdd9XKqIwQ+wAANySX+Cqf+Gy+Tki0P49CgHaTxaxH/Mi/35zDyQL2AQLx2troH3
         uj4Y9gZezhoCcL+esBWQPnHgfsRQHcjaQBQbHm2++7esbRMDM/O20QJDIXJi6VUu0uU7
         UtXQ3t/KDOIDb93IrsPTr2canCISrrbrLURjHQJ6MUjWW3m+zb4PUPVNAvoPDtFBrKwl
         7YhEEXCcSMdRI+f928XtOWBfAN+VKijU4rdCLDHfMiUqPiOnvuf/rxYRbdZY87YF/3kn
         YbmqjN8DdAxGdYTQCW+yBrknOru1w+JVN5BIe9upekIaH99ICOJ9CtXTMBFOjfkOj+ZQ
         IHtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=efHyiVC/LBZfOk0B9SIqlLuOFO1671uB7v4aNThPrT8=;
        b=IkgzvDV+t3PajMMZ7S8d5yvzM/c0d0Aa6osYAPm1yA1NFTIXca+UVoheGxoeLGhZFu
         NhK2sZ+6hxS7xpvkADD/HRvlsxw8OGvCeof9f6YFQjbnNY1pwuS/bYN3q/Tdr45sMsbI
         Hs+JyJ1HJWdhgUKfMZKvz+EgUnVSBgyZe+bv2ZYucIC4jnPlYPdAb7YrMOOpgYBeH+TY
         EUnM/E55CPehUFdBLpDs3AOnpDtTltVDN/tP1bSYRYf7rDj8myktFnt6y1kXUGBxad14
         3yV7Zy+3aZh4M/gSH+Tnycp0oX2rfsIDmkyF/eXCqBsdcXQm6Z1KjGTKz2aC6XKhlwRV
         aTpQ==
X-Gm-Message-State: ACgBeo06PPGVK7glo3BO7fZ5G3BeOnaki4NO+O3B660j8J6Yqm+MfASH
        s5ukMPy5/7JXYQOtNIyB4Uzkj/LWgiWBfA==
X-Google-Smtp-Source: AA6agR7fu4XQMf1LQ8nh5h1IZX1pyafVRA/zneKMr3D7nPkAEWjHber72MEzI5qHFXR0CQ9iALQytw==
X-Received: by 2002:a05:6a00:2181:b0:51b:560b:dd30 with SMTP id h1-20020a056a00218100b0051b560bdd30mr9103855pfi.44.1660932883413;
        Fri, 19 Aug 2022 11:14:43 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:3995:f9b1:1e6b:e373])
        by smtp.gmail.com with ESMTPSA id t14-20020a170902e84e00b0015ee60ef65bsm3460918plg.260.2022.08.19.11.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 11:14:43 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 5/9] xfs: always succeed at setting the reserve pool size
Date:   Fri, 19 Aug 2022 11:14:27 -0700
Message-Id: <20220819181431.4113819-6-leah.rumancik@gmail.com>
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

[ Upstream commit 0baa2657dc4d79202148be79a3dc36c35f425060 ]

Nowadays, xfs_mod_fdblocks will always choose to fill the reserve pool
with freed blocks before adding to fdblocks.  Therefore, we can change
the behavior of xfs_reserve_blocks slightly -- setting the target size
of the pool should always succeed, since a deficiency will eventually
be made up as blocks get freed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 3c6d9d6836ef..5c2bea1e12a8 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -434,11 +434,14 @@ xfs_reserve_blocks(
 	 * The code below estimates how many blocks it can request from
 	 * fdblocks to stash in the reserve pool.  This is a classic TOCTOU
 	 * race since fdblocks updates are not always coordinated via
-	 * m_sb_lock.
+	 * m_sb_lock.  Set the reserve size even if there's not enough free
+	 * space to fill it because mod_fdblocks will refill an undersized
+	 * reserve when it can.
 	 */
 	free = percpu_counter_sum(&mp->m_fdblocks) -
 						xfs_fdblocks_unavailable(mp);
 	delta = request - mp->m_resblks;
+	mp->m_resblks = request;
 	if (delta > 0 && free > 0) {
 		/*
 		 * We'll either succeed in getting space from the free block
@@ -455,10 +458,8 @@ xfs_reserve_blocks(
 		 * Update the reserve counters if blocks have been successfully
 		 * allocated.
 		 */
-		if (!error) {
-			mp->m_resblks += fdblks_delta;
+		if (!error)
 			mp->m_resblks_avail += fdblks_delta;
-		}
 	}
 out:
 	if (outval) {
-- 
2.37.1.595.g718a3a8f04-goog

