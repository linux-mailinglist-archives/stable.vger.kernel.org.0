Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4236F1B2669
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgDUMlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728921AbgDUMlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:41:04 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3600BC061A10
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:04 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g12so3502979wmh.3
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kBbkNev7JBcXLr1TGpXKoVWw/2EDkyMfr9A7uSxU+qU=;
        b=u25KT+8xR5AXQxc68Ku3vgXjhHRqaq7mnRKTG1Wr6wXfo92CDanaVUiTc6e+1jeyZv
         CHmOYTFjpvEGtSc82yvWVoBj6RXF/8zVoUGTYOHeCbJaxrjMvvF4l5kE64H39sJdaGyZ
         Pke5OwKkS3vlyhl60xcsfaEPnXGOQYgS4DYZK+bwmPGjs8xc5cFDhcoVIKNT7Da48m7a
         +/PqqVkmee4p31+ljtam7SaGBWS1w+COfE+SfnjKVFsuKwWj22GzYvMrpLXGJgYz6nw2
         cJ5wvpZGhPlQg4IXaM31sZb70KyxyG35bTEn4eI5UuX31PnUarCMJEsZXGCkb3y+XzXY
         J6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kBbkNev7JBcXLr1TGpXKoVWw/2EDkyMfr9A7uSxU+qU=;
        b=EAGGI8CMccW+h3OP+yD3a3ES58+C8AcEWQSCbYSm/gqojp0iPPpb5CDY2TSZs/uguf
         7s2RBAeBb/WpcP0uLtGtjCXkWcnq8sdbZDtX5MqEgIJtjHuI+nH5v9RyWbwQWhwlFcnU
         BsC3D9rJ3BmQxbS5tTsL5lSA+NVOEhX8QDTkuvNzPvhAbaf1gyx0gFWZ3qf+UTgorba4
         jHhn8nxPeLyrUd0mfs3c9VwZDSyUUNJGXEN48H+JX+2GLIJkLGxMu7OzTKb0iSfqmqDG
         xcY2IAlBZfVX8fYInXunVFNPYFrjvvPBz6BAm13Vh0y2criooNJ7V1+/HtmyWOXQHZ7D
         njMw==
X-Gm-Message-State: AGi0PuakXyQi4qcTlucWXVSVJgTaERgYoarWX0hkRHxrQfmp7ZNiy6uZ
        ClizoHAYn2PECVEm16Gj0NsszFLglAI=
X-Google-Smtp-Source: APiQypJc3MXjPsErcfLAvRFYtP7qzhrLmupmXDdqPvL7RJPHnvSablsnLM9RCtRnohZXiyjtK5OUhw==
X-Received: by 2002:a1c:4c10:: with SMTP id z16mr4784518wmf.77.1587472862641;
        Tue, 21 Apr 2020 05:41:02 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:41:01 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 13/24] rpmsg: glink: use put_device() if device_register fail
Date:   Tue, 21 Apr 2020 13:40:06 +0100
Message-Id: <20200421124017.272694-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Yadav <arvind.yadav.cs@gmail.com>

[ Upstream commit a9011726c4bb37e5d6a7279bf47fcc19cd9d3e1a ]

if device_register() returned an error! Always use put_device()
to give up the reference initialized. And unregister device for
other return error.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/rpmsg/qcom_glink_smem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rpmsg/qcom_glink_smem.c b/drivers/rpmsg/qcom_glink_smem.c
index 2b54e71886d9c..69a14041ef1fe 100644
--- a/drivers/rpmsg/qcom_glink_smem.c
+++ b/drivers/rpmsg/qcom_glink_smem.c
@@ -212,6 +212,7 @@ struct qcom_glink *qcom_glink_smem_register(struct device *parent,
 	ret = device_register(dev);
 	if (ret) {
 		pr_err("failed to register glink edge\n");
+		put_device(dev);
 		return ERR_PTR(ret);
 	}
 
@@ -294,7 +295,7 @@ struct qcom_glink *qcom_glink_smem_register(struct device *parent,
 	return glink;
 
 err_put_dev:
-	put_device(dev);
+	device_unregister(dev);
 
 	return ERR_PTR(ret);
 }
-- 
2.25.1

