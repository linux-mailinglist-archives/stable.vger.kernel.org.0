Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5DA62136C
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbiKHNuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbiKHNuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:50:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020A5101E5
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:50:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9348F615A3
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A292FC433D7;
        Tue,  8 Nov 2022 13:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915405;
        bh=oro78or03vcCjFxH79JW5RAb2+OaVMD5XYGRHcMu6P8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBALjCZBO7oi8KF/oq4Snle3bGLpUpuqusDQT5tpNlkJ7I3UJK0l4KY6qz91GeNhD
         /MrM8UgQOv6oJcD/3cmonYrjle9w2wNcZlwQi/OsZi+IrnA0yMs/U+BhZPEGQyKeyJ
         8W/GVfOAke55/keUe1QI0V8Q3xqP5ecQpX26IIG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Serge Hallyn <serge@hallyn.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.4 53/74] capabilities: fix potential memleak on error path from vfs_getxattr_alloc()
Date:   Tue,  8 Nov 2022 14:39:21 +0100
Message-Id: <20221108133335.944250359@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
@@ -391,8 +391,10 @@ int cap_inode_getsecurity(struct inode *
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


