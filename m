Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF4247EAF7
	for <lists+stable@lfdr.de>; Fri, 24 Dec 2021 04:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351174AbhLXDwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 22:52:46 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:57370 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351171AbhLXDwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 22:52:45 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V.ahoK8_1640317963;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0V.ahoK8_1640317963)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 24 Dec 2021 11:52:43 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     dhowells@redhat.com
Subject: [PATCH for 5.15.y stable] netfs: fix parameter of cleanup()
Date:   Fri, 24 Dec 2021 11:52:43 +0800
Message-Id: <20211224035243.56554-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <163913443334205@kroah.com>
References: <163913443334205@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 3cfef1b612e15a0c2f5b1c9d3f3f31ad72d56fcd upstream.

The order of these two parameters is just reversed. gcc didn't warn on
that, probably because 'void *' can be converted from or to other
pointer types without warning.

Cc: stable@vger.kernel.org
Fixes: 3d3c95046742 ("netfs: Provide readahead and readpage netfs helpers")
Fixes: e1b1240c1ff5 ("netfs: Add write_begin helper")
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Link: https://lore.kernel.org/r/20211207031449.100510-1-jefflexu@linux.alibaba.com/ # v1
---
 fs/netfs/read_helper.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/read_helper.c b/fs/netfs/read_helper.c
index 4b54529f8176..242f8bcb34a4 100644
--- a/fs/netfs/read_helper.c
+++ b/fs/netfs/read_helper.c
@@ -958,7 +958,7 @@ int netfs_readpage(struct file *file,
 	rreq = netfs_alloc_read_request(ops, netfs_priv, file);
 	if (!rreq) {
 		if (netfs_priv)
-			ops->cleanup(netfs_priv, page_file_mapping(page));
+			ops->cleanup(page_file_mapping(page), netfs_priv);
 		unlock_page(page);
 		return -ENOMEM;
 	}
@@ -1185,7 +1185,7 @@ int netfs_write_begin(struct file *file, struct address_space *mapping,
 		goto error;
 have_page_no_wait:
 	if (netfs_priv)
-		ops->cleanup(netfs_priv, mapping);
+		ops->cleanup(mapping, netfs_priv);
 	*_page = page;
 	_leave(" = 0");
 	return 0;
@@ -1196,7 +1196,7 @@ int netfs_write_begin(struct file *file, struct address_space *mapping,
 	unlock_page(page);
 	put_page(page);
 	if (netfs_priv)
-		ops->cleanup(netfs_priv, mapping);
+		ops->cleanup(mapping, netfs_priv);
 	_leave(" = %d", ret);
 	return ret;
 }
-- 
2.27.0

