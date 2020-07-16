Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CB62220BB
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 12:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgGPKin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 06:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgGPKin (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 06:38:43 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30046C061755;
        Thu, 16 Jul 2020 03:38:43 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ch3so4587698pjb.5;
        Thu, 16 Jul 2020 03:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=Xi10Azjc3LYA6y1wwwmx1FIXyFCFp9l/aJg3weE/cU8=;
        b=Pq/FSfpzhrM0GxXsdRR/uLQv2uAiDhYjXndr1acNxbgDZLlKQlwa7Ukoh2LRi1gVYT
         16/3pMbpXwb3kzCXGu/I886DT7nsVNjss85pqCjLsIT/OErNjdkGn3RuU8deA6X0GH48
         yAzXNCmUUnAiVGD8tSXi5sNPCwjDTPr4hHtmgxHw7xFPBhrpOKHR9jsKtwWUEQ90hSi8
         BjHQ/mXzseMwrbtAWFU6eeEXUH9pBZnasezCMQYSscYCfcak7XdMGEQPVwWcrGjKGmcF
         dk4xJ0aVOaIaRBNM1oXcoN9m8PqqXXvgOyLWfVjseBTHlBmkZa3RwAOii1zKbh1g8QWP
         WevQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=Xi10Azjc3LYA6y1wwwmx1FIXyFCFp9l/aJg3weE/cU8=;
        b=khVGhvgvh9ooiXOHCAvCuOpTib85EadG9eMEmO3RNlQhamn5g9LYGPEAqTtTsbHEjm
         3lhSOPlUR5tfI+xaW6lyr0J4tVjOCFqO8GMRHwcIe+cvsplSx86+4QmdWDQXW3CMG5Sf
         EmFcGv7Ih2M7hb/Pa49wLzP4dZHO5HsKFFEuRMqjhZ8hYbE3Q21H14mBZ8M76kv9dIto
         e7xSQih5EbROjRkuzeNkGtUJoVsU0hGshw78LBUrXyVZtKW5Pu5u4aCLzfAlmnfNseHe
         pD5/JLHZ+BH2KOMGFvmvoXc5UhKv5xt3W6p2eAiPGW57E+5CNjX1aEkfDQBHRbTTjQNO
         19tQ==
X-Gm-Message-State: AOAM530qyYjtpvxFagg9Sy3a2VPtpukc8TDgv6BzUOmB7o+HH8a9WdhP
        AIVlhIQZHAWzdpPhs6KLICc=
X-Google-Smtp-Source: ABdhPJwvwc5xQa3njYBfmLlIdhRXSaeHNwZ/ppB8TxJ/caisV3Cjf4ACMDjgQfmcagMB2l5CbbeR1A==
X-Received: by 2002:a17:90b:390e:: with SMTP id ob14mr3798618pjb.221.1594895922546;
        Thu, 16 Jul 2020 03:38:42 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id o129sm4936655pfg.14.2020.07.16.03.38.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2020 03:38:42 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
Subject: [PATCH V2] MIPS: CPU#0 is not hotpluggable
Date:   Thu, 16 Jul 2020 18:40:23 +0800
Message-Id: <1594896024-16624-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Now CPU#0 is not hotpluggable on MIPS, so prevent to create /sys/devices
/system/cpu/cpu0/online which confuses some user-space tools.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 arch/mips/kernel/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/topology.c b/arch/mips/kernel/topology.c
index cd3e1f8..08ad637 100644
--- a/arch/mips/kernel/topology.c
+++ b/arch/mips/kernel/topology.c
@@ -20,7 +20,7 @@ static int __init topology_init(void)
 	for_each_present_cpu(i) {
 		struct cpu *c = &per_cpu(cpu_devices, i);
 
-		c->hotpluggable = 1;
+		c->hotpluggable = !!i;
 		ret = register_cpu(c, i);
 		if (ret)
 			printk(KERN_WARNING "topology_init: register_cpu %d "
-- 
2.7.0

