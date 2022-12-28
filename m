Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BDF657887
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbiL1OwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233189AbiL1Ovv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:51:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0837BE8D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:51:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56071B81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41AAC433D2;
        Wed, 28 Dec 2022 14:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239080;
        bh=EOT13qNqO9wNjfTQOfp6Vv92F/Wje6Iick9/VN0jVe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gz8xUjRKedLYAZfH3lX5cxaU5uscSHb2Q8DZzKgUs3nOY6av+JWd++8FFbBLigwkJ
         CPY1sZNJsmeHf0TftOroyRv2Q79GSChSpzYfsZO9dFODUAPIbXxnljClMaJ2o4q1pG
         GQZdWP63OK+Gk3ZyY5opWRpX9FbD2LGDArt4uuK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Zetao <lizetao1@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/731] ACPICA: Fix use-after-free in acpi_ut_copy_ipackage_to_ipackage()
Date:   Wed, 28 Dec 2022 15:33:48 +0100
Message-Id: <20221228144300.060659413@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit 470188b09e92d83c5a997f25f0e8fb8cd2bc3469 ]

There is an use-after-free reported by KASAN:

  BUG: KASAN: use-after-free in acpi_ut_remove_reference+0x3b/0x82
  Read of size 1 at addr ffff888112afc460 by task modprobe/2111
  CPU: 0 PID: 2111 Comm: modprobe Not tainted 6.1.0-rc7-dirty
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
  Call Trace:
   <TASK>
   kasan_report+0xae/0xe0
   acpi_ut_remove_reference+0x3b/0x82
   acpi_ut_copy_iobject_to_iobject+0x3be/0x3d5
   acpi_ds_store_object_to_local+0x15d/0x3a0
   acpi_ex_store+0x78d/0x7fd
   acpi_ex_opcode_1A_1T_1R+0xbe4/0xf9b
   acpi_ps_parse_aml+0x217/0x8d5
   ...
   </TASK>

The root cause of the problem is that the acpi_operand_object
is freed when acpi_ut_walk_package_tree() fails in
acpi_ut_copy_ipackage_to_ipackage(), lead to repeated release in
acpi_ut_copy_iobject_to_iobject(). The problem was introduced
by "8aa5e56eeb61" commit, this commit is to fix memory leak in
acpi_ut_copy_iobject_to_iobject(), repeatedly adding remove
operation, lead to "acpi_operand_object" used after free.

Fix it by removing acpi_ut_remove_reference() in
acpi_ut_copy_ipackage_to_ipackage(). acpi_ut_copy_ipackage_to_ipackage()
is called to copy an internal package object into another internal
package object, when it fails, the memory of acpi_operand_object
should be freed by the caller.

Fixes: 8aa5e56eeb61 ("ACPICA: Utilities: Fix memory leak in acpi_ut_copy_iobject_to_iobject")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/utcopy.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/acpi/acpica/utcopy.c b/drivers/acpi/acpica/utcopy.c
index d9877153f400..fdd503bb69c4 100644
--- a/drivers/acpi/acpica/utcopy.c
+++ b/drivers/acpi/acpica/utcopy.c
@@ -916,13 +916,6 @@ acpi_ut_copy_ipackage_to_ipackage(union acpi_operand_object *source_obj,
 	status = acpi_ut_walk_package_tree(source_obj, dest_obj,
 					   acpi_ut_copy_ielement_to_ielement,
 					   walk_state);
-	if (ACPI_FAILURE(status)) {
-
-		/* On failure, delete the destination package object */
-
-		acpi_ut_remove_reference(dest_obj);
-	}
-
 	return_ACPI_STATUS(status);
 }
 
-- 
2.35.1



