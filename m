Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743C53BC02E
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbhGEPex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:34:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232937AbhGEPd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:33:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D64DB6199F;
        Mon,  5 Jul 2021 15:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499053;
        bh=DMZ1J9U1ljW101f398mx03Ld/9jbweqZcVMb6ReUrG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZKYvo4QO564CMJoDtuXAgmSn/SvVhBTomYUYhhsjGxBoaKdx+S1zg9xaUkeKjRwJ
         KvVtnKwRu1jXQn48xtUOdHod/eidqMzOwlTeM7ajYV46+jk/S7Ac8hlhfnqFAGbwbf
         HuRhzx2XUlu/1whg9zcbKKYGpeCoIdKWWbS9IU6a9g+vrG2zF3GvwhvESoFQqBA8j+
         GJhAsyyqza4yNA1hiN39EBVe7AoaiCmNI9VAOPQkmfamjRyGPE4erEb3z7X0oC2/Zv
         ZoWXXemgTuZli8l+9rObsW+powAcoisoHS31pvPH3Z3co35rbNejC66lIxGKFEc8vF
         B23pfz+EhuYqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erik Kaneda <erik.kaneda@intel.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 5.4 11/26] ACPICA: Fix memory leak caused by _CID repair function
Date:   Mon,  5 Jul 2021 11:30:24 -0400
Message-Id: <20210705153039.1521781-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153039.1521781-1-sashal@kernel.org>
References: <20210705153039.1521781-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erik Kaneda <erik.kaneda@intel.com>

[ Upstream commit c27bac0314131b11bccd735f7e8415ac6444b667 ]

ACPICA commit 180cb53963aa876c782a6f52cc155d951b26051a

According to the ACPI spec, _CID returns a package containing
hardware ID's. Each element of an ASL package contains a reference
count from the parent package as well as the element itself.

Name (TEST, Package() {
    "String object" // this package element has a reference count of 2
})

A memory leak was caused in the _CID repair function because it did
not decrement the reference count created by the package. Fix the
memory leak by calling acpi_ut_remove_reference on _CID package elements
that represent a hardware ID (_HID).

Link: https://github.com/acpica/acpica/commit/180cb539
Tested-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Erik Kaneda <erik.kaneda@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/nsrepair2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/acpica/nsrepair2.c b/drivers/acpi/acpica/nsrepair2.c
index 663d85e0adba..b7c408ce340c 100644
--- a/drivers/acpi/acpica/nsrepair2.c
+++ b/drivers/acpi/acpica/nsrepair2.c
@@ -375,6 +375,13 @@ acpi_ns_repair_CID(struct acpi_evaluate_info *info,
 
 			(*element_ptr)->common.reference_count =
 			    original_ref_count;
+
+			/*
+			 * The original_element holds a reference from the package object
+			 * that represents _HID. Since a new element was created by _HID,
+			 * remove the reference from the _CID package.
+			 */
+			acpi_ut_remove_reference(original_element);
 		}
 
 		element_ptr++;
-- 
2.30.2

