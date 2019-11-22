Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 483CD106F41
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730216AbfKVKxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:53:32 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40975 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730212AbfKVKxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:53:32 -0500
Received: by mail-wr1-f65.google.com with SMTP id b18so8033910wrj.8
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=EwOfwwiNckMuQzPVj8mAR4X16hKKAPeuk3yKLlec5YI=;
        b=XFjik6/1F5q/FGsLPzqx/WRNDDqb1Faj6Ianja2u99UxfAsl/WnAdQ9xhIVH6MzGTF
         JLUl3+TddRPpfgV04UK8uMETkYrgrayOWSWFbQKXbXVgKlVzYODlLllbDIn5pHI7c9oe
         sOkNvkge+4WwSw4pgriiWN1Rk15xZ3wdRt4XyhEwFtBOY+XFdDZckS2E4p2vjuVRwAWo
         7UwIPECGHAif1f/3TuIlc/le5fA12pp+K2GM4xE3he/uEyb/K7+96osTjuA/Gvo6WRQf
         er/JgLv0JbJVUIG3fw8rEd+wyu22zefI9IWY5UGCH2McjnIWPfUqZQYxKtFoD/hg/CXx
         uEPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EwOfwwiNckMuQzPVj8mAR4X16hKKAPeuk3yKLlec5YI=;
        b=KHg//EYXlU6WvjYWZLyEDTyMvB71R4SwueVY7POuf2qv3GBHbPvn+OpFBsgnJqq6ka
         5viGqQCFWmDf1+v3LO1QR69GK/8z7dDEAMG5Wjk/J4xC6Y/srN0pz2REg0L9KbtlSVAm
         zYI8hLH7oVzAjj9lhrs4C04wrt/hhLG1hOi6O8/d2shF+Tyj5AElSRJ5+q9NjFQSqfDJ
         TuzIO49kg7JeTqZ0ygZHkIg9IQpBBnhTkB+V7o/ngBeNVUOwReVRXAncLJx11ZzDjPE9
         jL3RwEIaGaecHSVICT5HxCQbNKNmzyGXS9EecM7ocF7FwPeP/I+l975tspQWXocknykt
         8Tpw==
X-Gm-Message-State: APjAAAW8EjVJKWpHMvlGJDJjZfKmtJyWNTF9gKog8mY5F9XVHcVfBKMc
        bX5xtc+Rnj8N+9oX4KGx71/l/wkY+HM=
X-Google-Smtp-Source: APXvYqygi/D/gXEtBe8E7AfxFCtIdtBoM6tbvmQBBH3sHPMYkm+sEWnzR0JmD3f+R0abR1Uzhiuw4w==
X-Received: by 2002:a5d:4946:: with SMTP id r6mr9412090wrs.155.1574420010516;
        Fri, 22 Nov 2019 02:53:30 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id o1sm7444087wrs.50.2019.11.22.02.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:53:29 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 4.9 6/8] dm: use blk_set_queue_dying() in __dm_destroy()
Date:   Fri, 22 Nov 2019 10:52:51 +0000
Message-Id: <20191122105253.11375-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122105253.11375-1-lee.jones@linaro.org>
References: <20191122105253.11375-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bart.vanassche@sandisk.com>

[ Upstream commit 2e91c3694181dc500faffec16c5aaa0ac5e15449 ]

After QUEUE_FLAG_DYING has been set any code that is waiting in
get_request() should be woken up.  But to get this behaviour
blk_set_queue_dying() must be used instead of only setting
QUEUE_FLAG_DYING.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/md/dm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2ffe7db75acb..36e6221fabab 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1946,9 +1946,7 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 	set_bit(DMF_FREEING, &md->flags);
 	spin_unlock(&_minor_lock);
 
-	spin_lock_irq(q->queue_lock);
-	queue_flag_set(QUEUE_FLAG_DYING, q);
-	spin_unlock_irq(q->queue_lock);
+	blk_set_queue_dying(q);
 
 	if (dm_request_based(md) && md->kworker_task)
 		kthread_flush_worker(&md->kworker);
-- 
2.24.0

