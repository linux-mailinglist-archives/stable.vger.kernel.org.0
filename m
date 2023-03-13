Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F886B81B9
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 20:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjCMTYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 15:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjCMTX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 15:23:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FDD1CBC2
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 12:23:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36C4BB811DD
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 19:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF41DC433D2;
        Mon, 13 Mar 2023 19:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678735390;
        bh=BijfgByntABiAYlj6OrFomp0dyrciWsas5Aq1yk3QOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPMr1VHAaKS0Y1Ko2pcEdOnQWY87D4sRWphYSQhH3LHEbK+j7UxxUYUq/gWhGfifS
         L+Y+0bTVgOSSIdNgwx+zV/Dem3MONpsROL6WbXeXfaNy+RLs+Gf3e6R9BleTrK6jPM
         aKA5evKmWlpnPUFSc1OWekhKtE0OD+V2GVQL23VlCYafjGhUP61QyYCxyL6DCZ1Yai
         CPVeLFrFfuSljnu6JJ8A82AIjdxeFxdP/fBIGU3hoYl5MgDbdtOvcYZdv6LxiSkTg7
         q7m9OFW28l6OS4FDhDCP3TNDmM3S8+i/xtId+dPAsdHSRaNsx6zWXPgvKN7MV0HkZE
         7CnuMoIoBWJlQ==
From:   "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     sforshee@kernel.org, brauner@kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.15] filelocks: use mount idmapping for setlease permission check
Date:   Mon, 13 Mar 2023 14:23:09 -0500
Message-Id: <20230313192309.3988024-1-sforshee@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <1678704830213151@kroah.com>
References: <1678704830213151@kroah.com>
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
index 82a4487e95b3..881fd16905c6 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1901,9 +1901,10 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp,
 			void **priv)
 {
 	struct inode *inode = locks_inode(filp);
+	kuid_t uid = i_uid_into_mnt(file_mnt_user_ns(filp), inode);
 	int error;
 
-	if ((!uid_eq(current_fsuid(), inode->i_uid)) && !capable(CAP_LEASE))
+	if ((!uid_eq(current_fsuid(), uid)) && !capable(CAP_LEASE))
 		return -EACCES;
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
-- 
2.39.1

