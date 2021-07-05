Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD893BC0B5
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhGEPhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232588AbhGEPgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51878619B7;
        Mon,  5 Jul 2021 15:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499109;
        bh=gHI2DoY4IyNFtGPUKqbxnQZ2z7cG3IQxGPlRt7+kbcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfhfIBrPbwz5z7Z0GKM4jPgxq0t3yr6v63ZRM1qXU63hgzWPv5RGk50rGsDS+dZIU
         UhhocA4FeDla0xnfsDunb7I5acKyCghQbFEF9Slsus7nqgMaUBPditPY0FEbC109rR
         E0ZbMA/X/AL0JmjQRfvR5WZvlJ6SIPTo9ao5cHKwe75AGbxzzohWH/BsDw3I3lvz/R
         5uH76V4y3NslH1C6f4yqCrwwxEohhCOr+oYTCj0LYE4D6r8PV8dFLAYwmmdMap8O2g
         HyVYdHqXwzKKjmLNlRVBovWbkRNpFz/bmy6oYEgJE/2K1ZUTBRCI2Fvk1H81oRVnIV
         Vq9T0lEmYmYBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erik Kaneda <erik.kaneda@intel.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 4.14 10/15] ACPICA: Fix memory leak caused by _CID repair function
Date:   Mon,  5 Jul 2021 11:31:31 -0400
Message-Id: <20210705153136.1522245-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153136.1522245-1-sashal@kernel.org>
References: <20210705153136.1522245-1-sashal@kernel.org>
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
index 06037e044694..78b802b5f7d3 100644
--- a/drivers/acpi/acpica/nsrepair2.c
+++ b/drivers/acpi/acpica/nsrepair2.c
@@ -409,6 +409,13 @@ acpi_ns_repair_CID(struct acpi_evaluate_info *info,
 
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

