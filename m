Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554D03EA586
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 15:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237268AbhHLNW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 09:22:57 -0400
Received: from mail-lf1-f49.google.com ([209.85.167.49]:43717 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237248AbhHLNWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 09:22:17 -0400
Received: by mail-lf1-f49.google.com with SMTP id w1so13239009lfq.10;
        Thu, 12 Aug 2021 06:21:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Vn0uzgRzdNDH04gbbOlRqCsW1lwpK0pywcYhQCTW2s=;
        b=X7gGVTkATcwhyr/6QtJseGD5yreJDlcR4qk2BVSiFkEYTmxRtT06IuqkF8OQk3Ru8p
         JdNla7NhDSgt0QTr/Q7fwKSEIYGixrbTOrrQ+mrz7myTLQukos/mCG6bE5ctesO7PvH8
         TRtv1M2y9jeqZoi+LucETKS/kfrsWkgMWwz4JPoclI6ux4HRvY8czqubpZct5Feyu+Rq
         iSQNkq4RnRCOfL8Ie1dgWLBBA34+Y67pMxKNl26TODh4q1rZhm04zwbKfnQ9u+JlXbSm
         iVRSTY18dH5xzN+WNmphMG7lLki1qcf4lxJ5kSTrInydj5DfnPnylE5uC9HN5tKZFKQP
         VehA==
X-Gm-Message-State: AOAM531ZDzTbm3E9j2nOrgBiaCJRFsNFrjpwLaA9QpmuNfMGq12rv+2B
        sTKjGCkuT0d4KqRdhsA0zzo=
X-Google-Smtp-Source: ABdhPJwPSo9EoWN+TXBFBRD8W6263Ns4ijsMHjGg4JNeX8Y1aKFAx3XQ1p9kfW/dHwSwzuAmiKbKxA==
X-Received: by 2002:ac2:5e7a:: with SMTP id a26mr2171842lfr.312.1628774506571;
        Thu, 12 Aug 2021 06:21:46 -0700 (PDT)
Received: from workstation.lan ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id q26sm263306lfb.75.2021.08.12.06.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 06:21:45 -0700 (PDT)
From:   =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] PCI/sysfs: Use correct variable for the legacy_mem sysfs object
Date:   Thu, 12 Aug 2021 13:21:44 +0000
Message-Id: <20210812132144.791268-1-kw@linux.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Two legacy PCI sysfs objects "legacy_io" and "legacy_mem" were updated
to use an unified address space in the commit 636b21b50152 ("PCI: Revoke
mappings like devmem").  This allows for revocations to be managed from
a single place when drivers want to take over and mmap() a /dev/mem
range.

Following the update, both of the sysfs objects should leverage the
iomem_get_mapping() function to get an appropriate address range, but
only the "legacy_io" has been correctly updated - the second attribute
seems to be using a wrong variable to pass the iomem_get_mapping()
function to.

Thus, correct the variable name used so that the "legacy_mem" sysfs
object would also correctly call the iomem_get_mapping() function.

Fixes: 636b21b50152 ("PCI: Revoke mappings like devmem")
Signed-off-by: Krzysztof Wilczyński <kw@linux.com>
---
 drivers/pci/pci-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 5d63df7c1820..7bbf2673c7f2 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -978,7 +978,7 @@ void pci_create_legacy_files(struct pci_bus *b)
 	b->legacy_mem->size = 1024*1024;
 	b->legacy_mem->attr.mode = 0600;
 	b->legacy_mem->mmap = pci_mmap_legacy_mem;
-	b->legacy_io->mapping = iomem_get_mapping();
+	b->legacy_mem->mapping = iomem_get_mapping();
 	pci_adjust_legacy_attr(b, pci_mmap_mem);
 	error = device_create_bin_file(&b->dev, b->legacy_mem);
 	if (error)
-- 
2.32.0

