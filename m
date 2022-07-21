Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFFF57D61C
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 23:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiGUVhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 17:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbiGUVhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 17:37:09 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6848293612;
        Thu, 21 Jul 2022 14:37:08 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id g17so3025138plh.2;
        Thu, 21 Jul 2022 14:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Aws6enxWnJNrzjwNJTmwHm8uAfuOK8bWrAeZ4QMkGiE=;
        b=qmWXXbAIexisM0c9dQ70MjlZ9JiwNNzQy8HFqzc9KhhAY7xKKQ1mrg+ygNnjvyPfru
         TFyS8llPpH7ylOeEsjg/kGwAKkRPSopQojPaGb/d+xXvXROe+wOCs9tY6ibWAXOvvVXM
         QaDCJIs8rR/JUA22kVzJ5JIWctjOHegJXyAz28hk0QqXK1NyL9pj9Z2yJtMo8NMit1AJ
         GA4QaKExHG1Yz9M6zT2iPsYS0sVTXbNb4eltdZXn3D8aPQNkQxB6bAgEiRGmz8BErPEh
         FUE3GrvvdUNSAMgTWdi8/4Q2TNEWAYtI68HljrTl6lASgNhkw1Qazw5sPARXkm9MTVEp
         TScQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Aws6enxWnJNrzjwNJTmwHm8uAfuOK8bWrAeZ4QMkGiE=;
        b=gLe+lMPt61YRnjKhBhAmU2mIA9bHGHPL8xMoLX2sJgQuW0/jpU/C5qx3RMYn8ZUZY7
         wzGljT5yOUOJkzJFi1cVV6WG2z4KvVjG4M2Rel0Ofbpk9bFL4p+QsSMBM6rKexi1fKdC
         I+ex5bU+JhgDvTXuMYYfLTy3voPHu7j5aXIxnqkZ04xkmHCoHCqOyi7+5C+bQovEZFgD
         1vaoJ5QqueyuoZp4EaeMjuVZSa/Urt09sGtyOogB8uAcyosffscSzzz2sruw1L8gGvM4
         KfZtCvCOMqSxgZyQzt/YDqdwZoHqkfXWhzMuL4NP1C8sUZT1mpd7o1J8sTDpqSG6zjda
         tVeg==
X-Gm-Message-State: AJIora8I+hFc6EcZsRUqtOYXwGjIPPrVZgElBWmFcbkgrIJ32s73vRJG
        PEtOSNnv9/NfC/TqABgG7OBjCQRGXuHDqQ==
X-Google-Smtp-Source: AGRyM1uR/mYZZzfpv8qkfcwGl0tB91LNqNt5BsyRmcHHpuyG+Hq8A9roLODhssbc9rnMbKbToLT+aA==
X-Received: by 2002:a17:903:32d0:b0:16c:eb4:ad8 with SMTP id i16-20020a17090332d000b0016c0eb40ad8mr499409plr.54.1658439427636;
        Thu, 21 Jul 2022 14:37:07 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:ea45:e7f2:4e46:fc7a])
        by smtp.gmail.com with ESMTPSA id c26-20020a634e1a000000b004114cc062f0sm1919502pgb.65.2022.07.21.14.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 14:36:55 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 v2 2/6] xfs: fold perag loop iteration logic into helper function
Date:   Thu, 21 Jul 2022 14:36:06 -0700
Message-Id: <20220721213610.2794134-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
In-Reply-To: <20220721213610.2794134-1-leah.rumancik@gmail.com>
References: <20220721213610.2794134-1-leah.rumancik@gmail.com>
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

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit bf2307b195135ed9c95eebb38920d8bd41843092 ]

Fold the loop iteration logic into a helper in preparation for
further fixups. No functional change in this patch.

[backport: dependency for f1788b5e5ee25bedf00bb4d25f82b93820d61189]

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.h | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 4c6f9045baca..ddb89e10b6ea 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -124,12 +124,22 @@ void xfs_perag_put(struct xfs_perag *pag);
  * for_each_perag_from() because they terminate at sb_agcount where there are
  * no perag structures in tree beyond end_agno.
  */
+static inline struct xfs_perag *
+xfs_perag_next(
+	struct xfs_perag	*pag,
+	xfs_agnumber_t		*next_agno)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	*next_agno = pag->pag_agno + 1;
+	xfs_perag_put(pag);
+	return xfs_perag_get(mp, *next_agno);
+}
+
 #define for_each_perag_range(mp, next_agno, end_agno, pag) \
 	for ((pag) = xfs_perag_get((mp), (next_agno)); \
 		(pag) != NULL && (next_agno) <= (end_agno); \
-		(next_agno) = (pag)->pag_agno + 1, \
-		xfs_perag_put(pag), \
-		(pag) = xfs_perag_get((mp), (next_agno)))
+		(pag) = xfs_perag_next((pag), &(next_agno)))
 
 #define for_each_perag_from(mp, next_agno, pag) \
 	for_each_perag_range((mp), (next_agno), (mp)->m_sb.sb_agcount, (pag))
-- 
2.37.1.359.gd136c6c3e2-goog

