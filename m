Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDAB5BACEE
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 14:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiIPMER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 08:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiIPMEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 08:04:16 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0DAEAC
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 05:04:15 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id z6so3189431wrq.1
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 05:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=mPLFhGHVYS4W9tS1dcvfB9NP8UzfLXVqTT8hwLQ6Qp8=;
        b=D5OHODgvzrWdOm7CQw9H47TsZxfYEVRdG8l5BxLnaZzAntR3XCxVdNxm32MLZTS7k2
         24kxzEBVVOUCJ+ZG5/aQ7iN/IRQlybypFd0PnSfXmlw/j3nfHhTL+5tUtLvNjv7Wr0fi
         mqYk7IWN4ZyARHNSd8iMqU3UM0ufh7dacX7OnnVz0YNe2LdMFvtEE7zAdyNKpllfHMrd
         gRWNAD+Plu6iVvJ1EDq8NnhXoTY2u4ZbmbNht5v1fYM6ojWB/P3IicMMIDGwrSAQoy6H
         RPw7+c+RqBu6iOqlm6TKsFH3vDCc1l164K2nw/LCKxhgOHX2nGcrjeffiRtdqox1u3RV
         +rnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=mPLFhGHVYS4W9tS1dcvfB9NP8UzfLXVqTT8hwLQ6Qp8=;
        b=mDsQ08avHfuQhwnDBiKj1cpy4veHKX1VZysUfqIq+dciUZ8taXIyEHN8yszGkqdrsy
         flS9z0YbMhVLOvi5M5knuJkw4kqeEx9XJ1c4rsxbcuMhQVHnDdvL1a97QCP7uoI92M/G
         0rNCTSQpI5IBANjP6smLhdL2BXZa8DRuV0GLlEDIS7YqKjaey6+1kg+M3uLlTqAY5NoF
         TEIqWI7jEmTTirnNO3KoxpGYUhnekOhjBcOreuYKWFRjwzXGQXwD2ScyUFkPlch73tip
         lSjSiF9d3I+IkcnLvHytQqpA9YNL9YkH57r2zw5V/NbsY+9YsqftVbUbc5YIBUEeHlyA
         /lRQ==
X-Gm-Message-State: ACrzQf38Sq2Wk9726edXw+g9/qk2C6L4OqP0rnMnrWJqAz55b2Tyfu9J
        KpJGcqOD+d+S2jFc+CvsEM+p1g==
X-Google-Smtp-Source: AMsMyM6cWFe2TlELuBCJ85zIT1+UECvePc5f3DSP3FM/W9vpA5+gaADTwK9AWZjW6rj0dcUVLx3fTQ==
X-Received: by 2002:a5d:5848:0:b0:22a:c104:c2f1 with SMTP id i8-20020a5d5848000000b0022ac104c2f1mr2700157wrf.699.1663329853500;
        Fri, 16 Sep 2022 05:04:13 -0700 (PDT)
Received: from srini-hackbase.lan (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.gmail.com with ESMTPSA id l7-20020adffe87000000b00228da396f9dsm4733168wrr.84.2022.09.16.05.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 05:04:12 -0700 (PDT)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        Gaosheng Cui <cuigaosheng1@huawei.com>, stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH] nvmem: core: Fix memleak in nvmem_register()
Date:   Fri, 16 Sep 2022 13:04:02 +0100
Message-Id: <20220916120402.38753-1-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

dev_set_name will alloc memory for nvmem->dev.kobj.name in
nvmem_register, when nvmem_validate_keepouts failed, nvmem's
memory will be freed and return, but nobody will free memory
for nvmem->dev.kobj.name, there will be memleak, so moving
nvmem_validate_keepouts() after device_register() and let
the device core deal with cleaning name in error cases.

Fixes: de0534df9347 ("nvmem: core: fix error handling while validating keepout regions")
Cc: stable@vger.kernel.org
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
Hi Greg,

Here is a fix in nvmem core which can possibly go in next rc.
Could you please pick this up.

thanks,
Srini

 drivers/nvmem/core.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 1e3c754efd0d..2164efd12ba9 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -829,21 +829,18 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 	nvmem->dev.groups = nvmem_dev_groups;
 #endif
 
-	if (nvmem->nkeepout) {
-		rval = nvmem_validate_keepouts(nvmem);
-		if (rval) {
-			ida_free(&nvmem_ida, nvmem->id);
-			kfree(nvmem);
-			return ERR_PTR(rval);
-		}
-	}
-
 	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
 
 	rval = device_register(&nvmem->dev);
 	if (rval)
 		goto err_put_device;
 
+	if (nvmem->nkeepout) {
+		rval = nvmem_validate_keepouts(nvmem);
+		if (rval)
+			goto err_device_del;
+	}
+
 	if (config->compat) {
 		rval = nvmem_sysfs_setup_compat(nvmem, config);
 		if (rval)
-- 
2.25.1

