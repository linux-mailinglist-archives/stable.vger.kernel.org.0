Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB5559A592
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350211AbiHSSPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 14:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350655AbiHSSPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 14:15:31 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC0D25E9A;
        Fri, 19 Aug 2022 11:14:43 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id r22so4285985pgm.5;
        Fri, 19 Aug 2022 11:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=S/EDilCN6R/rInC4ILcrmRd4Xiig+SrevRMQ+U2aGso=;
        b=gCCAwVIGWsS+wJtd07K2iy37HLgvpMWr3yaPCE8/RwiAO/pWSZO4bmm3syBycdWYu6
         VBHkXA17W++6JhROi0LfjkJR+fIdlLe6eF62JEMWK3PSYEiBJcl8yngsnl0h50phLJjk
         ANHcXYeOUnu0ZkOJTCsk/iH8IKw4cFwaW9DroEnn34xbISsDkDRn7QLravqdjPHQoKZm
         X0Lrqgan5HzqHuO4KQo6YVg5R3otPk0ABtSmX5RMa6B/ala5jmFMfw68U3ET/Y/Q4Rn4
         ZGOxWrmGKlaMGbFXKrepJSa/+BBTE8ArwWzzSx4owe1Uq7WQL5cdiJbXTgr3ZUPDdPvF
         K/Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=S/EDilCN6R/rInC4ILcrmRd4Xiig+SrevRMQ+U2aGso=;
        b=DgiLXAE8okKLGAznAXfeh3uTQbWN97TeRUTBu6LFMgQM989RWabjzYSrIvYMsbMiYI
         AemTEV+aVzJgKBfg1DtX2QJsJsKKNy/k5N5uGr9GhtYOPBqZah/uIypknkNnxJKzxWxt
         k6RJsr77uRkxPu4cT/U9ka4ldw8X6LS1/43aN5ScC0QyLmbTj1vsceP9mnG0B/Ia2V1u
         qRTZvzkeBDwhohKkoxjVdBSDW/Ns+n7Yp+0Qom59X3G/QMxh4cZ9LJgCSZamChR29Qyw
         aZPZO85W04HfbCLVl+4S3IgLYiJ6wlNNwE3UkKmRCewTJNkK44iEurL4ZFs/0xyU5V6T
         KE0A==
X-Gm-Message-State: ACgBeo3NxdkUhtFJhagAhe+GiPX0vPUfrNTQhCcxDPzbLAP/jZDQ2aV0
        e/FqQF9GF0kR4vsUwP0gojYHGR3C6AcDbQ==
X-Google-Smtp-Source: AA6agR4CZaEFWfzkrJhW6yCBXAO9w6XmZASJDe7u0aikAaZrFJ42yEJCwupQBOWi7EUFc5BX1FqXSg==
X-Received: by 2002:a65:6d98:0:b0:41d:d9:a338 with SMTP id bc24-20020a656d98000000b0041d00d9a338mr7081525pgb.421.1660932882356;
        Fri, 19 Aug 2022 11:14:42 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:3995:f9b1:1e6b:e373])
        by smtp.gmail.com with ESMTPSA id t14-20020a170902e84e00b0015ee60ef65bsm3460918plg.260.2022.08.19.11.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 11:14:41 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 4/9] xfs: remove infinite loop when reserving free block pool
Date:   Fri, 19 Aug 2022 11:14:26 -0700
Message-Id: <20220819181431.4113819-5-leah.rumancik@gmail.com>
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

[ Upstream commit 15f04fdc75aaaa1cccb0b8b3af1be290e118a7bc ]

Infinite loops in kernel code are scary.  Calls to xfs_reserve_blocks
should be rare (people should just use the defaults!) so we really don't
need to try so hard.  Simplify the logic here by removing the infinite
loop.

Cc: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c | 50 +++++++++++++++++++---------------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 710e857bb825..3c6d9d6836ef 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -430,46 +430,36 @@ xfs_reserve_blocks(
 	 * If the request is larger than the current reservation, reserve the
 	 * blocks before we update the reserve counters. Sample m_fdblocks and
 	 * perform a partial reservation if the request exceeds free space.
+	 *
+	 * The code below estimates how many blocks it can request from
+	 * fdblocks to stash in the reserve pool.  This is a classic TOCTOU
+	 * race since fdblocks updates are not always coordinated via
+	 * m_sb_lock.
 	 */
-	error = -ENOSPC;
-	do {
-		free = percpu_counter_sum(&mp->m_fdblocks) -
+	free = percpu_counter_sum(&mp->m_fdblocks) -
 						xfs_fdblocks_unavailable(mp);
-		if (free <= 0)
-			break;
-
-		delta = request - mp->m_resblks;
-		lcounter = free - delta;
-		if (lcounter < 0)
-			/* We can't satisfy the request, just get what we can */
-			fdblks_delta = free;
-		else
-			fdblks_delta = delta;
-
+	delta = request - mp->m_resblks;
+	if (delta > 0 && free > 0) {
 		/*
 		 * We'll either succeed in getting space from the free block
-		 * count or we'll get an ENOSPC. If we get a ENOSPC, it means
-		 * things changed while we were calculating fdblks_delta and so
-		 * we should try again to see if there is anything left to
-		 * reserve.
-		 *
-		 * Don't set the reserved flag here - we don't want to reserve
-		 * the extra reserve blocks from the reserve.....
+		 * count or we'll get an ENOSPC.  Don't set the reserved flag
+		 * here - we don't want to reserve the extra reserve blocks
+		 * from the reserve.
 		 */
+		fdblks_delta = min(free, delta);
 		spin_unlock(&mp->m_sb_lock);
 		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
 		spin_lock(&mp->m_sb_lock);
-	} while (error == -ENOSPC);
 
-	/*
-	 * Update the reserve counters if blocks have been successfully
-	 * allocated.
-	 */
-	if (!error && fdblks_delta) {
-		mp->m_resblks += fdblks_delta;
-		mp->m_resblks_avail += fdblks_delta;
+		/*
+		 * Update the reserve counters if blocks have been successfully
+		 * allocated.
+		 */
+		if (!error) {
+			mp->m_resblks += fdblks_delta;
+			mp->m_resblks_avail += fdblks_delta;
+		}
 	}
-
 out:
 	if (outval) {
 		outval->resblks = mp->m_resblks;
-- 
2.37.1.595.g718a3a8f04-goog

