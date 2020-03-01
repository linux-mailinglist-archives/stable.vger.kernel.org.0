Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5130174AB1
	for <lists+stable@lfdr.de>; Sun,  1 Mar 2020 02:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgCABwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 20:52:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbgCABwC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 Feb 2020 20:52:02 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 946E8214DB;
        Sun,  1 Mar 2020 01:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583027521;
        bh=gW+ceflL2NcxTAro1X3TiroKte/Ez+zVtxTCXyoOrnk=;
        h=Date:From:To:Subject:From;
        b=gdRs2cK7Hr4RiHedP7UVjCMM0IcqyxqWu7RCPxX2guOvRRtgmLK3a+ciS+b7mTz7Z
         XZcHUY9xaa6l7gROju5BmPeVm6dM2vlbLPbD3WajqCZxoaqX1fPQNHD9Grgnz6hzTZ
         Cq3l6bsCK5YoywZmZNx164wWfegYZLmC5X9GefKY=
Date:   Sat, 29 Feb 2020 17:52:01 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, fengc@google.com, ghackmann@google.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        sumit.semwal@linaro.org, xiyou.wangcong@gmail.com
Subject:  [merged]
 dma-buf-free-dmabuf-name-in-dma_buf_release.patch removed from -mm tree
Message-ID: <20200301015201.JcACTR4Xk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: dma-buf: free dmabuf->name in dma_buf_release()
has been removed from the -mm tree.  Its filename was
     dma-buf-free-dmabuf-name-in-dma_buf_release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: dma-buf: free dmabuf->name in dma_buf_release()

dma-buff name can be set via DMA_BUF_SET_NAME ioctl, but once set
it never gets freed.

Free it in dma_buf_release().

Link: http://lkml.kernel.org/r/20200225204446.11378-1-xiyou.wangcong@gmail.com
Fixes: bb2bb9030425 ("dma-buf: add DMA_BUF_SET_NAME ioctls")
Reported-by: syzbot+b2098bc44728a4efb3e9@syzkaller.appspotmail.com
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Chenbo Feng <fengc@google.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg Hackmann <ghackmann@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma-buf/dma-buf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/dma-buf/dma-buf.c~dma-buf-free-dmabuf-name-in-dma_buf_release
+++ a/drivers/dma-buf/dma-buf.c
@@ -108,6 +108,7 @@ static int dma_buf_release(struct inode
 		dma_resv_fini(dmabuf->resv);
 
 	module_put(dmabuf->owner);
+	kfree(dmabuf->name);
 	kfree(dmabuf);
 	return 0;
 }
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are


