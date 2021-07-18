Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFFC3CCBA4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 01:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhGRX57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 19:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhGRX55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Jul 2021 19:57:57 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD2EC061766
        for <stable@vger.kernel.org>; Sun, 18 Jul 2021 16:54:57 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id t5so19586703wrw.12
        for <stable@vger.kernel.org>; Sun, 18 Jul 2021 16:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qJ6V7XxGp7X7Mk2Vc/vNO+J77JgrLdzNPnbxMVMNpcc=;
        b=fAV4bG5A9Wvc8k2UEtyCZ/wJCWn4758px82p1DZm2ysVXypHrdHL96ISxsDHPJ/DRx
         yR8f9pT57YtP9T9H2mgPV8ctTGai74YzxnbgBsh9P9f0K8tH5mW3ivbuH8K68zH1nR4i
         JWSo15kPUyqxJb+DumpzNS/sicOwDUwa3GLV2Y7O57dptzSj6oleWqs3G5xMDKezS57p
         pOG2cb0dSfhBgSPDY9yyyKwRmA/CtNY6Y2wFTEPERJqz4u52fGhYKzbkeJYYP1Ki4Ded
         dEDlRsFOVTuUHRYo/UD+MKW7eGBmIozcJGJgFtKVqmYJ7g2QCq6ygYQZ5T5aA/fwKkUq
         ScnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qJ6V7XxGp7X7Mk2Vc/vNO+J77JgrLdzNPnbxMVMNpcc=;
        b=KVh8qqQ2ko6qH9T+scn6agt+Qmcl3DopnUxqeobYyU5qunx1YeC8aqTeCF4mKajQUh
         CDJgugLfMfAy/PLs2O0DT+8kQFlD0YIc3QCkabCJ4GaZou1gDXqk4xdSJB8iD+vqMHXL
         aIBmCK8BMK+KTiwQeqfI9n8k9LoPRLgQ2mqmDi7W0Oqbbod6Q6pGQ2Azsl8bOBWpSMoE
         //r4qh0bO4IcN+LLsZ+RQLrIjPWEa5YLR1XsJXDtEsRWrjhtrseUO7O2VWSjZmZgG3I6
         KIqxd8ceX6Rx7kKYonwF21PMFkYYdRxCJxgcsAwS95Gm3AUOHql2EE7+A2kkeMjkQJa1
         dQZQ==
X-Gm-Message-State: AOAM530Dfvej/zQJtfGtG1A+PlmE/nbavl3ZRH2AJaqRdMgSoKSA7DHT
        8SnNoKs4k06eeYt2iwEPO2GNuxbA4EsjVg==
X-Google-Smtp-Source: ABdhPJyeO5lkQZD1S6WILaE4epAIagZdUMDwWf5NTtuBX1yxUN9gsrvSjjPINjxLb3npoGOXIA2Y3Q==
X-Received: by 2002:a5d:5985:: with SMTP id n5mr27224413wri.63.1626652495584;
        Sun, 18 Jul 2021 16:54:55 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.101])
        by smtp.gmail.com with ESMTPSA id p18sm18098200wmg.46.2021.07.18.16.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jul 2021 16:54:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+a2910119328ce8e7996f@syzkaller.appspotmail.com
Subject: [PATCH 2/2] io_uring: fix link timeout refs
Date:   Mon, 19 Jul 2021 00:54:23 +0100
Message-Id: <07d1e4a10988b2ffb0b4bad641b46ce05626a494.1626651114.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1626651114.git.asml.silence@gmail.com>
References: <cover.1626651114.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a298232ee6b9a1d5d732aa497ff8be0d45b5bd82 ]

WARNING: CPU: 0 PID: 10242 at lib/refcount.c:28 refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
RIP: 0010:refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
Call Trace:
 __refcount_sub_and_test include/linux/refcount.h:283 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 io_put_req fs/io_uring.c:2140 [inline]
 io_queue_linked_timeout fs/io_uring.c:6300 [inline]
 __io_queue_sqe+0xbef/0xec0 fs/io_uring.c:6354
 io_submit_sqe fs/io_uring.c:6534 [inline]
 io_submit_sqes+0x2bbd/0x7c50 fs/io_uring.c:6660
 __do_sys_io_uring_enter fs/io_uring.c:9240 [inline]
 __se_sys_io_uring_enter+0x256/0x1d60 fs/io_uring.c:9182

io_link_timeout_fn() should put only one reference of the linked timeout
request, however in case of racing with the master request's completion
first io_req_complete() puts one and then io_put_req_deferred() is
called.

Cc: stable@vger.kernel.org # 5.12+
Fixes: 9ae1f8dd372e0 ("io_uring: fix inconsistent lock state")
Reported-by: syzbot+a2910119328ce8e7996f@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/ff51018ff29de5ffa76f09273ef48cb24c720368.1620417627.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 930c5d5a2b0b..29a0af50a439 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6307,7 +6307,6 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	} else {
 		io_req_complete_post(req, -ETIME, 0);
 	}
-	io_put_req_deferred(req, 1);
 	return HRTIMER_NORESTART;
 }
 
-- 
2.32.0

