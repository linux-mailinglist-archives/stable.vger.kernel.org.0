Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6724543A17F
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236067AbhJYTjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:39:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236894AbhJYTgb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:36:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE1206103C;
        Mon, 25 Oct 2021 19:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190395;
        bh=dXuBBqV6tkY02y5+kFPTAXc3Q0eJgvOamQXA7aUtWAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oNya6fIWjc8MG8e6S2xX4yxof8Qyo7UoGvINGJIKOxbdQPjg1LkU6Mz74/MJ8+AqH
         b8lmVvhq0giPiyL0uMjXJcMnfuUGI10dAVvYtjwCp3vIyqtn5T5LvII0UGawwczqk7
         NLKCoDN6srBaUJ8/UcOvJYM3AIQvhDdbgknxXBtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Li Wang <liwang@redhat.com>, Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 47/95] userfaultfd: fix a race between writeprotect and exit_mmap()
Date:   Mon, 25 Oct 2021 21:14:44 +0200
Message-Id: <20211025191003.451892422@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

commit cb185d5f1ebf900f4ae3bf84cee212e6dd035aca upstream.

A race is possible when a process exits, its VMAs are removed by
exit_mmap() and at the same time userfaultfd_writeprotect() is called.

The race was detected by KASAN on a development kernel, but it appears
to be possible on vanilla kernels as well.

Use mmget_not_zero() to prevent the race as done in other userfaultfd
operations.

Link: https://lkml.kernel.org/r/20210921200247.25749-1-namit@vmware.com
Fixes: 63b2d4174c4ad ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Signed-off-by: Nadav Amit <namit@vmware.com>
Tested-by: Li  Wang <liwang@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/userfaultfd.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1794,9 +1794,15 @@ static int userfaultfd_writeprotect(stru
 	if (mode_wp && mode_dontwake)
 		return -EINVAL;
 
-	ret = mwriteprotect_range(ctx->mm, uffdio_wp.range.start,
-				  uffdio_wp.range.len, mode_wp,
-				  &ctx->mmap_changing);
+	if (mmget_not_zero(ctx->mm)) {
+		ret = mwriteprotect_range(ctx->mm, uffdio_wp.range.start,
+					  uffdio_wp.range.len, mode_wp,
+					  &ctx->mmap_changing);
+		mmput(ctx->mm);
+	} else {
+		return -ESRCH;
+	}
+
 	if (ret)
 		return ret;
 


