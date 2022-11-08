Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A603B6215A5
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235272AbiKHONw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235279AbiKHONu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:13:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EE15FAB
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:13:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A22AA615CD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9316EC433D6;
        Tue,  8 Nov 2022 14:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916829;
        bh=AU9figjEZxxoi/zMw1Q6LXr7S5mk3Nh9vkF9NgqiQCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CEpBExcJIp9h9Pr1CNDIBggB3XSFMIgTMHoFXolF6BAr0bCcU0JA21ncMfcYD3xYl
         XT1QfdkMlCWk2Ha3/8inf3NxxqFnS1ID+4uQQQQCBB8hCrNaENI/wDzAL+xqH0q83I
         FicaGCGKx8u6gabi2SAbBblNkD7nxl32eXgg6Fnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Serge Hallyn <serge@hallyn.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.0 146/197] capabilities: fix potential memleak on error path from vfs_getxattr_alloc()
Date:   Tue,  8 Nov 2022 14:39:44 +0100
Message-Id: <20221108133401.593287469@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit 8cf0a1bc12870d148ae830a4ba88cfdf0e879cee upstream.

In cap_inode_getsecurity(), we will use vfs_getxattr_alloc() to
complete the memory allocation of tmpbuf, if we have completed
the memory allocation of tmpbuf, but failed to call handler->get(...),
there will be a memleak in below logic:

  |-- ret = (int)vfs_getxattr_alloc(mnt_userns, ...)
    |           /* ^^^ alloc for tmpbuf */
    |-- value = krealloc(*xattr_value, error + 1, flags)
    |           /* ^^^ alloc memory */
    |-- error = handler->get(handler, ...)
    |           /* error! */
    |-- *xattr_value = value
    |           /* xattr_value is &tmpbuf (memory leak!) */

So we will try to free(tmpbuf) after vfs_getxattr_alloc() fails to fix it.

Cc: stable@vger.kernel.org
Fixes: 8db6c34f1dbc ("Introduce v3 namespaced file capabilities")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
[PM: subject line and backtrace tweaks]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/commoncap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -401,8 +401,10 @@ int cap_inode_getsecurity(struct user_na
 				      &tmpbuf, size, GFP_NOFS);
 	dput(dentry);
 
-	if (ret < 0 || !tmpbuf)
-		return ret;
+	if (ret < 0 || !tmpbuf) {
+		size = ret;
+		goto out_free;
+	}
 
 	fs_ns = inode->i_sb->s_user_ns;
 	cap = (struct vfs_cap_data *) tmpbuf;


