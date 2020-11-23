Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B9A2C188E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 23:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732419AbgKWWhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 17:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731256AbgKWWhZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 17:37:25 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C37CC0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 14:37:25 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id l1so20366824wrb.9
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 14:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vYgPUrNEQyw6uSfhuYdCmKrGi2j8dIAecawv0eDe0Do=;
        b=mG9PLRkIpArqgv4eRr6qx9BrcxN90ZyCPYdWbmFzgma8zw3eBusflyl/zt8fmIcfUk
         8Sb4WTDIqaxAa3lWPXouVsB1vpubjr8xa8SITFc2MmBau1+48tx/dO3aim8rG1qTkkCs
         OoJLg3+jcQvzu5trjx1OsA/6eHr9XcEkydsrO7TknhNnvaHZEG/MUU2ePSaeZJ1b9a4x
         rd86XLqOVXYnCNdhvJx7fPS7stS9pZOdLKecMV+O7355XuhHNV+8WYPz7Cu1FxRCow4P
         wDViaiNocXmBvLiYlWi82wFYFamQvHe1X4Aciqtko65nKXdWR9+65oP42uET4f4UI8Lo
         IWJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vYgPUrNEQyw6uSfhuYdCmKrGi2j8dIAecawv0eDe0Do=;
        b=ELpByV8JWJh3qns2KjfDqgmUlYKioKsardZbJCc/jtaep9KwXeRkn113YUusRzq8KG
         OV4QvldMxvY76hd7eVgN8SmR9tNJ6LGHWo/n44aY8UrAS+jG7cFoNRDRzlC4xPVW0dD1
         JErwz+K9dk4teGjca0SAsGH51BH7u7LnGpbad+wedcrPBzOrvI6iTweoVGBjGiHZypMd
         JkR9YUv+9JINBJ3bePP+MYkgIhdC9/q3eN8JgMKBniFJRPzuQjsMAhV9G4Vild7OZhRT
         /W7PTpw+oMMTkOeIfNDWR/RmLEVwSimDX5Qe4TgaMug5oHgjBI/MfhT4w6n1t/iDq2jM
         K09Q==
X-Gm-Message-State: AOAM530GzhVZxtzVNl3V8EG6ANKt60ZQ//ixYkO7IkYfXrXZmXmU1SVc
        NTTGUQenkihbvJ7a2FVLwVQ=
X-Google-Smtp-Source: ABdhPJzKPV6rKTg8t1NQW7dB+5Tcm9uemR/q1oLdkk85fzBgg2qcr6Z1kMJG1rEi6I8tmTPV3Z+bRg==
X-Received: by 2002:adf:d082:: with SMTP id y2mr1972323wrh.301.1606171043841;
        Mon, 23 Nov 2020 14:37:23 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id f18sm21309868wru.42.2020.11.23.14.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 14:37:23 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2][5.9 backport] io_uring: get an active ref_node from files_data
Date:   Mon, 23 Nov 2020 22:34:06 +0000
Message-Id: <075a6b4e7a9235d13b08b1f13f461846fbb97673.1606170275.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1e5d770bb8a23dd01e28e92f4fb0b1093c8bdbe6 upstream

An active ref_node always can be found in ctx->files_data, it's much
safer to get it this way instead of poking into files_data->ref_list.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 352bd3ad446b..24c0ad17ec4c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6855,9 +6855,8 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 		return -ENXIO;
 
 	spin_lock(&data->lock);
-	if (!list_empty(&data->ref_list))
-		ref_node = list_first_entry(&data->ref_list,
-				struct fixed_file_ref_node, node);
+	ref_node = container_of(data->cur_refs, struct fixed_file_ref_node,
+				refs);
 	spin_unlock(&data->lock);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
-- 
2.24.0

