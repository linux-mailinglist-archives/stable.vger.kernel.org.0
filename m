Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E782A46FF70
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 12:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhLJLKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 06:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbhLJLKx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 06:10:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89489C0617A2
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 03:07:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA0C7B8275D
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 11:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FEDC00446;
        Fri, 10 Dec 2021 11:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639134435;
        bh=LlMLdZUXH0xFuEDrcHg73XMDjMmWrKhhPORUGMq0zrs=;
        h=Subject:To:Cc:From:Date:From;
        b=hqptl1FSENiEpHl/z7Zt+0LJo20PN/ZIY1Iag95fG/pKOUSBJPnC8FLtrZbPWDuZE
         usxyQyyoPjzipExw6BNAOfMmCd+SIaf8UlC+uR3AS7lxY0RWKnNCIBgIwp1o6xAM4u
         tYocytIiEN2yRAytbZA5FEMctI1719e/+px3ilA8=
Subject: FAILED: patch "[PATCH] netfs: fix parameter of cleanup()" failed to apply to 5.15-stable tree
To:     jefflexu@linux.alibaba.com, dhowells@redhat.com, jlayton@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Dec 2021 12:07:13 +0100
Message-ID: <163913443334205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3cfef1b612e15a0c2f5b1c9d3f3f31ad72d56fcd Mon Sep 17 00:00:00 2001
From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Tue, 7 Dec 2021 11:14:49 +0800
Subject: [PATCH] netfs: fix parameter of cleanup()

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

diff --git a/fs/netfs/read_helper.c b/fs/netfs/read_helper.c
index 7c6e199618af..75c76cbb27cc 100644
--- a/fs/netfs/read_helper.c
+++ b/fs/netfs/read_helper.c
@@ -955,7 +955,7 @@ int netfs_readpage(struct file *file,
 	rreq = netfs_alloc_read_request(ops, netfs_priv, file);
 	if (!rreq) {
 		if (netfs_priv)
-			ops->cleanup(netfs_priv, folio_file_mapping(folio));
+			ops->cleanup(folio_file_mapping(folio), netfs_priv);
 		folio_unlock(folio);
 		return -ENOMEM;
 	}
@@ -1186,7 +1186,7 @@ int netfs_write_begin(struct file *file, struct address_space *mapping,
 		goto error;
 have_folio_no_wait:
 	if (netfs_priv)
-		ops->cleanup(netfs_priv, mapping);
+		ops->cleanup(mapping, netfs_priv);
 	*_folio = folio;
 	_leave(" = 0");
 	return 0;
@@ -1197,7 +1197,7 @@ int netfs_write_begin(struct file *file, struct address_space *mapping,
 	folio_unlock(folio);
 	folio_put(folio);
 	if (netfs_priv)
-		ops->cleanup(netfs_priv, mapping);
+		ops->cleanup(mapping, netfs_priv);
 	_leave(" = %d", ret);
 	return ret;
 }

