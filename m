Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394EB29AE31
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 14:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752961AbgJ0N5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752955AbgJ0N5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:57:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 601112072D;
        Tue, 27 Oct 2020 13:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807070;
        bh=v8P6ZSRKnnsELgim7giWIaierPdmu0FAQLMPvm0bIjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CdOLkOLzuUi5TPFQ5jC5G3/9uJCG7h7cH0zAAqko3wdrTN+ISnyCFZGU/sl4vBnsE
         nk6Y9Na69QOC0BumZpX6tW8d1WndPJbb+JO2CeGD+4BqzmnFIA8h7QwrqxRHcq19gC
         hiiWw20ktbibb22/+4ahYt7whDmW4JwDwJI2LSCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 009/112] compiler.h: Add read_word_at_a_time() function.
Date:   Tue, 27 Oct 2020 14:48:39 +0100
Message-Id: <20201027134900.991495979@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>

commit 7f1e541fc8d57a143dd5df1d0a1276046e08c083 upstream.

Sometimes we know that it's safe to do potentially out-of-bounds access
because we know it won't cross a page boundary.  Still, KASAN will
report this as a bug.

Add read_word_at_a_time() function which is supposed to be used in such
cases.  In read_word_at_a_time() KASAN performs relaxed check - only the
first byte of access is validated.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -292,6 +292,7 @@ static __always_inline void __write_once
  * with an explicit memory barrier or atomic instruction that provides the
  * required ordering.
  */
+#include <linux/kasan-checks.h>
 
 #define __READ_ONCE(x, check)						\
 ({									\
@@ -310,6 +311,13 @@ static __always_inline void __write_once
  */
 #define READ_ONCE_NOCHECK(x) __READ_ONCE(x, 0)
 
+static __no_kasan_or_inline
+unsigned long read_word_at_a_time(const void *addr)
+{
+	kasan_check_read(addr, 1);
+	return *(unsigned long *)addr;
+}
+
 #define WRITE_ONCE(x, val) \
 ({							\
 	union { typeof(x) __val; char __c[1]; } __u =	\


