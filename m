Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADE5419C99A
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389380AbgDBTNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:21 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39069 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388710AbgDBTNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:21 -0400
Received: by mail-wr1-f68.google.com with SMTP id p10so5579216wrt.6
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=s+5z7hpgHx3t3tORDAizZUKeG0vZjm/9fT5OAnVDs+A=;
        b=d5gTPmCM36bAsgxJh3GHjPKin6PTcnrw5STd7gSh/yYDU4ELRmDP4K3nedNuHkUXt+
         Fvzef8lIxdOP+dLYv1S9jRWVUpQueQm96e/R/Li62IgFhoue/UhM5CuHMnT7u+jPPPT8
         cD0sDUxhEg0La/7rO9EMWTzkUXJEmZX7U24zRY9sadpImNsqqd5jAuk9MFbke6ZpXGSB
         g9cMhUMVv2hze57zf9QyHqxyEwueZECxoTlvModAxKKIW7Ap8fGB597tTwaT6b9Ia9G5
         9eC9Tr3UvVm9R4gzPVi+EFyNsQHZko3sdPLzarJwntXSPVFy9c+kSiaUV2fablwAlSqe
         XcFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s+5z7hpgHx3t3tORDAizZUKeG0vZjm/9fT5OAnVDs+A=;
        b=QW3li6CEVgxJ9ZDH3kKy8WbV/OV6SFcnd4womak1CFnPIEV438j3lOApj+QDOTFipC
         WMWUT/3h7PRy+hF7hpn9xxprJHmJS7S1DY8qHmXSh6obENSIPgjMeBVCKz3bC/BY9jQr
         a4jQXGKSeZCCw3vX6IH9xw7JfDmh9NfXfus5Ef7pOp0R4JQ8VjxnkskBC/xTsoEOMRXD
         BlHIYRNwvmtQ1bn/Iy95xOTbzsYe4loIGKzEWSfvVMRCpsIzFPp6Ttm28KaVyMfImZOM
         GkvItmD3YIMc4hNcBmZPuJz6pozgeZicdipeBXFnA8YZvBSka8xaWqpdnY9rC9ssxjJe
         lmOA==
X-Gm-Message-State: AGi0PuaJQKLEbZ0GFDh/y6eC826Vh1qBvAJKgrrRUj1gVK6W+KUErvRt
        yTXsbBJSmH3qLtpRs5UGireBHPsRgaSljQ==
X-Google-Smtp-Source: APiQypKNULeAEzIMrW+sTMN3a5oFZLSXOehtkespZ0GYHpwrIlXjNl7hp3/5PhHpQf4MuUX0ZqMN7Q==
X-Received: by 2002:a5d:4c48:: with SMTP id n8mr4875200wrt.414.1585854798144;
        Thu, 02 Apr 2020 12:13:18 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:17 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 19/33] rpmsg: glink: use put_device() if device_register fail
Date:   Thu,  2 Apr 2020 20:13:39 +0100
Message-Id: <20200402191353.787836-19-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
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
index 53b3a43160f47..b1c15c64cdec3 100644
--- a/drivers/rpmsg/qcom_glink_smem.c
+++ b/drivers/rpmsg/qcom_glink_smem.c
@@ -216,6 +216,7 @@ struct qcom_glink *qcom_glink_smem_register(struct device *parent,
 	ret = device_register(dev);
 	if (ret) {
 		pr_err("failed to register glink edge\n");
+		put_device(dev);
 		return ERR_PTR(ret);
 	}
 
@@ -298,7 +299,7 @@ struct qcom_glink *qcom_glink_smem_register(struct device *parent,
 	return glink;
 
 err_put_dev:
-	put_device(dev);
+	device_unregister(dev);
 
 	return ERR_PTR(ret);
 }
-- 
2.25.1

