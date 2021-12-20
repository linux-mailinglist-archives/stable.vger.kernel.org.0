Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F92247AC1E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbhLTOlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234142AbhLTOkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:40:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4040C061A08;
        Mon, 20 Dec 2021 06:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BD00B80EA3;
        Mon, 20 Dec 2021 14:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDADEC36AE8;
        Mon, 20 Dec 2021 14:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011218;
        bh=DgUJeCi6f00l52yaNNon5R87DiPyXiLlVRgh8L4s/30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=17J4X/OekapYljjuswSO/S3h0MZETkabCjNuGt7dCn4hfLdtpYHJpW0T8a9eEPoWr
         wtN5nDfVztqGY1ZWwTWtEa64B4q3WLn667MRctICmoWqxVibkQErrKQL/h9aq6AXeb
         I2nBbW8nfNXxGbHIbYL59eVvI55PuDfm5lQZsaJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        syzbot+9f747458f5990eaa8d43@syzkaller.appspotmail.com
Subject: [PATCH 4.14 34/45] fuse: annotate lock in fuse_reverse_inval_entry()
Date:   Mon, 20 Dec 2021 15:34:29 +0100
Message-Id: <20211220143023.405798649@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143022.266532675@linuxfoundation.org>
References: <20211220143022.266532675@linuxfoundation.org>
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
@@ -969,7 +969,7 @@ int fuse_reverse_inval_entry(struct supe
 	if (!parent)
 		return -ENOENT;
 
-	inode_lock(parent);
+	inode_lock_nested(parent, I_MUTEX_PARENT);
 	if (!S_ISDIR(parent->i_mode))
 		goto unlock;
 


