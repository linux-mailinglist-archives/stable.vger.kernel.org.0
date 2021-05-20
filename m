Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E9038A2B2
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhETJo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233358AbhETJmS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:42:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 920A0613E3;
        Thu, 20 May 2021 09:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503142;
        bh=ReUvWNaX+2lv9IU0ids6Ske0WYXr9DTwvJK8sogaDjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y27+b0wxeiGYBAs5ISRkRTfAvWt2f8OnnXkzbnQIAkKSEZNN4ZV6jF8B/jIgZv4co
         ekDD9cAGYzy+WwWUZPZCTLUNjlUdNVwYK8ALjMjiR1n/slUHngU2uW8aKiUFO3SU3U
         6mpDljOKTluOZKV1yV04PGeQtpXanuExaZw7MmNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.19 088/425] NFS: Dont discard pNFS layout segments that are marked for return
Date:   Thu, 20 May 2021 11:17:37 +0200
Message-Id: <20210520092134.339969777@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 39fd01863616964f009599e50ca5c6ea9ebf88d6 upstream.

If the pNFS layout segment is marked with the NFS_LSEG_LAYOUTRETURN
flag, then the assumption is that it has some reporting requirement
to perform through a layoutreturn (e.g. flexfiles layout stats or error
information).

Fixes: e0b7d420f72a ("pNFS: Don't discard layout segments that are marked for return")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pnfs.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2359,6 +2359,9 @@ pnfs_mark_matching_lsegs_return(struct p
 
 	assert_spin_locked(&lo->plh_inode->i_lock);
 
+	if (test_bit(NFS_LAYOUT_RETURN_REQUESTED, &lo->plh_flags))
+		tmp_list = &lo->plh_return_segs;
+
 	list_for_each_entry_safe(lseg, next, &lo->plh_segs, pls_list)
 		if (pnfs_match_lseg_recall(lseg, return_range, seq)) {
 			dprintk("%s: marking lseg %p iomode %d "
@@ -2366,6 +2369,8 @@ pnfs_mark_matching_lsegs_return(struct p
 				lseg, lseg->pls_range.iomode,
 				lseg->pls_range.offset,
 				lseg->pls_range.length);
+			if (test_bit(NFS_LSEG_LAYOUTRETURN, &lseg->pls_flags))
+				tmp_list = &lo->plh_return_segs;
 			if (mark_lseg_invalid(lseg, tmp_list))
 				continue;
 			remaining++;


