Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6AD420ECD
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236455AbhJDN2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:28:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235497AbhJDN0l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:26:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 182B2611F0;
        Mon,  4 Oct 2021 13:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353099;
        bh=tMhuGDyBXUTtTuF1q8r60tAq+z3mz33pkCdv6gIUzps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2BIF4YDD3Iyd1Hlq9T2SG/kd4WvxLzshct+J4VxYmeyTwAvHlKX8bBQLQsDTcaWUh
         MlDT0WpKZoom8v5dRg1+KEiZ/Fl5/0866Jph8MmRlBH4Y89aQgVA8yVBMHpvd/oipN
         nSARVAvmmJ4Vh4TMJ818u2hozMuK100tRUGKzctU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 88/93] mm: dont allow oversized kvmalloc() calls
Date:   Mon,  4 Oct 2021 14:53:26 +0200
Message-Id: <20211004125037.510417247@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 7661809d493b426e979f39ab512e3adf41fbcc69 upstream.

'kvmalloc()' is a convenience function for people who want to do a
kmalloc() but fall back on vmalloc() if there aren't enough physically
contiguous pages, or if the allocation is larger than what kmalloc()
supports.

However, let's make sure it doesn't get _too_ easy to do crazy things
with it.  In particular, don't allow big allocations that could be due
to integer overflow or underflow.  So make sure the allocation size fits
in an 'int', to protect against trivial integer conversion issues.

Acked-by: Willy Tarreau <w@1wt.eu>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/util.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/util.c
+++ b/mm/util.c
@@ -581,6 +581,10 @@ void *kvmalloc_node(size_t size, gfp_t f
 	if (ret || size <= PAGE_SIZE)
 		return ret;
 
+	/* Don't even allow crazy sizes */
+	if (WARN_ON_ONCE(size > INT_MAX))
+		return NULL;
+
 	return __vmalloc_node(size, 1, flags, node,
 			__builtin_return_address(0));
 }


