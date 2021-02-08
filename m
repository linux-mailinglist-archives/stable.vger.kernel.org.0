Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D285B313657
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbhBHPJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233071AbhBHPGm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 10:06:42 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF6DC0617A7
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 07:04:34 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id s26so12715981edt.10
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 07:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6IdRX02f71VtSCOgLB7umSVkmw3Wa3ffAZk4G0tZrdA=;
        b=iCPc0xGpqDE3y9uhtnc3XI/B5gAwjGxRsHDb1G1k8v4ArS5yC/5wItmSNXg8FCfkim
         k5ghrzlySucLqjw/JbwVg9DR1qhcC8WyU1x9Qx51meoypa4ROTbR1iuYzLPm7WQXepd0
         ESxIozvVbYD+JhtIQoGdOWqy+7o/Vpgzl59U1MmCxV/OlsmTfGFBAOCivFIyc5CrfLOX
         BmLcgiXGBnU9h33tnsEc/yM2rOi6V7xQQ823LxGBiNL9/aUQcidYLYYYi6ctNBPItaGZ
         zPVICwkBLnHLYLToZX42BbSfEphDqzFN1Zy7jeNxuL4FYTfzLeSQIXGOfE9UUgiw4PHu
         /jAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6IdRX02f71VtSCOgLB7umSVkmw3Wa3ffAZk4G0tZrdA=;
        b=OwOJ7bAk3nl3B5AS8RmjVMhKv5n1eaAIXnsDRDUTUYJKZ2HIG7Ka2swer5XPtxUL84
         Kld1NChtK+02wFxvVQkJ9zl3lERTp2v679FZEbCBmUbGoQ8+l4cAVW8ghbdvdkiHvrCY
         mNxWb3l5aRJv6iqDakFINhrPExbegLPmPJXeFGZ2jlRSidpyS/hE9B6GCcBYE3/tcK8V
         3tMdZGpA4CDxZmp0OUIk/wOpI6ZhQ9d2eUf4qDN4gKgWTerEFukc8dcICqp7bWEzNT7R
         ANfghINQP8r3GCwRuBh7RXlmV9D0YEIC1ids50ynOg6y9xDVr4REPUM5SWCuBX0mDcEd
         eanw==
X-Gm-Message-State: AOAM532s1aeNu+tZRztMJdIvcFQSaxa4GeHz05H3/hjgpi15qKsXEMR8
        CsLedBfhKl0qd+DgqZsxFYWn3w==
X-Google-Smtp-Source: ABdhPJwfXLNMFtadj9SJWr4BwcsS5ttunJik+vD/qsQYkdDOX2wAfGwafW6+7j8GWPunhArlN0wq7w==
X-Received: by 2002:aa7:dd4c:: with SMTP id o12mr17088282edw.180.1612796673403;
        Mon, 08 Feb 2021 07:04:33 -0800 (PST)
Received: from jwang-Latitude-5491.fkb.profitbricks.net ([2001:16b8:4980:d900:bc0f:acd:c20a:c261])
        by smtp.gmail.com with ESMTPSA id kb25sm4359106ejc.19.2021.02.08.07.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 07:04:32 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org, axboe@kernel.dk,
        stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [stable-4.19 Resend 6/7] block: fix race between switching elevator and removing queues
Date:   Mon,  8 Feb 2021 16:04:25 +0100
Message-Id: <20210208150426.62755-7-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210208150426.62755-1-jinpu.wang@cloud.ionos.com>
References: <20210208150426.62755-1-jinpu.wang@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

cecf5d87ff20 ("block: split .sysfs_lock into two locks") starts to
release & actuire sysfs_lock again during switching elevator. So it
isn't enough to prevent switching elevator from happening by simply
clearing QUEUE_FLAG_REGISTERED with holding sysfs_lock, because
in-progress switch still can move on after re-acquiring the lock,
meantime the flag of QUEUE_FLAG_REGISTERED won't get checked.

Fixes this issue by checking 'q->elevator' directly & locklessly after
q->kobj is removed in blk_unregister_queue(), this way is safe because
q->elevator can't be changed at that time.

Fixes: cecf5d87ff20 ("block: split .sysfs_lock into two locks")
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit 0a67b5a926e63ff5492c3c675eab5900580d056d)
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 block/blk-sysfs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index b2208b69f04a..899987152701 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -977,7 +977,6 @@ EXPORT_SYMBOL_GPL(blk_register_queue);
 void blk_unregister_queue(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
-	bool has_elevator;
 
 	if (WARN_ON(!q))
 		return;
@@ -993,7 +992,6 @@ void blk_unregister_queue(struct gendisk *disk)
 	 */
 	mutex_lock(&q->sysfs_lock);
 	blk_queue_flag_clear(QUEUE_FLAG_REGISTERED, q);
-	has_elevator = !!q->elevator;
 	mutex_unlock(&q->sysfs_lock);
 
 	mutex_lock(&q->sysfs_dir_lock);
@@ -1009,7 +1007,11 @@ void blk_unregister_queue(struct gendisk *disk)
 	blk_trace_remove_sysfs(disk_to_dev(disk));
 
 	mutex_lock(&q->sysfs_lock);
-	if (q->request_fn || has_elevator)
+	/*
+	 * q->kobj has been removed, so it is safe to check if elevator
+	 * exists without holding q->sysfs_lock.
+	 */
+	if (q->request_fn || q->elevator)
 		elv_unregister_queue(q);
 	mutex_unlock(&q->sysfs_lock);
 	mutex_unlock(&q->sysfs_dir_lock);
-- 
2.25.1

