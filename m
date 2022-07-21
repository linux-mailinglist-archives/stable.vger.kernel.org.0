Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E952757D61F
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 23:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbiGUVhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 17:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbiGUVhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 17:37:18 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7724093631;
        Thu, 21 Jul 2022 14:37:17 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id k16so2998450pls.8;
        Thu, 21 Jul 2022 14:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=POtqjo0Y/JJIqS1rNgusZ5ywUwm4RmOAQ3QIFbE8JVg=;
        b=I1ajcS8geDV2mKlA8JKePsVDr7hpciS4MgXxIDjDXSz4pYr2YmAkZgHCYCq5mNOJsa
         qPCMg5ZTbvIUX0QvPjcNcF7pjCkVcDZ+967KF0wcMmq7uEI/4ABMHs3OaovKFE1YCBXJ
         +ZRLY3SG4Lt+fl/TZnpFeXjGg6GjnNrYoOPraInKCrcTX7/fXGL/i9lrWnKoTtnD1eXy
         AfmbGYEvmhAo4aGW936Y1qa0e1xOT0zsSd3GIMqxxuWuwgmx2z5Gt7YxnzQRuWyJeRAx
         l6aGI35ezgEzPwlNJhNVX9Zirq9zCT9R2Dq3a1srFzs48ZHmH/lzlZw1amnW8q1OKA5L
         l99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=POtqjo0Y/JJIqS1rNgusZ5ywUwm4RmOAQ3QIFbE8JVg=;
        b=H+iVD4u8xoswOjfaatrVuZbp86nrcdHui0Qgdio20c6NRzITghL8bx4y4j5IEc6Ely
         dLn4PHc2kLevwiZS0FESGiAQ2J937vUA1aUYX77u/G7F5hnhOieJayW1xgXksPNC8RfO
         fCzG7sEkYLWdRzGWkjtDseT0oKWC0pzzMFXYIra8OT+raQSnijbOEdOnmuU+RKxyPO+F
         kB9beWhegIfwb5hT5kCFxQ0+7NNhI7hc6NW/9IyhPuhnOlUchgv6dEdIltV4Mp5k7S1j
         qo0caruWGxPx/JL0aGSvV7iJgoCU+bd2Cr95szJyU/+M3OLa2lJD3vYqCfqk8oDiXs/U
         XGxg==
X-Gm-Message-State: AJIora/Fr/KPXpq0R7dcrg2BYRzARArpIokA3oGixJ2Bm4Fvlx18D+Cz
        Uo7xxE/3/e1cQJeRp6Sup3qeqvDUACME3g==
X-Google-Smtp-Source: AGRyM1tZlMBkMIgt7yEFyoEFvqmbZemmHUjCzeCLZdfv56aPUywNtpfvZsWRNuFbHzkEhGmF8+c5yQ==
X-Received: by 2002:a17:902:d542:b0:16c:8ac:f471 with SMTP id z2-20020a170902d54200b0016c08acf471mr277674plf.39.1658439436719;
        Thu, 21 Jul 2022 14:37:16 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:ea45:e7f2:4e46:fc7a])
        by smtp.gmail.com with ESMTPSA id c26-20020a634e1a000000b004114cc062f0sm1919502pgb.65.2022.07.21.14.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 14:37:08 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 v2 3/6] xfs: rename the next_agno perag iteration variable
Date:   Thu, 21 Jul 2022 14:36:07 -0700
Message-Id: <20220721213610.2794134-4-leah.rumancik@gmail.com>
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

[ Upstream commit f1788b5e5ee25bedf00bb4d25f82b93820d61189 ]

Rename the next_agno variable to be consistent across the several
iteration macros and shorten line length.

[backport: dependency for 8ed004eb9d07a5d6114db3e97a166707c186262d]

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index ddb89e10b6ea..134e8635dee1 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -127,22 +127,22 @@ void xfs_perag_put(struct xfs_perag *pag);
 static inline struct xfs_perag *
 xfs_perag_next(
 	struct xfs_perag	*pag,
-	xfs_agnumber_t		*next_agno)
+	xfs_agnumber_t		*agno)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 
-	*next_agno = pag->pag_agno + 1;
+	*agno = pag->pag_agno + 1;
 	xfs_perag_put(pag);
-	return xfs_perag_get(mp, *next_agno);
+	return xfs_perag_get(mp, *agno);
 }
 
-#define for_each_perag_range(mp, next_agno, end_agno, pag) \
-	for ((pag) = xfs_perag_get((mp), (next_agno)); \
-		(pag) != NULL && (next_agno) <= (end_agno); \
-		(pag) = xfs_perag_next((pag), &(next_agno)))
+#define for_each_perag_range(mp, agno, end_agno, pag) \
+	for ((pag) = xfs_perag_get((mp), (agno)); \
+		(pag) != NULL && (agno) <= (end_agno); \
+		(pag) = xfs_perag_next((pag), &(agno)))
 
-#define for_each_perag_from(mp, next_agno, pag) \
-	for_each_perag_range((mp), (next_agno), (mp)->m_sb.sb_agcount, (pag))
+#define for_each_perag_from(mp, agno, pag) \
+	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
 
 
 #define for_each_perag(mp, agno, pag) \
-- 
2.37.1.359.gd136c6c3e2-goog

