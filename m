Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DD743A307
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235490AbhJYTzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236789AbhJYTtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:49:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E9BC61247;
        Mon, 25 Oct 2021 19:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190903;
        bh=t1Gycd020CfYNxPxWwT1r/i5yG/k7GbSWh4GVBNXRWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHon48HZLHX4dGaQO0e6EJSJyA3S2AJxdV8r8JX/83e+yE+qsDxz1s4nOb0cQwDbE
         yTa28DQ6F+qAwoePMJQXALPwzE7q5uTEmW3oMe6ScvTlOdGAeJFsCDQ7JyqHtWhf3K
         xr0Yl5nplC2girbm0N4UFMO+zneoJ4Phk3YnX/Tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Li Wang <liwang@redhat.com>, Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.14 081/169] userfaultfd: fix a race between writeprotect and exit_mmap()
Date:   Mon, 25 Oct 2021 21:14:22 +0200
Message-Id: <20211025191027.587825008@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
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
@@ -1826,9 +1826,15 @@ static int userfaultfd_writeprotect(stru
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
 


