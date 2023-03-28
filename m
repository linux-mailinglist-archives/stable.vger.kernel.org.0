Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A87D6CB840
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 09:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbjC1HgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 03:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbjC1HgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 03:36:04 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746EB420A;
        Tue, 28 Mar 2023 00:35:22 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id t4so5867309wra.7;
        Tue, 28 Mar 2023 00:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679988919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vuzld3mAHd+X1pTk+ATg2u3J+Wc1sSzauQ6zriav4ug=;
        b=crWr27KZT4Ioy/ccX2ReBb/P+8Tv6EMA9xniiS89nN0nuSFbKu2pZxdR/wGzhqRX4W
         CxmqUcOn2Va5wYabZpFUcjo1RnBeBqSR8FxgNXGK6MuP0U3BeLxWq9UL4de8tWLBXTdf
         fUh5x8sOfQ2SEbOahK6eLr5uIv/fjVlw+0DdjFhTe6gbtP8WtKw6BtH7up0J1mFKGzWt
         Z223Rsjd2FlWcd1D9dm7E1XhgwQgQv1Z13smrn1ODbz/h1oY1rUFNAWFRjowCTSMHPuL
         z/W84Jt4MGztRJAaybXghQgg4vzJ9bCh1RP/pcn8QO57YAmjoKaQdErgkphU6NQlfZ4k
         ej+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679988919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vuzld3mAHd+X1pTk+ATg2u3J+Wc1sSzauQ6zriav4ug=;
        b=I2kliTqbBKfLMNRYWas4QsrsEwqvC0VUhwcWKTaGfmjtQCxkS8uIrwM7haz40MCyo4
         82efgzFHUP0IMtc5ZglHaPFQ03ocyHjV/BnskcyYXj7+1wh1gOQ9mt8sH/W9M5Xwc8W2
         yDzGG3B+DLbnFbjhFR/fOG3v2k/Vw7PUp72k5QW90+Ld95TcDvx7Y5H5ZhTGAF5LLASM
         ujvCfZVN0HMoE30GjOWTAOw2BrfSqRQ1Pbome75Yq4nEu5+q3kydfv6cr+24ygZDjiUI
         kFn5WGgLB2sAZWpxvgbtsL/OlrQTPhcxtvAbUz1l5ADq5ONDn+IgjN+N2iIODcvrE/wt
         22RA==
X-Gm-Message-State: AAQBX9dxYVSGKorlhrKo1+uQ/aZ+/U3+twf/GDMnzzUpskloPNQrt3hm
        Toc0Hf37sR+90h5s8+PpxtA=
X-Google-Smtp-Source: AKy350ZbPAnSbF3PXE/WRayijbKioDwMp0VtxEPjRDxutTTMUY8Qvu5HQJf2QeuchddcTK8kqH7G6A==
X-Received: by 2002:adf:efc3:0:b0:2cf:e827:b597 with SMTP id i3-20020adfefc3000000b002cfe827b597mr12942574wrp.10.1679988918533;
        Tue, 28 Mar 2023 00:35:18 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id u11-20020a05600c00cb00b003ef64affec7sm9717940wmm.22.2023.03.28.00.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 00:35:18 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5.10 1/2] xfs: shut down the filesystem if we screw up quota reservation
Date:   Tue, 28 Mar 2023 10:35:11 +0300
Message-Id: <20230328073512.460533-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230328073512.460533-1-amir73il@gmail.com>
References: <20230328073512.460533-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 2a4bdfa8558ca2904dc17b83497dc82aa7fc05e9 upstream.

If we ever screw up the quota reservations enough to trip the
assertions, something's wrong with the quota code.  Shut down the
filesystem when this happens, because this is corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trans_dquot.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 288ea38c43ad..5ca210e6626c 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -16,6 +16,7 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_trace.h"
+#include "xfs_error.h"
 
 STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
 
@@ -708,9 +709,11 @@ xfs_trans_dqresv(
 					    XFS_TRANS_DQ_RES_INOS,
 					    ninos);
 	}
-	ASSERT(dqp->q_blk.reserved >= dqp->q_blk.count);
-	ASSERT(dqp->q_rtb.reserved >= dqp->q_rtb.count);
-	ASSERT(dqp->q_ino.reserved >= dqp->q_ino.count);
+
+	if (XFS_IS_CORRUPT(mp, dqp->q_blk.reserved < dqp->q_blk.count) ||
+	    XFS_IS_CORRUPT(mp, dqp->q_rtb.reserved < dqp->q_rtb.count) ||
+	    XFS_IS_CORRUPT(mp, dqp->q_ino.reserved < dqp->q_ino.count))
+		goto error_corrupt;
 
 	xfs_dqunlock(dqp);
 	return 0;
@@ -720,6 +723,10 @@ xfs_trans_dqresv(
 	if (xfs_dquot_type(dqp) == XFS_DQTYPE_PROJ)
 		return -ENOSPC;
 	return -EDQUOT;
+error_corrupt:
+	xfs_dqunlock(dqp);
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	return -EFSCORRUPTED;
 }
 
 
-- 
2.34.1

