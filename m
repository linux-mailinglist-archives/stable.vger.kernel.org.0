Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3112666C8E9
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbjAPQoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbjAPQnq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:43:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044BB39BB2
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:31:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA39CB81077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B7CC433F2;
        Mon, 16 Jan 2023 16:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886688;
        bh=UPw55wXHTEgyOHqevqFCXglAqMMYr0F1K8VA3yX2I58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tia/JItN80YJtgkGVa0dmuDcoYQHSAG0yl959eLl2eRqv0/euxpo7pEXZxhSuGS2N
         74bx2DImuTirHNhqeWYMnl7+gXhba18WTXJBEYn+UbIFDwWOEeGRYeYwDYcQ9WtHJE
         //DUS/Rcez87PxFBkHLCFNMEyMTLj8hbKK4WnHZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Baokun Li <libaokun1@huawei.com>,
        Jason Yan <yanaijie@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.4 525/658] ext4: add helper to check quota inums
Date:   Mon, 16 Jan 2023 16:50:13 +0100
Message-Id: <20230116154933.563661964@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

commit 07342ec259df2a35d6a34aebce010567a80a0e15 upstream.

Before quota is enabled, a check on the preset quota inums in
ext4_super_block is added to prevent wrong quota inodes from being loaded.
In addition, when the quota fails to be enabled, the quota type and quota
inum are printed to facilitate fault locating.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221026042310.3839669-3-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5954,6 +5954,20 @@ static int ext4_quota_on(struct super_bl
 	return err;
 }
 
+static inline bool ext4_check_quota_inum(int type, unsigned long qf_inum)
+{
+	switch (type) {
+	case USRQUOTA:
+		return qf_inum == EXT4_USR_QUOTA_INO;
+	case GRPQUOTA:
+		return qf_inum == EXT4_GRP_QUOTA_INO;
+	case PRJQUOTA:
+		return qf_inum >= EXT4_GOOD_OLD_FIRST_INO;
+	default:
+		BUG();
+	}
+}
+
 static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
 			     unsigned int flags)
 {
@@ -5970,9 +5984,16 @@ static int ext4_quota_enable(struct supe
 	if (!qf_inums[type])
 		return -EPERM;
 
+	if (!ext4_check_quota_inum(type, qf_inums[type])) {
+		ext4_error(sb, "Bad quota inum: %lu, type: %d",
+				qf_inums[type], type);
+		return -EUCLEAN;
+	}
+
 	qf_inode = ext4_iget(sb, qf_inums[type], EXT4_IGET_SPECIAL);
 	if (IS_ERR(qf_inode)) {
-		ext4_error(sb, "Bad quota inode # %lu", qf_inums[type]);
+		ext4_error(sb, "Bad quota inode: %lu, type: %d",
+				qf_inums[type], type);
 		return PTR_ERR(qf_inode);
 	}
 
@@ -6011,8 +6032,9 @@ static int ext4_enable_quotas(struct sup
 			if (err) {
 				ext4_warning(sb,
 					"Failed to enable quota tracking "
-					"(type=%d, err=%d). Please run "
-					"e2fsck to fix.", type, err);
+					"(type=%d, err=%d, ino=%lu). "
+					"Please run e2fsck to fix.", type,
+					err, qf_inums[type]);
 				for (type--; type >= 0; type--) {
 					struct inode *inode;
 


