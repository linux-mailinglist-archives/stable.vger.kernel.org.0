Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2FB907BD
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 20:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfHPSZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 14:25:40 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46222 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbfHPSZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 14:25:40 -0400
Received: by mail-pf1-f195.google.com with SMTP id q139so3494431pfc.13
        for <stable@vger.kernel.org>; Fri, 16 Aug 2019 11:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=ir1KQmZlPpKxgmGy2SCHqJx8IJOCdBb03vSVaXVXzEo=;
        b=ebt947S9nGw4npUaMGd+jLk2j1W8Ap4E0OuuCLsW8xD8bOO5TlFWizKMATW293hreq
         R5e7WB/VO8rgjEFmHwzGKX2fi11cDwK/2Nm1eO5PgUeQ5E0Whz3j3lzVImDBBdWHMqjL
         g0qZ8pmccOReGPUFMoP5Gjy8HDssIgAqckQew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ir1KQmZlPpKxgmGy2SCHqJx8IJOCdBb03vSVaXVXzEo=;
        b=I0CnCxD8CdHu4lR6xSc5GU1gd4oEMxcxPVf/nc6S/1w6cvWf9Hm0Gczg1IQEIh7+sl
         2TyyXf+5n6Qq1SiZzH5COfZ/Vb1tGSF2Rmj1dj8OR8aO6sVyvohujD2evftF3oHVai8H
         ZB3JF/cQPxZ4i4gHqu6ZLbYv3995CLWbXAslTPLyGqlXw41YURZb7gv1ykdWDvrBCvbZ
         JFXycrl6y+sdEMjMIcDNaIbQI9etcwXM3XnkR6dDkdhjQps5w65swntg7gbHTDxHIT9o
         jAgbHWoh86ZLJWnO4U7UbsUxk2pn7ofOOC+jWJ7t0qXHshHWc+18Xewz3YPe3CSTN0BM
         NrKg==
X-Gm-Message-State: APjAAAV73lgpbQTwAyoI9ZKR4lJwqnh4/aZ6s1pPkdHtSJ0ji8xKuGSg
        /TUP0NTNd9XitNeh45ugdMU10g==
X-Google-Smtp-Source: APXvYqzfqla125OTBU6edOHsNIdsHhsvDxa2f6BBQ95S9sRpL7je6UmW3cbv7YoBcl97C7yPp0KzPg==
X-Received: by 2002:a17:90a:8c06:: with SMTP id a6mr8772019pjo.45.1565979939872;
        Fri, 16 Aug 2019 11:25:39 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f12sm5983953pgo.85.2019.08.16.11.25.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Aug 2019 11:25:39 -0700 (PDT)
Date:   Fri, 16 Aug 2019 11:25:38 -0700
From:   Kees Cook <keescook@chromium.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trilok Soni <tsoni@codeaurora.org>
Subject: [PATCH -stable v4.9] mm/usercopy: use memory range to be accessed
 for wraparound check
Message-ID: <201908161125.7D5A0278@keescook>
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
[kees: backport to v4.9]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 mm/usercopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/usercopy.c b/mm/usercopy.c
index 3c8da0af9695..7683c22551ff 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -124,7 +124,7 @@ static inline const char *check_kernel_text_object(const void *ptr,
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
