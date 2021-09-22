Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F55414E7C
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236755AbhIVRCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236746AbhIVRCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:02:04 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908B2C06175F;
        Wed, 22 Sep 2021 10:00:34 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id j15so756880plh.7;
        Wed, 22 Sep 2021 10:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iK5EQhH1NycVgnbIOwQx0+/b05SHMZHmUEsfPOHRgE4=;
        b=RrI4nPOjOwZl84LbCP9M1y3Yuhu103H0p1WEbW0PcpiygrbBYanVGpZhESzj1+HUzu
         YVMHl+Jsm8NSv6V6I7epUIoWsqp7aNki4UxXEVF9mADmc3BnNxqsIwO9zAf9rP2VHcCv
         9IKcklZLMDPBBU5kiRa2CKyXoFGKxgXoTlrUdIJswqLhOlK6ncPZDry5gXLVgPXNfs/Z
         wNxpaPo8A8xZuxDLpUeVDbROLyZd8UqqDjcWG9Z+ENaJpJs5Jco4jAO6j9JZkObQjlio
         hoAJXCTF0NAllmQj0mYbtKmXlBONaRm/kHxf9r4lG2joMO/AJQRLmoBY927Zfy94uMWa
         hmKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iK5EQhH1NycVgnbIOwQx0+/b05SHMZHmUEsfPOHRgE4=;
        b=q35E9LrB067O+e7WIDebeKwsPP0falQjQXxCLNjLKaK+5XkNsQOBfv/rIviA2bTHc9
         FjYyOdsoeKZMFpezSpxQ0K6AiZGZJ8Ll64rlTJ07B7q2OfJ5T0NdA/h0pPwiNmltxS3e
         S8rnrjqwjh3yhJFrdXH/YAvs3gH1w7wjH5QwDFDEnbWa2HMqVRim6Oy1udDcmLhiv7e9
         x62WFOhKTuPHfNWsPeSCBLETlaX8+cmPTrHjxJou1v/BhalF6B0TKiBCYOK9DDl0ykp8
         5GwbwaZoHivv2reXj2S9u9c/5A079eeKMbQgb5vNBVGJVGOf7QK/eY7ox3vu+SXVb0yO
         u7kw==
X-Gm-Message-State: AOAM5328XucFny2CzNxjs606yCFhbcz+37tfWoNZ+Lrs/EUZX9eATZ9A
        AQ2opJWXRQH5+C8s1SCUwJu20PFg5Hs=
X-Google-Smtp-Source: ABdhPJxgqvbVh1eBM72iKcIT02ShaCtCLGXltUcGWei1zg5VO7Lqg2DZJ27zZlO78eKuanGPDVEPvg==
X-Received: by 2002:a17:90a:af92:: with SMTP id w18mr59449pjq.98.1632330033651;
        Wed, 22 Sep 2021 10:00:33 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j23sm3196336pfr.208.2021.09.22.10.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:00:32 -0700 (PDT)
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
Subject: [PATCH stable 5.10 v2 4/4] ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without DYNAMIC_FTRACE
Date:   Wed, 22 Sep 2021 09:59:58 -0700
Message-Id: <20210922165958.189843-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922165958.189843-1-f.fainelli@gmail.com>
References: <20210922165958.189843-1-f.fainelli@gmail.com>
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
index a0524ad84e4d..1fc309b41f94 100644
--- a/arch/arm/kernel/module-plts.c
+++ b/arch/arm/kernel/module-plts.c
@@ -22,7 +22,7 @@
 #endif
 
 static const u32 fixed_plts[] = {
-#ifdef CONFIG_FUNCTION_TRACER
+#ifdef CONFIG_DYNAMIC_FTRACE
 	FTRACE_ADDR,
 	MCOUNT_ADDR,
 #endif
-- 
2.25.1

