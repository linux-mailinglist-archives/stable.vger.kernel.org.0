Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1319238381A
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbhEQPsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245560AbhEQPqf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:46:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08C5461D36;
        Mon, 17 May 2021 14:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262672;
        bh=LFIUclFMsfiLUsrfN44xqGsqkeryLjlmO8+A8VFMcnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EACZDyIauegCLL1ydZqAvY8yU0L64WfYr46vrmz6M3AhJflBxotl01iDFCs21tlAz
         6qAZL3SGtiQMFIkY9d3zQEhCZqknx/I877f7aEItuRvXWLp8vzDiwjT264UiLAB9as
         T78uxNQi1nuQGQqvabP9C5R5D/yKTohrXjHWFRBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Juergen Gross <jgross@suse.com>,
        Luca Fancellu <luca.fancellu@arm.com>
Subject: [PATCH 5.10 255/289] xen/gntdev: fix gntdev_mmap() error exit path
Date:   Mon, 17 May 2021 16:03:00 +0200
Message-Id: <20210517140313.732166062@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 970655aa9b42461f8394e4457307005bdeee14d9 upstream.

Commit d3eeb1d77c5d0af ("xen/gntdev: use mmu_interval_notifier_insert")
introduced an error in gntdev_mmap(): in case the call of
mmu_interval_notifier_insert_locked() fails the exit path should not
call mmu_interval_notifier_remove(), as this might result in NULL
dereferences.

One reason for failure is e.g. a signal pending for the running
process.

Fixes: d3eeb1d77c5d0af ("xen/gntdev: use mmu_interval_notifier_insert")
Cc: stable@vger.kernel.org
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Luca Fancellu <luca.fancellu@arm.com>
Link: https://lore.kernel.org/r/20210423054038.26696-1-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/gntdev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -1005,8 +1005,10 @@ static int gntdev_mmap(struct file *flip
 		err = mmu_interval_notifier_insert_locked(
 			&map->notifier, vma->vm_mm, vma->vm_start,
 			vma->vm_end - vma->vm_start, &gntdev_mmu_ops);
-		if (err)
+		if (err) {
+			map->vma = NULL;
 			goto out_unlock_put;
+		}
 	}
 	mutex_unlock(&priv->lock);
 


