Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90FC014D73
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbfEFOsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:48:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729178AbfEFOsc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:48:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68A9A20C01;
        Mon,  6 May 2019 14:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154111;
        bh=p6RVOtZfYnh8+vutVexuQSUaNn8ATx66Mk/NyeUR5gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlrGXug/rXVYeU5FIYFpCbloHD7aZQtwrJce2SoMP5Y+qGtJNQvqFGQNyVbwh5ugo
         0zPNoRtMGPO1874BpRqRN1pcRTQ46UZmD97hGE0S5ZUA84bKyQRkLfP2IImmcPXdFS
         El06vZ7vMAWrWQykBVZdU7jKuSGA4iper7aHL3Bw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 09/62] kasan: turn on -fsanitize-address-use-after-scope
Date:   Mon,  6 May 2019 16:32:40 +0200
Message-Id: <20190506143051.888762392@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>

commit c5caf21ab0cf884ef15b25af234f620e4a233139 upstream.

In the upcoming gcc7 release, the -fsanitize=kernel-address option at
first implied new -fsanitize-address-use-after-scope option.  This would
cause link errors on older kernels because they don't have two new
functions required for use-after-scope support.  Therefore, gcc7 changed
default to -fno-sanitize-address-use-after-scope.

Now the kernel has everything required for that feature since commit
828347f8f9a5 ("kasan: support use-after-scope detection").  So, to make it
work, we just have to enable use-after-scope in CFLAGS.

Link: http://lkml.kernel.org/r/1481207977-28654-1-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/Makefile.kasan |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/Makefile.kasan
+++ b/scripts/Makefile.kasan
@@ -29,6 +29,8 @@ else
     endif
 endif
 
+CFLAGS_KASAN += $(call cc-option, -fsanitize-address-use-after-scope)
+
 CFLAGS_KASAN_NOSANITIZE := -fno-builtin
 
 endif


