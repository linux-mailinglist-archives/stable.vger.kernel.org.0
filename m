Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B6F4915F5
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345968AbiARCcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:32:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46718 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344244AbiARC3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:29:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 289EB60AB6;
        Tue, 18 Jan 2022 02:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73D2C36AF5;
        Tue, 18 Jan 2022 02:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472963;
        bh=Pmo6IF4IBwL5Qx1rzocHFg+51u517NDJnuUHyGjU8H4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cC1L3JkinZ8vJHlmD8IBxKih1YNTthwzETKtUNxn9UoQszKMzDyhTgEaEdvTCm2uL
         C0YpFAPPxZSmhc6grBm3PubHMYXciFMXdw0BkGOUGlwaR+0nnPRByBy1KczTZ7tF1J
         ndcZxo9P08lO8GhacDzMLhClplDIvQtaPEjtl0kaoUXAChsMF8kS2bC+LFOmbqRyvQ
         2aGyKOLTmnviWoIzAZJ2d1r6cd3gA289OJavNhL7pClnHWmsmZtANEr20HBMXzXM3w
         47oe67VUtPMTJV00o/89AZdplsXNepF7+3lNbUuqbX0moBKdfRuXDcXwblWI6nNDSK
         PF0FOMBoPVXdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mark Asselstine <mark.asselstine@windriver.com>,
        Bob Moore <robert.moore@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 5.16 180/217] ACPICA: Utilities: Avoid deleting the same object twice in a row
Date:   Mon, 17 Jan 2022 21:19:03 -0500
Message-Id: <20220118021940.1942199-180-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

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

