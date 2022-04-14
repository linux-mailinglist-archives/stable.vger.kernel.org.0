Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CC15004DD
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 05:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238593AbiDND6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 23:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiDND6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 23:58:39 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A011EAD3;
        Wed, 13 Apr 2022 20:56:16 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id bo5so3754623pfb.4;
        Wed, 13 Apr 2022 20:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=6JqFeh4navCAkj5rFbxKZvKaVnUhQSiW3dMCYFISCQ0=;
        b=qA2StoYwKpYFkG4qBYg96eNsK1abtI4aeNFwNiyNnZL8nfFcfVSXduu/NoTlmzrkPn
         cMIR+H0kgy/XVbdC80vUY+DJAw0J05HbljoF6a6oKLw3rFDefujzna6GnnY+cXEUDan8
         TSiRr9mdhbYrs7I2XbVwwOHZ7L2tbDr26JlbSvH+YeCBloaiqEYgs9IN2+SHpUUda7t3
         QD2F+MCYgBxdC8cCH8WQ4u2WzQnNoF/baJZDT9IOaDyfmwbR78Z24btf/TLbFjJzD5eh
         vTadunXo1Ob0/LcyLdyXoKIijzCKI1qS0q3G1KctL0kjUD3wk2fk/BxzWizGNmD78snh
         sxWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6JqFeh4navCAkj5rFbxKZvKaVnUhQSiW3dMCYFISCQ0=;
        b=okfTeKXXY1hllGhlez7NK0yV1Eg75ukz2IZ0qOrhW0pamOYVWmmCWyOSI0PRC1zpfq
         KRbCx7SLHAy4Df7C6MnYIiffuPxs9XJ6Ye6REP6Yl6Ar6MclJ3jyQYhLqQVgOjJASIvB
         vCXJT1NDvU5qsWTT/3go26fmht2w51ijo1OfWrhX7QDiHaHWijxNENepvWLnqORxxoAN
         h3Qgt+c0SDJj+7a1L7Sa5z2Fu+0iAA9WUWlMtVQaOWHwB0dhbgwJ+2PdLXPuQdetgQtX
         Ngp9YMASxcoK1CRAXCywPN7wD3mGdu9TrtF2GwjvkglohFBplaYoQ5DmEecGOOU4+fZs
         p0bg==
X-Gm-Message-State: AOAM530bkGpbhN1kAJVPbfAWT2IiWGvL+GtczA0JT9LM94xdQDSgTukq
        i/A5t5qOh+JucVCHEcu3M8Y=
X-Google-Smtp-Source: ABdhPJwamlC67c0gDpeV3po1lICPHaYXmM3aTTHLaNXps5ULDTMUFYVt53myWkTCiI7YtEuBQIZ3EQ==
X-Received: by 2002:a62:1714:0:b0:505:fbff:fe8e with SMTP id 20-20020a621714000000b00505fbfffe8emr11808137pfx.49.1649908576148;
        Wed, 13 Apr 2022 20:56:16 -0700 (PDT)
Received: from localhost.localdomain ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id u22-20020a17090a891600b001cd498dc152sm622918pjn.2.2022.04.13.20.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 20:56:15 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     dinguyen@kernel.org
Cc:     gregkh@linuxfoundation.org, richard.gong@intel.com,
        atull@kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [RESEND][PATCH] firmware: stratix10-svc: fix a missing check on list iterator
Date:   Thu, 14 Apr 2022 11:56:09 +0800
Message-Id: <20220414035609.2239-1-xiam0nd.tong@gmail.com>
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

