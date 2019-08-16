Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1AF907AE
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 20:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfHPSYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 14:24:11 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38943 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfHPSYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 14:24:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id f17so3514819pfn.6
        for <stable@vger.kernel.org>; Fri, 16 Aug 2019 11:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=B8KseAa0jP9Z3aH6w0J06hZzkloTehnI7stgUVtKyPo=;
        b=m9mjaPNawzf2Rp1tzA3VU8kdpvfhrSTDcRrLwi9crZJy287BlsUYA+M9Geon3+T2y9
         8/wBWsspDRdY3ua1W5sV/99NXped450QBJvWLU2dXvAuATxARPcc538KUk0BIHKjNURl
         +PgkmT5uohXtBGE7wroioa0cmBK6evUjRQFMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=B8KseAa0jP9Z3aH6w0J06hZzkloTehnI7stgUVtKyPo=;
        b=azMLcSLSH57RRnrkJ+m30ZqGKTcVLfc0bz8+sP58bX+3fFsXT8bBisUzryaDc9oYq3
         8XbQZ6kAj9MM6NUQSF3P1I6yMorpCk1wv6pcx2H0NMgpbjl3IRK27/ZXLJwUD+ldsB2c
         pbdu7RYF5Bk/hb3dcEEfbYBqqPy9tbVj+CcbrYiqAwyNRwfUQP4zgwbWpEx2SAMQUnvC
         qUyKkBbCJ6CMHuuvoJ6D9LLxLaj0dSclYEx0ZES4PLx8SqZTa9kv1Ih0xCafakiea2Ll
         HVE10etz2F98z4YeSij+GQYKoiegpqMWDEzpjJXVxHyPI5Eo0QvGfYH7JJsY7ZAE/19t
         DYyA==
X-Gm-Message-State: APjAAAVnHZ78kg1x7juCfXzpkza1ethVrhNHpvzruyabxq3KtVHnbWHF
        UewO1ktEXvyHoheUQB69KxXH7w==
X-Google-Smtp-Source: APXvYqwgmPTXXbpT7tiRMvpi7OPqplMN+DHxlKDij9QL2sklReiAGcIR/BQEpR5BuFs1DJX4JfRuQg==
X-Received: by 2002:a63:1f1f:: with SMTP id f31mr8766291pgf.353.1565979850621;
        Fri, 16 Aug 2019 11:24:10 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y8sm9165480pfr.140.2019.08.16.11.24.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Aug 2019 11:24:09 -0700 (PDT)
Date:   Fri, 16 Aug 2019 11:24:08 -0700
From:   Kees Cook <keescook@chromium.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trilok Soni <tsoni@codeaurora.org>
Subject: [PATCH -stable v4.14] mm/usercopy: use memory range to be accessed
 for wraparound check
Message-ID: <201908161123.93DFEB96@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prasad Sodagudi <psodagud@codeaurora.org>

commit 951531691c4bcaa59f56a316e018bc2ff1ddf855 upstream.

Currently, when checking to see if accessing n bytes starting at address
"ptr" will cause a wraparound in the memory addresses, the check in
check_bogus_address() adds an extra byte, which is incorrect, as the
range of addresses that will be accessed is [ptr, ptr + (n - 1)].

This can lead to incorrectly detecting a wraparound in the memory
address, when trying to read 4 KB from memory that is mapped to the the
last possible page in the virtual address space, when in fact, accessing
that range of memory would not cause a wraparound to occur.

Use the memory range that will actually be accessed when considering if
accessing a certain amount of bytes will cause the memory address to
wrap around.

Link: http://lkml.kernel.org/r/1564509253-23287-1-git-send-email-isaacm@codeaurora.org
Fixes: f5509cc18daa ("mm: Hardened usercopy")
Signed-off-by: Prasad Sodagudi <psodagud@codeaurora.org>
Signed-off-by: Isaac J. Manjarres <isaacm@codeaurora.org>
Co-developed-by: Prasad Sodagudi <psodagud@codeaurora.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Trilok Soni <tsoni@codeaurora.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[kees: backport to v4.14]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 mm/usercopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/usercopy.c b/mm/usercopy.c
index a9852b24715d..975f7dff8059 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -121,7 +121,7 @@ static inline const char *check_kernel_text_object(const void *ptr,
 static inline const char *check_bogus_address(const void *ptr, unsigned long n)
 {
 	/* Reject if object wraps past end of memory. */
-	if ((unsigned long)ptr + n < (unsigned long)ptr)
+	if ((unsigned long)ptr + (n - 1) < (unsigned long)ptr)
 		return "<wrapped address>";
 
 	/* Reject if NULL or ZERO-allocation. */
-- 
2.17.1


-- 
Kees Cook
