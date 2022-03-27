Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1F14E8642
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 08:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiC0GYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 02:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiC0GYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 02:24:00 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179F211A32;
        Sat, 26 Mar 2022 23:22:10 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so12547167pjm.0;
        Sat, 26 Mar 2022 23:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=2+k5zw4UeWTVGq+IrF5mnTMmU6zOsHiGi1YYw7GIJjs=;
        b=jtiaQYzS6/owMqLM9XhSR0EDPTLY0V6y0R0MvHJfJuX5aySk3D55CIxg3Q1IHC66ds
         Lwpm0Vr7lM0OEdVSGGOnO2MgJJygBdnHdNrWPlHPFfrkdLaClqu5udmllAOt93HYp3GT
         Lu4lYrRMUeOUlBQ3bUzXFI/Q/lOzlx1wjCtdBaFlUNmZQGSlcCnyvL+bIsxRn3+qKCzf
         bxr+oFG9NqJpPuuFHtshlxI8SW1mDc2FiFyTh2lgtV1xfp5LVZRJ9EYXTSuewQwoIZqN
         tD98iDOsB5lqIR4iOMWXAFuxratBI5y6dtzzlTDjMTq+NLq1KiPDrGAEGvZCgpbYOAsW
         3Xcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2+k5zw4UeWTVGq+IrF5mnTMmU6zOsHiGi1YYw7GIJjs=;
        b=Wal3m0r/LoHIkXh296qtl+n+Om9ggi6kVmF5EDPkiP6R9xGT1TefyyiniQVVTvNxj4
         Tss798PMcZrjzJF74eOl7DttOPbHOquGNtwRTaXXNd8LkkbA4AsApPHWgyaPf1lylQQ4
         OYB4nB0bgEaUD2nC9WiKfTUEU0b9+aSOfPtiKnzIqfVFydcO8DEI9C5zBwx5UCNWcaZ+
         BUN4WwT1v5NZpS63fjjPr23Elqsgij8p3O1fYisF1Bty6Ndl6kvRnIf79Pa2ZFnpZclz
         NVaNjAulpmFy2h4x5j0XQNucF5ekOKnIHqNF6zhLoRuKHMEzmq4CWEhAAkzWmEya26f4
         eI0Q==
X-Gm-Message-State: AOAM531LP4a2t7lTNxN30kUFuSXfWR+YFQQytbhFtBWYgsUWJDVDL35W
        7v5NuSITBZiAtIToxQAv0Vs=
X-Google-Smtp-Source: ABdhPJzoTM4gwf2vVMJZXghIBHYF29uo2xq+ONuoPnlNNlrVzY6hswAF87YdMbStydxT6SdQ6fhnGQ==
X-Received: by 2002:a17:902:6944:b0:153:9866:7fea with SMTP id k4-20020a170902694400b0015398667feamr20505669plt.6.1648362129633;
        Sat, 26 Mar 2022 23:22:09 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id ij17-20020a17090af81100b001c67c964d93sm15879005pjb.2.2022.03.26.23.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 23:22:09 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     srinivas.kandagatla@linaro.org
Cc:     amahesh@qti.qualcomm.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, jorge.ramirez-ortiz@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] misc: fastrpc: fix an incorrect NULL check on list iterator
Date:   Sun, 27 Mar 2022 14:22:02 +0800
Message-Id: <20220327062202.5720-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
	if (!buf) {

The list iterator value 'buf' will *always* be set and non-NULL
by list_for_each_entry(), so it is incorrect to assume that the
iterator value will be NULL if the list is empty (in this case, the
check 'if (!buf) {' will always be false and never exit expectly).

To fix the bug, use a new variable 'iter' as the list iterator,
while use the original variable 'buf' as a dedicated pointer to
point to the found element.

Cc: stable@vger.kernel.org
Fixes: 2419e55e532de ("misc: fastrpc: add mmap/unmap support")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/misc/fastrpc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index aa1682b94a23..45aaf54a7560 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1353,17 +1353,18 @@ static int fastrpc_req_munmap_impl(struct fastrpc_user *fl,
 				   struct fastrpc_req_munmap *req)
 {
 	struct fastrpc_invoke_args args[1] = { [0] = { 0 } };
-	struct fastrpc_buf *buf, *b;
+	struct fastrpc_buf *buf = NULL, *iter, *b;
 	struct fastrpc_munmap_req_msg req_msg;
 	struct device *dev = fl->sctx->dev;
 	int err;
 	u32 sc;
 
 	spin_lock(&fl->lock);
-	list_for_each_entry_safe(buf, b, &fl->mmaps, node) {
-		if ((buf->raddr == req->vaddrout) && (buf->size == req->size))
+	list_for_each_entry_safe(iter, b, &fl->mmaps, node) {
+		if ((iter->raddr == req->vaddrout) && (iter->size == req->size)) {
+			buf = iter;
 			break;
-		buf = NULL;
+		}
 	}
 	spin_unlock(&fl->lock);
 
-- 
2.17.1

