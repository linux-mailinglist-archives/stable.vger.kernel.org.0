Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C398A67E1E5
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 11:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbjA0Kkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 05:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbjA0Kkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 05:40:39 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543C5233D1
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:40:27 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id d4-20020a05600c3ac400b003db1de2aef0so3131158wms.2
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZ/dbwvC/OCtxSOOA9d0W6psKQ4eaQ3lNNXdRstbkvE=;
        b=X8+c4bFDhkMae3h9yR37umPXww2KuYISs2Z4DzhfxCcstci/9R35mJh1PjSvLNS8c9
         EaZVlfYCsYnvToqRUGEYaSL3t9ZhpqXV/CpzVm95kXNJDnZpFyHzl/OnH1zMQTqUiAU/
         DACtZaEq075QrpzVGASl3D0IeI7FJBaV4hciAOCyQ3u98LqO6GA5ulXfFEjD0mXqnzB2
         MAThoSN6DalvumbBGq3CFJ1t2tkVvkGPn4UVamRYJS72g8KhmRzTnNSEb27DGFPX/iiO
         iLiGLmkTcWNTYpqlZzQbK7VFtrFWA4ZxH+22XdMHBnKpxh+EsYxhQ94PUTn5hKDUStCq
         +knQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YZ/dbwvC/OCtxSOOA9d0W6psKQ4eaQ3lNNXdRstbkvE=;
        b=1oHddjda0C7aLPZSjvqisG8Mp2uKxuDr8i7PE8xJCRTtKPcVL1avd8+j8iZqWd7otO
         OdAaQYPtW4V4pHqrSSn7wNLaItKwxE+ESmlnXep00bCA1x3uQQGAQSKXUNQornZJEzRI
         y8s6xHcO/mpwDdAv/aqT++3JGOEWQtG+Sr66ZPNTFjUNh2cG3oCTSHDTSX1TAk4/Mb9+
         xdzqA22STlyBjklNazsrElIrMCwqtOYAdbj+GjqB4WpPnm88mFN7ddNPdD30NZHFrwy0
         Gj2oTXiaCEmxdW5xWQYrDPwDEPy4ai4HwuNva9mPNDZCkwAamDZrF28udhp9uB3+uqHw
         qPTQ==
X-Gm-Message-State: AFqh2kpn+PWPF8M1Wts9Hypg5BODspoEjyJLSVvoO7id4jO2ZHS3+7k6
        XARiZpQwoSxQo4dkyNsdaflxog==
X-Google-Smtp-Source: AMrXdXunRyCNUeRvYQwcSeNf87YzGs38JNZ4bVyc3TExAaKLL5xqHLa6C46l/motOy17v0nF47IsQA==
X-Received: by 2002:a7b:c5d6:0:b0:3d9:fb89:4e3d with SMTP id n22-20020a7bc5d6000000b003d9fb894e3dmr40936818wmk.28.1674816025916;
        Fri, 27 Jan 2023 02:40:25 -0800 (PST)
Received: from localhost.localdomain ([5.133.47.210])
        by smtp.gmail.com with ESMTPSA id q9-20020a1ce909000000b003dc34edacf8sm1619787wmc.31.2023.01.27.02.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 02:40:25 -0800 (PST)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 03/10] nvmem: core: initialise nvmem->id early
Date:   Fri, 27 Jan 2023 10:40:08 +0000
Message-Id: <20230127104015.23839-4-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127104015.23839-1-srinivas.kandagatla@linaro.org>
References: <20230127104015.23839-1-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

The error path for wp_gpio attempts to free the IDA nvmem->id, but
this has yet to be assigned, so will always be zero - leaking the
ID allocated by ida_alloc(). Fix this by moving the initialisation
of nvmem->id earlier.

Cc: stable@vger.kernel.org
Fixes: f7d8d7dcd978 ("nvmem: fix memory leak in error path")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/nvmem/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 321d7d63e068..7394a7598efa 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -770,6 +770,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 		return ERR_PTR(rval);
 	}
 
+	nvmem->id = rval;
+
 	if (config->wp_gpio)
 		nvmem->wp_gpio = config->wp_gpio;
 	else if (!config->ignore_wp)
@@ -785,7 +787,6 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 	kref_init(&nvmem->refcnt);
 	INIT_LIST_HEAD(&nvmem->cells);
 
-	nvmem->id = rval;
 	nvmem->owner = config->owner;
 	if (!nvmem->owner && config->dev->driver)
 		nvmem->owner = config->dev->driver->owner;
-- 
2.25.1

