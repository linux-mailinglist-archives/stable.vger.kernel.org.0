Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03A2272EF4
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbgIUQxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729839AbgIUQsa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:48:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64ABB20874;
        Mon, 21 Sep 2020 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706909;
        bh=4P4HVcRllaTMUZ2xk5y9pq+lQ0ARi20gQIHD4O4ah6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gw06efKTrvz7RvdXeFp9HeC7Uz9nJhl253APv7Sku6n5E00po6YnjECQnriMG8n27
         vT7XLnIbSXqYMkHiEGmBrt2RWHxc0oGRSAYeLEOmMjq1Vc+mXjayWS0Nzzzm89qPQs
         1kxCk1wgjFOr2PUtFjtNb8tSflyih3VRNKwc6Pjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prateek Sood <prsood@codeaurora.org>,
        Takashi Iwai <tiwai@suse.de>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.4 07/72] firmware_loader: fix memory leak for paged buffer
Date:   Mon, 21 Sep 2020 18:30:46 +0200
Message-Id: <20200921163122.228682866@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prateek Sood <prsood@codeaurora.org>

commit 4965b8cd1bc1ffb017e5c58e622da82b55e49414 upstream.

vfree() is being called on paged buffer allocated
using alloc_page() and mapped using vmap().

Freeing of pages in vfree() relies on nr_pages of
struct vm_struct. vmap() does not update nr_pages.
It can lead to memory leaks.

Fixes: ddaf29fd9bb6 ("firmware: Free temporary page table after vmapping")
Signed-off-by: Prateek Sood <prsood@codeaurora.org>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1597957070-27185-1-git-send-email-prsood@codeaurora.org
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/firmware_loader/firmware.h |    2 ++
 drivers/base/firmware_loader/main.c     |   17 +++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/base/firmware_loader/firmware.h
+++ b/drivers/base/firmware_loader/firmware.h
@@ -139,10 +139,12 @@ int assign_fw(struct firmware *fw, struc
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
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -252,9 +252,11 @@ static void __free_fw_priv(struct kref *
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
@@ -268,6 +270,11 @@ static void free_fw_priv(struct fw_priv
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
@@ -275,6 +282,8 @@ void fw_free_paged_buf(struct fw_priv *f
 	if (!fw_priv->pages)
 		return;
 
+	vunmap(fw_priv->data);
+
 	for (i = 0; i < fw_priv->nr_pages; i++)
 		__free_page(fw_priv->pages[i]);
 	kvfree(fw_priv->pages);
@@ -328,10 +337,6 @@ int fw_map_paged_buf(struct fw_priv *fw_
 	if (!fw_priv->data)
 		return -ENOMEM;
 
-	/* page table is no longer needed after mapping, let's free */
-	kvfree(fw_priv->pages);
-	fw_priv->pages = NULL;
-
 	return 0;
 }
 #endif


