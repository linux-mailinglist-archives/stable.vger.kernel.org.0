Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC15C489721
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 12:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244485AbiAJLO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 06:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244449AbiAJLOy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 06:14:54 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F962C06173F;
        Mon, 10 Jan 2022 03:14:54 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 51B50C009; Mon, 10 Jan 2022 12:14:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1641813292; bh=/0pUiq7KFM+daYGEUE294c0IR+pDHWltFcA11lI6wFI=;
        h=From:To:Cc:Subject:Date:From;
        b=zci0CAI01UnYDfTTKu/Gesnzf/IXr0qPf+13clr5+FncGR4f9IPqQU/VIC4SO98As
         xG1likKmvBAatcfkq2vGWLp4KBUELajCRoj+4pGBxCCe6Monfp9Xik7xkWNquyBhep
         eCCze1JO6k0Z9Q0y9EYzMWTT0aYXPZ/CeIydVHjox6GnUxMd6/DtVb3eQ1IvKMWF89
         vlcH5nOSRtboHs0DbfZVaaiaSDWRGDO8o/Bmr0xg+87WqMkRf+5aTq5Yl3F2XlbQ1m
         VWJaxaL+OvdFJ9V64X9LCKcGzGHtC3Z//gfSPUc6bL1YMl8VpvrN5yHj5cfMDqDsvl
         N1jJvOX1dXWUQ==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 9B56FC009;
        Mon, 10 Jan 2022 12:14:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1641813291; bh=/0pUiq7KFM+daYGEUE294c0IR+pDHWltFcA11lI6wFI=;
        h=From:To:Cc:Subject:Date:From;
        b=I+zMu7zaOc9j0Y0BzuDbaY6ben6dzBtUQn7spawp62JEkXCPZoWknW/jKZ0y+1F1W
         f7mWyaUHXNX/gDsd0oV+O2kvJ1Gm0AxbCS/wo0Xomevc+GvLk9hlnlwaMWX3GW9raJ
         6gC1PiSmZ7QVh6Yy0glPIhHRsqbs0Ze8NhJWNkfVoddWBvhYYAUrsLEFivvOJVYj2s
         A7ikFWUAy52udEc9jU1yx56c4kB3kvauGK0OCHQ1kfXE6Y7fqfSTWgZzpZIty/Jm7D
         QXI0i/VumGbbLemp5fYlKOkBVKDVx+QB+5qs8UTH0BB1svbOQNiWbfZxdGLu8VuRai
         avVyRz1FWEGnw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id ad3c41fc;
        Mon, 10 Jan 2022 11:14:45 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     dhowells@redhat.com, v9fs-developer@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, lucho@ionkov.net, ericvh@gmail.com,
        Dominique Martinet <asmadeus@codewreck.org>,
        stable@vger.kernel.org
Subject: [PATCH] 9p: fix enodata when reading growing file
Date:   Mon, 10 Jan 2022 20:14:44 +0900
Message-Id: <20220110111444.926753-1-asmadeus@codewreck.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reading from a file that was just extended by a write, but the write had
not yet reached the server would return ENODATA as illustrated by this
command:
$ xfs_io -c 'open -ft test' -c 'w 4096 1000' -c 'r 0 1000'
wrote 1000/1000 bytes at offset 4096
1000.000000 bytes, 1 ops; 0.0001 sec (5.610 MiB/sec and 5882.3529 ops/sec)
pread: No data available

Fix this case by having netfs assume zeroes when reads from server come
short like AFS and CEPH do

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Co-authored-by: David Howells <dhowells@redhat.com>
Cc: stable@vger.kernel.org
---
 fs/9p/vfs_addr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index c72e9f8f5f32..9a10e68c5f30 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -43,6 +43,11 @@ static void v9fs_req_issue_op(struct netfs_read_subrequest *subreq)
 	iov_iter_xarray(&to, READ, &rreq->mapping->i_pages, pos, len);
 
 	total = p9_client_read(fid, pos, &to, &err);
+
+	/* if we just extended the file size, any portion not in
+	 * cache won't be on server and is zeroes */
+	__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
+
 	netfs_subreq_terminated(subreq, err ?: total, false);
 }
 
-- 
2.33.1

