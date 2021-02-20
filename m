Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A5E320666
	for <lists+stable@lfdr.de>; Sat, 20 Feb 2021 18:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhBTR0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Feb 2021 12:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhBTR0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Feb 2021 12:26:17 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3E0C06178A;
        Sat, 20 Feb 2021 09:25:36 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id f7so13156394wrt.12;
        Sat, 20 Feb 2021 09:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=54AnpaWMyfYuq/h7VqmVoWY2kNLRu6ylLPSweeYy4a8=;
        b=e034LxaN7MUAh6vgSF32HG5qyXDILqvpkRkQnEqjUwPLDEjJwmokamAyovpCkpdwJg
         htxTsMcWjeFC7Hc2PVumLnvCvt1VIvoMpaulpWfcoX+aWnvV0JdqQffVGrKddaqGCnRA
         EaOUH7j2wF8n3QUUeFN4hXKAtdNybzX5LZdh1OY3LqKDTOR6Map3R4Ic1FFGmKXAIiHl
         EEhcEgBty+Sjb00zfuf93pKCcckBGYYcRDVow09vNTEgTzFD/GMXWf+AfS8VIhnXXk23
         oh1cg/OXsRK4/3OTX5ECbKnS5tfdhkXnUv01GjUJIcybYT8jmOkt9YwPiLdIxlfta1nY
         WbJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=54AnpaWMyfYuq/h7VqmVoWY2kNLRu6ylLPSweeYy4a8=;
        b=hx56jVUa8/r3Eq/h0JMcfOQb0Uowhr+wANM/1LgoXarAl3bRmcTAmKWlfmWsFfzhn1
         EtZ3ucUpbB2OXEm5gpkV+nz4E/uC0qXDuKcY3iduT32n3ZvPBekpyb43hnQl1rqQjYxl
         JJQjbh7D0M3PqT2JZr4Z48oOL3vXW62YJWthLhfQoFpz1FMcdR6xql+32i4xTQ3WJOWu
         TbKFIJY5i+lskgANpRj1B901m3vJ9qZILXcAKye7mNhCmu26lF2ZBFLPGW0twLaY3iij
         eNnVI9pTPTToUmv1YgC59n5W8V3SUC9/bDgeZY7ObyHgAklZCmRO9oE1UIjoEF62ZvF0
         dTkA==
X-Gm-Message-State: AOAM5322/d4LZ22TAdMcRK4dTHpz3BoyzIhyAwPi4nOChbspV5BT2KMb
        /5PoFj9cwedKjnfw9RmJJtyvgYwLNBfftA==
X-Google-Smtp-Source: ABdhPJxGLx1M7n9iCvU8Q9ZOiYMbFCgAOxSTkhsu1zHNs3TnnGMGuVnrJUCd8aLC3c4Q4AoNyJJCBQ==
X-Received: by 2002:a5d:4b50:: with SMTP id w16mr6445740wrs.34.1613841935229;
        Sat, 20 Feb 2021 09:25:35 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id r1sm19908520wrl.95.2021.02.20.09.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 09:25:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 2/2] io_uring: wait for ->release() on rsrc resurrect
Date:   Sat, 20 Feb 2021 17:21:36 +0000
Message-Id: <73ff1722a3cc15deb79be163eddcbe44db047981.1613841429.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613841429.git.asml.silence@gmail.com>
References: <cover.1613841429.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As with ctx refs, on resurrect wait for potentially concurrently running
->release().

Cc: <stable@vger.kernel.org> # 5.10+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6ea4633e5ed5..c08d32523f79 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7368,13 +7368,11 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 		flush_delayed_work(&ctx->rsrc_put_work);
 
 		ret = wait_for_completion_interruptible(&data->done);
-		if (!ret)
+		if (!ret || !io_refs_resurrect(&data->refs, &data->done))
 			break;
 
-		percpu_ref_resurrect(&data->refs);
 		io_sqe_rsrc_set_node(ctx, data, backup_node);
 		backup_node = NULL;
-		reinit_completion(&data->done);
 		mutex_unlock(&ctx->uring_lock);
 		ret = io_run_task_work_sig();
 		mutex_lock(&ctx->uring_lock);
-- 
2.24.0

