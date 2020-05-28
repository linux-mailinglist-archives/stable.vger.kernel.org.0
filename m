Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D51D1E5669
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 07:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgE1FUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 01:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbgE1FUx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 01:20:53 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A54F4206F1;
        Thu, 28 May 2020 05:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590643253;
        bh=8F95w6NfYH4Aub7J6ainY1th9ClMvivYnWp8faYCQbE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=18RgYJlpK+mXG3ym1oOEanuO90hDfkritfzG84ckuzkpQL+2Fe9iO5dS1Z3SIizUj
         AnMFuzpkOSXQdoeD3ExTdB4RXZI89SSaeLY+s+VS6cO8q1MPNsUZ8TLTe+sNSIac5Y
         rcLjL1UuDY23JgXLTkXb5cqKr0wmbN+6+g7mcGzI=
Date:   Wed, 27 May 2020 22:20:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, glider@google.com,
        keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        sunhaoyl@outlook.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 4/5] fs/binfmt_elf.c: allocate initialized memory
 in fill_thread_core_info()
Message-ID: <20200528052052.tLpI_z4pp%akpm@linux-foundation.org>
In-Reply-To: <20200527222015.62ba8592af63dae12ab58ffe@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Potapenko <glider@google.com>
Subject: fs/binfmt_elf.c: allocate initialized memory in fill_thread_core_info()

KMSAN reported uninitialized data being written to disk when dumping core.
As a result, several kilobytes of kmalloc memory may be written to the
core file and then read by a non-privileged user.

Link: http://lkml.kernel.org/r/20200419100848.63472-1-glider@google.com
Link: https://github.com/google/kmsan/issues/76
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: sam <sunhaoyl@outlook.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/binfmt_elf.c~fs-binfmt_elfc-allocate-initialized-memory-in-fill_thread_core_info
+++ a/fs/binfmt_elf.c
@@ -1733,7 +1733,7 @@ static int fill_thread_core_info(struct
 		    (!regset->active || regset->active(t->task, regset) > 0)) {
 			int ret;
 			size_t size = regset_size(t->task, regset);
-			void *data = kmalloc(size, GFP_KERNEL);
+			void *data = kzalloc(size, GFP_KERNEL);
 			if (unlikely(!data))
 				return 0;
 			ret = regset->get(t->task, regset,
_
