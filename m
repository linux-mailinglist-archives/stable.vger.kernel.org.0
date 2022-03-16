Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2E54DAD43
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 10:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244329AbiCPJOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 05:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243385AbiCPJOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 05:14:32 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2135C865;
        Wed, 16 Mar 2022 02:13:18 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id g19so3162141pfc.9;
        Wed, 16 Mar 2022 02:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XCXMhctspS14CSj3bDVJKa2fECrychRdoSVtouYxm4M=;
        b=gvCiEX8yBD3meY306RCIl71Jm7P82zrMmlnCtQJjT6DEdTuYtXTEldQsFLVWKqE+Mu
         ZtCa5nI04kKPT7cX+pT8ScPknFLQvA8Rc3j3Yj1SMCz/NwSQzpt0GxTqrWPry83YzDlR
         3UZTthKjfD1PTlvxHwxBxHqKSw04cqYgFrAVvFS+yN0bw502gRKUESXAvtz70OlORqyx
         XSAzIkCEZzwJqmDbRRf7Jj8TuHru2IZIV4V5Vv5YGhaMuo7DMvd8LPWEfqr2eXKjx+l1
         MSWtAV7UxtEMq40F8uaHeFHxvETuojm86zA9jDrfAuTO9RiihvCa0w+RvsJIBrtYSMDc
         p+oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XCXMhctspS14CSj3bDVJKa2fECrychRdoSVtouYxm4M=;
        b=w8RwC2QoPihAIn46qgtnNcNp6avRypkjDsuuFAg8N2D81bQIYD7HUHliG+S60I6qdV
         TL5SgOhxjhf16unRobog/PQfrDc1Cf85pcrjLuZufuWx4ytv40Zny19JYTlBZm7R/zOO
         8GQiD60Mj8PkNwXWV4dGwfI6MgNo5hg9Dm6QWJIE4biAT6tTqGOIHuXLgn5Pgt3VqAb4
         D8ZLIJ2a49kcT6MGvKHARc4LnYIUP1gj9z1aHcOy9MJnrTSQzkoOk1AZvlk733z/uiUU
         8Y8KS1xumWNdtlSRmuAe3zIBaX+a0YMkZ7CH0ZASWSXWSOPDx1LKcTprYacOHjHB1g0M
         Bfsg==
X-Gm-Message-State: AOAM531th/4ncruhiHUfvc/xaHjtxgs1bIKa8/0+BCYBdn2tfJY/f6RK
        YNOgIQrUdu0be74BAETh1iM=
X-Google-Smtp-Source: ABdhPJy2rBH9fqFCc4mpGmWysIGVhExMhDm1IgbDRfIas26SVekO3FGKhUHMFvnRIjufgIUXaL2gLg==
X-Received: by 2002:a63:235b:0:b0:380:5d91:6cc with SMTP id u27-20020a63235b000000b003805d9106ccmr27530271pgm.183.1647421998215;
        Wed, 16 Mar 2022 02:13:18 -0700 (PDT)
Received: from octofox.hsd1.ca.comcast.net ([2601:641:401:1d20:6282:e9e2:394e:c94e])
        by smtp.gmail.com with ESMTPSA id t7-20020a056a0021c700b004f7916d44bcsm2219510pfj.220.2022.03.16.02.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 02:13:17 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] xtensa: fix stop_machine_cpuslocked call in patch_text
Date:   Wed, 16 Mar 2022 02:13:11 -0700
Message-Id: <20220316091311.2173309-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_LOCAL_NOVOWEL,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

patch_text must invoke patch_text_stop_machine on all online CPUs, but
it calls stop_machine_cpuslocked with NULL cpumask. As a result only one
CPU runs patch_text_stop_machine potentially leaving stale icache
entries on other CPUs. Fix that by calling stop_machine_cpuslocked with
cpu_online_mask as the last argument.

Cc: stable@vger.kernel.org
Fixes: 64711f9a47d4 ("xtensa: implement jump_label support")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/kernel/jump_label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/xtensa/kernel/jump_label.c b/arch/xtensa/kernel/jump_label.c
index 61cf6497a646..0dde21e0d3de 100644
--- a/arch/xtensa/kernel/jump_label.c
+++ b/arch/xtensa/kernel/jump_label.c
@@ -61,7 +61,7 @@ static void patch_text(unsigned long addr, const void *data, size_t sz)
 			.data = data,
 		};
 		stop_machine_cpuslocked(patch_text_stop_machine,
-					&patch, NULL);
+					&patch, cpu_online_mask);
 	} else {
 		unsigned long flags;
 
-- 
2.30.2

