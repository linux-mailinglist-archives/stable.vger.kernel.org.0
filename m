Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9CF57D621
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 23:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbiGUVh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 17:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233433AbiGUVh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 17:37:29 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C28593635;
        Thu, 21 Jul 2022 14:37:28 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id d7-20020a17090a564700b001f209736b89so6543969pji.0;
        Thu, 21 Jul 2022 14:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p2rFn+r2ewev9WNnffKfHpK8/iXJJ7B1/jNVh5WRwKw=;
        b=TL5gCgdnicoFh2Z91B7++BptujRU1Q0dghpRW2OHkhofBfYJUhMsrhdDUjduYjYWPF
         1axuAbAjozP68RJV1BRaMSAFqgRhxFwSBjM340L1fB3MHO1naaLrFQCfEFLdWAN15Eje
         NIs0xVPw9P6vQVN3mE63NVnOD/7AtOiIHrCLLgqlbZ8+YLGj2n04iqqt59fP++dSuQJ0
         /mc2Cr1ySZ3eOqVGAYup6sXjsfc19EGgJBDjpntAEt7SNfSvytUUvN2b/q5rXwj2D8PT
         9EYl5rJ2fbYFxmnSQ86jL4K4wKfrDcUA4jRjQL6EvYRDd0XKs1UatUAl491ENmxxGl6b
         gxJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p2rFn+r2ewev9WNnffKfHpK8/iXJJ7B1/jNVh5WRwKw=;
        b=k/0Mh27pO6vMuud4x8fW0Qa/SYrJz4CpzO14ioDSVlO6NIZ/jHGCQ/sPQCzNCy8a2H
         /fBr5fTAEHV2HE6A+rjLHlcaU/2hj+v/4ZzHVWQx3lcxvp+pYiDJZVzE914zTRxBpZfv
         +DSZsgNMZGalUAVmNPk8SE1DLiOzuKNq11sR3DlJ7wPVPosj1YIhoz2O85eOnPts67Vs
         YkPpTI47/81V9CmX0A7tRRqE3d6wI8hBXdRKtaeqJG0CeuaurVFnklEh1I0RgqZn2oUi
         7gzdBOy28x0eY6UJ/laadk4dhyIfxhs5FdkkPKvaIeVhIVYwPtO7nqIfZtsDwJjl639X
         WgOw==
X-Gm-Message-State: AJIora+YnXREIIZddNvGpiV/gpXYD+Q+/7ODD2Czz0wFFAzu1JQvbmAc
        seNgyolQCCSpWur2NiNSBS90Ty/CvXvk2w==
X-Google-Smtp-Source: AGRyM1tw7Pgx6iWkg0zwFPSQjqjoUzrgmcGuy0sVTiBsCuSi475Bo3CXTJVvN8Hjh72H05oVIszOng==
X-Received: by 2002:a17:90a:2a0d:b0:1f2:aed:ce18 with SMTP id i13-20020a17090a2a0d00b001f20aedce18mr424594pjd.91.1658439447309;
        Thu, 21 Jul 2022 14:37:27 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:ea45:e7f2:4e46:fc7a])
        by smtp.gmail.com with ESMTPSA id c26-20020a634e1a000000b004114cc062f0sm1919502pgb.65.2022.07.21.14.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 14:37:17 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 v2 4/6] xfs: terminate perag iteration reliably on agcount
Date:   Thu, 21 Jul 2022 14:36:08 -0700
Message-Id: <20220721213610.2794134-5-leah.rumancik@gmail.com>
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

[ Upstream commit 8ed004eb9d07a5d6114db3e97a166707c186262d ]

The for_each_perag_from() iteration macro relies on sb_agcount to
process every perag currently within EOFS from a given starting
point. It's perfectly valid to have perag structures beyond
sb_agcount, however, such as if a growfs is in progress. If a perag
loop happens to race with growfs in this manner, it will actually
attempt to process the post-EOFS perag where ->pag_agno ==
sb_agcount. This is reproduced by xfs/104 and manifests as the
following assert failure in superblock write verifier context:

 XFS: Assertion failed: agno < mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c, line: 22

Update the corresponding macro to only process perags that are
within the current sb_agcount.

Fixes: 58d43a7e3263 ("xfs: pass perags around in fsmap data dev functions")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 134e8635dee1..4585ebb3f450 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -142,7 +142,7 @@ xfs_perag_next(
 		(pag) = xfs_perag_next((pag), &(agno)))
 
 #define for_each_perag_from(mp, agno, pag) \
-	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
+	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
 
 
 #define for_each_perag(mp, agno, pag) \
-- 
2.37.1.359.gd136c6c3e2-goog

