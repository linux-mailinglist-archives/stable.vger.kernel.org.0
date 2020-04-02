Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B517019C9E0
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgDBTSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:18:21 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38514 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389486AbgDBTSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:18:21 -0400
Received: by mail-wm1-f67.google.com with SMTP id f6so4957990wmj.3
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5ViWoK06xQspHTq5fSoOq1VehibGSMcOWc3+p1ggF7w=;
        b=kCykBnSZeXynX7WMhKEUNnXlNINAJ0Z1S0422jqmxF4a+kR8umpE1acde+/vlKQaOu
         Hu0cPs+MiWRSvZuhDp0MBPRCfvx/rEcAn5C46kkdDm+D7Ge9YLCpgGy6ihvcg6viykbK
         z6E11P2ooN6NA5R4HCLqyn0kECzVuabhqRWaHzemfrs8Mo1ZZEeAgxz56NWlb/YeOLFV
         jworYSczGA9cIqbdGS1YFggoKE7g+91yPTGCvGTMYgS9WGCSBqmwt0Ef9NKLURdC7yMh
         nQlwCWEqHpLbM/vIdMjdTQzzQwIM3JjfGGsp2Sac69mjU/Bkzr5O3189D64Ir0jHia09
         z8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5ViWoK06xQspHTq5fSoOq1VehibGSMcOWc3+p1ggF7w=;
        b=r0iNzggTNlUpo5xPlFpyUgS+s4zvWe1/PZP5KZhyiaQvFxOWAoT4gaUuEHqmg9Uw1h
         tO2HCc2TBvqYwc2KqwRxDJWatOs2fM+gya/tVXS0Kqc0pi3PpsUTAxG9xj19IcUFJ0iN
         wvx288FGcR8Yg0fujcw9c/WQ9zxcjtEu+vyqVIWK3P1g+98jzGLzVeGuI71nI5ctrEfL
         q8GNu8e9jxAN65xuHq/uqgEeW9nYaLm4LDmCxGRXnNjR8EhdSnthRoVZ7mWaKMDxIonr
         nCFVxWI85t4dGHZ3FQOanRrV+3g/6rs3Z2j0ChIuzzM8LjwYDj1pl0a5/ta3ENbZn0ai
         r6WQ==
X-Gm-Message-State: AGi0PuZgxGsQa7RXQHAEIp3eU/yvCKeCXexbZs21AxOCwrz9WOMa5TPB
        VQgNLEkTd/28y0vq0Xhbpa/haLa5idK86w==
X-Google-Smtp-Source: APiQypLmPW/Wk8HfoYIq6bi0s5OFg4HBU14ISJnrvM6+ByLpGiic4/uawsHE7K3mqZo6UHaDpuzPtw==
X-Received: by 2002:a05:600c:2197:: with SMTP id e23mr4810369wme.90.1585855099042;
        Thu, 02 Apr 2020 12:18:19 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id l10sm8622707wrq.95.2020.04.02.12.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:18:18 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 17/20] of: fix missing kobject init for !SYSFS && OF_DYNAMIC config
Date:   Thu,  2 Apr 2020 20:18:53 +0100
Message-Id: <20200402191856.789622-17-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191856.789622-1-lee.jones@linaro.org>
References: <20200402191856.789622-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit bd82bbf38cbe27f2c65660da801900d71bcc5cc8 ]

The ref counting is broken for OF_DYNAMIC when sysfs is disabled because
the kobject initialization is skipped. Only the properties
add/remove/update should be skipped for !SYSFS config.

Tested-by: Nicolas Pitre <nico@linaro.org>
Reviewed-by: Frank Rowand <frowand.list@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/of/base.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 27783223ca5cd..8adffecd710b8 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -167,9 +167,6 @@ int __of_attach_node_sysfs(struct device_node *np)
 	struct property *pp;
 	int rc;
 
-	if (!IS_ENABLED(CONFIG_SYSFS))
-		return 0;
-
 	if (!of_kset)
 		return 0;
 
-- 
2.25.1

