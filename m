Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD4624C6E9
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 22:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgHTU65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 16:58:57 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:56139 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728146AbgHTU64 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 16:58:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597957135; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=FJnUZ8hSOEwfDswhjf6p3X1DWgepHwpYrB7MhBJr5Ig=; b=S9XAOM/fcJ0DKV9lcTKw5Fz0UA5SutNvJR9Blezn0CCd9igqP39wsiiR73KOifhFCPUM8Zt4
 aS+3SserXrpgkv7FvoFzbb1o6l00Sh/UfDGKV5uYmHQOg87k83GcztAFji8kqfr/d/l9XLtF
 t28RLQ0fu605J4CcV5vuWgxFwmI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5f3ee3d6f37da9fb0e87a339 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 20 Aug 2020 20:57:58
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5E9DDC4339C; Thu, 20 Aug 2020 20:57:57 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from localhost (unknown [202.46.22.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: prsood)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9FBB1C433CB;
        Thu, 20 Aug 2020 20:57:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9FBB1C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=prsood@codeaurora.org
From:   Prateek Sood <prsood@codeaurora.org>
To:     tiwai@suse.de, mcgrof@kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Prateek Sood <prsood@codeaurora.org>
Subject: [PATCH v3] firmware_loader: fix memory leak for paged buffer
Date:   Fri, 21 Aug 2020 02:27:50 +0530
Message-Id: <1597957070-27185-1-git-send-email-prsood@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <s5h364lpj3d.wl-tiwai@suse.de>
References: <s5h364lpj3d.wl-tiwai@suse.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

vfree() is being called on paged buffer allocated
using alloc_page() and mapped using vmap().

Freeing of pages in vfree() relies on nr_pages of
struct vm_struct. vmap() does not update nr_pages.
It can lead to memory leaks.

Fixes: ddaf29fd9bb6 ("firmware: Free temporary page table after vmapping")
Signed-off-by: Prateek Sood <prsood@codeaurora.org>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Cc: stable@vger.kernel.org
---
 drivers/base/firmware_loader/firmware.h |  2 ++
 drivers/base/firmware_loader/main.c     | 17 +++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/base/firmware_loader/firmware.h b/drivers/base/firmware_loader/firmware.h
index 933e2192..d08efc7 100644
--- a/drivers/base/firmware_loader/firmware.h
+++ b/drivers/base/firmware_loader/firmware.h
@@ -142,10 +142,12 @@ static inline void fw_state_done(struct fw_priv *fw_priv)
 void fw_free_paged_buf(struct fw_priv *fw_priv);
 int fw_grow_paged_buf(struct fw_priv *fw_priv, int pages_needed);
 int fw_map_paged_buf(struct fw_priv *fw_priv);
+bool fw_is_paged_buf(struct fw_priv *fw_priv);
 #else
 static inline void fw_free_paged_buf(struct fw_priv *fw_priv) {}
 static inline int fw_grow_paged_buf(struct fw_priv *fw_priv, int pages_needed) { return -ENXIO; }
 static inline int fw_map_paged_buf(struct fw_priv *fw_priv) { return -ENXIO; }
+static inline bool fw_is_paged_buf(struct fw_priv *fw_priv) { return false; }
 #endif
 
 #endif /* __FIRMWARE_LOADER_H */
diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index ca871b1..36bf455 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -252,9 +252,11 @@ static void __free_fw_priv(struct kref *ref)
 	list_del(&fw_priv->list);
 	spin_unlock(&fwc->lock);
 
-	fw_free_paged_buf(fw_priv); /* free leftover pages */
-	if (!fw_priv->allocated_size)
+	if (fw_is_paged_buf(fw_priv))
+		fw_free_paged_buf(fw_priv);
+	else if (!fw_priv->allocated_size)
 		vfree(fw_priv->data);
+
 	kfree_const(fw_priv->fw_name);
 	kfree(fw_priv);
 }
@@ -268,6 +270,11 @@ static void free_fw_priv(struct fw_priv *fw_priv)
 }
 
 #ifdef CONFIG_FW_LOADER_PAGED_BUF
+bool fw_is_paged_buf(struct fw_priv *fw_priv)
+{
+	return fw_priv->is_paged_buf;
+}
+
 void fw_free_paged_buf(struct fw_priv *fw_priv)
 {
 	int i;
@@ -275,6 +282,8 @@ void fw_free_paged_buf(struct fw_priv *fw_priv)
 	if (!fw_priv->pages)
 		return;
 
+	vunmap(fw_priv->data);
+
 	for (i = 0; i < fw_priv->nr_pages; i++)
 		__free_page(fw_priv->pages[i]);
 	kvfree(fw_priv->pages);
@@ -328,10 +337,6 @@ int fw_map_paged_buf(struct fw_priv *fw_priv)
 	if (!fw_priv->data)
 		return -ENOMEM;
 
-	/* page table is no longer needed after mapping, let's free */
-	kvfree(fw_priv->pages);
-	fw_priv->pages = NULL;
-
 	return 0;
 }
 #endif
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc., 
is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

