Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA8348008D
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239997AbhL0PrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:47:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45566 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240308AbhL0PpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:45:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F7A8B810C6;
        Mon, 27 Dec 2021 15:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85894C36AEA;
        Mon, 27 Dec 2021 15:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619899;
        bh=rBkpXv8jPim6Hu8Lfagn0NCxZCy/3bBQYGIT73hTXV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Znl8bef+i2All3PLQPDwO/+39xmnHCGwIjjivh1Bc2J1Xya2/NwVCdTDxF99b1A3
         erRn63Cf+h+BdPT8uRcK9Y+4gng2LznQS7axWBTwCOnnIh9wEEsqrpABdHYKYHNj9a
         if1ox8mD7zR3Kayj0IaTdPecBsgaSSStQ+hSmauc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
        David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 5.15 108/128] netfs: fix parameter of cleanup()
Date:   Mon, 27 Dec 2021 16:31:23 +0100
Message-Id: <20211227151335.132174127@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffle Xu <jefflexu@linux.alibaba.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/read_helper.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
@@ -1185,7 +1185,7 @@ have_page:
 		goto error;
 have_page_no_wait:
 	if (netfs_priv)
-		ops->cleanup(netfs_priv, mapping);
+		ops->cleanup(mapping, netfs_priv);
 	*_page = page;
 	_leave(" = 0");
 	return 0;
@@ -1196,7 +1196,7 @@ error:
 	unlock_page(page);
 	put_page(page);
 	if (netfs_priv)
-		ops->cleanup(netfs_priv, mapping);
+		ops->cleanup(mapping, netfs_priv);
 	_leave(" = %d", ret);
 	return ret;
 }


