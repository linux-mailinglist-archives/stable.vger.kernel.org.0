Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A670B59A569
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350335AbiHSSPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 14:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350674AbiHSSPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 14:15:32 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8762AC6C;
        Fri, 19 Aug 2022 11:14:45 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id k14so5020636pfh.0;
        Fri, 19 Aug 2022 11:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=A1jwGNihEua/xjlZ16qM8zyq+B6+JuBhAHdzSolMm6Y=;
        b=jdM57gWUMHVMskxpbHntWXIh5SW0mcMXugUNu4HIgdYHeeztmNHlYtPhfw7pHnSYWC
         VE8hLDZrIIBjlJSmYn3funuBs5ioYBgRkIwMfQKnU5zOQgsuO+uKbXtZ4fB7P7Gtdb20
         XSuijMeu2GBqlEkFdtC7gN/DEgCC9ndFi/q4oM8ojMWeTl+c9j0aCDB8udh4pTsU11HK
         AL/8rxNZV+jjNbxX3UJY5rR9wPQwMS4j7LpcwZBOsk53gbRY/8gBbajToGxBruQQSUcv
         fks1sTRIs8Q1/Cb0CzPxjh8bOwWppRzxiZjwJKKOg/ignYh5XeR7l2f9cr99et4skMUf
         tqKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=A1jwGNihEua/xjlZ16qM8zyq+B6+JuBhAHdzSolMm6Y=;
        b=dhCXhvssWPp80/Z4kcZoC0WYPuCUjr4MzVGnHKidx9SFZxDXSEyLIVNz3HtCQRvMcb
         vOCh+LfKqqHaBlGIvYYfnk3o9oV+9ktd8bs+FfxowUJkUZpWcQk0zH9/FWeHqA0gHzx7
         XSQnObv3OBLHYpmf7gr5J1kABjP/y1Lgi4YUWdSfdvNfQGWE79sqEzBJkhib2G2D4bQ7
         4/fwLX8H+dcw2F3oEBxOok9nDButwTveFIhPVAFJj+nz9Mk7jMnSkaL/UxrLI2McMJBV
         0CmphVMqboI+C5nodXQHM7cmTqNdk6+gL7Ub6Jxu0JoSQJT5+SWDKv5ndYYq9g519dOn
         qlhg==
X-Gm-Message-State: ACgBeo3DtXe1YSjRcO0fZDuqdC/DYLQxhQu8Dow6ykQGHVsVeqve3K0U
        k1MCblyQLIAyOaBHWFV45HFN040FrUrlwQ==
X-Google-Smtp-Source: AA6agR4vjvmfjEry8TGGLjIsOWN+sND68pp/DiymiczffMnAqzE2LznJW+Rqiu2KDHsEqG8/PEYNqA==
X-Received: by 2002:a05:6a00:428d:b0:52e:6305:14c with SMTP id bx13-20020a056a00428d00b0052e6305014cmr9040874pfb.10.1660932884839;
        Fri, 19 Aug 2022 11:14:44 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:3995:f9b1:1e6b:e373])
        by smtp.gmail.com with ESMTPSA id t14-20020a170902e84e00b0015ee60ef65bsm3460918plg.260.2022.08.19.11.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 11:14:44 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 6/9] xfs: fix overfilling of reserve pool
Date:   Fri, 19 Aug 2022 11:14:28 -0700
Message-Id: <20220819181431.4113819-7-leah.rumancik@gmail.com>
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

[ Upstream commit 82be38bcf8a2e056b4c99ce79a3827fa743df6ec ]

Due to cycling of m_sb_lock, it's possible for multiple callers of
xfs_reserve_blocks to race at changing the pool size, subtracting blocks
from fdblocks, and actually putting it in the pool.  The result of all
this is that we can overfill the reserve pool to hilarious levels.

xfs_mod_fdblocks, when called with a positive value, already knows how
to take freed blocks and either fill the reserve until it's full, or put
them in fdblocks.  Use that instead of setting m_resblks_avail directly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 5c2bea1e12a8..5b5b68affe66 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -448,18 +448,17 @@ xfs_reserve_blocks(
 		 * count or we'll get an ENOSPC.  Don't set the reserved flag
 		 * here - we don't want to reserve the extra reserve blocks
 		 * from the reserve.
+		 *
+		 * The desired reserve size can change after we drop the lock.
+		 * Use mod_fdblocks to put the space into the reserve or into
+		 * fdblocks as appropriate.
 		 */
 		fdblks_delta = min(free, delta);
 		spin_unlock(&mp->m_sb_lock);
 		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
-		spin_lock(&mp->m_sb_lock);
-
-		/*
-		 * Update the reserve counters if blocks have been successfully
-		 * allocated.
-		 */
 		if (!error)
-			mp->m_resblks_avail += fdblks_delta;
+			xfs_mod_fdblocks(mp, fdblks_delta, 0);
+		spin_lock(&mp->m_sb_lock);
 	}
 out:
 	if (outval) {
-- 
2.37.1.595.g718a3a8f04-goog

