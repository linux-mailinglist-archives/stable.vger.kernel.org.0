Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43755303C80
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 13:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391617AbhAZMHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 07:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392342AbhAZLW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 06:22:56 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32537C06178C
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:08 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id a10so22415053ejg.10
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y7C3dEjSQf0vm136vVDcVcxL/La2ICtMhTEJduTPdyY=;
        b=KJNA8NZZcIqyDFyTvW23llcFINgS/obbkExltdjW82NBT1uNl66Vrtx75yq5fLNwXF
         ZatTxKXv7CU57F+0WtG6SICWiuV35jxc6qBxhxIpeuy73rCDxhS142Fr9ZDI3DL3DQkA
         RCgW+WWf6IM0jOu1KHPlU9ZEP9ipH8c23OOOWhjYxnV1FFCsRa57Piadtbg5hn3dkk2Z
         D7xylax4G4u1t+TaL3ztsq9r2LAXh0PK6MT/Voc5Ct45mjcmMtC7y705xWUr35yp9ptH
         YeP1Dhe8VH8GymFBIvMEZ2VECsYvzZ32h2hH3wTXeNOPaa8MshgstUBwl+JTTtc1QtY6
         Npbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y7C3dEjSQf0vm136vVDcVcxL/La2ICtMhTEJduTPdyY=;
        b=HEuYfXrKSWCc7kVVT+a9RPAI0Skr8DjUM61XGxCZjpzJDA3kzH/8MlS4fpRtLg8KGL
         F/O2hhd4waYHuRm1xlbd9wwj6FoWIvbdFLGw1MQQvk7m9qtIVhgp0ohlLk/CRyYzY3CO
         B6airxUIPoN+2XfikmPHrsXQjxlDyHpRFnT5PF3RDaIpso0VuEjyVBZhveQKrTxy07z4
         t7+8rKGi8ztNR6NUC81SkunZoxgWj/L+icDsaXLx8z/K4R3s+Qg6zaypjbh1oWwK4YET
         033Npo1DsJkzJeQa4Gjc6dmUI6WulQ1aAwdTrCBxpzCCl283dr93nCC5We9/L+j7+ExW
         nCAQ==
X-Gm-Message-State: AOAM5310qxHsbuCn5vzUZsHR6wfF/TvsVJ5nCXN0IWOANnqvTfo7mfpP
        DviSN6RCqr3SRzE/0McWFtH4/4Ci6WM25w==
X-Google-Smtp-Source: ABdhPJzVgo46tNjT7KgYUTxCtiPl9MwsQbb65NlJhPAuRBux5T4ydeEyrWjgTM+nO5QVmXc4F4BchQ==
X-Received: by 2002:a17:906:298b:: with SMTP id x11mr3251012eje.158.1611660066796;
        Tue, 26 Jan 2021 03:21:06 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id o17sm12167128edr.17.2021.01.26.03.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 03:21:06 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH stable 09/11] io_uring: fix skipping disabling sqo on exec
Date:   Tue, 26 Jan 2021 11:17:08 +0000
Message-Id: <4bb1c422df133f0e883fefe221ffc866bfce7aa9.1611659564.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611659564.git.asml.silence@gmail.com>
References: <cover.1611659564.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0b5cd6c32b14413bf87e10ee62be3162588dcbe6 ]

If there are no requests at the time __io_uring_task_cancel() is called,
tctx_inflight() returns zero and and it terminates not getting a chance
to go through __io_uring_files_cancel() and do
io_disable_sqo_submit(). And we absolutely want them disabled by the
time cancellation ends.

Cc: stable@vger.kernel.org # 5.5+
Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Fixes: d9d05217cb69 ("io_uring: stop SQPOLL submit on creator's death")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 12fa5e09cefa..5ead8b6aeda2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8886,6 +8886,10 @@ void __io_uring_task_cancel(void)
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
 
+	/* trigger io_disable_sqo_submit() */
+	if (tctx->sqpoll)
+		__io_uring_files_cancel(NULL);
+
 	do {
 		/* read completions before cancelations */
 		inflight = tctx_inflight(tctx);
-- 
2.24.0

