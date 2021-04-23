Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BFB368CD1
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 07:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhDWFlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 01:41:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:47056 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229456AbhDWFlR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 01:41:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619156440; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NZgPMke49PfmASyT+K1h7cCq8emc+deK1BAEsqWaEPw=;
        b=nTAr2IN5DBYPkCFqqq+eLwiXMbbGmun0odKrA+jJl9NkITBehpkoRHRYzfVNtvBzmoeuIx
        uYmVjrOyOHPTYfbyo4bnoAYOUgajPgFeLwqQQW5KmbeogJnwctPoA7R3s8xLQFI1UgkAWo
        bsa7Mo+q2jzxdBaftOmifhikTfSdt7I=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 900A8AEFF;
        Fri, 23 Apr 2021 05:40:40 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Subject: [PATCH] xen/gntdev: fix gntdev_mmap() error exit path
Date:   Fri, 23 Apr 2021 07:40:38 +0200
Message-Id: <20210423054038.26696-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/xen/gntdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index f01d58c7a042..a3e7be96527d 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -1017,8 +1017,10 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
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
 
-- 
2.26.2

