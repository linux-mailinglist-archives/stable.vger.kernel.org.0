Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1449310AB06
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfK0HVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:21:55 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38977 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbfK0HVz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:21:55 -0500
Received: by mail-wr1-f68.google.com with SMTP id y11so22256258wrt.6
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3e3k1oohMwi/CIBzV4BTFHUMYD58PCHmDDNOIUgpFX8=;
        b=BwuanHBlSGiB0SMRYFVOhKBgOxnOH00qH53m8N+9VBllwChKBquiZU7plX/u/0yvvi
         4zazPRC4PNpo6raGpYDymT2tzHhmKg0p7tFFjgDKCYls3FgoOKGxuCrCeZ8hnuC0JjLA
         i91EVRoHWCuPrx8DORatdFIEh9Xt5mo8daTgJjXB5p+IDEw1WUCNezFVzIM9Ws9F/AO8
         y0myRl4GPXKxHS3QqENi/DlpTJSvg3Yo1n5tad5AyUlQlQXtKjabUBoTRDfJnj0f71jt
         ZwG/4dmE5zQnNJthKT5smA1Qeu1T3W/aymht1cjvpU2ChPqL8zThZKtUgLFdvT05X/eU
         D6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3e3k1oohMwi/CIBzV4BTFHUMYD58PCHmDDNOIUgpFX8=;
        b=jyFSxIZP3ZQohAazwamGFtugak/ATiK+BlTu/hTZKt+uYUiSL0sItmg32EgO7GZCti
         5L5guj1WrX9N5ReNZInoZIBAT2TRAE2KhS+iIlCMWEq86NgiFZx/rHDVu0KpHdrV6/13
         bXRsSYdNqNKAH/hJfpRXzd0UrQjuFJpTqbcaH+ULG4PuZl2Al8Eg5jygYVDRXJul1A6M
         4OxpF3U1g/XpdQ6Gm/PSNEqzi/7nBoRG25lD0ysv6HeVcYZVLzt/+w0f348LwtCwfS61
         2YSsJHXthX5w/xBIJgDbJL4VL89tkLvNBEe1LSirBvh47bAAHZ2ABRiMBMtmpg3lHAdh
         54Xg==
X-Gm-Message-State: APjAAAVpr6NzSpuIhCqlUUFehue/e/PW+hKFtbgwYrwsk2mrYq2yOsR6
        /QuSzZfT/UjhL+HCeFcHVu63qe9WTT0=
X-Google-Smtp-Source: APXvYqzz3y8sjwFoYquoDsZXBrjWbnb1dBvdD3WyC1k3QZbtWAX2fovyv1cIqNfh77g619iJVlxHlA==
X-Received: by 2002:a5d:438c:: with SMTP id i12mr19231296wrq.196.1574839311928;
        Tue, 26 Nov 2019 23:21:51 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id y6sm18151872wrn.21.2019.11.26.23.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:21:51 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 4/6] dm: use blk_set_queue_dying() in __dm_destroy()
Date:   Wed, 27 Nov 2019 07:21:22 +0000
Message-Id: <20191127072124.30445-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127072124.30445-1-lee.jones@linaro.org>
References: <20191127072124.30445-1-lee.jones@linaro.org>
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

