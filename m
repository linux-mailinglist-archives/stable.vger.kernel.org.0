Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4D15A9905
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 15:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbiIANgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 09:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbiIANfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 09:35:44 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BDB12AAB;
        Thu,  1 Sep 2022 06:34:12 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id bd26-20020a05600c1f1a00b003a5e82a6474so1463832wmb.4;
        Thu, 01 Sep 2022 06:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=4oxQGuYR2UpJS0BVOv4mLxNV2a7chSFxPlvyuLBVozo=;
        b=nfPugp+mlewgWjXzavyFXVyGayt2b2L1T8HgTXmkz9bm72dalA8eycHQhtBx5kyG04
         9niQuzJohcBFAlj779nZ4om3Heyjs3ggoMzrFohtmFWKAqsIIQJsrVg9Rp0Hd/DL9HxR
         0sUD+vQ9N3+hZ9bQMipJ4V03wOI6k5ee4r+jntn6sr5Ck+PdJDt6CmtcBl8FIn4+T8g1
         4adVIBmBvn1MuaCRZLjpo6RaAQ+qGWat1Urc88uLuqvJF3rgskBy3fqSRVx375/UcsLH
         1KRwGEcg1bus1njlgnw4quwM1eLGKQmfQKwQBYo/7bGsIn7Q6EADXtE0g9rplV6fm91j
         ERow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=4oxQGuYR2UpJS0BVOv4mLxNV2a7chSFxPlvyuLBVozo=;
        b=lPXjRYcdCwBOXIXrlTr9K8qe/36+Pyu0KLNEs/RKHJuyQ/SOJHyAyNxp0jDdfmqLQ8
         PvYmmYSHNnPfujqjcgxUI68kNxUKuLTNql9HMHP+1c5N0nM1E8cCBP0y/8lSqE9ECSU7
         F9YQMoWFMsXGtFpAEKqtK95fEbgMSjpf6BOnzmVy0zftwnznG4McO7sUKIqgn/Vsspde
         N5zcrYHmXqpbXXFN1608D+hDcXCpsiIbkNxiqZF6n5I/KgR4GnFnScq2Q/drugnwSH6b
         zbBVmIaHT6o1fYcAOvOQchDjBdjACfQ7oYd//l/ZMMAt7Yd/Czb4JtWNKujomSe2ueB3
         hGbg==
X-Gm-Message-State: ACgBeo1sWfiHoNoYjct6QMuyqkpc/ZtLeMWgvWhfZTxX9AltUP2wh3SO
        tvPNx9p44hOZ3V+d9blDrxxho/COggg=
X-Google-Smtp-Source: AA6agR5Uo1m/JLdMWOG4XMVOghs3Wl4lKjEK85W9rr53mKjkzJvnaNE02uNTdzzmW5JmNm3S/cp6KQ==
X-Received: by 2002:a1c:44d7:0:b0:3a6:725:c0a7 with SMTP id r206-20020a1c44d7000000b003a60725c0a7mr5484383wma.137.1662039252117;
        Thu, 01 Sep 2022 06:34:12 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id az26-20020adfe19a000000b0022529d3e911sm15516390wrb.109.2022.09.01.06.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 06:34:11 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.10 v3 5/5] xfs: revert "xfs: actually bump warning counts when we send warnings"
Date:   Thu,  1 Sep 2022 16:33:56 +0300
Message-Id: <20220901133356.2473299-6-amir73il@gmail.com>
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

From: Eric Sandeen <sandeen@redhat.com>

commit bc37e4fb5cac2925b2e286b1f1d4fc2b519f7d92 upstream.

This reverts commit 4b8628d57b725b32616965e66975fcdebe008fe7.

XFS quota has had the concept of a "quota warning limit" since
the earliest Irix implementation, but a mechanism for incrementing
the warning counter was never implemented, as documented in the
xfs_quota(8) man page. We do know from the historical archive that
it was never incremented at runtime during quota reservation
operations.

With this commit, the warning counter quickly increments for every
allocation attempt after the user has crossed a quote soft
limit threshold, and this in turn transitions the user to hard
quota failures, rendering soft quota thresholds and timers useless.
This was reported as a regression by users.

Because the intended behavior of this warning counter has never been
understood or documented, and the result of this change is a regression
in soft quota functionality, revert this commit to make soft quota
limits and timers operable again.

Fixes: 4b8628d57b72 ("xfs: actually bump warning counts when we send warnings)
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trans_dquot.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index fe45b0c3970c..288ea38c43ad 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -615,7 +615,6 @@ xfs_dqresv_check(
 			return QUOTA_NL_ISOFTLONGWARN;
 		}
 
-		res->warnings++;
 		return QUOTA_NL_ISOFTWARN;
 	}
 
-- 
2.25.1

