Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68FB690704
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjBILXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbjBILW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:22:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327AC5FB7F;
        Thu,  9 Feb 2023 03:18:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87C44B82102;
        Thu,  9 Feb 2023 11:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94321C4339B;
        Thu,  9 Feb 2023 11:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941447;
        bh=AiUFxwgP6JG71yEWTBEA9ukmIi5IsJRhe5/HEhzoA5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uyed2p/L3bFwXoThpFzQoIOw+cCd3u/wOjkNW8MleNwC9Exriz7fcdwURVD3GQssh
         Hzv1S2c5Waeae0LsXqZ920MjwI9gYWQCvI+4dvZO1SHkKJ83yojiJgpmAqf/vWVLb2
         AWMzrLLeFxTLHM5JUlwL2IXjChMgj4oIj8TKA9OETFARfNK8VXvk4jhBiG9CbzfcYl
         PCiPwb+tB1gU4Tm892s8rWz3RPsN5G8MkhxhS9y8omr4lK7TdXVh8cmKru4GoG6qSm
         +4BKlXaLIO3c4xcKeh5RUpbESsAPTIrVZYhdqgVEYUKs661ZHvHt6GoU1hf3HgejGD
         qGn9xZuCkFH8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>, Venky Shankar <vshankar@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 37/38] ceph: move mount state enum to super.h
Date:   Thu,  9 Feb 2023 06:14:56 -0500
Message-Id: <20230209111459.1891941-37-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit b38b17b6a01ca4e738af097a1529910646ef4270 ]

These flags are only used in ceph filesystem in fs/ceph, so just
move it to the place it should be.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Venky Shankar <vshankar@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/super.h              | 10 ++++++++++
 include/linux/ceph/libceph.h | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index ae4126f634101..735279b2ceb55 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -100,6 +100,16 @@ struct ceph_mount_options {
 	char *mon_addr;
 };
 
+/* mount state */
+enum {
+	CEPH_MOUNT_MOUNTING,
+	CEPH_MOUNT_MOUNTED,
+	CEPH_MOUNT_UNMOUNTING,
+	CEPH_MOUNT_UNMOUNTED,
+	CEPH_MOUNT_SHUTDOWN,
+	CEPH_MOUNT_RECOVER,
+};
+
 #define CEPH_ASYNC_CREATE_CONFLICT_BITS 8
 
 struct ceph_fs_client {
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 00af2c98da75a..4497d0a6772cd 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -99,16 +99,6 @@ struct ceph_options {
 
 #define CEPH_AUTH_NAME_DEFAULT   "guest"
 
-/* mount state */
-enum {
-	CEPH_MOUNT_MOUNTING,
-	CEPH_MOUNT_MOUNTED,
-	CEPH_MOUNT_UNMOUNTING,
-	CEPH_MOUNT_UNMOUNTED,
-	CEPH_MOUNT_SHUTDOWN,
-	CEPH_MOUNT_RECOVER,
-};
-
 static inline unsigned long ceph_timeout_jiffies(unsigned long timeout)
 {
 	return timeout ?: MAX_SCHEDULE_TIMEOUT;
-- 
2.39.0

