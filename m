Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAE2414EB3
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236923AbhIVREh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236920AbhIVRE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:04:27 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AB3C061762;
        Wed, 22 Sep 2021 10:02:57 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id y1so2164200plk.10;
        Wed, 22 Sep 2021 10:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ETleUGqj8okouLW+8qnjHS0760cK4CL53iB0k0eC4GY=;
        b=Dprf5xWzJ9KPg3xS9vOEKpHkriRgiOvViVnv+zMjKPVwOOHn/yR8y46EtYYp7I9I5M
         Oq1jwvqUycvK3kiLKpf7irjLxhFTMv6SGPTemN267XAbndpFW26qcceDD96wh5SDh6+U
         ulqQaZa8Qk70xIKqjwqE1T1szjjLlpocojYL80kArIwdq5/FztXBcgue95ol7l9EMeNv
         t4vlkA9t584fPr40FAPsET5xSvH5drMkr3wmBjesZCsH3GWihYW+AD93HAxBAZTmqI/7
         zENWeqZReuG/Qcdy/QWhTh4hbz7RzNrIKdictFBn+Fmkk+FnAP9iF31VK0pbt4+Zyiwk
         efHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ETleUGqj8okouLW+8qnjHS0760cK4CL53iB0k0eC4GY=;
        b=FQQhCm2I03IT4zZZ0CFas7H/z7Zud2CwD3RPXIaVBIfiguUk5RweJ4/y2XDeOElTDS
         g7GnSJf9cRgbpTUFK3y6kkttHQ2cQ8rJ2oKzhjuNVjtE/5GF6i797l8S+GBn8BR1YldR
         VpQ3R2FOXfX2/waySqSM9q3MKNmOYwYHDFnyGq6gMrO0a6zC+s1zwzpdd6GB78gJGh4E
         +nq2/SEZGk8z9DRKaTpSj1QubR4ydRX4ZV3JhcS1W7dppFAv8zb/cNgkDXe2uZAfW20G
         ZloupyvD+e0afPgKFe4VUu5IN+3nLa1Emrg5E65n10FRz6yGFClvBKp1K6DS/5Ic4cMu
         JvKQ==
X-Gm-Message-State: AOAM533qrKWpejU4wzCOpFZRSiswzloKLq2ep2bwJHmSNFtcXAB/Y/vi
        i0cnXIb2uCpB0/MXYxd2D9m/K53wQ4c=
X-Google-Smtp-Source: ABdhPJxIRGttokXOiwMnk+mLwRFxpSFSzxwc6uPdqvzruvSa4OJ01GDEtk166KRDrXZ4Yhp7boYjbg==
X-Received: by 2002:a17:90a:de0b:: with SMTP id m11mr78704pjv.90.1632330176614;
        Wed, 22 Sep 2021 10:02:56 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x128sm3061885pfd.203.2021.09.22.10.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:02:56 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Alex Sverdlin <alexander.sverdlin@nokia.com>,
        kernel test robot <lkp@intel.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT)
Subject: [PATCH stable 4.9 v2 4/4] ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without DYNAMIC_FTRACE
Date:   Wed, 22 Sep 2021 10:02:46 -0700
Message-Id: <20210922170246.190499-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922170246.190499-1-f.fainelli@gmail.com>
References: <20210922170246.190499-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Sverdlin <alexander.sverdlin@nokia.com>

commit 6fa630bf473827aee48cbf0efbbdf6f03134e890 upstream

FTRACE_ADDR is only defined when CONFIG_DYNAMIC_FTRACE is defined, the
latter is even stronger requirement than CONFIG_FUNCTION_TRACER (which is
enough for MCOUNT_ADDR).

Link: https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/ZUVCQBHDMFVR7CCB7JPESLJEWERZDJ3T/

Fixes: 1f12fb25c5c5d22f ("ARM: 9079/1: ftrace: Add MODULE_PLTS support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/kernel/module-plts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/module-plts.c b/arch/arm/kernel/module-plts.c
index 6804a145be11..ed0e09cc735f 100644
--- a/arch/arm/kernel/module-plts.c
+++ b/arch/arm/kernel/module-plts.c
@@ -24,7 +24,7 @@
 #endif
 
 static const u32 fixed_plts[] = {
-#ifdef CONFIG_FUNCTION_TRACER
+#ifdef CONFIG_DYNAMIC_FTRACE
 	FTRACE_ADDR,
 	MCOUNT_ADDR,
 #endif
-- 
2.25.1

