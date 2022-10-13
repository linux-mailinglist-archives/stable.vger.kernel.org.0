Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC1E5FE499
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 23:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiJMV5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 17:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiJMV5a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 17:57:30 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262B5B1DE5
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 14:57:29 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t10-20020a17090a4e4a00b0020af4bcae10so3066613pjl.3
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 14:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cLnzfjyyTf8WgASDWawjHSJccX1+IP1aw5dD9OiyAEM=;
        b=hDWMDQ8IVTYXZo65HnELnujodY0ChODvGiH/+O9W2bRH2jVUWhkDy2mEr5KFz0OTcz
         hwcT6pbskfyFZtulupO6+hTMKspRKvv920R8cuO9quFAVEIoAbXb1qo4yoLcIQa3JlA2
         X5NCr6kOZsvRuL/FtIF4S56KU0IbHssYoDgIo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cLnzfjyyTf8WgASDWawjHSJccX1+IP1aw5dD9OiyAEM=;
        b=rnqRx9CJv9RSKSm8wwLJvKt+YyifkTtDNCxFBkxN2/WUw4UhXma+ZyUi/8kEg3ufH+
         QWXAuz+GP7iLSvfwerswGJkJxVeBsvd/bgotsSdz+d1aF18hwu2lTf3tPX4Z6ry0aQQp
         nNEiwzDN84fZMqV01q+cwY/YuRR327Ybe237MLs4f93/P8iB3vS3Shbdih0uIMDeEwck
         pjo2DsuJ+jz/orsUUZSx3RWbgKI47jhaqZikECDDcwoNidHsVyghVeYSQbJKpJFrg98G
         b9K6EFT88VXg08W4jpytY390txgmFMof2qIevMZ9uF8tYBYCNDM6lGKNTMdx2t9kBFj7
         q49g==
X-Gm-Message-State: ACrzQf2FhyKScubOm1Bhnk4mJoLVrpMFScSC+cglC/og6fv1XrJIT92y
        dCBHOEbxe/poDmd7GxSP+bW++mE8aSY3SQ==
X-Google-Smtp-Source: AMsMyM4dd8L0EBNZvKQDTK2JpoNmz8Ono8znRiILB8sUobSmZe11kuxciOCGliwvXP6f6Y4DcrSZlg==
X-Received: by 2002:a17:903:1d1:b0:17f:6494:f8c3 with SMTP id e17-20020a17090301d100b0017f6494f8c3mr1761550plh.157.1665698248326;
        Thu, 13 Oct 2022 14:57:28 -0700 (PDT)
Received: from khazhy-linux.svl.corp.google.com ([2620:15c:2d4:203:a572:a73c:63a6:7f13])
        by smtp.gmail.com with ESMTPSA id pi12-20020a17090b1e4c00b0020a686e57dbsm3754808pjb.49.2022.10.13.14.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 14:57:27 -0700 (PDT)
From:   Khazhismel Kumykov <khazhy@chromium.org>
X-Google-Original-From: Khazhismel Kumykov <khazhy@google.com>
To:     stable@vger.kernel.org
Cc:     Jeffle Xu <jefflexu@linux.alibaba.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Khazhismel Kumykov <khazhy@google.com>
Subject: [PATCH v5.10] block: fix inflight statistics of part0
Date:   Thu, 13 Oct 2022 14:56:03 -0700
Message-Id: <20221013215603.2841286-1-khazhy@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffle Xu <jefflexu@linux.alibaba.com>

[ Upstream commit b0d97557ebfc9d5ba5f2939339a9fdd267abafeb ]

The inflight of partition 0 doesn't include inflight IOs to all
sub-partitions, since currently mq calculates inflight of specific
partition by simply camparing the value of the partition pointer.

Thus the following case is possible:

$ cat /sys/block/vda/inflight
       0        0
$ cat /sys/block/vda/vda1/inflight
       0      128

While single queue device (on a previous version, e.g. v3.10) has no
this issue:

$cat /sys/block/sda/sda3/inflight
       0       33
$cat /sys/block/sda/inflight
       0       33

Partition 0 should be specially handled since it represents the whole
disk. This issue is introduced since commit bf0ddaba65dd ("blk-mq: fix
sysfs inflight counter").

Besides, this patch can also fix the inflight statistics of part 0 in
/proc/diskstats. Before this patch, the inflight statistics of part 0
doesn't include that of sub partitions. (I have marked the 'inflight'
field with asterisk.)

$cat /proc/diskstats
 259       0 nvme0n1 45974469 0 367814768 6445794 1 0 1 0 *0* 111062 6445794 0 0 0 0 0 0
 259       2 nvme0n1p1 45974058 0 367797952 6445727 0 0 0 0 *33* 111001 6445727 0 0 0 0 0 0

This is introduced since commit f299b7c7a9de ("blk-mq: provide internal
in-flight variant").

Fixes: bf0ddaba65dd ("blk-mq: fix sysfs inflight counter")
Fixes: f299b7c7a9de ("blk-mq: provide internal in-flight variant")
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
[axboe: adapt for 5.11 partition change]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[khazhy: adapt for 5.10 partition]
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
---
 block/blk-mq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index cfc039fabf8c..e37ba792902a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -105,7 +105,8 @@ static bool blk_mq_check_inflight(struct blk_mq_hw_ctx *hctx,
 {
 	struct mq_inflight *mi = priv;
 
-	if (rq->part == mi->part && blk_mq_rq_state(rq) == MQ_RQ_IN_FLIGHT)
+	if ((!mi->part->partno || rq->part == mi->part) &&
+	    blk_mq_rq_state(rq) == MQ_RQ_IN_FLIGHT)
 		mi->inflight[rq_data_dir(rq)]++;
 
 	return true;
-- 
2.38.0.rc1.362.ged0d419d3c-goog

