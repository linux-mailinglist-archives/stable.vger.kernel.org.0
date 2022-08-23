Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5478059E687
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 18:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242548AbiHWQC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 12:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244279AbiHWQAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 12:00:42 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3320E23DF11;
        Tue, 23 Aug 2022 05:12:11 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id k17so7101496wmr.2;
        Tue, 23 Aug 2022 05:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=dwyYxuJamyCThGYEhux6k2lNfMR5/mA+iH2gkx5gwZ4=;
        b=c3GSuUrH9gof/sSrDL1ldyJDJNfqMWgXBzxZ1Y5MRN8V0qsFdUMfAcm8XETWfr4rPJ
         Rkb4BkEFy6kAeWaHF/jGm/siVeu3uvjXeh3hNjO32G0Cjj/9+pJI80ZqjDPtvIVkhayE
         r7i1fFey0LFNsOy/QBByzMdf1ayFX4qnCzHaAF7lqKLbT9Rts/kSA8SAhQMF1H3XA+oA
         zbMAm54uM7YIZtmJ7oi1uLoCQehInCEGgonqlVOtBQi08+KHp3j4Ofq9OORgMS96jnJC
         3wPQzVWv+5fm3/xGwHXFULnilRwxgX0bA+owyhb62+BStcco48RAgcSnO1tIin1bU21/
         TG1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=dwyYxuJamyCThGYEhux6k2lNfMR5/mA+iH2gkx5gwZ4=;
        b=GscH2ZNY9fn9KP5F8hAQQ8NJkDabdgsLyCF0mcGsYrlFpjEb3NQuAUxDi4ywjFIXad
         ku5QLYgw2sFF9z7UmAQzgjXaUazfbAF198cxtYCQxAqRQPHgGmvt034UBTdRVxiNrmt/
         4xv7Ynw2LkYpNd2lMf+GXZPitKbLjEH3KCaBxnEkAsVD+fWxphSvxE5rNQXRjLqfpTJx
         IgLzrU09w34APIfYmNy1ASh8qecZMbfOlx4gzUC10rTm8Qc6GftfOwkKNJNGrmxwDY9R
         SWQmbEX7cQhiVtrWwBwxTjbM51A36/haGxl4CsjuUfrcBAkgWx9RwZKklTB/kJcJ9Ite
         Yk0g==
X-Gm-Message-State: ACgBeo1XCq3w3kJqS4Pr0xfqjGm0kZX94pNtEZS3sGE7W62JgjSHhjTW
        0Ss2QphzZyXWYMP0bJbHWHI=
X-Google-Smtp-Source: AA6agR5dAVuCgrqR17Viaxutf7h80N5q6ksry7R+nZ1ZwPLZJVx2wlorX+yDogn91fmGRnqL2h9RDg==
X-Received: by 2002:a05:600c:4f90:b0:3a6:2bda:dc4e with SMTP id n16-20020a05600c4f9000b003a62bdadc4emr2017332wmq.39.1661256708832;
        Tue, 23 Aug 2022 05:11:48 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id g11-20020a05600c4ecb00b003a4c6e67f01sm24681879wmq.6.2022.08.23.05.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 05:11:48 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 v2 4/6] vfs: make sync_filesystem return errors from ->sync_fs
Date:   Tue, 23 Aug 2022 15:11:34 +0300
Message-Id: <20220823121136.1806820-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220823121136.1806820-1-amir73il@gmail.com>
References: <20220823121136.1806820-1-amir73il@gmail.com>
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

commit 5679897eb104cec9e99609c3f045a0c20603da4c upstream.

[backport to 5.10 only differs in __sync_blockdev helper]

Strangely, sync_filesystem ignores the return code from the ->sync_fs
call, which means that syscalls like syncfs(2) never see the error.
This doesn't seem right, so fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/sync.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 0d6cdc507cb9..79180e58d862 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -28,7 +28,7 @@
  */
 int sync_filesystem(struct super_block *sb)
 {
-	int ret;
+	int ret = 0;
 
 	/*
 	 * We need to be protected against the filesystem going from
@@ -51,15 +51,21 @@ int sync_filesystem(struct super_block *sb)
 	 * at a time.
 	 */
 	writeback_inodes_sb(sb, WB_REASON_SYNC);
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, 0);
+	if (sb->s_op->sync_fs) {
+		ret = sb->s_op->sync_fs(sb, 0);
+		if (ret)
+			return ret;
+	}
 	ret = __sync_blockdev(sb->s_bdev, 0);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	sync_inodes_sb(sb);
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, 1);
+	if (sb->s_op->sync_fs) {
+		ret = sb->s_op->sync_fs(sb, 1);
+		if (ret)
+			return ret;
+	}
 	return __sync_blockdev(sb->s_bdev, 1);
 }
 EXPORT_SYMBOL(sync_filesystem);
-- 
2.25.1

