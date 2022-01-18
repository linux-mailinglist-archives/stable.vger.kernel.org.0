Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFCA491DEE
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350876AbiARDn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351572AbiARCyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:54:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE02C035414;
        Mon, 17 Jan 2022 18:43:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D038E6130B;
        Tue, 18 Jan 2022 02:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694B7C36AEF;
        Tue, 18 Jan 2022 02:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473829;
        bh=zqJnWNKklnSWXdJB0iFSt+ijGhwZdc7Fc9xs+tVmSC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eoyldqS5Bx5Yg40V08kfvHfbArReETe/GkqEaiSXPJND2pnXFc5DDE8G9gaDz3RPo
         eXSlRdNaLcVCvyC5SrhoJo4xXX1RBp4zqO1NIXawz0RnaSXezMvnAy2bbC3a3ijg1f
         OvxZUjTpU3nkntMxLbqqtDssBFp4/JbTuM53o0t+nLD5HXv4mIN07qZB9PLJSA1VyV
         s3FAophOPUbpm/dMZXF6RQsp0HB96yQ/dDP/iPFHgKBD6q+bA/mTUljBDyBSyP0bTn
         6AWavZ08kLtx4OleQzT6w0QaA9y3PSJEUUas288X8ay6MNGA+/eCQxterJ91fdmfMX
         qA3e44r+nXL2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mark Asselstine <mark.asselstine@windriver.com>,
        Bob Moore <robert.moore@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 5.10 091/116] ACPICA: Utilities: Avoid deleting the same object twice in a row
Date:   Mon, 17 Jan 2022 21:39:42 -0500
Message-Id: <20220118024007.1950576-91-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index 72d2c0b656339..cb1750e7a6281 100644
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

