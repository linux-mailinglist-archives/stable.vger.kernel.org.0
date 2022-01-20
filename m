Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DD6494F2C
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 14:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238938AbiATNkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 08:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbiATNkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 08:40:55 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE06FC061574;
        Thu, 20 Jan 2022 05:40:54 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id w26so12275411wmi.0;
        Thu, 20 Jan 2022 05:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VDkNSsPJEfKQRWGToPkLFqx2eL9VH9/2+z4FYHRDpb4=;
        b=EyCwPGHfYRycr8FI3MjCnCEIJ6dBkJFgRribeAGi8yMOQFU0VVW44aQjFg6hSypBPO
         AJ5M0KuNUvBvRwUvGu1nLXBTSKZ88mx24JlSzixDlVdzaSnam3C1prUDENEDdHoYzpLs
         DaY4Pi8t8/dDYu6B/wuFWLXosi0ydHPvv24HP4AxQtFCZJiSx/ERFS6WWw8nG0/NwGwi
         tTbVTvsJCZhIyS18t/TSA5wuTb67/wXfW3D6fDNL8jCWDgIQSthWW5m3PlTIX3r9mbOb
         kC1F09Om7P4z5Hs+jGfwa3Z1YEXx+Tb7lPkzQcJsE/KR8J5PLm95oFadpjooUk5lQonq
         1vuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VDkNSsPJEfKQRWGToPkLFqx2eL9VH9/2+z4FYHRDpb4=;
        b=qeS58mGfpWclLQS3niHKkXA3M0ntOnXlM0o5f7I9wthNankhheQaP/flWZZIQTUYFC
         0pBSzOhLaX4PTA7oybekg3VIDRvbTXQGRcHCvStjIxc/JA8CQSRsL5E80rn6FuwYxJh6
         N3+6/igHgbvbJFymQi8gIT0zI7X4pncnOp2JJCt9OHzF6CpNbBSdu3a5onEwR4Gjoa41
         WFVq2qfqYIHUq96rWr5yJifeGOJ83Lx3AfZDFC0mueI39ev561z69/MoT2ecjdYdRMgI
         VEvFzg/dpKGg0b1OZ6xxpq4UDDdVZEzg0SsY5XZ3GpeY7eEXhxmqoIkY01uhToD5x13K
         crLg==
X-Gm-Message-State: AOAM5310zr7iwuHw/KHR5Q2uokOT+v7pkczGilAy1XpT/b0uDiYYwkod
        LcV5TNvexbednoP0Z0L9VKA=
X-Google-Smtp-Source: ABdhPJyLbpBGaZOjXLATEW/7UbCYN0jrAQ/HCqDpjyM0+LTqpL6v8hr5QQmkiH/rrnG5W3ix5bTt4w==
X-Received: by 2002:adf:f850:: with SMTP id d16mr5001363wrq.303.1642686053369;
        Thu, 20 Jan 2022 05:40:53 -0800 (PST)
Received: from localhost.localdomain ([195.245.21.30])
        by smtp.gmail.com with ESMTPSA id f10sm3094344wri.50.2022.01.20.05.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 05:40:52 -0800 (PST)
From:   Alexander Sverdlin <alexander.sverdlin@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@armlinux.org.uk>,
        Nikita Shubin <nikita.shubin@maquefel.me>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: [PATCH] ep93xx: clock: Fix UAF in ep93xx_clk_register_gate()
Date:   Thu, 20 Jan 2022 14:37:38 +0100
Message-Id: <20220120133739.4170298-1-alexander.sverdlin@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

arch/arm/mach-ep93xx/clock.c:151:2: note: Taking true branch
if (IS_ERR(clk))
^
arch/arm/mach-ep93xx/clock.c:152:3: note: Memory is released
kfree(psc);
^~~~~~~~~~
arch/arm/mach-ep93xx/clock.c:154:2: note: Use of memory after it is freed
return &psc->hw;
^ ~~~~~~~~

Link: https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/B5YCO2NJEXINCYE26Y255LCVMO55BGWW/
Reported-by: kernel test robot <lkp@intel.com>
Fixes: 9645ccc7bd7a ("ep93xx: clock: convert in-place to COMMON_CLK")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
---
 arch/arm/mach-ep93xx/clock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-ep93xx/clock.c b/arch/arm/mach-ep93xx/clock.c
index cc75087134d3..4aee14f18123 100644
--- a/arch/arm/mach-ep93xx/clock.c
+++ b/arch/arm/mach-ep93xx/clock.c
@@ -148,8 +148,10 @@ static struct clk_hw *ep93xx_clk_register_gate(const char *name,
 	psc->lock = &clk_lock;
 
 	clk = clk_register(NULL, &psc->hw);
-	if (IS_ERR(clk))
+	if (IS_ERR(clk)) {
 		kfree(psc);
+		return (void *)clk;
+	}
 
 	return &psc->hw;
 }
-- 
2.34.1

