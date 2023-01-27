Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433EF67E1F0
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 11:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbjA0Kks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 05:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbjA0Kkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 05:40:41 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CDB68AC2
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:40:33 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id f19-20020a1c6a13000000b003db0ef4dedcso5101487wmc.4
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sr6CA9xjZwvud8xzQyK6dmW2Ra23HBqhT3DLj1X0by0=;
        b=rWfW+A9+dX4D+Iqs4/ibFCmB7czEciSj0MHxvMw1Tmmmyw5Kc/22/Ocevvr8+ZlUmS
         CY7oYhz9T5650eWArL6xtD2IM+VJz5FGEg/MsKDQ5OnTyr2nyOe0nu7rSUhLUlgytMAT
         PrfBnWL90QlVpCPVPv3neli5edKk+ZWj2Xmus07O4IL7LXRMlITk8Tp31Fu+RgYEqprM
         nPGzcF9MOywEqrEg3F/WFs635W/g/CnO5YhldqA488+ThVoWyCxEBjW/rGjDUf4VN2kE
         hcKoaD+FwLjW2xn2medwVmGCEpLwuy2PM12ACAfk9/v1kF6PjP9kw8xP3LRSOQ5AYMZ0
         vTBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sr6CA9xjZwvud8xzQyK6dmW2Ra23HBqhT3DLj1X0by0=;
        b=6nwNm5BGqXSIw0KUY9FQE9Pu7/L+s78vBIMd1gQ2Wbh1hMOyEJtHPBB7Y7bbZldOaF
         eyMzD8hGH/xIf1IaKjEojGAie2+PQRW+Ys2SNFrm99K4j0lgoKtoTw+pAEkaHSgbnubh
         zRJ6eybAKM10bXd8/8l1AF0LYq65o1zi09ZBLKDrj2ZjQ93TJ1I0EBujZuHNAZemIOij
         11o33sFd88ojVdpS+cQZBn0aJ/KOhhkBjsyehujyKsn/fD9w8vWOanlDWX16WNctMrch
         fVfFVOfR1ESwdCfPsFo+TLEPmZ7Q81cFnuJHiktgSMchXGHTqxpkeYiYqCYKRfrzI3Fu
         qXHg==
X-Gm-Message-State: AO0yUKU+xX7LiC92vkTQf+iUCVi26NiKuRVgZJ0tlQTdzazqVBAjd7zg
        9mh3NYJXeJ4N96C5BGEA+bwCrg==
X-Google-Smtp-Source: AK7set+tOtiGVim8zUWkNPhRPkneuLmW0MBPeqbl6VpXdZ8WBbsM96M8ldJ0TjdGk3S0caS1RL/wKA==
X-Received: by 2002:a05:600c:1e0d:b0:3dc:3f1b:6757 with SMTP id ay13-20020a05600c1e0d00b003dc3f1b6757mr728908wmb.15.1674816031564;
        Fri, 27 Jan 2023 02:40:31 -0800 (PST)
Received: from localhost.localdomain ([5.133.47.210])
        by smtp.gmail.com with ESMTPSA id q9-20020a1ce909000000b003dc34edacf8sm1619787wmc.31.2023.01.27.02.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 02:40:30 -0800 (PST)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 07/10] nvmem: core: fix device node refcounting
Date:   Fri, 27 Jan 2023 10:40:12 +0000
Message-Id: <20230127104015.23839-8-srinivas.kandagatla@linaro.org>
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

From: Michael Walle <michael@walle.cc>

In of_nvmem_cell_get(), of_get_next_parent() is used on cell_np. This
will decrement the refcount on cell_np, but cell_np is still used later
in the code. Use of_get_parent() instead and of_node_put() in the
appropriate places.

Cc: stable@vger.kernel.org
Fixes: 69aba7948cbe("nvmem: Add a simple NVMEM framework for consumers")
Fixes: 7ae6478b304b ("nvmem: core: rework nvmem cell instance creation")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/nvmem/core.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index e92c6f1aadbb..cbe5df99db82 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -1237,16 +1237,21 @@ struct nvmem_cell *of_nvmem_cell_get(struct device_node *np, const char *id)
 	if (!cell_np)
 		return ERR_PTR(-ENOENT);
 
-	nvmem_np = of_get_next_parent(cell_np);
-	if (!nvmem_np)
+	nvmem_np = of_get_parent(cell_np);
+	if (!nvmem_np) {
+		of_node_put(cell_np);
 		return ERR_PTR(-EINVAL);
+	}
 
 	nvmem = __nvmem_device_get(nvmem_np, device_match_of_node);
 	of_node_put(nvmem_np);
-	if (IS_ERR(nvmem))
+	if (IS_ERR(nvmem)) {
+		of_node_put(cell_np);
 		return ERR_CAST(nvmem);
+	}
 
 	cell_entry = nvmem_find_cell_entry_by_node(nvmem, cell_np);
+	of_node_put(cell_np);
 	if (!cell_entry) {
 		__nvmem_device_put(nvmem);
 		return ERR_PTR(-ENOENT);
-- 
2.25.1

