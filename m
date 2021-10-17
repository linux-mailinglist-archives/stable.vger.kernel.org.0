Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B17C430BFF
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 22:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242902AbhJQUc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 16:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242900AbhJQUcz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Oct 2021 16:32:55 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E186C06161C
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 13:30:45 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id i20so61442032edj.10
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 13:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/nVjTYA81wB7SSdqTCo1jbJLycAjbKBO8LR6ntkz6ew=;
        b=gkmH3Rv1EIFurgcAzT0odeSUg7x/VEHJsY/T8C8Ih8MO/hlOwbK8xBadJe0tXOy1hc
         HSR0iTBSz5icrPEBGNw3JLne8NvnHcQF/8hIV6QsTjRt1PGyzruNPgtACc6hdKYChBdx
         VaNXySjmKYmoPONn3792F/TDrTD0VaVWvt5KFFCqGCtW157K1EgqbHhzzk6Hs9KUmiDn
         PsBBte+Eb/OkCqSxWlDoGnxWXDVCHq50OhVTGSgUAVK6CFLJHkp85tfqlrnfwtMBaVg/
         2cFLhdwpmCPK4pLoHI8Nj65e+qT2FzFpm9IaoBny9iYGRiBIXNt1o0MgvV33v9RqCN5C
         Xiag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/nVjTYA81wB7SSdqTCo1jbJLycAjbKBO8LR6ntkz6ew=;
        b=C9/c9p4yfpWpsklGjoQcbTuzw1mx4EB8VEd3rxEQt67pv8grDyvlR2o+7vh2xfXczU
         S5lK9Bq3ydvJKMYCGvPMkASJa7BO2qYvp+dzLI7EQ5bW9zwT/Ki7rUKZWoJFIsxGQrmT
         0OVTStwzP6vS+ZRFPpifzeJNxfIMVsF0NRUKWduobeDDMe/YfF6QeUJNsmetxqtB4VpC
         ucMNHYX3gDqj31lZ0P+YgC4pVWwQbSTODkABr+8hWriQtTN7OQc5EJdD9vfSwyxCiyHo
         iDyqOIClGrKnoHrpXthqE56qeJN4RBWNQ2tpZMcm30jXQv3kVCFgZjJ0nvDNCaGp/86V
         bqRw==
X-Gm-Message-State: AOAM531BypPG8p7fO58pXYmaq3CuXNncNGIYzahXKl+MeBYnRoaU3BdO
        xIEBU8RdsId+gRiCOREjGNcRT+U5XhOoZw==
X-Google-Smtp-Source: ABdhPJxb89maNIUYDvwhD8r5o83eLqTFN+EOQCMprbemwKKgZhfKdyYN8MWI1y2V6DjpLqetMVl5Gg==
X-Received: by 2002:a05:6402:27d2:: with SMTP id c18mr38736255ede.186.1634502643632;
        Sun, 17 Oct 2021 13:30:43 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.145.195])
        by smtp.gmail.com with ESMTPSA id p23sm9465498edw.94.2021.10.17.13.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 13:30:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     asml.silence@gmail.com
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring: fail iopoll links if can't retry
Date:   Sun, 17 Oct 2021 20:30:55 +0000
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

