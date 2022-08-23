Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF1359D33F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241903AbiHWILy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242111AbiHWIKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:10:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F89169F68;
        Tue, 23 Aug 2022 01:07:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A162461257;
        Tue, 23 Aug 2022 08:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B6EC433D6;
        Tue, 23 Aug 2022 08:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242068;
        bh=LVQCqq3fPPBeojXbpVMFwyVEGNh3B23jnxi6VGPH+yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=puUJs5RyuI7an0aDAXhSXGv9DgyVfQZgst5zEwn37DujkvxYAGcSCqx0Vy1+fM7w5
         RWFlGh8wcgPqa+EDxM5LdMDPj8sIG6zPkw7rBkHd5CvoOH70xCINyRupKc4nhhj8tf
         M/KRfsDYCJWuWdxztwRINYR1ixL859lPd5UFfgCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianyue Ren <rentianyue@kylinos.cn>,
        Paul Moore <paul@paul-moore.com>,
        Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 014/101] selinux: fix error initialization in inode_doinit_with_dentry()
Date:   Tue, 23 Aug 2022 10:02:47 +0200
Message-Id: <20220823080035.116874434@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianyue Ren <rentianyue@kylinos.cn>

commit 83370b31a915493231e5b9addc72e4bef69f8d31 upstream.

Mark the inode security label as invalid if we cannot find
a dentry so that we will retry later rather than marking it
initialized with the unlabeled SID.

Fixes: 9287aed2ad1f ("selinux: Convert isec->lock into a spinlock")
Signed-off-by: Tianyue Ren <rentianyue@kylinos.cn>
[PM: minor comment tweaks]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Alexander Grund <theflamefire89@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1450,7 +1450,13 @@ static int inode_doinit_with_dentry(stru
 			 * inode_doinit with a dentry, before these inodes could
 			 * be used again by userspace.
 			 */
-			goto out;
+			isec->initialized = LABEL_INVALID;
+			/*
+			 * There is nothing useful to jump to the "out"
+			 * label, except a needless spin lock/unlock
+			 * cycle.
+			 */
+			return 0;
 		}
 
 		len = INITCONTEXTLEN;
@@ -1558,8 +1564,15 @@ static int inode_doinit_with_dentry(stru
 			 * inode_doinit() with a dentry, before these inodes
 			 * could be used again by userspace.
 			 */
-			if (!dentry)
-				goto out;
+			if (!dentry) {
+				isec->initialized = LABEL_INVALID;
+				/*
+				 * There is nothing useful to jump to the "out"
+				 * label, except a needless spin lock/unlock
+				 * cycle.
+				 */
+				return 0;
+			}
 			rc = selinux_genfs_get_sid(dentry, sclass,
 						   sbsec->flags, &sid);
 			dput(dentry);


