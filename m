Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACEC0A6EE4
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730417AbfICQ3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:29:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730333AbfICQ3S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:29:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E06EC238C5;
        Tue,  3 Sep 2019 16:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528156;
        bh=SMG6crDeDLKZ8Wa1i6tr98xOE7QNGjkD2lNR624+nXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F1NDXQEQLKGTL35X0VYSQ/VSAVEqVTs491ZtuNKKiBCZ+YNn/MGD+GtW5JekTlscZ
         D6+rNSyAGxryq1b+fNmBMgyVS9EJXu1rV1Ae85tNqcNHcY59f1QYNp6HBgy4SLD4sV
         oDIwryH/4QUFv1273WB8oq/N13MCkpTmD7KIidBY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Lianbo Jiang <lijiang@redhat.com>,
        Takashi Iwai <tiwai@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Yaowei Bai <baiyaowei@cmss.chinamobile.com>, bhe@redhat.com,
        dyoung@redhat.com, kexec@lists.infradead.org, mingo@redhat.com,
        x86-ml <x86@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 142/167] resource: Include resource end in walk_*() interfaces
Date:   Tue,  3 Sep 2019 12:24:54 -0400
Message-Id: <20190903162519.7136-142-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit a98959fdbda1849a01b2150bb635ed559ec06700 ]

find_next_iomem_res() finds an iomem resource that covers part of a range
described by "start, end".  All callers expect that range to be inclusive,
i.e., both start and end are included, but find_next_iomem_res() doesn't
handle the end address correctly.

If it finds an iomem resource that contains exactly the end address, it
skips it, e.g., if "start, end" is [0x0-0x10000] and there happens to be an
iomem resource [mem 0x10000-0x10000] (the single byte at 0x10000), we skip
it:

  find_next_iomem_res(...)
  {
    start = 0x0;
    end = 0x10000;
    for (p = next_resource(...)) {
      # p->start = 0x10000;
      # p->end = 0x10000;
      # we *should* return this resource, but this condition is false:
      if ((p->end >= start) && (p->start < end))
        break;

Adjust find_next_iomem_res() so it allows a resource that includes the
single byte at the end of the range.  This is a corner case that we
probably don't see in practice.

Fixes: 58c1b5b07907 ("[PATCH] memory hotadd fixes: find_next_system_ram catch range fix")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Brijesh Singh <brijesh.singh@amd.com>
CC: Dan Williams <dan.j.williams@intel.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Lianbo Jiang <lijiang@redhat.com>
CC: Takashi Iwai <tiwai@suse.de>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Tom Lendacky <thomas.lendacky@amd.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
CC: bhe@redhat.com
CC: dan.j.williams@intel.com
CC: dyoung@redhat.com
CC: kexec@lists.infradead.org
CC: mingo@redhat.com
CC: x86-ml <x86@kernel.org>
Link: http://lkml.kernel.org/r/153805812254.1157.16736368485811773752.stgit@bhelgaas-glaptop.roam.corp.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/resource.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 30e1bc68503b5..155ec873ea4d1 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -319,7 +319,7 @@ int release_resource(struct resource *old)
 EXPORT_SYMBOL(release_resource);
 
 /*
- * Finds the lowest iomem resource existing within [res->start.res->end).
+ * Finds the lowest iomem resource existing within [res->start..res->end].
  * The caller must specify res->start, res->end, res->flags, and optionally
  * desc.  If found, returns 0, res is overwritten, if not found, returns -1.
  * This function walks the whole tree and not just first level children until
@@ -352,7 +352,7 @@ static int find_next_iomem_res(struct resource *res, unsigned long desc,
 			p = NULL;
 			break;
 		}
-		if ((p->end >= start) && (p->start < end))
+		if ((p->end >= start) && (p->start <= end))
 			break;
 	}
 
-- 
2.20.1

