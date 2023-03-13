Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510616B81A9
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 20:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjCMTWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 15:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjCMTWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 15:22:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC9088ECD
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 12:21:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5064614AC
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 19:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBDCC433A0;
        Mon, 13 Mar 2023 19:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678735302;
        bh=PR2X3+foEPJFQ67VrOByezZdEGyAz4P/s7GF9X7uEjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ruHAJfXR7K5Oyadc5WyyyDnGfyjcWivshxnQpbIZf3JQb9qLNG8M/04mQeDorxVMe
         8Rz/sB1tox+V0FxJqp7oiPQ9XBCmDofBo6OuKOD32GLvKfr9f3cvcP6bdnwf34Qn5+
         XDxYa+UfkbPO07fJgz+Z089rOMyEZiBdsvOSZhjOICzbeClXsw2jQ5cDtwW55ahUDO
         ykTqFUyQ+Tav+0n4qvh3lfztTLesIswc3zcbWr4sBi0+mKkHIUlQbkTLdzN+uDJxAQ
         zIE1FdaaLQZGDn3v1Mo9NZMPuWnwPzSZk2Y/nrh6hzI4AGormFnpFYzSSdYWPpCmp4
         9qwRKjJyU8Krw==
From:   "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     sforshee@kernel.org, brauner@kernel.org, stable@vger.kernel.org
Subject: [PATCH 6.2] filelocks: use mount idmapping for setlease permission check
Date:   Mon, 13 Mar 2023 14:21:40 -0500
Message-Id: <20230313192140.3986664-1-sforshee@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <167870482993162@kroah.com>
References: <167870482993162@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seth Forshee <sforshee@kernel.org>

[ Upstream commit 42d0c4bdf753063b6eec55415003184d3ca24f6e ]

A user should be allowed to take out a lease via an idmapped mount if
the fsuid matches the mapped uid of the inode. generic_setlease() is
checking the unmapped inode uid, causing these operations to be denied.

Fix this by comparing against the mapped inode uid instead of the
unmapped uid.

Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
Cc: stable@vger.kernel.org
Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/locks.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/locks.c b/fs/locks.c
index 8f01bee17715..8a881cda3dd2 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1862,9 +1862,10 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp,
 			void **priv)
 {
 	struct inode *inode = locks_inode(filp);
+	vfsuid_t vfsuid = i_uid_into_vfsuid(file_mnt_user_ns(filp), inode);
 	int error;
 
-	if ((!uid_eq(current_fsuid(), inode->i_uid)) && !capable(CAP_LEASE))
+	if ((!vfsuid_eq_kuid(vfsuid, current_fsuid())) && !capable(CAP_LEASE))
 		return -EACCES;
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
-- 
2.39.1

