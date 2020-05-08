Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5091CAC84
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbgEHMyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:54:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730149AbgEHMyB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:54:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A183524967;
        Fri,  8 May 2020 12:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942441;
        bh=f0xr2TAEkyL4kye8GmlZwNW+yvmgzpgCK7AqH3ydBQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rc0qYP6qoegmrh/wKpNEfeGKdZwm4XHdJhectAjOA6mbucznc1qVowYJBQxfHgYr3
         AtIj/1PQ1BFdxAuEnDjv6z9CjNlA+cMS7rmhafWi+Vo25zJHI/Kyr69czfTT8Gaao6
         vd5igqx27cdJki7omZKWVtUlPTfvKy6PclBKrKaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.4 46/50] mm/mremap: Add comment explaining the untagging behaviour of mremap()
Date:   Fri,  8 May 2020 14:35:52 +0200
Message-Id: <20200508123049.388415423@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123043.085296641@linuxfoundation.org>
References: <20200508123043.085296641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit b2a84de2a2deb76a6a51609845341f508c518c03 upstream.

Commit dcde237319e6 ("mm: Avoid creating virtual address aliases in
brk()/mmap()/mremap()") changed mremap() so that only the 'old' address
is untagged, leaving the 'new' address in the form it was passed from
userspace. This prevents the unexpected creation of aliasing virtual
mappings in userspace, but looks a bit odd when you read the code.

Add a comment justifying the untagging behaviour in mremap().

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mremap.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -606,6 +606,16 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	LIST_HEAD(uf_unmap_early);
 	LIST_HEAD(uf_unmap);
 
+	/*
+	 * There is a deliberate asymmetry here: we strip the pointer tag
+	 * from the old address but leave the new address alone. This is
+	 * for consistency with mmap(), where we prevent the creation of
+	 * aliasing mappings in userspace by leaving the tag bits of the
+	 * mapping address intact. A non-zero tag will cause the subsequent
+	 * range checks to reject the address as invalid.
+	 *
+	 * See Documentation/arm64/tagged-address-abi.rst for more information.
+	 */
 	addr = untagged_addr(addr);
 
 	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE))


