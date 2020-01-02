Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8922912EC5C
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgABWRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:17:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728112AbgABWRm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:17:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B22B21582;
        Thu,  2 Jan 2020 22:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003461;
        bh=cDGxvQ6VaN64SpWCnKdSQZiZKTB9gPZsUPK1SbMRtkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTpqaWOJ8DgZv5dypiPatNiT5Ae+fx0Dn+wikmJdgEAz6m/FTyCoxnEPI1jObwl5Y
         KEkh8Xds2tdajJlEQOdx9htnaqPzWSYb6Rzn0qwCsifLqo+mBUIbsz9llBUIYkc6oA
         70+AC8/45q60riHyBi39k3VRmUhHqQJgEE2bncds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 144/191] uaccess: disallow > INT_MAX copy sizes
Date:   Thu,  2 Jan 2020 23:07:06 +0100
Message-Id: <20200102215844.953035794@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 6d13de1489b6bf539695f96d945de3860e6d5e17 upstream.

As we've done with VFS, string operations, etc, reject usercopy sizes
larger than INT_MAX, which would be nice to have for catching bugs
related to size calculation overflows[1].

This adds 10 bytes to x86_64 defconfig text and 1980 bytes to the data
section:

     text    data     bss     dec     hex filename
  19691167        5134320 1646664 26472151        193eed7 vmlinux.before
  19691177        5136300 1646664 26474141        193f69d vmlinux.after

[1] https://marc.info/?l=linux-s390&m=156631939010493&w=2

Link: http://lkml.kernel.org/r/201908251612.F9902D7A@keescook
Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/thread_info.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -147,6 +147,8 @@ check_copy_size(const void *addr, size_t
 			__bad_copy_to();
 		return false;
 	}
+	if (WARN_ON_ONCE(bytes > INT_MAX))
+		return false;
 	check_object_size(addr, bytes, is_source);
 	return true;
 }


