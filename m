Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA683CDCD2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238470AbhGSOx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239344AbhGSOuk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:50:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D602360551;
        Mon, 19 Jul 2021 15:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708680;
        bh=SA5MZgS2PfvCVaCfZaGNl9mDx1oFuWLRKXOI2zUk/hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUWoFdmNoweKJnGVIt7Ett6MOJOH7eH5AFFIl4Wep9qonQu0HKYs9qvHVA1GXSM+4
         /OgVjc+f6sESDz8Q+OtU8Hxhn6QHar7hSAZBABBYjfZZX40aJE5sokTqLP1+Ts7lAb
         caphil3KGzwiSThyaV32aU60fBILJXMyE12MD34Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Erik Kaneda <erik.kaneda@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 087/421] ACPICA: Fix memory leak caused by _CID repair function
Date:   Mon, 19 Jul 2021 16:48:18 +0200
Message-Id: <20210719144949.132266521@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a3bd6280882c..4c8ce483805d 100644
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



