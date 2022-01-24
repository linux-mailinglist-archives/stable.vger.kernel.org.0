Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27AF4999D2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456142AbiAXVhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:37:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50630 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450178AbiAXV3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:29:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EFFE61469;
        Mon, 24 Jan 2022 21:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D0FC340E4;
        Mon, 24 Jan 2022 21:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059777;
        bh=xZVrHsD0rPsj3VwK4y+uOU/PgOon9I3CUjgItIi+HoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jaCJCUV6apRBmvC/WRkmSRMmHPurcFQQun3IBROqSxFBfYDPhPhj8YyhHh/4lYuCd
         3xzL3g22ARsRt2SERhR7sHCrORIqe/l1zOKxepIB+vqNS/RUPfRt7iV5iWYpdy2RKd
         x5GZZmIEHqx6Rhgc17U3tjHSO+wp+h1ALv+65ezc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mark Asselstine <mark.asselstine@windriver.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0697/1039] ACPICA: Utilities: Avoid deleting the same object twice in a row
Date:   Mon, 24 Jan 2022 19:41:26 +0100
Message-Id: <20220124184148.772245819@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 1cdfe9e346b4c5509ffe19ccde880fd259d9f7a3 ]

ACPICA commit c11af67d8f7e3d381068ce7771322f2b5324d687

If original_count is 0 in acpi_ut_update_ref_count (),
acpi_ut_delete_internal_obj () is invoked for the target object, which is
incorrect, because that object has been deleted once already and the
memory allocated to store it may have been reclaimed and allocated
for a different purpose by the host OS.  Moreover, a confusing debug
message following the "Reference Count is already zero, cannot
decrement" warning is printed in that case.

To fix this issue, make acpi_ut_update_ref_count () return after finding
that original_count is 0 and printing the above warning.

Link: https://github.com/acpica/acpica/commit/c11af67d
Link: https://github.com/acpica/acpica/pull/652
Reported-by: Mark Asselstine <mark.asselstine@windriver.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/utdelete.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/acpica/utdelete.c b/drivers/acpi/acpica/utdelete.c
index e5ba9795ec696..8d7736d2d2699 100644
--- a/drivers/acpi/acpica/utdelete.c
+++ b/drivers/acpi/acpica/utdelete.c
@@ -422,6 +422,7 @@ acpi_ut_update_ref_count(union acpi_operand_object *object, u32 action)
 			ACPI_WARNING((AE_INFO,
 				      "Obj %p, Reference Count is already zero, cannot decrement\n",
 				      object));
+			return;
 		}
 
 		ACPI_DEBUG_PRINT_RAW((ACPI_DB_ALLOCATIONS,
-- 
2.34.1



