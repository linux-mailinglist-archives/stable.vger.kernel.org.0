Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F1D3D6264
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbhGZPfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236439AbhGZPfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:35:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99913604AC;
        Mon, 26 Jul 2021 16:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316133;
        bh=PhzJGdhL7Hu80EXFKI9ArmLHQ6kkVInTkBciICfisWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NRou4r44zGhWvskRDotCkzZ9zOvWYOcRNhmO3xTSOoXHpwGreWCqvyTvHjmXItxR6
         V/M4OZN45ZV95RAmi7g5pKNonA1rjIyFNPHVxKmXyvf6Ka69fVuIMwYxTjGbAkbwMK
         6oSld4Gfrg5dEUPmZ43buu2OZJROS5eCV3J6sbuA=
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
Subject: [PATCH 5.13 202/223] hugetlbfs: fix mount mode command line processing
Date:   Mon, 26 Jul 2021 17:39:54 +0200
Message-Id: <20210726153852.803630064@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
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
@@ -77,7 +77,7 @@ enum hugetlb_param {
 static const struct fs_parameter_spec hugetlb_fs_parameters[] = {
 	fsparam_u32   ("gid",		Opt_gid),
 	fsparam_string("min_size",	Opt_min_size),
-	fsparam_u32   ("mode",		Opt_mode),
+	fsparam_u32oct("mode",		Opt_mode),
 	fsparam_string("nr_inodes",	Opt_nr_inodes),
 	fsparam_string("pagesize",	Opt_pagesize),
 	fsparam_string("size",		Opt_size),


