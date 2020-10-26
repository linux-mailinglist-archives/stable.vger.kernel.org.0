Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446EB299CD0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437379AbgJ0AB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:01:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411103AbgJZX4T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:56:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FF72221FA;
        Mon, 26 Oct 2020 23:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756579;
        bh=6XoUXnIdvL4XZT7z50zvJBq5nImrK/02lhXRe6OvHEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wBAfVOAQI7g6vdNKDskrBg1iRLuZ2y6pjQdwgrQ2UvOPqOwXITnxBSkT1ghrjoW8l
         o3YhCyzUBlSae0vO2raLaN7iEpKAhdeu8srOxJDOa3lldKGVGRNG2lQNX1647X6KTf
         rKb8FBK6f+MXak4EHDCJB58fRzgj8HqVdhfP8z6E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 52/80] ACPI: HMAT: Fix handling of changes from ACPI 6.2 to ACPI 6.3
Date:   Mon, 26 Oct 2020 19:54:48 -0400
Message-Id: <20201026235516.1025100-52-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235516.1025100-1-sashal@kernel.org>
References: <20201026235516.1025100-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 2c5b9bde95c96942f2873cea6ef383c02800e4a8 ]

In ACPI 6.3, the Memory Proximity Domain Attributes Structure
changed substantially.  One of those changes was that the flag
for "Memory Proximity Domain field is valid" was deprecated.

This was because the field "Proximity Domain for the Memory"
became a required field and hence having a validity flag makes
no sense.

So the correct logic is to always assume the field is there.
Current code assumes it never is.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/hmat/hmat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/hmat/hmat.c b/drivers/acpi/hmat/hmat.c
index 8b0de8a3c6470..0f1c939b7e901 100644
--- a/drivers/acpi/hmat/hmat.c
+++ b/drivers/acpi/hmat/hmat.c
@@ -403,7 +403,8 @@ static int __init hmat_parse_proximity_domain(union acpi_subtable_headers *heade
 		pr_info("HMAT: Memory Flags:%04x Processor Domain:%d Memory Domain:%d\n",
 			p->flags, p->processor_PD, p->memory_PD);
 
-	if (p->flags & ACPI_HMAT_MEMORY_PD_VALID && hmat_revision == 1) {
+	if ((hmat_revision == 1 && p->flags & ACPI_HMAT_MEMORY_PD_VALID) ||
+	    hmat_revision > 1) {
 		target = find_mem_target(p->memory_PD);
 		if (!target) {
 			pr_debug("HMAT: Memory Domain missing from SRAT\n");
-- 
2.25.1

