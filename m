Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5597F3D431E
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 00:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbhGWWKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 18:10:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233064AbhGWWKQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Jul 2021 18:10:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5677460EB5;
        Fri, 23 Jul 2021 22:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627080645;
        bh=5JUSCAQlPFtlAg3XzVomObTQ+RoMD50OOdwH73RgAvI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZtMY1iwyBR8rrR486460lmnTzE7qwHaJbQ/XhIICqNQ1VIc9dyiUOH+UZ40jFODIa
         RZT6JP3GwcnJscD8pBQEWXbMjYmlmOe2IthyPtQZzO8wYzFat27jL4WW0sHtooZ947
         H2eJTfumbtqhS1B9dY/XpBy/MQerfZvRbfCWcpUQ=
Date:   Fri, 23 Jul 2021 15:50:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bugs+kernel.org@dtnr.ch,
        dhowells@redhat.com, linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [patch 15/15] hugetlbfs: fix mount mode command line
 processing
Message-ID: <20210723225044.DpiHGbzxj%akpm@linux-foundation.org>
In-Reply-To: <20210723154926.c6cda0f262b1990b950a5886@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: fix mount mode command line processing

In commit 32021982a324 ("hugetlbfs: Convert to fs_context") processing of
the mount mode string was changed from match_octal() to fsparam_u32.  This
changed existing behavior as match_octal does not require octal values to
have a '0' prefix, but fsparam_u32 does.

Use fsparam_u32oct which provides the same behavior as match_octal.

Link: https://lkml.kernel.org/r/20210721183326.102716-1-mike.kravetz@oracle.com
Fixes: 32021982a324 ("hugetlbfs: Convert to fs_context")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Dennis Camera <bugs+kernel.org@dtnr.ch>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-fix-mount-mode-command-line-processing
+++ a/fs/hugetlbfs/inode.c
@@ -77,7 +77,7 @@ enum hugetlb_param {
 static const struct fs_parameter_spec hugetlb_fs_parameters[] = {
 	fsparam_u32   ("gid",		Opt_gid),
 	fsparam_string("min_size",	Opt_min_size),
-	fsparam_u32   ("mode",		Opt_mode),
+	fsparam_u32oct("mode",		Opt_mode),
 	fsparam_string("nr_inodes",	Opt_nr_inodes),
 	fsparam_string("pagesize",	Opt_pagesize),
 	fsparam_string("size",		Opt_size),
_
