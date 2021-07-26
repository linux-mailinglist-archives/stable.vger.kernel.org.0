Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DB33D5FD2
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbhGZPTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:19:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236514AbhGZPSv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:18:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2052E60FA0;
        Mon, 26 Jul 2021 15:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315160;
        bh=6tdVmc8+k5o5n29AgJThLPgZtvTBGjpXIogXodbu0IA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1Tu9SvC1z2Zq7AHek2u3EAnNrPEFXSGRbhBidqxQ4EGYuQAWrs5+CHUblfHFQwck
         tyogpx3wqUCgAUnhFD4bXGkVQ43kZx+kvPOLLD/3S5NagIf63K+q8Zb8TpVvo0jvvD
         waJj772t2azUeG98I38uy+IUkvqTbulKJpO/46hA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Kravetz <mike.kravetz@oracle.com>,
        Dennis Camera <bugs+kernel.org@dtnr.ch>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 096/108] hugetlbfs: fix mount mode command line processing
Date:   Mon, 26 Jul 2021 17:39:37 +0200
Message-Id: <20210726153834.762076100@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit e0f7e2b2f7e7864238a4eea05cc77ae1be2bf784 upstream.

In commit 32021982a324 ("hugetlbfs: Convert to fs_context") processing
of the mount mode string was changed from match_octal() to fsparam_u32.

This changed existing behavior as match_octal does not require octal
values to have a '0' prefix, but fsparam_u32 does.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -76,7 +76,7 @@ enum hugetlb_param {
 static const struct fs_parameter_spec hugetlb_param_specs[] = {
 	fsparam_u32   ("gid",		Opt_gid),
 	fsparam_string("min_size",	Opt_min_size),
-	fsparam_u32   ("mode",		Opt_mode),
+	fsparam_u32oct("mode",		Opt_mode),
 	fsparam_string("nr_inodes",	Opt_nr_inodes),
 	fsparam_string("pagesize",	Opt_pagesize),
 	fsparam_string("size",		Opt_size),


