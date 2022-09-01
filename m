Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE995A8DA6
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 07:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbiIAFtu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 01:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbiIAFtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 01:49:33 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E481178D1;
        Wed, 31 Aug 2022 22:49:18 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id e13so19946061wrm.1;
        Wed, 31 Aug 2022 22:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=4oxQGuYR2UpJS0BVOv4mLxNV2a7chSFxPlvyuLBVozo=;
        b=WnIo4RCLAX4ieqoTb/VLjaFosBF1UY2gcAQHiVcDHiKznOSWTTLqfIwTf6n0LUht19
         TBTorPVH2qhv8goh//74w7c7mVCw0k9YyOugXe3mOKWB/7XA24Kh1+CuHpqbG9iqrcOg
         8WsK714TlYnPOVN4LOmkYxiaYv/Q0Naza/nAQnGH/+99QW7St58O5UfabzMYtzQunfr/
         4Zr1WrwMSX18K6TqTQIyIuT64cDSF2Q5s1nnO9iaLPx5w69MXv0xZ4090Wy356jzIHQb
         qk4v6UEIYY1VNsEzeT/lvx/iAqeJdXxR3QF0Ya05lpPMhNEr8exraCszr1UOi6VgYvrk
         Ca5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=4oxQGuYR2UpJS0BVOv4mLxNV2a7chSFxPlvyuLBVozo=;
        b=z9YoJTq1H82IATQaM1kN4WV1VIgNUkwZ3biDHdfuIIv5e6d9DNX1KaeZzAHWwP1Ijw
         a/nVO0Zz6hKWPzkiS8W9NjmyvvNMds36BNMWB6kagvvRpB+u/nnCRpwerS85v/maMA2/
         stWCxjA71XsHcrbh8RE21ZQm56BGrWrBDgtZ0bAc6jaR8hGw/B7eczdiylNUZOawhJJE
         p34MVWwG8wwkPw0B850D0NM/fmXAtAtulik8zlas9XcHBwThTFcS53tFaXS9v7zUoyCr
         nnFSxXPI/TetoZugJmU1fp24bKm0UipWAW0BwVnEfB9KYtEnnkTldQ6/wsCsN9RZ+01r
         2vvg==
X-Gm-Message-State: ACgBeo1dxm//rFQXyw7EMIQ29aBRm3poTapsFtG5s8hVeUumnydW49sZ
        CYHup1ZppiBZMTwlnFNIplz2nAf53bk=
X-Google-Smtp-Source: AA6agR5joboXJ50eoG2Z6BF5GBW6Yh5sfKVgZPkKsN9Ofcq93h+RS3Gip+6Kf0tI6cmW3ZIknNaXKw==
X-Received: by 2002:a5d:4b4f:0:b0:226:e3d0:b6f8 with SMTP id w15-20020a5d4b4f000000b00226e3d0b6f8mr6342409wrs.355.1662011350617;
        Wed, 31 Aug 2022 22:49:10 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id bg15-20020a05600c3c8f00b003a4f08495b7sm4447262wmb.34.2022.08.31.22.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 22:49:10 -0700 (PDT)
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
Subject: [PATCH 5.10 v2 5/7] xfs: revert "xfs: actually bump warning counts when we send warnings"
Date:   Thu,  1 Sep 2022 08:48:52 +0300
Message-Id: <20220901054854.2449416-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220901054854.2449416-1-amir73il@gmail.com>
References: <20220901054854.2449416-1-amir73il@gmail.com>
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

