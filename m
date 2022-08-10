Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C9558EE0A
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 16:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbiHJOQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 10:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbiHJOQF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 10:16:05 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BD8606AC;
        Wed, 10 Aug 2022 07:16:04 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id k17so1007897wmr.2;
        Wed, 10 Aug 2022 07:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=yJTJeBH5eeBX44c6u9JN3IXpz+84tiTBfFtmfUlzynY=;
        b=oVEhjsE1xaUL6CNE1ZYzJmvscAV8O3UV7s84oAlp+Be/ONAQF6B08sw4st1cvSORKz
         X8oNphFqB0ViE2R1MSVL7MdJ1vJM2bNBarPspuXKRcLvngEb3uY6dUcOdQ8DbCvr6JEo
         wJ3Aaf9larVJXVtTIztuQLdqRScvynu4zNzCwqqYO4QJDZHg3jfSRcBvBzrf+wRpiELQ
         EQHx15qwXdV3lEsQREbGkuur9vgsR1HCU3o2OC2dr5ghO8C5vd4jPbX/v/0OUNRvA0m6
         mEtRTjEo28HWt3Y7M3CRnIZCA15tCntyGAqjSBzFPictamrw/pkgDKDtDB/HdzvRFUuU
         sNFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=yJTJeBH5eeBX44c6u9JN3IXpz+84tiTBfFtmfUlzynY=;
        b=ashnc1pH45jK+zTMdS6/SPhxIerOuN6DK7c+R/XIU3jXTBiTyiMkeMl1iGDQ/quNOf
         UYeV9Icrg5ACWiMPcRdmnV93/isLWeoPra8nA0Sc8csDjaQyOt2wLOfSLT/7I1G4B4/l
         s2DD/FopAaER4FoAkaFbokoi/zUy9KLV8e0g20M+jD5kCRVm5OQ368QXj15/vDctM23B
         Ox1bwQmhQ/ez9WphJ2LGaocNgRfnjgiUc5pcjljOhYOVuEhm3LIAgQ7IUg4wqNf2uqlT
         nRAvCFq69miRDLrq63U0S9GVcqh+uIyrmqw8Qe4++Kr9Qf6SpOnCzmk7y1fDFmAaAnbT
         NODQ==
X-Gm-Message-State: ACgBeo0dmDFhJvPCsvwF6G/3V0enuOFhz0pRAESq7yGofEHlN58hXw8R
        oBLwXc2qyLF/FRm0LGrtTHBNFMjY7m0=
X-Google-Smtp-Source: AA6agR7XFjoYEgACthjIx/gtejcteZhlFex/qI3X7AHTeQZneGRpdphjNmE3Q5rbG6kUBBzc0F5urQ==
X-Received: by 2002:a05:600c:a41:b0:39c:1512:98bd with SMTP id c1-20020a05600c0a4100b0039c151298bdmr2666051wmq.88.1660140963213;
        Wed, 10 Aug 2022 07:16:03 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id x13-20020adfdccd000000b0021d65675583sm16902969wrm.52.2022.08.10.07.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 07:16:02 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 v2 3/3] xfs: fix I_DONTCACHE
Date:   Wed, 10 Aug 2022 16:15:52 +0200
Message-Id: <20220810141552.168763-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220810141552.168763-1-amir73il@gmail.com>
References: <20220810141552.168763-1-amir73il@gmail.com>
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

From: Dave Chinner <dchinner@redhat.com>

commit f38a032b165d812b0ba8378a5cd237c0888ff65f upstream.

Yup, the VFS hoist broke it, and nobody noticed. Bulkstat workloads
make it clear that it doesn't work as it should.

Fixes: dae2f8ed7992 ("fs: Lift XFS_IDONTCACHE to the VFS layer")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c | 3 ++-
 fs/xfs/xfs_iops.c   | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index deb99300d171..e69a08ed7de4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -47,8 +47,9 @@ xfs_inode_alloc(
 		return NULL;
 	}
 
-	/* VFS doesn't initialise i_mode! */
+	/* VFS doesn't initialise i_mode or i_state! */
 	VFS_I(ip)->i_mode = 0;
+	VFS_I(ip)->i_state = 0;
 
 	XFS_STATS_INC(mp, vn_active);
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b7f7b31a77d5..6a3026e78a9b 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1328,7 +1328,7 @@ xfs_setup_inode(
 	gfp_t			gfp_mask;
 
 	inode->i_ino = ip->i_ino;
-	inode->i_state = I_NEW;
+	inode->i_state |= I_NEW;
 
 	inode_sb_list_add(inode);
 	/* make the inode look hashed for the writeback code */
-- 
2.25.1

