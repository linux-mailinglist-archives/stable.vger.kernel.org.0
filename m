Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6BAE5A9902
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 15:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbiIANgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 09:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbiIANfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 09:35:43 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FB011A1B;
        Thu,  1 Sep 2022 06:34:10 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id b5so22379492wrr.5;
        Thu, 01 Sep 2022 06:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=rXO269FD1Qqh/3kSRd+jcHDLkTXo4nk6CloH8biq0G4=;
        b=G7guemJfElS3TczNoMMBULiKgj2V5cRpuxIlQboLqa2/8or9xnBucM1JS7HCei2gy1
         FD/7Idf8y0PXx9LhmzoHjOcKo+uiEZEkkp6Z5Tkhq9trfBxTN4H9ZuqkDg8gR67fITRA
         cdeTM61RfrM73u/CijeaGupj3yVEkvsXEj+i/YhpOikvaeBLZFTek8aMUQeOacm2p2O1
         Clsu8M5tdtLawqd/37pBrjDgy+fhgGoSxdciA4i+75zSab1AUVB3mYIj3esgVuHnQU89
         0+dlRtYTRNTUqig3CM4hBuN0SBNkVe+xUW7u0RtQ6nDGHU5tfKRNW74ZaY8bZB17BRbR
         VvyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=rXO269FD1Qqh/3kSRd+jcHDLkTXo4nk6CloH8biq0G4=;
        b=t/DJjO7mYXWPrgmiXKb4HSgOXiyP9QSfNDznmZRZBvreuub2NpuLmCYyiz9thdVlU0
         ZNP994GZkit72S30tA0dbgnril6SJEYJkTY4XnI97cKwSbv4poRNWR2I684EpmAskrUV
         GrsdEa3jhYAKfOH+3CsOJVl6Pc91IFvjbg2gPVjvSPA9Byj39O9NazbE5apG4wPLWfUO
         tWJiUM3S9Xt8Uh/+rdTqKallieHPBznTfzXgG4vqmew5nBr9kaO2aWuh3Xr1j123ksO9
         y5n9qWiBMmLtTqDbpEuGHNFp51uYe8sVcNmbTejV/faptYNIcrCt3fiw0Ceq4ea/z/xo
         BZ6w==
X-Gm-Message-State: ACgBeo3dCmnAENUZSRPSNw/sSTI+7JCnBQZbvBuB7y/K0dkclRF6zL7x
        GJsdHfAgAu/HlByH4dWyRXg=
X-Google-Smtp-Source: AA6agR45s1ab/I1+42fPETGyFtE+7Wbc53xvDhZVC0a8wX+YRUTbNmwToh/NXjEN7vXYDfyquwXUNA==
X-Received: by 2002:a05:6000:616:b0:226:d80b:76ab with SMTP id bn22-20020a056000061600b00226d80b76abmr11974342wrb.547.1662039248313;
        Thu, 01 Sep 2022 06:34:08 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id az26-20020adfe19a000000b0022529d3e911sm15516390wrb.109.2022.09.01.06.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 06:34:07 -0700 (PDT)
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
Subject: [PATCH 5.10 v3 3/5] xfs: fix overfilling of reserve pool
Date:   Thu,  1 Sep 2022 16:33:54 +0300
Message-Id: <20220901133356.2473299-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220901133356.2473299-1-amir73il@gmail.com>
References: <20220901133356.2473299-1-amir73il@gmail.com>
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

commit 82be38bcf8a2e056b4c99ce79a3827fa743df6ec upstream.

Due to cycling of m_sb_lock, it's possible for multiple callers of
xfs_reserve_blocks to race at changing the pool size, subtracting blocks
from fdblocks, and actually putting it in the pool.  The result of all
this is that we can overfill the reserve pool to hilarious levels.

xfs_mod_fdblocks, when called with a positive value, already knows how
to take freed blocks and either fill the reserve until it's full, or put
them in fdblocks.  Use that instead of setting m_resblks_avail directly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index dacead0d0934..775f833146e3 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -394,18 +394,17 @@ xfs_reserve_blocks(
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
2.25.1

