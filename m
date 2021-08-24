Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E04D3F640B
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239279AbhHXRAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238854AbhHXQ7H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:59:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB12D6140F;
        Tue, 24 Aug 2021 16:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824247;
        bh=iYpokmwWAAOBxQLa8EwYET1rHDrF+SMvZT+yvW+hgEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERUFFKi5mq76k9wg6SsW30witqwcfnNf32LjLMBD8pIU/sstY3r3Ducb1nkVYCpPc
         IOQ7mwF/fLkCal/c8z7MAIOkr2zWMcU93vyITSjT3mlOAKM+HW0qJxWwJmzV+adYHY
         j/eKQoLmWRE4FhfhmRye0BuqF8W9EhX2X5l6arD7GrSMuHOMXFvBwo4ADVrBPqly9S
         pFk2/g2O7irG1FdKpxrwimewHXXlMPQ94tDIGesPZ7TzXEIm06XlHPR3BOuV7FumwG
         zwu4tbDFGFemiWhk1ACgxsfBqUEBuYyPOKfOpGuSE2FdlatRfhFVV6oXGW/bDqi/m/
         xC3om9OyFL2Qw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 080/127] PCI/sysfs: Use correct variable for the legacy_mem sysfs object
Date:   Tue, 24 Aug 2021 12:55:20 -0400
Message-Id: <20210824165607.709387-81-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Wilczyński <kw@linux.com>

[ Upstream commit 045a9277b5615846c7b662ffaba84e781f08a172 ]

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
Link: https://lore.kernel.org/r/20210812132144.791268-1-kw@linux.com
Signed-off-by: Krzysztof Wilczyński <kw@linux.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index beb8d1f4fafe..fb667d78e7b3 100644
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
2.30.2

