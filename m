Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F05C53754A
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 09:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbiE3Ff0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 01:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbiE3FfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 01:35:25 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA78A532EC
        for <stable@vger.kernel.org>; Sun, 29 May 2022 22:35:21 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cx11so1618287pjb.1
        for <stable@vger.kernel.org>; Sun, 29 May 2022 22:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/JtKBXQeykeEfVfemyRv9PnUMkopjlnHQ0uHvlRxnNg=;
        b=FS+Hfos3tVLkP6pfUtv9bQw1AOAuP0XZGA2UrHyxGbTc0lpS6L38YEY5YeGwuYXwQ6
         LG2bl0R/b32K45w1g5lzbmehjMUGjIY/YzFM6KYuwohacM8at+ODfnsJzl5qnVExQgKb
         noRmDvIprlIjdAbsma1TCLl/Li/8NFrX0r1kNI/FDqb6dwXV07c2Sj97JDJlyQU1sxKJ
         lImSfiV4J4iCg4LGNozLRNhN86YYHFSWC8gGvgUUqfeGhYJPhILWpcztKELoaSC33qYU
         deYZf/+h/WnazGoAS19W81fpOAp+2eVIkBlAIHXO316fIxCF/OQnYYnQdS71g7m4GELs
         1CMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/JtKBXQeykeEfVfemyRv9PnUMkopjlnHQ0uHvlRxnNg=;
        b=joV9NB0rSeRTKeQZAE4LOkgwlR1/tbqgcDi7BcfI1iY+UyOrTgaxUJsXi5ZbiPj5aS
         oZok0Hr99KT6dcGt7zf2mE8n+u3HDj8H9fjnVBsj1hHdvvdqzxS88JGTy3ItI7owEwVH
         1YxeVI8SgnQSbxCtXo15zilp2+/AQZq5ly7EffnRRjyrmiqNhPYmiNlQ17Hnwd8Mww7l
         h6CjPWPDy9wPoRsIIP1Lk2GusLrQkBCSPrSGc4bArVYWFyf4sCugj57GJ5t8iLRc63zS
         ztAWrZQNJjocW230o8eyvvVQxxtCUFkt8lo6X1XTEtVVsyqIxSp1Q1n8i4VlXfDbxAl2
         uAvw==
X-Gm-Message-State: AOAM5318zlgGtUj6sddtmL1MxZz3UgKFHdTpvx9OkTGJbq5elBYYabSh
        /lQliOrZ/sRzplDQj5FMw1H1lg==
X-Google-Smtp-Source: ABdhPJySr2Ivi7ylMmfBTwkcEZO68TKLTngqWb7nEt0WGzVQTfy9JGwYwBUrFYECvHTttvzCZfa/zg==
X-Received: by 2002:a17:903:288:b0:15f:a13:dfd5 with SMTP id j8-20020a170903028800b0015f0a13dfd5mr55491837plr.55.1653888921248;
        Sun, 29 May 2022 22:35:21 -0700 (PDT)
Received: from FVFYT0MHHV2J.bytedance.net ([2408:8207:18da:2310:2071:e13a:8aa:cacf])
        by smtp.gmail.com with ESMTPSA id v1-20020aa78081000000b0050dc7628178sm7812482pff.82.2022.05.29.22.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 May 2022 22:35:20 -0700 (PDT)
From:   Muchun Song <songmuchun@bytedance.com>
To:     gregkh@linuxfoundation.org, rafael@kernel.org, david@redhat.com,
        cheloha@linux.vnet.ibm.com, mhocko@suse.com,
        akpm@linux-foundation.org, nathanl@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Subject: [PATCH] mm: memory_hotplug: fix memory error handling
Date:   Mon, 30 May 2022 13:33:26 +0800
Message-Id: <20220530053326.41682-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.1 (Apple Git-133)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The device_unregister() is supposed to be used to unregister devices if
device_register() has succeed.  And device_unregister() will put device.
The caller should not do it again, otherwise, the first call of
put_device() will drop the last reference count, then the next call
of device_unregister() will UAF on device.

Fixes: 4fb6eabf1037 ("drivers/base/memory.c: cache memory blocks in xarray to accelerate lookup")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
---
 drivers/base/memory.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 7222ff9b5e05..084d67fd55cc 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -636,10 +636,9 @@ static int __add_memory_block(struct memory_block *memory)
 	}
 	ret = xa_err(xa_store(&memory_blocks, memory->dev.id, memory,
 			      GFP_KERNEL));
-	if (ret) {
-		put_device(&memory->dev);
+	if (ret)
 		device_unregister(&memory->dev);
-	}
+
 	return ret;
 }
 
-- 
2.11.0

