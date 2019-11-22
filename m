Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2E75106C63
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbfKVKvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:51:43 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37250 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730100AbfKVKvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:51:43 -0500
Received: by mail-wm1-f66.google.com with SMTP id f129so5706519wmf.2
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3e3k1oohMwi/CIBzV4BTFHUMYD58PCHmDDNOIUgpFX8=;
        b=a+S6XuN6DLpHQmyuKX87vN0F4OV+FjAfy2BG0BOQyhpiTyPVCs+b2ocA7lPK6xouDZ
         ZajotSTaPKx3LcttuXSt2OqYJmXD/N6K649gRa/kVR+XSXDoLN0VE15TXxscNh0RBtf3
         62nJEHwnXUx6MaHsIpLY2ikzIlGtIxCp2/sDs3T4iHQ2lVUWlZB8uPjN51DQGSybt9b9
         2cGXMd30cZFAzVKZQLSSlWu8dysm/oI8sHCCA3nJMRCM3kZF6+4C/zYUl2IiLpQ5YheB
         LtNWHPggcHDCjrqkPPKp4sCYXA9cwXya36dnT08dG5uztxfg3/WlyttNi+U/UyB8MyYY
         e1Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3e3k1oohMwi/CIBzV4BTFHUMYD58PCHmDDNOIUgpFX8=;
        b=Uo0fhqhbqscohMK7cSIuAqKdhG3TLP2+p/IxSWj2G5BSWrb6ab2GPKGfZVe5aiX43G
         n9CRd0efGcP0XYlFkeo4J8KqjAX3rRpow+DUgWFslfIwGvY+GhhmmNcF9+IWMHaW7l3K
         WPR6GBbyyTgY3VI2hPAKNWHn9vnihMTZIu0XtJA9vlJ4HYUjWosicNCEeiNpCbOmLygS
         SPTkwSTnnJPjDtxOaNnev1K2zXiiXdRhCld5EPBse7IPJEh+DL3ufZeCZlvNVKtcYcle
         3itKGjYi3Xe798Qg67mILyMT43u8BDiICXQjRRDlb0BHxuhZszKMFhDXCuKcFHFhCOf5
         JLZw==
X-Gm-Message-State: APjAAAXpkW1/E7z0FQdExmq3OJz58XNKAWl18Q4wnt03W8ZJUcuRNm1v
        zT2zoJvztrtjS85qfup7QNhz9A==
X-Google-Smtp-Source: APXvYqxNi5m810RGl9Dt6H4OiyDpX5STS6y8j3lmbyfRY1WM5eQNmQR8V4o9tqARyZQzIGkzmZ1hLw==
X-Received: by 2002:a7b:c08c:: with SMTP id r12mr15674067wmh.67.1574419901594;
        Fri, 22 Nov 2019 02:51:41 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id w4sm2894338wmk.29.2019.11.22.02.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:51:41 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 4.4 6/9] dm: use blk_set_queue_dying() in __dm_destroy()
Date:   Fri, 22 Nov 2019 10:51:10 +0000
Message-Id: <20191122105113.11213-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122105113.11213-1-lee.jones@linaro.org>
References: <20191122105113.11213-1-lee.jones@linaro.org>
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
index 3d9a80759d95..c752c55f0bb2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2939,9 +2939,7 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 	set_bit(DMF_FREEING, &md->flags);
 	spin_unlock(&_minor_lock);
 
-	spin_lock_irq(q->queue_lock);
-	queue_flag_set(QUEUE_FLAG_DYING, q);
-	spin_unlock_irq(q->queue_lock);
+	blk_set_queue_dying(q);
 
 	if (dm_request_based(md) && md->kworker_task)
 		flush_kthread_worker(&md->kworker);
-- 
2.24.0

