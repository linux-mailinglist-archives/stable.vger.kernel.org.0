Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C77C69CE6E
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbjBTN7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbjBTN7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:59:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15111E9EE
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:58:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC7C9B80D58
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F9DC4339B;
        Mon, 20 Feb 2023 13:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901499;
        bh=AiUFxwgP6JG71yEWTBEA9ukmIi5IsJRhe5/HEhzoA5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btlbThGf20e+SmMby0uHF4YlB7dPh6WbL5wsZlak+bvH7OZlxKTH9bkVxVFPuWOv3
         BKAi36EIv3d/73sdRaPAP25Cb4mj7UeKVN+BpPp+PPGXQnRo+skbfwPMSG8KPwdk16
         zEW3DIsE5D3wytQ9vbsQ1txh8GcyElxWq90Pyzqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiubo Li <xiubli@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/118] ceph: move mount state enum to super.h
Date:   Mon, 20 Feb 2023 14:35:57 +0100
Message-Id: <20230220133602.079935725@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
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



