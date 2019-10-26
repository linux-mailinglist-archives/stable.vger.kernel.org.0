Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01F4FE5A90
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfJZNQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:16:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfJZNQP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:16:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B6FF2070B;
        Sat, 26 Oct 2019 13:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095775;
        bh=zsCfej5/3HVGt1LmhAowMZJP339FutiqxSS2vEQtYgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V8fTheVabvwYpwr8jzwaKIJkJTTg0ZyHDfUKlRTf3kMV0G4uV5m9aH1sQnKkza768
         iSS8Tmq3ZIBs6aTjLvASzCziRaeLgEwDO33cnDdZ9Eg9wAJ3TNhaivMN/kMCFw7eJR
         ZEQG6ebBSMVkR8rOIBz5pcy27no2lCF8WZa3cpN4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Black <daniel@linux.ibm.com>, Tao Xu <tao3.xu@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 06/99] ACPI: HMAT: ACPI_HMAT_MEMORY_PD_VALID is deprecated since ACPI-6.3
Date:   Sat, 26 Oct 2019 09:14:27 -0400
Message-Id: <20191026131600.2507-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Black <daniel@linux.ibm.com>

[ Upstream commit 35b9ad840892d979dbeffe702dae95a3cbefa07b ]

ACPI-6.3 corresponds to when HMAT revision was bumped
from 1 to 2. In this version ACPI_HMAT_MEMORY_PD_VALID
was deprecated and made reserved.

As such in revision 2+ we shouldn't be testing this flag.

This is as per ACPI-6.3, 5.2.27.3, Table 5-145
"Memory Proximity Domain Attributes Structure"
for Flags.

Signed-off-by: Daniel Black <daniel@linux.ibm.com>
Reviewed-by: Tao Xu <tao3.xu@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/hmat/hmat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/hmat/hmat.c b/drivers/acpi/hmat/hmat.c
index 96b7d39a97c65..e938e34673d98 100644
--- a/drivers/acpi/hmat/hmat.c
+++ b/drivers/acpi/hmat/hmat.c
@@ -382,7 +382,7 @@ static int __init hmat_parse_proximity_domain(union acpi_subtable_headers *heade
 		pr_info("HMAT: Memory Flags:%04x Processor Domain:%d Memory Domain:%d\n",
 			p->flags, p->processor_PD, p->memory_PD);
 
-	if (p->flags & ACPI_HMAT_MEMORY_PD_VALID) {
+	if (p->flags & ACPI_HMAT_MEMORY_PD_VALID && hmat_revision == 1) {
 		target = find_mem_target(p->memory_PD);
 		if (!target) {
 			pr_debug("HMAT: Memory Domain missing from SRAT\n");
-- 
2.20.1

