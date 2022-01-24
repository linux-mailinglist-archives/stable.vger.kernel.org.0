Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED314498E56
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346253AbiAXTki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:40:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34360 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354331AbiAXTgb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:36:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC9A260909;
        Mon, 24 Jan 2022 19:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4013C340E5;
        Mon, 24 Jan 2022 19:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052990;
        bh=HouZgAats866R4r1zSh6Cjti9p5j8T6zOH2vHVEIsVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ax1hrUYe5XNcuQ9TfXg/3wJMd4AQ1byLQt8D8yvq8hEDW9j2BnDMQyoQv1mXOAWu
         uDX8V/IDEhN1tpJMHpqUfAcixe/3jjJbAIcUZP95PX4Rhx6NRl7bu+8Gq/YXNWTC/J
         EWib6mFMuaaEYa1fDQ9KAclf7C73vZLqmMv0cD8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lenny Szubowicz <lszubowi@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 206/320] ACPICA: Executer: Fix the REFCLASS_REFOF case in acpi_ex_opcode_1A_0T_1R()
Date:   Mon, 24 Jan 2022 19:43:10 +0100
Message-Id: <20220124184000.641096927@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

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
index 06e35ea098234..6d84618ba3871 100644
--- a/drivers/acpi/acpica/exoparg1.c
+++ b/drivers/acpi/acpica/exoparg1.c
@@ -1007,7 +1007,8 @@ acpi_status acpi_ex_opcode_1A_0T_1R(struct acpi_walk_state *walk_state)
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



