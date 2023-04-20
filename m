Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1A26E9ABB
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 19:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbjDTR2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 13:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbjDTR22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 13:28:28 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C5530E8
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 10:28:21 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-63b64a32fd2so1744777b3a.2
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 10:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1682011701; x=1684603701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3x8N7sxsFvg5b0uwbahj+PwbPcqRN9aSzyeMa7PrIzY=;
        b=PInXabSKPMPkpHkuZFbSfZyAVvTSjLv36Kr/cvSO8TjzWJ6vlXl0FTCM4HkL4ZD4vw
         aQGfOydJeFSTT7e0EsizobBwWZQwg9OQ166TMTtcAizTmIwmi1rXZ701QcJfeofeXRlS
         9cUaCm4t2WOGkiOxpO7Yj6DFl8oRlg4ewN0fo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682011701; x=1684603701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3x8N7sxsFvg5b0uwbahj+PwbPcqRN9aSzyeMa7PrIzY=;
        b=YRiZhZSA5akn4BZp70oz6COqNTzBsPjpxtYnxjzfD0/AwUmveJh27homrjZwSAgXRC
         KP2kgd0pV6rrj112oX9O7IKBz+wtomwZh0oEy2EAMQckAwr95MiX7YD7OE75g90txdjp
         zzL/kRdaS05ooagKaVhsxG/niv1x5Bh2MpgzQQmjn1+Av+UpL8f+l2+RPEMrGBr85Rsn
         WWQCRjgrx93pahgKhTP5iKMF2PsFtwETet/rjUFkxMkBaQFF9wnyJabtYZknOylVrozm
         H6xOjyGfEG+cMkjPuL6SxnyhJ2+QCpoOEehxgtA/O18APvW3gGzxzagJa10VmH4b49GF
         a+dA==
X-Gm-Message-State: AAQBX9f4wDbmxcLE2lqyg1BOowqn3DRONEN3o5EpgUoeo0L+taCYbdPf
        CJTeGiLyRR1PlrjKBIMabuczGw==
X-Google-Smtp-Source: AKy350aamevL738b4lQu+r4Mb45ADgAjxr+szLfVa8OCWWSr0APnPjIlT0WZwrlfZ+8BR9m9vFOf1A==
X-Received: by 2002:a05:6a20:d38d:b0:f0:558b:8fbb with SMTP id iq13-20020a056a20d38d00b000f0558b8fbbmr2889057pzb.34.1682011700784;
        Thu, 20 Apr 2023 10:28:20 -0700 (PDT)
Received: from sarthakkukreti-glaptop.hsd1.ca.comcast.net ([2601:647:4200:b5b0:42d9:debc:8d41:e6c4])
        by smtp.gmail.com with ESMTPSA id t9-20020a6549c9000000b0051b3ef1295csm1360372pgs.53.2023.04.20.10.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 10:28:20 -0700 (PDT)
From:   Sarthak Kukreti <sarthakkukreti@chromium.org>
To:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Bart Van Assche <bvanassche@google.com>,
        Daniil Lunev <dlunev@google.com>,
        "Darrick J. Wong" <djwong@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v5-fix 1/5] block: Don't invalidate pagecache for invalid falloc modes
Date:   Thu, 20 Apr 2023 10:28:07 -0700
Message-ID: <20230420172807.323150-1-sarthakkukreti@chromium.org>
X-Mailer: git-send-email 2.40.0.396.gfff15efe05-goog
In-Reply-To: <ZEFmS9h81Wwlv9+/@redhat.com>
References: <ZEFmS9h81Wwlv9+/@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Only call truncate_bdev_range() if the fallocate mode is
supported. This fixes a bug where data in the pagecache
could be invalidated if the fallocate() was called on the
block device with an invalid mode.

Fixes: 25f4c41415e5 ("block: implement (some of) fallocate for block devices")
Cc: stable@vger.kernel.org
Reported-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 block/fops.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index d2e6be4e3d1c..20b1eddcbe25 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -648,24 +648,35 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 
 	filemap_invalidate_lock(inode->i_mapping);
 
-	/* Invalidate the page cache, including dirty pages. */
-	error = truncate_bdev_range(bdev, file->f_mode, start, end);
-	if (error)
-		goto fail;
-
+	/*
+	 * Invalidate the page cache, including dirty pages, for valid
+	 * de-allocate mode calls to fallocate().
+	 */
 	switch (mode) {
 	case FALLOC_FL_ZERO_RANGE:
 	case FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE:
+		error = truncate_bdev_range(bdev, file->f_mode, start, end);
+		if (error)
+			goto fail;
+
 		error = blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,
 					     len >> SECTOR_SHIFT, GFP_KERNEL,
 					     BLKDEV_ZERO_NOUNMAP);
 		break;
 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE:
+		error = truncate_bdev_range(bdev, file->f_mode, start, end);
+		if (error)
+			goto fail;
+
 		error = blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,
 					     len >> SECTOR_SHIFT, GFP_KERNEL,
 					     BLKDEV_ZERO_NOFALLBACK);
 		break;
 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | FALLOC_FL_NO_HIDE_STALE:
+		error = truncate_bdev_range(bdev, file->f_mode, start, end);
+		if (!error)
+			goto fail;
+
 		error = blkdev_issue_discard(bdev, start >> SECTOR_SHIFT,
 					     len >> SECTOR_SHIFT, GFP_KERNEL);
 		break;
-- 
2.40.0.396.gfff15efe05-goog

