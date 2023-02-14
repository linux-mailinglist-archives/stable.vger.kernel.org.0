Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D41696F8C
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 22:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbjBNV1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 16:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbjBNV1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 16:27:14 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE99303EF;
        Tue, 14 Feb 2023 13:26:38 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id w14-20020a17090a5e0e00b00233d3b9650eso46863pjf.4;
        Tue, 14 Feb 2023 13:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f1te54KzFMmr35wDNb6ewvvz32i8ozDTSolMMbFNyKQ=;
        b=Tfyz0CxXZ4reVhTSDwWEpdP6e0yHQbU0+PLlamkDb3/XRVP1RslEymCHjDZYvQe4J3
         1ofS4JQ2F38hTLJVv/HDymWMGTns/28nArBCrFYREwTJdMUeh+oTaZY+JCKvPVEN3VAV
         l8wIdFaUvKsxNiW6yIW/V4g/QwDWVUUZVb4iREg0zBf2zdQiZ0KUGwegvLVHOdQcR5TI
         tuw6buGQyZU5g1sx++T/RBWYAP0WIMkYdxr6GXC5POZh5H8YuVczFeKFcszVAu9qs3TO
         NEILNY3Uyc2s2I29xIbFfnOnTCf8zZvWcIcrLUUGPmARbsrUQh8VnwDKWQG48Ka56/vn
         nqpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f1te54KzFMmr35wDNb6ewvvz32i8ozDTSolMMbFNyKQ=;
        b=dTslH1kEH4b4t3qYWAxM6f1b2/xTi/KY1fBvJHSuxv6H0OiPZucg9+cIEtFuozbegs
         XwvRILMQ/H3IkhGwSxtXrXxljS0uc+SBG1hYzls3UuI0TMCj48OMn3g7G+7pRrNKe1F6
         KXRRO2U5micEShoVMpqM0fWDaeesNIjqtvHH7J58n5vwPsSUlyFoau9Djh9OuCBLQcZN
         jX8qpGWdQ+FXL+98rp13iDWNsctbXRb3IcymsJTizCxjFV93wQ1tJObV/xTMsRzmia5d
         DF0F/NT2E+iIoaC9QoR6xgVIcEAgeRDZa0h/qRhXW+PZS3JJZQClMl/xunHrFlaVbllY
         mrNA==
X-Gm-Message-State: AO0yUKWLoXqcyJO7AuO1o3ipPTBEgsxjlXttX4VvUazXX7GhNZsSaSUE
        uMsz/ej0yPVWLSXtsH6kGXYiz3elPtYeow==
X-Google-Smtp-Source: AK7set+NO0BrwIo8RUvnLhH6sjGXt0LNHVaLjZYljckdl2BZTvDTnmB6A/xavAx3hElK0VfBMjRyDw==
X-Received: by 2002:a17:902:c641:b0:19a:b35d:dde5 with SMTP id s1-20020a170902c64100b0019ab35ddde5mr113473pls.6.1676409973106;
        Tue, 14 Feb 2023 13:26:13 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cf14:3756:2b5e:fb87])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902654e00b00195f0fb0c18sm6692569pln.31.2023.02.14.13.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:26:12 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 07/10] xfs: don't assert fail on perag references on teardown
Date:   Tue, 14 Feb 2023 13:25:31 -0800
Message-Id: <20230214212534.1420323-8-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
In-Reply-To: <20230214212534.1420323-1-leah.rumancik@gmail.com>
References: <20230214212534.1420323-1-leah.rumancik@gmail.com>
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

[ Upstream commit 5b55cbc2d72632e874e50d2e36bce608e55aaaea ]

Not fatal, the assert is there to catch developer attention. I'm
seeing this occasionally during recoveryloop testing after a
shutdown, and I don't want this to stop an overnight recoveryloop
run as it is currently doing.

Convert the ASSERT to a XFS_IS_CORRUPT() check so it will dump a
corruption report into the log and cause a test failure that way,
but it won't stop the machine dead.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 005abfd9fd34..aff6fb5281f6 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -173,7 +173,6 @@ __xfs_free_perag(
 	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
 
 	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
-	ASSERT(atomic_read(&pag->pag_ref) == 0);
 	kmem_free(pag);
 }
 
@@ -192,7 +191,7 @@ xfs_free_perag(
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
-		ASSERT(atomic_read(&pag->pag_ref) == 0);
+		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
 
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
 		xfs_iunlink_destroy(pag);
-- 
2.39.1.581.gbfd45094c4-goog

