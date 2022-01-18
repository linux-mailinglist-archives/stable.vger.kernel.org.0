Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C22491C56
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355895AbiARDOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:14:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353415AbiARDIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:08:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F89C061401;
        Mon, 17 Jan 2022 18:50:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F3C8612E8;
        Tue, 18 Jan 2022 02:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4A4C36AE3;
        Tue, 18 Jan 2022 02:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474258;
        bh=pZ1NTo5JdM11anxPbk0ViqgSU0kZbKCXvJ4ZZ/UjBrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPbwXPbcqotX9ct6qR4nPDaErKcM25MvqSiaGJyrf/AAfCDk0Uz0MhoJqWJ9ZZ2ho
         gEce7sEv9vfo/i1w0P59vVhZsYfAb4axVTtZPp67mDmhNC1VvtI33UpT4vC0SFtKFN
         1H4nFNyqsERfR47zcyO+A/UQuMBLpCkYlug4EUZnPtdQEJcg4xgwPpVia7JcqLU9sN
         an0iQ9xDOp2tELEX8PO3WvCILn71TtrXHoXwQpg7gxbju89QxPyg7GNBHAP9lzJhw+
         NiFXH4ZXeh/f9Idji4nNPrjtGiYpRhJ1R4qcyLx+QBlknMX0NBVVR3dKsNI+oCY/Dp
         z0jmGVSa0okEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        Bob Moore <robert.moore@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 4.14 45/56] ACPICA: Executer: Fix the REFCLASS_REFOF case in acpi_ex_opcode_1A_0T_1R()
Date:   Mon, 17 Jan 2022 21:48:57 -0500
Message-Id: <20220118024908.1953673-45-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024908.1953673-1-sashal@kernel.org>
References: <20220118024908.1953673-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 24ea5f90ec9548044a6209685c5010edd66ffe8f ]

ACPICA commit d984f12041392fa4156b52e2f7e5c5e7bc38ad9e

If Operand[0] is a reference of the ACPI_REFCLASS_REFOF class,
acpi_ex_opcode_1A_0T_1R () calls acpi_ns_get_attached_object () to
obtain return_desc which may require additional resolution with
the help of acpi_ex_read_data_from_field (). If the latter fails,
the reference counter of the original return_desc is decremented
which is incorrect, because acpi_ns_get_attached_object () does not
increment the reference counter of the object returned by it.

This issue may lead to premature deletion of the attached object
while it is still attached and a use-after-free and crash in the
host OS.  For example, this may happen when on evaluation of ref_of()
a local region field where there is no registered handler for the
given Operation Region.

Fix it by making acpi_ex_opcode_1A_0T_1R () return Status right away
after a acpi_ex_read_data_from_field () failure.

Link: https://github.com/acpica/acpica/commit/d984f120
Link: https://github.com/acpica/acpica/pull/685
Reported-by: Lenny Szubowicz <lszubowi@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/exoparg1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/exoparg1.c b/drivers/acpi/acpica/exoparg1.c
index f787651348c11..9f4dbdb70111a 100644
--- a/drivers/acpi/acpica/exoparg1.c
+++ b/drivers/acpi/acpica/exoparg1.c
@@ -1041,7 +1041,8 @@ acpi_status acpi_ex_opcode_1A_0T_1R(struct acpi_walk_state *walk_state)
 						    (walk_state, return_desc,
 						     &temp_desc);
 						if (ACPI_FAILURE(status)) {
-							goto cleanup;
+							return_ACPI_STATUS
+							    (status);
 						}
 
 						return_desc = temp_desc;
-- 
2.34.1

