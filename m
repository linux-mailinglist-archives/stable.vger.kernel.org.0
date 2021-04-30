Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FF636FD97
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 17:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhD3PUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 11:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhD3PUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 11:20:45 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB65AC06174A
        for <stable@vger.kernel.org>; Fri, 30 Apr 2021 08:19:55 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id m12so8891693pgr.9
        for <stable@vger.kernel.org>; Fri, 30 Apr 2021 08:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pTK2+tXKXlDNh7BndZWyfsnbTIToWlHunFXdpF9eDN4=;
        b=KHm1Gcr+1ooqMLOORFEcq8vsqEGfcVMGS5A7xGBnFtSaBYjZUC6CWe0RMeTDD2N+t+
         UrKQm5XqsAV8t81Vgy+wcoro+lyfDdZaoiv84dzNezu8OKbUqoXpHVrsG7EsTz9zVgXq
         hllP/2rtF0SdMpsdM4daAXBRF0p0RCdUwijLWKCOKjVILEzuRzb/e70n7g5vDUkWe6/0
         6VQB0BujPoVaGtZwIsoK5CV3RBTk8SkUk5w6A6M8PXSgJW2p+w9kxZK2N+7GkVD3q9DP
         l/1FEFkAHAZdBwEREuJHJ71ZItj7cnatYXLm8UY6i4ofZ7/UQAMXC+K0gNGx9s57QuRI
         qzHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pTK2+tXKXlDNh7BndZWyfsnbTIToWlHunFXdpF9eDN4=;
        b=BkDLGtHIy16EXWrHzEPFMAAJ6xoQqr6pASbC+zIhVgpl1EadekDPOnUCznx20KLar+
         Z65uD4fGr3M5yFNQi0HNmUcp7POOIKjAXz/YzZMR7YWe0JD52JWEDwTPgrzmM7pYyAN5
         8okdjcW+bbswUSZPC/CzvywMCfFCTnglZm607s3pEQ7DL5x8G8nyO4PT5Iy0Nvf7/5od
         sLvSffhX4pnKTLFKM732wm/i36JQQsRCo63l/hbpaotNaDTqIrTwQHtXDQjcosCKm8jh
         sN3dBjqo1J+yuiCH3Y2kZ0RHPVac2vmGlr2lucWG7le6GqizW9aiFQT8ok2Wtk/lccx8
         EI6Q==
X-Gm-Message-State: AOAM530OIiAE8opTZK5qs8dUMs0utlS+Gz+7KaEJf4kJudjE6s0s+LnW
        8SzqJvtsIM7c5q2ZJwjoI7Y=
X-Google-Smtp-Source: ABdhPJze/0Ajw2DuXXHB7kOE6iF/8WKsEf7hhxwarKVScZpgqm7TlFUJN4Y1gh1xWjYT7PMTjlygsQ==
X-Received: by 2002:a05:6a00:138b:b029:27f:179f:2c20 with SMTP id t11-20020a056a00138bb029027f179f2c20mr5239120pfg.37.1619795995430;
        Fri, 30 Apr 2021 08:19:55 -0700 (PDT)
Received: from stbsrv-and-01.and.broadcom.net ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id oa9sm2215031pjb.44.2021.04.30.08.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 08:19:55 -0700 (PDT)
From:   Jim Quinlan <jim2101024@gmail.com>
To:     james.quinlan@broadcom.com, jim2101024@gmail.com
Cc:     stable@vger.kernel.org
Subject: [PATCH v6 1/3] reset: add missing empty function reset_control_rearm()
Date:   Fri, 30 Apr 2021 11:19:47 -0400
Message-Id: <20210430151949.20849-2-jim2101024@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430151949.20849-1-jim2101024@gmail.com>
References: <20210430151949.20849-1-jim2101024@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

All other functions are defined for when CONFIG_RESET_CONTROLLER
is not set.

Fixes: 557acb3d2cd9 ("reset: make shared pulsed reset controls re-triggerable")
CC: stable@vger.kernel.org # v5.11+
Signed-off-by: Jim Quinlan <jim2101024@gmail.com>
---
 include/linux/reset.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/reset.h b/include/linux/reset.h
index b9109efa2a5c..9700124affa3 100644
--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -47,6 +47,11 @@ static inline int reset_control_reset(struct reset_control *rstc)
 	return 0;
 }
 
+static inline int reset_control_rearm(struct reset_control *rstc)
+{
+	return 0;
+}
+
 static inline int reset_control_assert(struct reset_control *rstc)
 {
 	return 0;
-- 
2.17.1

