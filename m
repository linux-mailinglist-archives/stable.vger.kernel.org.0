Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17C02F0BAE
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 05:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbhAKEEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 23:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbhAKEEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 23:04:54 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781DAC061794;
        Sun, 10 Jan 2021 20:04:13 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id t16so14948033wra.3;
        Sun, 10 Jan 2021 20:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=glxykhZaQNLTuXnX1EzJ+qMXhkhKyWV1A7xqyR5TOSc=;
        b=PyIB31Ce/rJwA2xzlp/W1XhVlDPycIJkDsS2HO2GpPFNUX09q6Wo6zzX/wUlZlENum
         xbUCGPcTrbjxvrACTww4eIut8fmAAV1Is0pxoeleooPD4AkfFI87WMZSvkMRqHFr73sf
         fd1WmYdok427FZwW4E6QCAEaHtbObVtj921JpyKrjE8ndmNUSruOqPkwEzulR8C8tLSz
         ISquxDKu5SEx5NyGwGOpXC7C4ASUUtnQvwkUMCsRRumGIjDjFs4QmQyKlhjoM/+wtXSH
         dUXGqbkCblgX3RbVZMEAZLAqoXQNGWZIapxjf+4DCXv6mGBBDcOdJ+2ML1crvRRAz4xY
         cupg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=glxykhZaQNLTuXnX1EzJ+qMXhkhKyWV1A7xqyR5TOSc=;
        b=frsDCUOeV3AUSM1LbvISX/YAy90ovwBC7JZE2P8BcXAIXMKo26bXy4BBABI/Icw3ec
         pFltH7zessBiSB/wHJhetrRM1GgSwGPiJiD2C+xqEWWp54pRmxBIsHw+dXai9oF7ZvJ+
         q3Dcqbzuxdmf269L4fShbJutnvguBumYHVw54iv0RdWT9REMQLSneIANxqgCMX6QtECf
         7NQzdHIwNNCWGlsFsDDStxSskDgDSSXNQTyW0cg5rGdyVwX1kwC/Nt3xfj8O7zPfJfum
         AlkTeDfaU5cCXl9HN30s1UYxY/feZrLwgTQ2hPqFAfYo0SKIScyKeTsHjB3wTxtRzvGW
         wfPA==
X-Gm-Message-State: AOAM533xstW8lNDZ9/OiVt1AfU4ujuhgKirQQqZa7VCNze60Z1BCz6JT
        bcvufAy9xwdWMSnjvBKtDfIAWqvvPJ8=
X-Google-Smtp-Source: ABdhPJyKKQnKTHwYiSw24Iqi6pndDJV2I2S+F0nTsOLelqMq0OSDaZWU2Pf8gzi3v5ihGTwj9m2cdw==
X-Received: by 2002:adf:8342:: with SMTP id 60mr14418457wrd.140.1610337852351;
        Sun, 10 Jan 2021 20:04:12 -0800 (PST)
Received: from localhost.localdomain ([85.255.237.6])
        by smtp.gmail.com with ESMTPSA id o8sm22658061wrm.17.2021.01.10.20.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 20:04:11 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring: drop mm and files after task_work_run
Date:   Mon, 11 Jan 2021 04:00:30 +0000
Message-Id: <c5dd8eefe93657e42898014037ab142286080ea3.1610337318.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610337318.git.asml.silence@gmail.com>
References: <cover.1610337318.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

__io_req_task_submit() run by task_work can set mm and files, but
io_sq_thread() in some cases, and because __io_sq_thread_acquire_mm()
and __io_sq_thread_acquire_files() do a simple current->mm/files check
it may end up submitting IO with mm/files of another task.

We also need to drop it after in the end to drop potentially grabbed
references to them.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2f305c097bd5..7af74c1ec909 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7056,6 +7056,7 @@ static int io_sq_thread(void *data)
 
 		if (sqt_spin || !time_after(jiffies, timeout)) {
 			io_run_task_work();
+			io_sq_thread_drop_mm_files();
 			cond_resched();
 			if (sqt_spin)
 				timeout = jiffies + sqd->sq_thread_idle;
@@ -7093,6 +7094,7 @@ static int io_sq_thread(void *data)
 	}
 
 	io_run_task_work();
+	io_sq_thread_drop_mm_files();
 
 	if (cur_css)
 		io_sq_thread_unassociate_blkcg();
-- 
2.24.0

