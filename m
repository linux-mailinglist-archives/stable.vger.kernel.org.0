Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCBB3D7B75
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 18:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhG0Q6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 12:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhG0Q6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 12:58:16 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB922C061764
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 09:58:15 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id z3-20020a4a98430000b029025f4693434bso3180812ooi.3
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 09:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I8MyldbATmj30SfQiMDDbHxNgEGx/fMmtLadIJbuYBA=;
        b=bAnOa1WAa6/s1f39xSkFVuQrJjpzbm0+jupmZmlU+N7GVt8emiv7EGDjDpc2DQZ0oS
         ouOnO4zbNGpbM+AIiSU8DNtrRnhqHc+wjWeOv2kd+pS3EDnRRJ+JnKWISKSVKjFVL5Nt
         6HsRlYCBZSW6zZSXj5vHJYCDXoCruFaImc1yaGlg4wpGqOvBXAQP7tGPFnvFnyug0KDb
         1/xK9oqNUx5pa8Aoq97He8yve4k3S0DOK8cNndN85v2EV9d6oO6bs2J7eLrenfMVFIXh
         5Jjj794IXNPEJv9iXs5Onh+JW2W1sIKpi75F7E8daNI32uE2PynGaMa743HD623VtSbY
         UgDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I8MyldbATmj30SfQiMDDbHxNgEGx/fMmtLadIJbuYBA=;
        b=UBMDk+bp/LhbE2V7np2IS4uos3mxHDeuv7qn2P/HezuPCiyO5Ya7D/0MrTDaEqgj0M
         SpK4IbsY7TbcGulzXREQ0JvRkS2qLZrpe5lTx3ahl9DwiQsNqLo9eY2/lxiyIoyrMOoC
         sC30aUTeE4L9naICU3sS/8nL/cRtNQCPKJpJVyqFpT7FzFmm7txhqv4pAwaBgDDgAdLx
         Kr9wzurgyQIZwUSO6kimnMEfEhaQckzfCaUKUU2lsXw+fadOonhRP8ISzfwWW3iayPQT
         VsKZZoQIC/KwcjBfYcAD3mkpS744OaSYtDc42weFLpjC31/CdU/UAPWeFxJJN3nTuV+W
         6k6A==
X-Gm-Message-State: AOAM532/5bBe04dLYX6PCFb5zRHLgNAk1C7D7oBrB4W6Am206PuLbpft
        b2OAqROQRlNdvj7+lOYGxbAcVw==
X-Google-Smtp-Source: ABdhPJxa/R1nRVrwa2g1gNWy21e2zXu+UnC84b3xD4DT64tbxhzb5m4c42vi0L9po80AvwF85yqImA==
X-Received: by 2002:a4a:98b0:: with SMTP id a45mr14533443ooj.22.1627405095332;
        Tue, 27 Jul 2021 09:58:15 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c21sm637922oiw.16.2021.07.27.09.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:58:15 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     f.ebner@proxmox.com, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] io_uring: don't block level reissue off completion path
Date:   Tue, 27 Jul 2021 10:58:11 -0600
Message-Id: <20210727165811.284510-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210727165811.284510-1-axboe@kernel.dk>
References: <20210727165811.284510-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some setups, like SCSI, can throw spurious -EAGAIN off the softirq
completion path. Normally we expect this to happen inline as part
of submission, but apparently SCSI has a weird corner case where it
can happen as part of normal completions.

This should be solved by having the -EAGAIN bubble back up the stack
as part of submission, but previous attempts at this failed and we're
not just quite there yet. Instead we currently use REQ_F_REISSUE to
handle this case.

For now, catch it in io_rw_should_reissue() and prevent a reissue
from a bogus path.

Cc: stable@vger.kernel.org
Reported-by: Fabian Ebner <f.ebner@proxmox.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6ba101cd4661..83f67d33bf67 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2447,6 +2447,12 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 	 */
 	if (percpu_ref_is_dying(&ctx->refs))
 		return false;
+	/*
+	 * Play it safe and assume not safe to re-import and reissue if we're
+	 * not in the original thread group (or in task context).
+	 */
+	if (!same_thread_group(req->task, current) || !in_task())
+		return false;
 	return true;
 }
 #else
-- 
2.32.0

