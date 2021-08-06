Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8053E269F
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 11:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244050AbhHFJAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 05:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244032AbhHFJAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 05:00:12 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DBCC061799
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 01:59:55 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id o7-20020a05600c5107b0290257f956e02dso8361489wms.1
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 01:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7I/XnXmF8czTUjjocbGR8hsRDQOmub4O/8bSm3IY4iw=;
        b=GDeLZ2K5U8ga4Z+FnNl6UFp5fR8fpLUYILKNqsJVqN00NFcGG558ItPGEn1cWUaoSn
         iBdrzhQgfxK/nNukj/9QbbP9TTCHQveOMRK4/5v+fN4s6N5XFpabdNNQB1UOnl2rVk3c
         nvOG7deUfxTZjsXqhD2QJDMtJQw78q3B1C/IEYI0XyQ7RRr7Dgtc/BcjJsLzm4R0jjFP
         uq8ywxmaW6McZKv09W8/LZbH3nRgJGveEKHmJEpKuSsl/jDzABkwVExm+1PzH5QUpKoQ
         uPTWFMaOucz7nbFWEIzdyiQq2KQqr4aGJrGnkTkoTmFoD+RYj1yEqGK3P+YimWPDOHKU
         bbwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7I/XnXmF8czTUjjocbGR8hsRDQOmub4O/8bSm3IY4iw=;
        b=lbEIDRI8+m1u+4ZOUqAdt9BlqPeHGwTbFPZ/XQrrpzOKUnbOuzgMBR6mjTYciKpOSd
         s59HxpRkNODE4bxIOQMYbTYN9vUXv/hevJII2fHvYfva62NJo3eT3lIVIwDCsGGNL/lW
         Zs93mG6K8Lha5o0qpmMxhRlrXg11OIDgKZ1BoWDIsd7H2pM5G0IGvzfjWAidNIqqb8QQ
         ml5utmDGCrC47xtlkIqyllKb44D0Qkc61TgMMr5M1e6e+byFZWlfiCDyxJs7QCJ/arNQ
         keC5wqOnwOYr0pCu1diZmvP86Pcrt95iBqyGVJXu0yxSjh3Z9oNvZoLUwTTmncPXWh53
         WIOQ==
X-Gm-Message-State: AOAM533uQQeJrwIhg9y/AP1d/AKEny4Mo0aGbt70KKlUSshyiG7iuV6Q
        Erk3F+ifFwUDtBnR8XABtTeMTw==
X-Google-Smtp-Source: ABdhPJwY/0DH9so/zpRJPRIoFxari7FEOgjs7L1BrooxREARu6SzXahpJCbg9b/wJAwfx49Iz2lcTQ==
X-Received: by 2002:a05:600c:4f4d:: with SMTP id m13mr2188796wmq.32.1628240394472;
        Fri, 06 Aug 2021 01:59:54 -0700 (PDT)
Received: from srini-hackbox.lan (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.gmail.com with ESMTPSA id x18sm8506144wrw.19.2021.08.06.01.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 01:59:54 -0700 (PDT)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 4/4] nvmem: core: fix error handling while validating keepout regions
Date:   Fri,  6 Aug 2021 09:59:47 +0100
Message-Id: <20210806085947.22682-5-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210806085947.22682-1-srinivas.kandagatla@linaro.org>
References: <20210806085947.22682-1-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Current error path on failure of validating keepout regions is calling
put_device, eventhough the device is not even registered at that point.

Fix this by adding proper error handling of freeing ida and nvmem.

Fixes: fd3bb8f54a88 ("nvmem: core: Add support for keepout regions")
Cc: <stable@vger.kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/nvmem/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index b3bc30a04ed7..3d87fadaa160 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -824,8 +824,11 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 
 	if (nvmem->nkeepout) {
 		rval = nvmem_validate_keepouts(nvmem);
-		if (rval)
-			goto err_put_device;
+		if (rval) {
+			ida_free(&nvmem_ida, nvmem->id);
+			kfree(nvmem);
+			return ERR_PTR(rval);
+		}
 	}
 
 	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
-- 
2.21.0

