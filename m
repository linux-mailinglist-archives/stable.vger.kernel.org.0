Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15E7491AE5
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344265AbiARDDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350941AbiARC6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:58:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE13C08E81D;
        Mon, 17 Jan 2022 18:46:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 134D061310;
        Tue, 18 Jan 2022 02:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931EEC36AEB;
        Tue, 18 Jan 2022 02:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473993;
        bh=cnN5xt6O7qL5pb9YX1Cpeo6wCDkG1nZj0Zoq4vNviYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oiekNBZdJHPsQMjU/Vut5Zp5cyGjOU44PH2KthAxUeICK/huPe7pVdYe3uL8Uos0U
         Lxa/f29CDwme2kuQPgS40Rx652pp1Jv3n6RYbBU5sh7NZZ+qy3l6ieHgP/6jgcHYqK
         55UoRGr2VZ+55pozABsoLWA6b1EbN6YWAxe4F0M74iZPdi+shWp8LGNA3EGP8r8Ly5
         MbwK7gbzeWPVb1aFx9GacVqRYQ+SvPvA/P0PXD24GF23ayh9fE0TUbuG1GpcBs8T0n
         J9ImNZuExj2l6sdiYJhGnE9UnIP92bmykAI3jrs0YwTVQCs2Tfsbnp1vrwfADCBhXs
         GNCmSlkOdgllg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 5.4 57/73] ACPICA: Fix wrong interpretation of PCC address
Date:   Mon, 17 Jan 2022 21:44:16 -0500
Message-Id: <20220118024432.1952028-57-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 9a3b8655db1ada31c82189ae13f40eb25da48c35 ]

ACPICA commit 41be6afacfdaec2dba3a5ed368736babc2a7aa5c

With the PCC Opregion in the firmware and we are hitting below kernel crash:

-->8
Unable to handle kernel NULL pointer dereference at virtual address 0000000000000010
 Workqueue: pm pm_runtime_work
 pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : __memcpy+0x54/0x260
 lr : acpi_ex_write_data_to_field+0xb8/0x194
 Call trace:
  __memcpy+0x54/0x260
  acpi_ex_store_object_to_node+0xa4/0x1d4
  acpi_ex_store+0x44/0x164
  acpi_ex_opcode_1A_1T_1R+0x25c/0x508
  acpi_ds_exec_end_op+0x1b4/0x44c
  acpi_ps_parse_loop+0x3a8/0x614
  acpi_ps_parse_aml+0x90/0x2f4
  acpi_ps_execute_method+0x11c/0x19c
  acpi_ns_evaluate+0x1ec/0x2b0
  acpi_evaluate_object+0x170/0x2b0
  acpi_device_set_power+0x118/0x310
  acpi_dev_suspend+0xd4/0x180
  acpi_subsys_runtime_suspend+0x28/0x38
  __rpm_callback+0x74/0x328
  rpm_suspend+0x2d8/0x624
  pm_runtime_work+0xa4/0xb8
  process_one_work+0x194/0x25c
  worker_thread+0x260/0x49c
  kthread+0x14c/0x30c
  ret_from_fork+0x10/0x20
 Code: f9000006 f81f80a7 d65f03c0 361000c2 (b9400026)
 ---[ end trace 24d8a032fa77b68a ]---

The reason for the crash is that the PCC channel index passed via region.address
in acpi_ex_store_object_to_node is interpreted as the channel subtype
incorrectly.

Assuming the PCC op_region support is not used by any other type, let us
remove the subtype check as the AML has no access to the subtype information.
Once we remove it, the kernel crash disappears and correctly complains about
missing PCC Opregion handler.

ACPI Error: No handler for Region [PFRM] ((____ptrval____)) [PCC] (20210730/evregion-130)
ACPI Error: Region PCC (ID=10) has no handler (20210730/exfldio-261)
ACPI Error: Aborting method \_SB.ETH0._PS3 due to previous error (AE_NOT_EXIST) (20210730/psparse-531)

Link: https://github.com/acpica/acpica/commit/41be6afa
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/exfield.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/acpi/acpica/exfield.c b/drivers/acpi/acpica/exfield.c
index d3d2dbfba680c..cd3debefe990d 100644
--- a/drivers/acpi/acpica/exfield.c
+++ b/drivers/acpi/acpica/exfield.c
@@ -320,12 +320,7 @@ acpi_ex_write_data_to_field(union acpi_operand_object *source_desc,
 		       obj_desc->field.base_byte_offset,
 		       source_desc->buffer.pointer, data_length);
 
-		if ((obj_desc->field.region_obj->region.address ==
-		     PCC_MASTER_SUBSPACE
-		     && MASTER_SUBSPACE_COMMAND(obj_desc->field.
-						base_byte_offset))
-		    || GENERIC_SUBSPACE_COMMAND(obj_desc->field.
-						base_byte_offset)) {
+		if (MASTER_SUBSPACE_COMMAND(obj_desc->field.base_byte_offset)) {
 
 			/* Perform the write */
 
-- 
2.34.1

