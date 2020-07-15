Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA3C220466
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 07:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgGOFdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 01:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728398AbgGOFdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 01:33:25 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BACCC061755;
        Tue, 14 Jul 2020 22:33:25 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id p1so1899501pls.4;
        Tue, 14 Jul 2020 22:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=QuXjJKe2NPVcY9Fdc86yQKEacLS61Gv+c6npgfuxORE=;
        b=hMVkA/qThitufi7O0uU5Xj0TV7pUfF5VnVXIvktBrcZFZxS2/n/DsrPyoOjYpkkawJ
         DzpnFmNBpTm9Kl7PmO07b0PZWuTXUSQCvG86nogZcPL1sl4ZbZJGPEVnuWeHDNyM02RN
         zsgEYR65iF+HBcu+0EHTRd8Q+m45kdNBjDI9Su4wbtepn+WZ1DPDeQNXoEnXZy6CIKkv
         ZT0iDmPJd6xHv1oIM1Xm920UG91hzI5WuUJXWP9qYyCIcK4SYxvnHWYD19A1p8VVcdhz
         8KXYSniuiFwbNcco0BJi4GGEpfRD4GdUoGZ1lIIPMnKX1sxelft6U8AnU7gmSIZgkPiz
         NLJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=QuXjJKe2NPVcY9Fdc86yQKEacLS61Gv+c6npgfuxORE=;
        b=loFxQ6M94KpTalu52Y0UVStEa9oSViffCUhgLd3ymSdEhd09tbo6qiXC8+NG4JNkqa
         5BCpeBzppIxySTlV9T0VYRVro77PZVErtGPT1OnIuDO7S0ZTUaYjvl+EAPnrxrpfWqKE
         RD2QsjFLV57dojU7AHak1NX+t+k4xhjzPu311e3zQWn8nYJUd6ihFpsX5qeZNI6u21T0
         lDjxDQryBdCVIP7Wv2lnDLvU9z3gFpz14HvMf46ZW+UmV/z5A7Y5oSjchD1V+KN4H+EX
         7cY6azuLhhkU25fxLqBbqc4OlesQIbJ//PRkSDmB28xgXZ5+FrV1QglMzjuDUNEhpv8j
         gqZw==
X-Gm-Message-State: AOAM5305HVYxwtqx86igqRlgBzutIhR9b19KgpvG270oLcNOk4uJlFac
        F+DrHDzxA/XytNPbd4w591M=
X-Google-Smtp-Source: ABdhPJymUlvUzQZ1TG5R2z3ARtuTeD4HTh/ufkLgiQu+w9BFwmsPmmJRmCfTBsPWeKrKPxfB6z7uEg==
X-Received: by 2002:a17:90a:8009:: with SMTP id b9mr8983803pjn.190.1594791204585;
        Tue, 14 Jul 2020 22:33:24 -0700 (PDT)
Received: from software.domain.org ([45.77.13.216])
        by smtp.gmail.com with ESMTPSA id b6sm834747pfp.0.2020.07.14.22.33.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jul 2020 22:33:24 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
Subject: [PATCH] MIPS: CPU#0 is not hotpluggable
Date:   Wed, 15 Jul 2020 13:35:29 +0800
Message-Id: <1594791329-20563-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Now CPU#0 is not hotpluggable on MIPS, so prevent to create /sys/devices
/system/cpu/cpu0/online which confusing some user-space tools.

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

