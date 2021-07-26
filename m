Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EECD3D5CD2
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbhGZOha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 10:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbhGZOh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 10:37:29 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224E4C061757
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 08:17:57 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id j2so11493667wrx.9
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 08:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6RlgbBQwvJe2UbDmIkdqIGpILekk/KUrs1/KP3XPrPU=;
        b=knRJN/X0aXxtVP624DsL4zZ1iLwA2mbvwedwWlOkbrx8Jsd/QUbeHap+rJTWwAN8Qh
         3QbAw2B7W/Ej1qKpn+Ke7qeakDPNaIRUnsy5fzcntCVd0RQRcBOhFCWHlQqS+4CpgcSp
         z0YxTFYFWunkzZnUxhMeeU5MhMX0aYAUasjcjww85kTRUxS2pxldcNw+2RGaop1QT7Xd
         vCBWKUGEM7InZLPffQZoApXuH5iV042+rlqgitNBoTrK8XogL+RCBl4F8sE0QHrHpEKp
         5wbgXHU4ixvwXsDneX9h+5rGKdyu3cCEUv6gAXJHRJNj8nHHY2D/EdfB+N92HKmwtx1s
         3ZkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6RlgbBQwvJe2UbDmIkdqIGpILekk/KUrs1/KP3XPrPU=;
        b=X69SfLT2GUP90MlHP7yns1MfeiDhRSd6A9EUzcJnyMw++lftMsTGSRACNp21P1m6p9
         JEJBz8IcQFlZgUqAFMMbWWYlXv2W3ONnNkoxo6YoWt+if/ZbOeNoBJneX1mFyKISvsiF
         lcj9+o+vxgiCTUgCScT3qXzkhjQYrgAAEK4oAA1FYgg7DXGaZH1ok/nd5JetlPhRnwHw
         0vT/W9EivN+7sK9YG4H5eXUi7wDNPzIcg0gx5lb9aZEG714RzC9y6BQ5IoNaHdX+YWKl
         ad4Y4LqFWcS98qBpCK7KGLwONIeM9C039Wc/nP5zd+UUCPmf4eLttN3doWHWcD/10FbH
         4qBw==
X-Gm-Message-State: AOAM530vyula/1NuxDKt2PjO6Cg9yVpLgsqSpuAgcln85S1E9i848aOV
        e5YxmN10xkuO+bR6C3gPAdTzhD8SsJQ1Mg==
X-Google-Smtp-Source: ABdhPJysDXiCGfjbg6OdvsaMOIQiYlzPTuSQH43Kppg6ZQY6AUWPsYFc6GSaEr+ARQBNTtGm6oSEDA==
X-Received: by 2002:a5d:5141:: with SMTP id u1mr9909910wrt.50.1627312675577;
        Mon, 26 Jul 2021 08:17:55 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.244])
        by smtp.gmail.com with ESMTPSA id a8sm95845wmj.8.2021.07.26.08.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 08:17:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot+a2910119328ce8e7996f@syzkaller.appspotmail.com
Subject: [PATCH] io_uring: fix link timeout refs
Date:   Mon, 26 Jul 2021 16:17:20 +0100
Message-Id: <caf9dc2dc29367bb38fee4064b7d562d9837e441.1627312513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
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
index 42153106b7bc..42439838eaf7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6260,7 +6260,6 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	if (prev) {
 		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
 		io_put_req_deferred(prev, 1);
-		io_put_req_deferred(req, 1);
 	} else {
 		io_cqring_add_event(req, -ETIME, 0);
 		io_put_req_deferred(req, 1);
-- 
2.32.0

