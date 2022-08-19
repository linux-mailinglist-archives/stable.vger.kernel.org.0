Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67ECC59A596
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350408AbiHSSP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 14:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350693AbiHSSPd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 14:15:33 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BA337F8A;
        Fri, 19 Aug 2022 11:14:48 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id x23so4784886pll.7;
        Fri, 19 Aug 2022 11:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Eg8lLnZD45tjnJs2FISMJ0GzB1uwNmqz0NlD8+uXijU=;
        b=mv/ttqkxqIB5nUnVjGsAm00z7k+W9h3i2s3SRzCBJhen+yoHgbcf/4ULZ7lxb+lCBl
         UaD0iKEedBTCdk3Tma3acs7btv/zuk/XgBS/W+AS8ONF+kH/z7ixI3+N83mfHhTdAelz
         ppNWxwkE335QdjXsFuBgshQITduzjMU5u9db/22B5UIILTsamPtiYxCFjP5gv2pbXCpc
         BKw2cfvarNVmd4JTnJz1twd6L+kDhmTaqUKi8VIaA5FfQXfpsOvgjthpoEtyhnMDIxKA
         fhPw7SgYGWDZdduE6eK13oHfasM/Rp1nPwGmltUriv1XkcPW6u8YGpbH5VtLf/yKi32+
         4UGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Eg8lLnZD45tjnJs2FISMJ0GzB1uwNmqz0NlD8+uXijU=;
        b=YflOctWzLe0RuM12Gh4xHU7+BAG+g3rGfMEuThPVRONCVXHxnv668RJJuvMoGs+col
         nWue16a4StuPlChUKOvv+M8iABMjafGS3C/Hm99YlqQq1S/iKd1lwuKoiAyDdvUBiluU
         kymZ+VyvPX1woPhQ82qEjicuzsgPdwhQVDU5q29PMFbw5+DUMVz+/qg+v2JmTXr3JyEm
         7zbr1kKIcI2IMR8Ak0eWA9+3psK7WAVoo0nmghUtBjFPRt5rhwr5/nJBYNNONo/1ZMQi
         G5WqpG/IgB6s2vNQBsGTw/tlWyafeWx9YGqWb+JTbp1XvEM0ftRWojDjecaMgqYEckzC
         Ioug==
X-Gm-Message-State: ACgBeo1+GTHnn9GSAXRQQ5vyC5b7q00Bn9I78a7a9NalmQq1R0NKP1al
        YVvPxS8am/EqnZT6HB+lCtiXNPQ00oG9KA==
X-Google-Smtp-Source: AA6agR54hD55doPt8LuwvfDzoepYyBUWslS8HkPB8ST3Y3KihmVlMJN9u4BfwWU2R5Wy0sM487KmKQ==
X-Received: by 2002:a17:90b:4d91:b0:1f5:24a:ff7e with SMTP id oj17-20020a17090b4d9100b001f5024aff7emr9583028pjb.194.1660932887730;
        Fri, 19 Aug 2022 11:14:47 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:3995:f9b1:1e6b:e373])
        by smtp.gmail.com with ESMTPSA id t14-20020a170902e84e00b0015ee60ef65bsm3460918plg.260.2022.08.19.11.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 11:14:46 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        Eric Sandeen <sandeen@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 8/9] xfs: revert "xfs: actually bump warning counts when we send warnings"
Date:   Fri, 19 Aug 2022 11:14:30 -0700
Message-Id: <20220819181431.4113819-9-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220819181431.4113819-1-leah.rumancik@gmail.com>
References: <20220819181431.4113819-1-leah.rumancik@gmail.com>
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

[ Upstream commit bc37e4fb5cac2925b2e286b1f1d4fc2b519f7d92 ]

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
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trans_dquot.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 3872ce671411..955c457e585a 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -603,7 +603,6 @@ xfs_dqresv_check(
 			return QUOTA_NL_ISOFTLONGWARN;
 		}
 
-		res->warnings++;
 		return QUOTA_NL_ISOFTWARN;
 	}
 
-- 
2.37.1.595.g718a3a8f04-goog

