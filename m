Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D086B3AE3A1
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 09:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhFUHDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 03:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbhFUHDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 03:03:30 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E80C06175F
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 00:01:17 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id pf4-20020a17090b1d84b029016f6699c3f2so4652884pjb.0
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 00:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=uMzv+T/Wucp5pVssFwhVMxpuZI8wy6p/j6myJL8r3oQ=;
        b=wKAqRToJTrozBDWE1bKnJIGWABV2Nbt/tC9DdB6+S2NMCUfWD8eTQvS/6pTK99JD06
         VuQM28W+rphsDWblnmVEJ7I4hdRkwxlKxb21NOoe1De3WHR2xO72UmZoU04VDVz9B3Ep
         uFh6COeB6e9ypG2o977TrCR7MiJh2WlZhfXRNV4CqytbNZHRs0LyBRL4zCxwlFYkHGhP
         g7XSFUwW812CcwuPKIn6lccsM/5axqAaJ7Q2JXGjbG4zdqJvmOTuaYk6AIkE1uv5UMgK
         PykvZ3ZsWooOr/SYKpIi0zDAFVwEhgMrxLeotybHUk5IfTqkgIbfFCUyDlxSxDJENY33
         /xcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uMzv+T/Wucp5pVssFwhVMxpuZI8wy6p/j6myJL8r3oQ=;
        b=mjtkgfHOmaJiwcWpaapJDcSH2jQQKfS4kHUa9XjfXazfFsQn6v1hWkxUr1xDizUfNF
         LyaOIo6f8/QCEYLcY3W/UF59aTQlYvlNip/aIH+CZ5qufNENcFzypfVVbQzMo/jQwWZ4
         z4GC3g0GTJmjZBuIb4PM5uObwFgnLAQRmS4kFuCvQQCqRAHJfCZrgEUYkYrNahQJmfZ5
         U5p9XFXBiIFr2eRtaD4gLo3QKLV6SXc7SOMvsJPFjB/tGdyf4PG5/tSFT7rS6bMIIp36
         /jYOSvWqr11xaCB6fc5mwNePdPJK4bQvHXLqByxRvhQDFvlEi1ILPUAaZCr1ymMQ8oQL
         lwLg==
X-Gm-Message-State: AOAM533Rko/N3KFcNWm7hzyxdwMzdT/0gETI5agkpflozwk9R3Hh2cpx
        ziVvT5PDIYTKeVizGzk6qx9niA==
X-Google-Smtp-Source: ABdhPJzoGUmOEx/WZyy8xRXKh2BNwe521xh/uf++He4NfZygjklN1uvuVklhO9lI1o2yMjyCmSqGSQ==
X-Received: by 2002:a17:902:720b:b029:113:19d7:2da7 with SMTP id ba11-20020a170902720bb029011319d72da7mr16531354plb.55.1624258876483;
        Mon, 21 Jun 2021 00:01:16 -0700 (PDT)
Received: from tyrell.hq.igel.co.jp (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id n5sm12098478pgf.35.2021.06.21.00.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 00:01:16 -0700 (PDT)
From:   Shunsuke Mie <mie@igel.co.jp>
To:     kishon@ti.com
Cc:     lorenzo.pieralisi@arm.com, bhelgaas@google.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, mie@igel.co.jp
Subject: [PATCH] PCI: endpoint: Fix use after free in pci_epf_remove_cfs()
Date:   Mon, 21 Jun 2021 16:00:58 +0900
Message-Id: <20210621070058.37682-1-mie@igel.co.jp>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

All of entries are freed in a loop, however, the freed entry is accessed
by list_del() after the loop.

When epf driver that includes pci-epf-test unload, the pci_epf_remove_cfs()
is called, and occurred the use after free. Therefore, kernel panics
randomly after or while the module unloading.

I tested this patch with r8a77951-Salvator-xs boards.

Fixes: ef1433f ("PCI: endpoint: Create configfs entry for each pci_epf_device_id table entry")
Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
---
 drivers/pci/endpoint/pci-epf-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/pci-epf-core.c b/drivers/pci/endpoint/pci-epf-core.c
index e9289d10f822..538e902b0ba6 100644
--- a/drivers/pci/endpoint/pci-epf-core.c
+++ b/drivers/pci/endpoint/pci-epf-core.c
@@ -202,8 +202,10 @@ static void pci_epf_remove_cfs(struct pci_epf_driver *driver)
 		return;
 
 	mutex_lock(&pci_epf_mutex);
-	list_for_each_entry_safe(group, tmp, &driver->epf_group, group_entry)
+	list_for_each_entry_safe(group, tmp, &driver->epf_group, group_entry) {
+		list_del(&group->group_entry);
 		pci_ep_cfs_remove_epf_group(group);
+	}
 	list_del(&driver->epf_group);
 	mutex_unlock(&pci_epf_mutex);
 }
-- 
2.17.1

