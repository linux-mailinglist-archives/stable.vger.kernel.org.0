Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743E031A55A
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 20:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhBLT1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 14:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbhBLT1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 14:27:41 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1C3C061786
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 11:27:01 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id b2so1106618lfq.0
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 11:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IP5QHmh/uMxvGIZstG4E6Zl93QlY3SkTHtuFh4ovGBk=;
        b=TasdBCqiOuiYWTRqMgX5qxBPZXpdf6fl7+gC1xYpA8jdRsBd0Yr+3iEDtYr6SQ+Z68
         UznHFCytnWtegksCWO61y/C1bNY1nNCWlQaho/pTCmdY3RYDaHyAy0r7+Elz05soE+Z6
         GsRnIVV2jiGYVR35CQ0ZUB7PAVkBG+DBk93xAGllgPqNyv9MNaOnS+iTMcZl+8hMkzwS
         84peyD59+U9XDdg4hC9SLlE9YKvkFR5H6DBAt+cx/mn/CHB6X/jC/JFNYvLqJbQLsoG6
         IJGEaCcALVFskmkEp5pg8/TD+SlC5zNuskFEp8E9MENIeVM/2OwYV9X9WvhJBJ7oEeX1
         vWrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IP5QHmh/uMxvGIZstG4E6Zl93QlY3SkTHtuFh4ovGBk=;
        b=ib4NtSQM4DBuZbgzZJBhdlY/MCpSVcsoW4MsRAKAwB5S2Ay64eIMua1qgN4tP+RtVx
         rIrbSFjmuXosgXAqTKY7qcyjIOjx7YORL+WR4n1kOSpMSDqGOd2pGbokjbnTB+5vMuKa
         HZ7f6LljdybWehEKMdnxciSeF8b6vo95SHvG+6Dqo8yDF8tAN3J8VvVBIHMgpz6QfBy/
         I0VBwDBnB/jXJMEWCgIwMH4mypyHUatHK8elKAFIP2M0MvG9mAX6VFj3B09FrZ8e4OFC
         sXyQFwvfbLD9jYcuijR3Pz19bRr/mScXstnzelcVJvYkgnRDIU9OagD1OP6WbmCOQDkM
         azsA==
X-Gm-Message-State: AOAM5301FQB50glAH4ZMWAfC8630QGMYX+sDPDKsGmuhGfzOVHmxPRx3
        hShyZPl7XvxShAzhwiP0t7z5xQ==
X-Google-Smtp-Source: ABdhPJxsfSkrWI3+yycb+PDvI7VGwKvvT+15WEsOznX+uhli7wFIgyrpO7My86tu+D5P5hyBSbe/GQ==
X-Received: by 2002:a05:6512:39d5:: with SMTP id k21mr2277608lfu.142.1613158019847;
        Fri, 12 Feb 2021 11:26:59 -0800 (PST)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id b5sm1209133lfi.3.2021.02.12.11.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 11:26:59 -0800 (PST)
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jonathan Marek <jonathan@marek.ca>, stable@vger.kernel.org
Subject: [PATCH v2] misc: fastrpc: restrict user apps from sending kernel RPC messages
Date:   Fri, 12 Feb 2021 22:26:58 +0300
Message-Id: <20210212192658.3476137-1-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Verify that user applications are not using the kernel RPC message
handle to restrict them from directly attaching to guest OS on the
remote subsystem. This is a port of CVE-2019-2308 fix.

Fixes: c68cfb718c8f ("misc: fastrpc: Add support for context Invoke method")
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Jonathan Marek <jonathan@marek.ca>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---

Changes since v1:
 - changed to dev_warn_ratelimited to prevent userspace from flooding
   kernel log

 drivers/misc/fastrpc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index f12e909034ac..beda610e6b30 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -950,6 +950,11 @@ static int fastrpc_internal_invoke(struct fastrpc_user *fl,  u32 kernel,
 	if (!fl->cctx->rpdev)
 		return -EPIPE;
 
+	if (handle == FASTRPC_INIT_HANDLE && !kernel) {
+		dev_warn_ratelimited(fl->sctx->dev, "user app trying to send a kernel RPC message (%d)\n",  handle);
+		return -EPERM;
+	}
+
 	ctx = fastrpc_context_alloc(fl, kernel, sc, args);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
-- 
2.30.0

