Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E45430C02
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 22:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242915AbhJQUf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 16:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242900AbhJQUfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Oct 2021 16:35:25 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E02FC06161C;
        Sun, 17 Oct 2021 13:33:15 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id r18so62441671edv.12;
        Sun, 17 Oct 2021 13:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/nVjTYA81wB7SSdqTCo1jbJLycAjbKBO8LR6ntkz6ew=;
        b=OOHOAGXWjp5pGhcPMdUC60ixDV+HrVHaaX5YjsUu9BUm8qkmEFjgFmmUOtj8rkjRIe
         gb3Dbj6NtE+XkpaaE93i4eieYfH8XB5NnzUXw3oiG8ot4lPxTKqAS2Of+qQ544nn25Lv
         0qDcoR2q0YUBge6yyTDbDQ2IMYsA5GGesO5PTdKWHT0imD/bJlXeaOoHl7fCRvHdlYgf
         ahUJg9DRNbU+3ug1m5VMpLiOrrxI2OChx2hEDDz3hfr69dC94qWxK/5pDkb/i/z4A+XU
         ARZUObRDZtyd86wgZr0G5tbRkJVi84r8kXBp/6wJKbrfsXS7RcAXD7ozr0WIAeczMOOk
         RkWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/nVjTYA81wB7SSdqTCo1jbJLycAjbKBO8LR6ntkz6ew=;
        b=rmLxIyLC1XmZHxumQyNcs01jJ2OXPSNoe4SGDGJGs4R2eVDv6oXThrTQGGvM7x6hts
         EqGdHvRIT+Yt0WW8/RfhV8TlwV0IU2455F4yOm9yEVm4FKjyLNqTfRC7vjBcOJ3YegB9
         zWYc1awy/SJh9JFFrsabDM3D6iq2tPlTXQBIgQSW17pwgpi8JFXLc51HGKO5o68/aKua
         BhNAUZBv8fQKrVphDqgzSRvsBQxoG9lk4eIhswCtzXThHsLTCdhjZj1X8UK5cccXKhap
         0+5QpAVrVoDi4SzpHrlYplMlJgC9C6MtQNq1aBH67Kyg+J8q69jHrS3/RCQzsjPJA6uW
         hjKg==
X-Gm-Message-State: AOAM532KBuGvljaTxVvTABb6VvMWlGW0HYjLWfH6SnpVTM0qZrvP8EZ9
        j70oQg+sinZJoU1gR/9OeDbP3c/D/6I7dA==
X-Google-Smtp-Source: ABdhPJz3aVPzeaGtIbn4FvInvZCCws4Wo1x/U6G5+PlOrz9eyNiFHH0SOPcKcc1XOTNIsPXbIaH7/Q==
X-Received: by 2002:a50:be82:: with SMTP id b2mr37204380edk.56.1634502792639;
        Sun, 17 Oct 2021 13:33:12 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.145.195])
        by smtp.gmail.com with ESMTPSA id ca4sm8119651ejb.1.2021.10.17.13.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 13:33:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring: fail iopoll links if can't retry
Date:   Sun, 17 Oct 2021 20:33:21 +0000
Message-Id: <ff66f584ff352b94ef0f5cb4188da609834fe173.1634501363.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1634501363.git.asml.silence@gmail.com>
References: <cover.1634501363.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If io_rw_should_reissue() fails in iopoll path and we can't reissue we
fail the request. Don't forget to also mark it as failed, so links are
broken.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0d7613c7355c..40b1697e7354 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2687,6 +2687,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 			req->flags |= REQ_F_REISSUE;
 			return;
 		}
+		req_set_fail(req);
 		req->result = res;
 	}
 
-- 
2.33.1

