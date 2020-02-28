Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85DC11741FA
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 23:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgB1W1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 17:27:22 -0500
Received: from mail-pf1-f181.google.com ([209.85.210.181]:33136 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgB1W1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 17:27:22 -0500
Received: by mail-pf1-f181.google.com with SMTP id n7so2430624pfn.0
        for <stable@vger.kernel.org>; Fri, 28 Feb 2020 14:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language;
        bh=N1TAvGZ3QNT+xpjjM8DLGNB3youEsUKiwDx0HWxHwmk=;
        b=OvsVcJSPgBR98KjnM7Erork2uKNOUxKILPOp3XWU9kenU4bhAnpoXQLooRhz63yndI
         VBC8OMEcM3Nsp1mG5NxzVvssd/rMs7vOwRTNBAckTViMn3S6Akbw/JNGvGChJatMxzB8
         8voLxmacDke3vvEm6Zi3yo+F82y6ZCOSGeMCNlFY9fGut8E7itAjXSqTWCI8zThmVZeK
         FvAbNB3MICQJvqKG/GYHSLkjjLdwnTf/x+QJgzkV5MpfJ4htEuq6kINvIVr4C0hecF1q
         G3no+VCWdS+xA8X4YzYkaK/yX8WCYu/76oU/xPGEHInKyfjwY/3qXO4i4eK677tgVeWc
         NdNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language;
        bh=N1TAvGZ3QNT+xpjjM8DLGNB3youEsUKiwDx0HWxHwmk=;
        b=jM51mMAW6vdF5hmNM/QtyOR1Msk1RvDkIwoHRHrVWoPpH93NZSi1MQwk9qhYPT6g2g
         aEciCts+kmHAw4d2KNhFoPVi/IiaTTrRutuivFAGR8CQJFHfqD6f7IsUba/+ZRE4AkL3
         TAiBXbRi6mg5Jo/GFciVsEyUV/WmOAGsXhtaxyLxDVH3uBBDauLAP4+oEfBRTtZulnmX
         prZ0MtDn25c2HcfR/lk0VeyeYhFE7NYaGHcK7KumbVj9U2yrpYOUEoLiZY9tZfc6wdWf
         2HgHI1YczDljuvB+ju7RMHnRgkmpbtaPYQerP+/SLrWO74u3JpEk9vHwF8ZZXiZQhUpM
         ShdQ==
X-Gm-Message-State: APjAAAUsEzL/xSiCIBGKGrZj8PWfSmCxWS4cNc+Zpqnemw8wIDCKc48o
        Cm3dbYl9BmNGjcTivMUml8ioQg==
X-Google-Smtp-Source: APXvYqwY0pGR9bBTi+Ep5BZNkIj1giA2ME1QmxOrS7IOyC80dDQSrmc91WdloVB2PetFNmPphH+uvA==
X-Received: by 2002:a63:5713:: with SMTP id l19mr6787858pgb.216.1582928840190;
        Fri, 28 Feb 2020 14:27:20 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id v29sm11205997pgc.72.2020.02.28.14.27.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 14:27:18 -0800 (PST)
To:     stable@vger.kernel.org
Cc:     Jann Horn <jannh@google.com>, Sasha Levin <sashal@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: 5.4 backport of io_uring/io-wq fix
Message-ID: <48a01733-c0cb-e738-8c18-1abc3de1dcfb@kernel.dk>
Date:   Fri, 28 Feb 2020 15:27:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------04CE939AB3C37F445B7764A9"
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------04CE939AB3C37F445B7764A9
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi,

We don't have these two commits in 5.4-stable:

ff002b30181d30cdfbca316dadd099c3ca0d739c
9392a27d88b9707145d713654eb26f0c29789e50

because they don't apply with the rework that was done in how io_uring
handles offload. Since there's no io-wq in 5.4, it doesn't make sense to
do two patches. I'm attaching my port of the two for 5.4-stable, it's
been tested. Please queue it up for the next 5.4-stable, thanks!

-- 
Jens Axboe


--------------04CE939AB3C37F445B7764A9
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-grab-fs-as-part-of-async-offload.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-io_uring-grab-fs-as-part-of-async-offload.patch"

From 343c693195f2424ed18be31b58d67d04df584429 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 28 Feb 2020 15:20:18 -0700
Subject: [PATCH] io_uring: grab ->fs as part of async offload

[ Upstream commits 9392a27d88b9 and ff002b30181d ]

Ensure that the async work grabs ->fs from the queueing task if the
punted commands needs to do lookups.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 709671faaed6..607edaef5e71 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -71,6 +71,7 @@
 #include <linux/sizes.h>
 #include <linux/hugetlb.h>
 #include <linux/highmem.h>
+#include <linux/fs_struct.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -334,6 +335,8 @@ struct io_kiocb {
 	u32			result;
 	u32			sequence;
 
+	struct fs_struct	*fs;
+
 	struct work_struct	work;
 };
 
@@ -651,6 +654,7 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
 	/* one is dropped after submission, the other at completion */
 	refcount_set(&req->refs, 2);
 	req->result = 0;
+	req->fs = NULL;
 	return req;
 out:
 	percpu_ref_put(&ctx->refs);
@@ -1672,6 +1676,16 @@ static int io_send_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			ret = -EINTR;
 	}
 
+	if (req->fs) {
+		struct fs_struct *fs = req->fs;
+
+		spin_lock(&req->fs->lock);
+		if (--fs->users)
+			fs = NULL;
+		spin_unlock(&req->fs->lock);
+		if (fs)
+			free_fs_struct(fs);
+	}
 	io_cqring_add_event(req->ctx, sqe->user_data, ret);
 	io_put_req(req);
 	return 0;
@@ -2168,6 +2182,7 @@ static inline bool io_sqe_needs_user(const struct io_uring_sqe *sqe)
 static void io_sq_wq_submit_work(struct work_struct *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct fs_struct *old_fs_struct = current->fs;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct mm_struct *cur_mm = NULL;
 	struct async_list *async_list;
@@ -2187,6 +2202,15 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 		/* Ensure we clear previously set non-block flag */
 		req->rw.ki_flags &= ~IOCB_NOWAIT;
 
+		if (req->fs != current->fs && current->fs != old_fs_struct) {
+			task_lock(current);
+			if (req->fs)
+				current->fs = req->fs;
+			else
+				current->fs = old_fs_struct;
+			task_unlock(current);
+		}
+
 		ret = 0;
 		if (io_sqe_needs_user(sqe) && !cur_mm) {
 			if (!mmget_not_zero(ctx->sqo_mm)) {
@@ -2285,6 +2309,11 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 		mmput(cur_mm);
 	}
 	revert_creds(old_cred);
+	if (old_fs_struct) {
+		task_lock(current);
+		current->fs = old_fs_struct;
+		task_unlock(current);
+	}
 }
 
 /*
@@ -2512,6 +2541,23 @@ static void io_submit_sqe(struct io_ring_ctx *ctx, struct sqe_submit *s,
 
 	req->user_data = s->sqe->user_data;
 
+#if defined(CONFIG_NET)
+	switch (READ_ONCE(s->sqe->opcode)) {
+	case IORING_OP_SENDMSG:
+	case IORING_OP_RECVMSG:
+		spin_lock(&current->fs->lock);
+		if (!current->fs->in_exec) {
+			req->fs = current->fs;
+			req->fs->users++;
+		}
+		spin_unlock(&current->fs->lock);
+		if (!req->fs) {
+			ret = -EAGAIN;
+			goto err_req;
+		}
+	}
+#endif
+
 	/*
 	 * If we already have a head request, queue this one for async
 	 * submittal once the head completes. If we don't have a head but
-- 
2.25.1


--------------04CE939AB3C37F445B7764A9--
