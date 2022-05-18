Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22C252BE8A
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 17:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239313AbiERPY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 11:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239271AbiERPYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 11:24:08 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5B319C759
        for <stable@vger.kernel.org>; Wed, 18 May 2022 08:24:07 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id p189so1334803wmp.3
        for <stable@vger.kernel.org>; Wed, 18 May 2022 08:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iwFDpDzsgkZxnKVg9aJTc5E9Q138Iv8GSg56Yqm0AM4=;
        b=cJPHEbefsOrS36AeKT5jTO5oHzqeCDUnv2YSZEO97zuos5lW1FIKIQg3jR6psxYH/Y
         iIXamqrwCBesaePVbnXKabA2SUTQlVsjMCnYunoQujOeo+BmKN4ydxzUGg1SuR0iz3rA
         LnsLEjPOsjWrOCVxVykoux8FWi4X9pFlLDMvlyEfp3iM2pg7XpxkjqM9Wx6UuK8+npN8
         8Jr3vTAwtKwk0XLe8QVq2htYXMsXrGv7rWzz4unJsIx6HdVu8jDTMhl27UTK6zo9mkEr
         qi6xWf+b/7OqAWVEHtTQdfe2EjjJXitNxVqleo20j9m7KvPdEA4Ls7KrEgVW78ayvjto
         Cvuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iwFDpDzsgkZxnKVg9aJTc5E9Q138Iv8GSg56Yqm0AM4=;
        b=zF/ocBx1PJ6Uj1+Zu7l2/n9ysj0gn4SRIPfm8JzonXTiKhwPAqVcCwZw4kmlFMZZXJ
         c5flXYRFPgcl1Lh/tXWpQvl5PvKcYyq0mkjh8RdlRo+bQ6AFnJl1cbTDHzGDLy4CPaz4
         QGfX5nHhbg3Gq+sznm5+FfMhgdPkPfE+XLfeu3HfuQaW9wQV8C/oq7UGk2vOUbof2LyB
         WifS8llpjRsKyejaN3128/q//VZ046QBs8Q1wGI5KNu8oSMrcvF3rf4Qz8rA5g6wbyLW
         LdwkzB9td+3Sclhiy7yXBscsa551/V2MknWysXrNftlPznuaKmq8q1YFAkwiA/ahA67o
         EORA==
X-Gm-Message-State: AOAM532IfXrSAYK+fSBo642cN52fl8loQAdM7LJii6B5klVmPYF4REDP
        lAziiIhigqM+p4EIQsTUaCG37w==
X-Google-Smtp-Source: ABdhPJzDD6Dg3zhbXuh1z8Drpc7WSNtxsx/KqISxAJMjOoonZ3gZNA4LRvb3POgg8EWVepm3Vkls5A==
X-Received: by 2002:a7b:c445:0:b0:397:28d3:d9cf with SMTP id l5-20020a7bc445000000b0039728d3d9cfmr452230wmi.116.1652887445896;
        Wed, 18 May 2022 08:24:05 -0700 (PDT)
Received: from srini-hackbox.lan (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.gmail.com with ESMTPSA id v9-20020a056000144900b0020c5253d8d8sm2975319wrx.36.2022.05.18.08.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 08:24:05 -0700 (PDT)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        stable@vger.kernel.org, Jan Jablonsky <jjablonsky@snapchat.com>
Subject: [PATCH] misc: fastrpc: fix list iterator in fastrpc_req_mem_unmap_impl
Date:   Wed, 18 May 2022 16:23:53 +0100
Message-Id: <20220518152353.13058-1-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is another instance of incorrect use of list iterator and
checking it for NULL.

The list iterator value 'map' will *always* be set and non-NULL
by list_for_each_entry(), so it is incorrect to assume that the
iterator value will be NULL if the list is empty (in this case, the
check 'if (!map) {' will always be false and never exit as expected).

To fix the bug, use a new variable 'iter' as the list iterator,
while use the original variable 'map' as a dedicated pointer to
point to the found element.

Without this patch, Kernel crashes with below trace:

Unable to handle kernel access to user memory outside uaccess routines
 at virtual address 0000ffff7fb03750
...
Call trace:
 fastrpc_map_create+0x70/0x290 [fastrpc]
 fastrpc_req_mem_map+0xf0/0x2dc [fastrpc]
 fastrpc_device_ioctl+0x138/0xc60 [fastrpc]
 __arm64_sys_ioctl+0xa8/0xec
 invoke_syscall+0x48/0x114
 el0_svc_common.constprop.0+0xd4/0xfc
 do_el0_svc+0x28/0x90
 el0_svc+0x3c/0x130
 el0t_64_sync_handler+0xa4/0x130
 el0t_64_sync+0x18c/0x190
Code: 14000016 f94000a5 eb05029f 54000260 (b94018a6)
---[ end trace 0000000000000000 ]---

Cc: stable@vger.kernel.org
Fixes: 5c1b97c7d7b7 ("misc: fastrpc: add support for FASTRPC_IOCTL_MEM_MAP/UNMAP")
Reported-by: Jan Jablonsky <jjablonsky@snapchat.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/misc/fastrpc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 4bdc8e0df657..93ebd174d848 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1748,17 +1748,18 @@ static int fastrpc_req_mmap(struct fastrpc_user *fl, char __user *argp)
 static int fastrpc_req_mem_unmap_impl(struct fastrpc_user *fl, struct fastrpc_mem_unmap *req)
 {
 	struct fastrpc_invoke_args args[1] = { [0] = { 0 } };
-	struct fastrpc_map *map = NULL, *m;
+	struct fastrpc_map *map = NULL, *iter, *m;
 	struct fastrpc_mem_unmap_req_msg req_msg = { 0 };
 	int err = 0;
 	u32 sc;
 	struct device *dev = fl->sctx->dev;
 
 	spin_lock(&fl->lock);
-	list_for_each_entry_safe(map, m, &fl->maps, node) {
-		if ((req->fd < 0 || map->fd == req->fd) && (map->raddr == req->vaddr))
+	list_for_each_entry_safe(iter, m, &fl->maps, node) {
+		if ((req->fd < 0 || iter->fd == req->fd) && (iter->raddr == req->vaddr)) {
+			map = iter;
 			break;
-		map = NULL;
+		}
 	}
 
 	spin_unlock(&fl->lock);
-- 
2.21.0

