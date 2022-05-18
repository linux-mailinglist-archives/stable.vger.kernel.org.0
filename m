Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0013552BA9C
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 14:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236541AbiERM1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 08:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236476AbiERM1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 08:27:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F70CB042C;
        Wed, 18 May 2022 05:27:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0892B81F43;
        Wed, 18 May 2022 12:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D00FC385AA;
        Wed, 18 May 2022 12:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876829;
        bh=3KXaNdVrYk/EFhR1Fb+di4Uk5jeldvRSpV8whhTzXI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jojmq3VmctB7noT++uireC0mrhq9loboeq8GtOPJ0vOyyQZqt5KJvEOKmVHXJ9mRr
         M92+VFD2loF4qURoODqWrbbQCdIloGtNpSpSNVF7XpTFyrsy5uTelFgiljgxaYH7qc
         iFaHNpEe7ckHI2EMJUBkbSGDdLJtf+QA0hTysvQtogxuC0KbrlYxZx7wOQ//7qb9WE
         ti02ilDyCTD9kzpDc60v4hbwpq6kRvkRP9GJxYSt1pQSHcN5lF+L4qi5j3NdvHYvnr
         f8UKyMBNxbHTJSL/wxkA+j4uOZ9Tn0PGa0bq6tQeIHYdk+6epsgH0KyO2LZyuDe6fJ
         8n4oCciebSsDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prarit Bhargava <prarit@redhat.com>,
        "David E. Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        platform-driver-x86@vger.kernel.org,
        David Arcari <darcari@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.17 11/23] platform/x86/intel: Fix 'rmmod pmt_telemetry' panic
Date:   Wed, 18 May 2022 08:26:24 -0400
Message-Id: <20220518122641.342120-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122641.342120-1-sashal@kernel.org>
References: <20220518122641.342120-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prarit Bhargava <prarit@redhat.com>

[ Upstream commit 2cdfa0c20d58da3757054797c2974c967035926a ]

'rmmod pmt_telemetry' panics with:

 BUG: kernel NULL pointer dereference, address: 0000000000000040
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP NOPTI
 CPU: 4 PID: 1697 Comm: rmmod Tainted: G S      W        --------  ---  5.18.0-rc4 #3
 Hardware name: Intel Corporation Alder Lake Client Platform/AlderLake-P DDR5 RVP, BIOS ADLPFWI1.R00.3056.B00.2201310233 01/31/2022
 RIP: 0010:device_del+0x1b/0x3d0
 Code: e8 1a d9 e9 ff e9 58 ff ff ff 48 8b 08 eb dc 0f 1f 44 00 00 41 56 41 55 41 54 55 48 8d af 80 00 00 00 53 48 89 fb 48 83 ec 18 <4c> 8b 67 40 48 89 ef 65 48 8b 04 25 28 00 00 00 48 89 44 24 10 31
 RSP: 0018:ffffb520415cfd60 EFLAGS: 00010286
 RAX: 0000000000000070 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000000
 RBP: 0000000000000080 R08: ffffffffffffffff R09: ffffb520415cfd78
 R10: 0000000000000002 R11: ffffb520415cfd78 R12: 0000000000000000
 R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 FS:  00007f7e198e5740(0000) GS:ffff905c9f700000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000040 CR3: 000000010782a005 CR4: 0000000000770ee0
 PKRU: 55555554
 Call Trace:
  <TASK>
  ? __xa_erase+0x53/0xb0
  device_unregister+0x13/0x50
  intel_pmt_dev_destroy+0x34/0x60 [pmt_class]
  pmt_telem_remove+0x40/0x50 [pmt_telemetry]
  auxiliary_bus_remove+0x18/0x30
  device_release_driver_internal+0xc1/0x150
  driver_detach+0x44/0x90
  bus_remove_driver+0x74/0xd0
  auxiliary_driver_unregister+0x12/0x20
  pmt_telem_exit+0xc/0xe4a [pmt_telemetry]
  __x64_sys_delete_module+0x13a/0x250
  ? syscall_trace_enter.isra.19+0x11e/0x1a0
  do_syscall_64+0x58/0x80
  ? syscall_exit_to_user_mode+0x12/0x30
  ? do_syscall_64+0x67/0x80
  ? syscall_exit_to_user_mode+0x12/0x30
  ? do_syscall_64+0x67/0x80
  ? syscall_exit_to_user_mode+0x12/0x30
  ? do_syscall_64+0x67/0x80
  ? exc_page_fault+0x64/0x140
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f7e1803a05b
 Code: 73 01 c3 48 8b 0d 2d 4e 38 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d fd 4d 38 00 f7 d8 64 89 01 48

The probe function, pmt_telem_probe(), adds an entry for devices even if
they have not been initialized.  This results in the array of initialized
devices containing both initialized and uninitialized entries.  This
causes a panic in the remove function, pmt_telem_remove() which expects
the array to only contain initialized entries.

Only use an entry when a device is initialized.

Cc: "David E. Box" <david.e.box@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Mark Gross <markgross@kernel.org>
Cc: platform-driver-x86@vger.kernel.org
Signed-off-by: David Arcari <darcari@redhat.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Reviewed-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20220429122322.2550003-1-prarit@redhat.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmt/telemetry.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index 6b6f3e2a617a..f73ecfd4a309 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -103,7 +103,7 @@ static int pmt_telem_probe(struct auxiliary_device *auxdev, const struct auxilia
 	auxiliary_set_drvdata(auxdev, priv);
 
 	for (i = 0; i < intel_vsec_dev->num_resources; i++) {
-		struct intel_pmt_entry *entry = &priv->entry[i];
+		struct intel_pmt_entry *entry = &priv->entry[priv->num_entries];
 
 		ret = intel_pmt_dev_create(entry, &pmt_telem_ns, intel_vsec_dev, i);
 		if (ret < 0)
-- 
2.35.1

