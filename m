Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B851B1996
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 00:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgDTWeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 18:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbgDTWeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 18:34:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5791E20857;
        Mon, 20 Apr 2020 22:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587422062;
        bh=6bRiUbt3P8T/tirNlpibkPN7iK7vpqpbiDLpAriVa40=;
        h=Date:From:To:Subject:From;
        b=OWfcF4OXQ6DNfwBAmjz8YICnq3rt8MqUnzoG8/RuymMWcnV3MjhYu8JA7bpBTP1yx
         fkfyWXqgOlpuQS7SvEjJ8a26c9wTLQw8ks5x2s9xLRgDl7giiaXOxY0NSUyTK4mVUs
         3dxxqBxKy3FEnOCQl/UEYENjYLq9ZecbXHSyLr+4=
Date:   Mon, 20 Apr 2020 15:34:21 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, glider@google.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        sunhaoyl@outlook.com
Subject:  +
 fs-binfmt_elfc-allocate-initialized-memory-in-fill_thread_core_info.patch
 added to -mm tree
Message-ID: <20200420223421.T8-AeZhcC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf.c: allocate initialized memory in fill_thread_core_info()
has been added to the -mm tree.  Its filename is
     fs-binfmt_elfc-allocate-initialized-memory-in-fill_thread_core_info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-binfmt_elfc-allocate-initialized-memory-in-fill_thread_core_info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-binfmt_elfc-allocate-initialized-memory-in-fill_thread_core_info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: fs/binfmt_elf.c: allocate initialized memory in fill_thread_core_info()

KMSAN reported uninitialized data being written to disk when dumping core.
As a result, several kilobytes of kmalloc memory may be written to the
core file and then read by a non-privileged user.

Link: http://lkml.kernel.org/r/20200419100848.63472-1-glider@google.com
Link: https://github.com/google/kmsan/issues/76
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: sam <sunhaoyl@outlook.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
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

Patches currently in -mm which might be from glider@google.com are

fs-binfmt_elfc-allocate-initialized-memory-in-fill_thread_core_info.patch

