Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5334259D39F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242043AbiHWIMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242132AbiHWIKn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:10:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785FF69F6C;
        Tue, 23 Aug 2022 01:07:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14CA26123F;
        Tue, 23 Aug 2022 08:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7FFC433C1;
        Tue, 23 Aug 2022 08:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242074;
        bh=HGZuHszCVXMKiPLMwr7I2qv6J3qZJWqweO7wKCDi7TU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWBkwSH5vctso18R54dKOKIMCC6sGN4R5dwTiHh8t7dKj9Z4KWtL4BEzeerE57kp3
         T2/GcxGkvuqcn38NcdcdzEgOy3VmwO9vfGhbrUpYHQOIjqXtYIDQPJ2aBL7hx/T2B5
         CZx3XMeybHjhQhQ07JvgsevgU87RZTu3kgvfRlUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 015/101] selinux: fix inode_doinit_with_dentry() LABEL_INVALID error handling
Date:   Tue, 23 Aug 2022 10:02:48 +0200
Message-Id: <20220823080035.146702826@linuxfoundation.org>
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

From: Paul Moore <paul@paul-moore.com>

commit 200ea5a2292dc444a818b096ae6a32ba3caa51b9 upstream.

A previous fix, commit 83370b31a915 ("selinux: fix error initialization
in inode_doinit_with_dentry()"), changed how failures were handled
before a SELinux policy was loaded.  Unfortunately that patch was
potentially problematic for two reasons: it set the isec->initialized
state without holding a lock, and it didn't set the inode's SELinux
label to the "default" for the particular filesystem.  The later can
be a problem if/when a later attempt to revalidate the inode fails
and SELinux reverts to the existing inode label.

This patch should restore the default inode labeling that existed
before the original fix, without affecting the LABEL_INVALID marking
such that revalidation will still be attempted in the future.

Fixes: 83370b31a915 ("selinux: fix error initialization in inode_doinit_with_dentry()")
Reported-by: Sven Schnelle <svens@linux.ibm.com>
Tested-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Alexander Grund <theflamefire89@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c |   31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1450,13 +1450,7 @@ static int inode_doinit_with_dentry(stru
 			 * inode_doinit with a dentry, before these inodes could
 			 * be used again by userspace.
 			 */
-			isec->initialized = LABEL_INVALID;
-			/*
-			 * There is nothing useful to jump to the "out"
-			 * label, except a needless spin lock/unlock
-			 * cycle.
-			 */
-			return 0;
+			goto out_invalid;
 		}
 
 		len = INITCONTEXTLEN;
@@ -1564,15 +1558,8 @@ static int inode_doinit_with_dentry(stru
 			 * inode_doinit() with a dentry, before these inodes
 			 * could be used again by userspace.
 			 */
-			if (!dentry) {
-				isec->initialized = LABEL_INVALID;
-				/*
-				 * There is nothing useful to jump to the "out"
-				 * label, except a needless spin lock/unlock
-				 * cycle.
-				 */
-				return 0;
-			}
+			if (!dentry)
+				goto out_invalid;
 			rc = selinux_genfs_get_sid(dentry, sclass,
 						   sbsec->flags, &sid);
 			dput(dentry);
@@ -1585,11 +1572,10 @@ static int inode_doinit_with_dentry(stru
 out:
 	spin_lock(&isec->lock);
 	if (isec->initialized == LABEL_PENDING) {
-		if (!sid || rc) {
+		if (rc) {
 			isec->initialized = LABEL_INVALID;
 			goto out_unlock;
 		}
-
 		isec->initialized = LABEL_INITIALIZED;
 		isec->sid = sid;
 	}
@@ -1597,6 +1583,15 @@ out:
 out_unlock:
 	spin_unlock(&isec->lock);
 	return rc;
+
+out_invalid:
+	spin_lock(&isec->lock);
+	if (isec->initialized == LABEL_PENDING) {
+		isec->initialized = LABEL_INVALID;
+		isec->sid = sid;
+	}
+	spin_unlock(&isec->lock);
+	return 0;
 }
 
 /* Convert a Linux signal to an access vector. */


