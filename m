Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7BD4E8638
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 08:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbiC0GPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 02:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbiC0GP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 02:15:29 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31D46465;
        Sat, 26 Mar 2022 23:13:50 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id p17so12138694plo.9;
        Sat, 26 Mar 2022 23:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=6JqFeh4navCAkj5rFbxKZvKaVnUhQSiW3dMCYFISCQ0=;
        b=MNg+6Ro1gbVF0AWYUoVUXXjh4zJIVeUSWOzvtXC6tJiK+63jZSPAyDu6EbNQ9Nbj8K
         5An9rz8mRUh0ixJBeScTtzQ7WuDb0ZdOTOXDDfN2X2a8yDZfFoogCUCfqxYlKDApvYLK
         vI2+L3E5hLr2u/yhYzmfW1wiaVY6u3vo5+wsTdSedkIQblqml9vYvvdsEQVruec44ybO
         VRlDaMgCJ4KwXBNQGKq3BkmOdZik6xnVb1lFoxfs3FjBFMjHeaJ8mUobcBulaQSYF6k5
         RoWvHrpRlSAX93HWjrDvHqNQqT2M6Tt4MN9j0KF4UsVIyaQ6UFUtsIHTBynL/F+8q3yx
         NVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6JqFeh4navCAkj5rFbxKZvKaVnUhQSiW3dMCYFISCQ0=;
        b=B2512oZqMbMy5AImkUTWAPXx8hzmOgUikC1ncS016gUoOA80wyv4g14I1N5c9oRt4q
         ZofUS9MRPweQXHxKqC5mGEURgej+0+PMJfm7o/H4m4gTDftfLK7hZsvltuZ8HhiYs9UV
         Oro/DrQ3vzUC8YT7W5jwkjplZx+6wxTARkrCeDLYd5MBndL5GI0vnQI+eMj1PHhGgdqc
         GVeFPlmayxUpzXJQ/C/19Kf/Niee5BM22c4I5IIXIo9N/2OqkJeyEsV70UNMoA5KGRZW
         6LZ2U6iEfF+8t1kek0lK91yuWIT0tbrI571VfvobTRQB3ALrWX4yP07kEOcm7MDUg0XX
         aeZA==
X-Gm-Message-State: AOAM531yznKwCTVNXfWZOgNUQW4+NrmEyuC8wgIlINZcOvGXaREyoYuO
        AbmC++kNrEf+9rKv6ARobW8=
X-Google-Smtp-Source: ABdhPJzoWx0Hv7ww0ec/NJoMZIYOzcG6x/aPjhMNUWT6h+MP8zts3xYMDcnvmf11dbBDEd7PZkxzdQ==
X-Received: by 2002:a17:90a:7147:b0:1bd:24ac:13bd with SMTP id g7-20020a17090a714700b001bd24ac13bdmr34521768pjs.70.1648361630211;
        Sat, 26 Mar 2022 23:13:50 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id f21-20020a056a00239500b004fb02a7a45bsm8332197pfc.214.2022.03.26.23.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 23:13:49 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     dinguyen@kernel.org
Cc:     gregkh@linuxfoundation.org, atull@kernel.org,
        richard.gong@intel.com, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] firmware: stratix10-svc: fix a missing check on list iterator
Date:   Sun, 27 Mar 2022 14:13:43 +0800
Message-Id: <20220327061343.4995-1-xiam0nd.tong@gmail.com>
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
	pmem->vaddr = NULL;

The list iterator 'pmem' will point to a bogus position containing
HEAD if the list is empty or no element is found. This case must
be checked before any use of the iterator, otherwise it will
lead to a invalid memory access.

To fix this bug, just gen_pool_free/set NULL/list_del() and return
when found, otherwise list_del HEAD and return;

Cc: stable@vger.kernel.org
Fixes: 7ca5ce896524f ("firmware: add Intel Stratix10 service layer driver")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/firmware/stratix10-svc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index 29c0a616b317..30093aa82b7f 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -941,17 +941,17 @@ EXPORT_SYMBOL_GPL(stratix10_svc_allocate_memory);
 void stratix10_svc_free_memory(struct stratix10_svc_chan *chan, void *kaddr)
 {
 	struct stratix10_svc_data_mem *pmem;
-	size_t size = 0;
 
 	list_for_each_entry(pmem, &svc_data_mem, node)
 		if (pmem->vaddr == kaddr) {
-			size = pmem->size;
-			break;
+			gen_pool_free(chan->ctrl->genpool,
+				       (unsigned long)kaddr, pmem->size);
+			pmem->vaddr = NULL;
+			list_del(&pmem->node);
+			return;
 		}
 
-	gen_pool_free(chan->ctrl->genpool, (unsigned long)kaddr, size);
-	pmem->vaddr = NULL;
-	list_del(&pmem->node);
+	list_del(&svc_data_mem);
 }
 EXPORT_SYMBOL_GPL(stratix10_svc_free_memory);
 
-- 
2.17.1

