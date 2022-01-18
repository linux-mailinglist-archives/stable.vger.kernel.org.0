Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0D6492AA5
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244077AbiARQMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:12:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41722 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346887AbiARQKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:10:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 916DD61330;
        Tue, 18 Jan 2022 16:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B0AC00446;
        Tue, 18 Jan 2022 16:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522240;
        bh=C5aujnFJ1NRiwxgdObOzedAoYWgfCW1MQquWKOgJ0yI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hxAwAvvFCTex9KM5f4pcZe2zJbS+7bI2q/lNNjXYEBSj59SMDFgnIAdVQ8mXlmN42
         nnOO2dTV4N0p2N6cOzoQfmTL6LyWKurunwiEs/jKmZVI2zicFFTb6bQzPRUSaw/KNG
         VYsUykYtgCFRKjVOECm9Plm0LVkt/nTVVnvUuC/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 5.16 14/28] 9p: fix enodata when reading growing file
Date:   Tue, 18 Jan 2022 17:06:09 +0100
Message-Id: <20220118160452.878838210@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160452.384322748@linuxfoundation.org>
References: <20220118160452.384322748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominique Martinet <asmadeus@codewreck.org>

commit 19d1c32652bbbf406063025354845fdddbcecd3a upstream.

Reading from a file that was just extended by a write, but the write had
not yet reached the server would return ENODATA as illustrated by this
command:
$ xfs_io -c 'open -ft test' -c 'w 4096 1000' -c 'r 0 1000'
wrote 1000/1000 bytes at offset 4096
1000.000000 bytes, 1 ops; 0.0001 sec (5.610 MiB/sec and 5882.3529 ops/sec)
pread: No data available

Fix this case by having netfs assume zeroes when reads from server come
short like AFS and CEPH do

Link: https://lkml.kernel.org/r/20220110111444.926753-1-asmadeus@codewreck.org
Cc: stable@vger.kernel.org
Fixes: eb497943fa21 ("9p: Convert to using the netfs helper lib to do reads and caching")
Co-authored-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Tested-by: David Howells <dhowells@redhat.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_addr.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -42,6 +42,11 @@ static void v9fs_req_issue_op(struct net
 	iov_iter_xarray(&to, READ, &rreq->mapping->i_pages, pos, len);
 
 	total = p9_client_read(fid, pos, &to, &err);
+
+	/* if we just extended the file size, any portion not in
+	 * cache won't be on server and is zeroes */
+	__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
+
 	netfs_subreq_terminated(subreq, err ?: total, false);
 }
 


