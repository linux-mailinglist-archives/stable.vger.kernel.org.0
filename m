Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1A2610AB0E
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfK0HWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:22:12 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35762 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfK0HWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:22:11 -0500
Received: by mail-wr1-f65.google.com with SMTP id s5so25353732wrw.2
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=EwOfwwiNckMuQzPVj8mAR4X16hKKAPeuk3yKLlec5YI=;
        b=V3I8YXvNor+nCa7b1xHp+CvzeKniVPoGLykjf+XAcuJKfd9p9+fkdjScDkbTF3xYv/
         QyEmkSOVx3fYUurIM1VUfgvHgX4GMMswAiGOGZkTj8fEuOwZjGAz/JDlYnFHLjZuWOHX
         duJFN8wQOzt9RxmmFgLnC0CO7QuYb2p6ORpI9u8oDK2BV6KU6p/iA+j9BAKFgnc//lxn
         8hLTx0wclZCdf/XjqWvytwvojGUqjOLYvqNc21kHJ+9IvLV5w3s/kQGHe4BwSV2unXH5
         URmFHvdKern3tvubdwEu4YjMcSTFaFJWsqVPQvCusDEjdO9pn6Mx1lk/QW7ofucp3KgP
         DABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EwOfwwiNckMuQzPVj8mAR4X16hKKAPeuk3yKLlec5YI=;
        b=UZ2OBcGKMNCHTXNLpGsn7yCzNmTp02X9M/AWG/2XA3I1i8TXAeBSlHuCiAiBYbK7+I
         /h/bdqTTtDGolEp78M7KUVpbIFNy6V6HzMqjav10N67SMfN0w/xG94RoNuiGhmRgcCOP
         yYOa605EhWO+d8GjL99abSScDMrXIVpFlzLpbS/XqKKuDzQk5GnvzXrFYuDV+jAW5+vt
         BHHactcQ9/9F7ibGMxH5EFnjhW8FDxixIMwo2RvBvdd9WsnubaQFJl4d3foUB1/6DH6S
         KrnzN9ROQgU2vw/PRXvmndZchmMM//KDq8vBA4nCWH2Wicww0TmCplY2XSdSV9jfG3J2
         3uAQ==
X-Gm-Message-State: APjAAAUwSKvl/EVU4P+h5UNS1jPIVxEfr3tTZE2DOKfodQIa0snybeOS
        CaTROLrPcMakd2cjn7ePB1QGcyTm5+I=
X-Google-Smtp-Source: APXvYqxuKhfi5lxNAOv2JrveS8GskEyWaiN06G8VohqsfmEtDe5JPu8iixsjrSsd33a5Fk2aFhdrUg==
X-Received: by 2002:adf:e40e:: with SMTP id g14mr19450781wrm.264.1574839327516;
        Tue, 26 Nov 2019 23:22:07 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id e16sm17983130wrj.80.2019.11.26.23.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:22:07 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 5/6] dm: use blk_set_queue_dying() in __dm_destroy()
Date:   Wed, 27 Nov 2019 07:21:43 +0000
Message-Id: <20191127072144.30537-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127072144.30537-1-lee.jones@linaro.org>
References: <20191127072144.30537-1-lee.jones@linaro.org>
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

