Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D7E47AFC6
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238740AbhLTPSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238354AbhLTPRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:17:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C5DC08ECA9;
        Mon, 20 Dec 2021 06:58:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0168B611C1;
        Mon, 20 Dec 2021 14:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8972C36AE7;
        Mon, 20 Dec 2021 14:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012326;
        bh=gKNyzEFbVo/6GCnvOhvDOU2keO8fqSNkieYpVdljaJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asL3bMjwfrd3UjxlevmsX1gVcXdm+D7StkkuBYNlsloXit0ThkbbQKQA9YJM6PGXU
         pJzqSMrW0I0dR3O9BVuOPY0GG05oz2L8gjePLbzNr4PVSrZ+RHJhYw7ZKSAcLkQ2sr
         6kwMeag4+zLPFAcl9xAkaQ6bs2c7aOWRiGsgBOzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        syzbot+9f747458f5990eaa8d43@syzkaller.appspotmail.com
Subject: [PATCH 5.15 161/177] fuse: annotate lock in fuse_reverse_inval_entry()
Date:   Mon, 20 Dec 2021 15:35:11 +0100
Message-Id: <20211220143045.500509677@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit bda9a71980e083699a0360963c0135657b73f47a upstream.

Add missing inode lock annotatation; found by syzbot.

Reported-and-tested-by: syzbot+9f747458f5990eaa8d43@syzkaller.appspotmail.com
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1079,7 +1079,7 @@ int fuse_reverse_inval_entry(struct fuse
 	if (!parent)
 		return -ENOENT;
 
-	inode_lock(parent);
+	inode_lock_nested(parent, I_MUTEX_PARENT);
 	if (!S_ISDIR(parent->i_mode))
 		goto unlock;
 


