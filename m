Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64533147B1
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 05:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhBIEwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 23:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhBIEw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 23:52:28 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C10C061788
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 20:51:46 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id y8so21894651ede.6
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 20:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kqVUd/LgI7jqzKstgT9xNmyGsiHrS3yv2AxLf12pQ5E=;
        b=YJnnTNKmJG6qRqWeweDWicQZJMes2fGOaCvk5uFFGkEvC3hhJxmSz0K0hN4SvErtA2
         Jvm3mw5Nqi2FxLN2umXEpDs8O8U7duIg8P7q3HyEa6MZ39TdFAcWCID5ItzL0TBJ3Sfo
         WlStksYUWpx3LhI6Ej2MVifDXjQTWhjsU0ZZXF2yVTt3mz35u+5wNAPgYFcpmYItcs/p
         t7LfJhNSFzQNOEfo1wD4dzdKHrdDSvKzL3iWqZd8/u14QRThZob/LJcrBw+iQs9DoVAO
         nZYWVHoF2dTZaYirgOVfqBDhEXC7qEEX1ZJIo3xDQ16XLz6dGhGRtAJ9bkwXBLGMeiWb
         FuWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kqVUd/LgI7jqzKstgT9xNmyGsiHrS3yv2AxLf12pQ5E=;
        b=f1vpW18qpJLSgm0SZ+AHpG8r8rKQ7yomaMECDz9uL9HT2SQaJQxG6BBpD+kt2N8HZj
         2RNlb90S5bQU3JQLgb5Rlub26rDEW7GgHKev8XjsryxJC3h7iweUG5Gq5G9gVRZIK8gU
         9+Zr5P7wx12CxxYJknsnqRxUk6Tg17wsPz1KqRqhcoyfnRkaKYDc6aAlMtPI5mzuUXiF
         hQOSA0CqfOMrlLmPv/of8diZ6swKE7mAl8juvTtx6ZKn1rP4+8TtFQ5clXhyDgK9RArW
         Z01OXw/50oG9IX2DcpPti3q+r9UXeKsTUovQUkEjyAkehVKnDZmi2N1is5Zz1F9j/RCQ
         +6SQ==
X-Gm-Message-State: AOAM530Q+5rMaOsraUbxQHWe1U4YoXpbEO+mxOv2/jT2ESuri6nlYO+r
        QdBRfpMDssWMHWhzxkYuHeik8X0fYx0=
X-Google-Smtp-Source: ABdhPJxDGDf9aJRqOwKXflr6ilfsBWx/HodBTlTcfM8DWKhIHNSQP3JK2QlBQ00XL4eWiXLCNUW2Hw==
X-Received: by 2002:a05:6402:4d3:: with SMTP id n19mr9775556edw.2.1612846305148;
        Mon, 08 Feb 2021 20:51:45 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id g9sm9973445ejp.55.2021.02.08.20.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 20:51:44 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/16] io_uring: simplify io_task_match()
Date:   Tue,  9 Feb 2021 04:47:35 +0000
Message-Id: <6545156988d3f911e4bdf9f161b600eca277c95d.1612845821.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612845821.git.asml.silence@gmail.com>
References: <cover.1612845821.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 06de5f5973c641c7ae033f133ecfaaf64fe633a6 ]

If IORING_SETUP_SQPOLL is set all requests belong to the corresponding
SQPOLL task, so skip task checking in that case and always match.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 907ecaffc338..510a860f8bdf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1472,11 +1472,7 @@ static bool io_task_match(struct io_kiocb *req, struct task_struct *tsk)
 
 	if (!tsk || req->task == tsk)
 		return true;
-	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		if (ctx->sq_data && req->task == ctx->sq_data->thread)
-			return true;
-	}
-	return false;
+	return (ctx->flags & IORING_SETUP_SQPOLL);
 }
 
 /*
-- 
2.24.0

