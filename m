Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E990677EC1
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 16:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjAWPIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 10:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjAWPIU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 10:08:20 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AA2976F
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 07:08:19 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id q10-20020a1cf30a000000b003db0edfdb74so4495146wmq.1
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 07:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sK9H1PX+KEEGUetWZoL4HfsJ5iVAu9hyBKY4KbtsmVY=;
        b=I9UZPXF96jemTS8yUxiSCuOoDZjG77Bhu7ppJAEUDRIjbIBrxrM4R5DqUeU5vt6ynP
         Ukh5MYvXU0cIWXCY43Ab/nShAjhUhULiuBQeZUVqvXRDMi4u+hndTwi+jwkVhIdal0Iu
         tQ8Mu50fyqrwRvwl3WGmdKuiWxv7Ng2/uXhBZH3IxD8YiwWexmUJHfnhOS9Xc0BJ+tpG
         8VwbfyvOsPpjTf7VBMUWtVzG+Ubz/bBnNLE1M9TQH3qTnWcjyeQ91hBFC6MiplTeOhJJ
         rzYVpT44fI7eSmADPaK0iNltLd9Zx3b3NPckNNq0k4u5iQZpCt3HJsEq3+sAV/jnvQCt
         qeDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sK9H1PX+KEEGUetWZoL4HfsJ5iVAu9hyBKY4KbtsmVY=;
        b=oYcJCr5BOVgD0Qr5j6WXhzuFqZqVKb4OhxPF2/H88zKq9KoBttuIc1k69UEXNMn8LW
         FPlui5IWhDUT3i1xd0IIH9cgNagcny+M+0JsFzwGgvV+y7ZbVagVtDmRappHip6eeYsB
         4qievUB8qXMpw9IvSNuCFqtRhfVaDEPaRVdDcJjr9qJeVvfGXELDrkP6/urbPxP5Q5AD
         rL3UaCl30CouAAyrdOcoc9k45qFg9OAMJ7bRKtjMbbXhgBWJs2tN7UbE2DE9pZDfVrWy
         9uTUiZ/k7LarHdm4jE86NspV1uwCm9a3kOrrAmJOxqKmrg5Loc1KZMjgMGiiDMwVyuUh
         SZSw==
X-Gm-Message-State: AFqh2kr9yxZ9xfZyA8p7mt/vmoUmcglCY7DCLfFYdZcyOtt8n2vVPjtI
        qPIWdmtKDyX1EtGLV1ef35H1cM8AVJ0=
X-Google-Smtp-Source: AMrXdXtjeopATOtHuv500qAo9p+pOLWpZJ9fOjVusZvxc/3N2ayG5PPrhAXSBUOv20kEXl9y/TuYIg==
X-Received: by 2002:a05:600c:2152:b0:3d9:ecae:853f with SMTP id v18-20020a05600c215200b003d9ecae853fmr24498510wml.3.1674486497500;
        Mon, 23 Jan 2023 07:08:17 -0800 (PST)
Received: from 127.0.0.1localhost (188.30.84.186.threembb.co.uk. [188.30.84.186])
        by smtp.gmail.com with ESMTPSA id t15-20020a05600c198f00b003db32ccf4bfsm10968811wmq.41.2023.01.23.07.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 07:08:17 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-6.1 1/1] io_uring/msg_ring: fix remote queue to disabled ring
Date:   Mon, 23 Jan 2023 15:03:24 +0000
Message-Id: <7912d2195155239ddcc77fa9ec22cf0f503ddf68.1674486170.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ upstream commit 8579538c89e33ce78be2feb41e07489c8cbf8f31 ]

IORING_SETUP_R_DISABLED rings don't have the submitter task set, so
it's not always safe to use ->submitter_task. Disallow posting msg_ring
messaged to disabled rings. Also add task NULL check for loosy sync
around testing for IORING_SETUP_R_DISABLED.

Cc: stable@vger.kernel.org
Fixes: 6d043ee1164ca ("io_uring: do msg_ring in target task via tw")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index a49ccab262d5..7d5b544cfc30 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -30,6 +30,8 @@ static int io_msg_ring_data(struct io_kiocb *req)
 
 	if (msg->src_fd || msg->dst_fd || msg->flags)
 		return -EINVAL;
+	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
+		return -EBADFD;
 
 	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0, true))
 		return 0;
@@ -84,6 +86,8 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (target_ctx == ctx)
 		return -EINVAL;
+	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
+		return -EBADFD;
 
 	ret = io_double_lock_ctx(ctx, target_ctx, issue_flags);
 	if (unlikely(ret))
-- 
2.38.1

