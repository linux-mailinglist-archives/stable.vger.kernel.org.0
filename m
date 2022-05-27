Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A72553631C
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 15:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351635AbiE0NCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 09:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238766AbiE0NCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 09:02:48 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CFB3BBF6;
        Fri, 27 May 2022 06:02:45 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id e2so5829558wrc.1;
        Fri, 27 May 2022 06:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GX4MGgyF/rjjoLGNo+9vAqeePSGvpBNozK+r4g9/A+k=;
        b=WF5HqPxbrl/Q0v5xS46WO1rdGfy3EU8Ofaho5g9NSk0r5JGrIU41JYpKF3I4HTr8HD
         Yj+JGTfZeNs7XnviBu8b6O4DK6MvNBQepI8Ul1QIfni/dkmL1lT42rWxcrPpLJ6SiQau
         6NHbwO/BYVcG5249uVPL/iFmNMP6QfGeVaBDmx3zXBLiPDQxU1oRAfldywMe+YOMACNU
         unfMV5VpqgFsGNT8s8FyXBlRGMW6jPk2Pe3rRkvZ4LOGq1cj6MnQsW6bMK88SZpdPF2f
         tArFk3Uhqr1vbZj6sH2aWpJbV4uxSH+nonJS4AVzJG0b3K2T2DfZv1FyCgk7tHMMgFPL
         V4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GX4MGgyF/rjjoLGNo+9vAqeePSGvpBNozK+r4g9/A+k=;
        b=OioIdla4XHvyfsKgOBhgBrj+eScesWMKrtmxi+yakK8ROBOfte07i4YQ+CvPqI0PGV
         hGwAqI1PvmuJfabV9BUo5gXWbJQUlCsWGADOS+P8aU/vdziC2GmfP4IOinFC2c4IC+Gk
         iHylbOQu5WXMeb7FuRjyyuZxY0os9qpSozeKUbuRsdHq+VMM3GqE6tR7+8nZL+lQuXmY
         ykeyKG00NG2zWxim9aVHqHxzeBOGsLVrztLcmcztF5LYv3IKbdg5N+4XWVJyB4pG40fL
         1ivzoH4etnQmjaFrdNDk3RXNiE7d6EF1dsRpPJNFrq1c334mtgUy6P+liulONSqCXsiS
         dDtg==
X-Gm-Message-State: AOAM530xfpFn98JslyPykhyTF9S1Yc/MwD82sUZ0rhaBjM0/kLfxd/kc
        7XBURuqPatchCySA2i0OcU0=
X-Google-Smtp-Source: ABdhPJy1q3PRNZwMMAFcy5ZRipoCnbeFWrR/Mu0fze51q6kG+gtQQO4yW+vNSHIcK0KgSJt1oBFUDg==
X-Received: by 2002:adf:f145:0:b0:210:598:4042 with SMTP id y5-20020adff145000000b0021005984042mr7755494wro.139.1653656563929;
        Fri, 27 May 2022 06:02:43 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.79.96])
        by smtp.gmail.com with ESMTPSA id l36-20020a05600c08a400b003942a244f48sm1932569wmp.33.2022.05.27.06.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 06:02:43 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, Jan Kara <jack@suse.cz>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        zlang@redhat.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 v2 3/5] xfs: fix the forward progress assertion in xfs_iwalk_run_callbacks
Date:   Fri, 27 May 2022 16:02:17 +0300
Message-Id: <20220527130219.3110260-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220527130219.3110260-1-amir73il@gmail.com>
References: <20220527130219.3110260-1-amir73il@gmail.com>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit a5336d6bb2d02d0e9d4d3c8be04b80b8b68d56c8 upstream.

In commit 27c14b5daa82 we started tracking the last inode seen during an
inode walk to avoid infinite loops if a corrupt inobt record happens to
have a lower ir_startino than the record preceeding it.  Unfortunately,
the assertion trips over the case where there are completely empty inobt
records (which can happen quite easily on 64k page filesystems) because
we advance the tracking cursor without actually putting the empty record
into the processing buffer.  Fix the assert to allow for this case.

Reported-by: zlang@redhat.com
Fixes: 27c14b5daa82 ("xfs: ensure inobt record walks always make forward progress")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_iwalk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 2a45138831e3..eae3aff9bc97 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -363,7 +363,7 @@ xfs_iwalk_run_callbacks(
 	/* Delete cursor but remember the last record we cached... */
 	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
 	irec = &iwag->recs[iwag->nr_recs - 1];
-	ASSERT(next_agino == irec->ir_startino + XFS_INODES_PER_CHUNK);
+	ASSERT(next_agino >= irec->ir_startino + XFS_INODES_PER_CHUNK);
 
 	error = xfs_iwalk_ag_recs(iwag);
 	if (error)
-- 
2.25.1

