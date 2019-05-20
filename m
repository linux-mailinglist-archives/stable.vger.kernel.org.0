Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B66DB235FA
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390165AbfETMat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389763AbfETMas (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:30:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3ECFE20645;
        Mon, 20 May 2019 12:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355447;
        bh=81+UjyrcSCKmXD9ZTUeHQt74KBPNk574mKGMq0/zJtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j69jicdzwcJclH6xUqesHR9YYZW2RVAt08raLqn8cQFMCd9Jfslf/8UQLG/nn7sva
         uuKVg40YNKzIvAk0irgFlx/ra4ZITJ+e1cm4c/e3J3Yqz/ksHVFXR/+Rj48WV+9T2M
         Rmg3ficAj7s35hMYQ1IPaG+OYS6H2ndM6TMat3YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.0 122/123] ext4: fix compile error when using BUFFER_TRACE
Date:   Mon, 20 May 2019 14:15:02 +0200
Message-Id: <20190520115253.281913711@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

commit ddccb6dbe780d68133191477571cb7c69e17bb8c upstream.

Fix compile error below when using BUFFER_TRACE.

fs/ext4/inode.c: In function ‘ext4_expand_extra_isize’:
fs/ext4/inode.c:5979:19: error: request for member ‘bh’ in something not a structure or union
  BUFFER_TRACE(iloc.bh, "get_write_access");

Fixes: c03b45b853f58 ("ext4, project: expand inode extra size if possible")
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6006,7 +6006,7 @@ int ext4_expand_extra_isize(struct inode
 
 	ext4_write_lock_xattr(inode, &no_expand);
 
-	BUFFER_TRACE(iloc.bh, "get_write_access");
+	BUFFER_TRACE(iloc->bh, "get_write_access");
 	error = ext4_journal_get_write_access(handle, iloc->bh);
 	if (error) {
 		brelse(iloc->bh);


