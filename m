Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E2D472C41
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 13:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234646AbhLMM15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 07:27:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23612 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234833AbhLMM14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 07:27:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639398476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=GiXBKC4rsXrhnyr9y2gHyHTAuu9t2uz+7DL/EoCgsgE=;
        b=ee5wUzDpH4c72tpq8eQS7cs3uO+YiwfYcC6wmoin3c3nbNUCzvcVSyrBZOfIVd/+GnuisT
        fx3jxY5IgMkE6uJh6AHdraaOImwv1kpiQpARcYE7+RsFmAWgYVCB7ATetJ5B57QI7NvKny
        4IVeMC59Xk4Uz25E5Od5dsOoDtzfvuk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-23-tI6aIu55PAyhn_NMucJ9Cg-1; Mon, 13 Dec 2021 07:27:53 -0500
X-MC-Unique: tI6aIu55PAyhn_NMucJ9Cg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D801874990;
        Mon, 13 Dec 2021 12:27:51 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (ovpn-12-202.pek2.redhat.com [10.72.12.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D90A78342;
        Mon, 13 Dec 2021 12:27:48 +0000 (UTC)
From:   Baoquan He <bhe@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
        cl@linux.com, John.p.donnelly@oracle.com,
        kexec@lists.infradead.org, bhe@redhat.com, stable@vger.kernel.org
Subject: [PATCH v3 3/5] mm_zone: add function to check if managed dma zone exists
Date:   Mon, 13 Dec 2021 20:27:10 +0800
Message-Id: <20211213122712.23805-4-bhe@redhat.com>
In-Reply-To: <20211213122712.23805-1-bhe@redhat.com>
References: <20211213122712.23805-1-bhe@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In some places of the current kernel, it assumes that dma zone must have
managed pages if CONFIG_ZONE_DMA is enabled. While this is not always true.
E.g in kdump kernel of x86_64, only low 1M is presented and locked down
at very early stage of boot, so that there's no managed pages at all in
DMA zone. This exception will always cause page allocation failure if page
is requested from DMA zone.

Here add function has_managed_dma() and the relevant helper functions to
check if there's DMA zone with managed pages. It will be used in later
patches.

Fixes: 6f599d84231f ("x86/kdump: Always reserve the low 1M when the crashkernel option is specified")
Cc: stable@vger.kernel.org
Signed-off-by: Baoquan He <bhe@redhat.com>
---
v2->v3:
 Rewrite has_managed_dma() in a simpler and more efficient way which is
 sugggested by DavidH. 

 include/linux/mmzone.h |  9 +++++++++
 mm/page_alloc.c        | 15 +++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 58e744b78c2c..6e1b726e9adf 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1046,6 +1046,15 @@ static inline int is_highmem_idx(enum zone_type idx)
 #endif
 }
 
+#ifdef CONFIG_ZONE_DMA
+bool has_managed_dma(void);
+#else
+static inline bool has_managed_dma(void)
+{
+	return false;
+}
+#endif
+
 /**
  * is_highmem - helper function to quickly check if a struct zone is a
  *              highmem zone or not.  This is an attempt to keep references
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c5952749ad40..7c7a0b5de2ff 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -9460,3 +9460,18 @@ bool take_page_off_buddy(struct page *page)
 	return ret;
 }
 #endif
+
+#ifdef CONFIG_ZONE_DMA
+bool has_managed_dma(void)
+{
+	struct pglist_data *pgdat;
+
+	for_each_online_pgdat(pgdat) {
+		struct zone *zone = &pgdat->node_zones[ZONE_DMA];
+
+		if (managed_zone(zone))
+			return true;
+	}
+	return false;
+}
+#endif /* CONFIG_ZONE_DMA */
-- 
2.17.2

