Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E318B29B80A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799229AbgJ0Pa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:30:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799223AbgJ0PaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:30:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 366D122202;
        Tue, 27 Oct 2020 15:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812622;
        bh=8qGO8t7OcJ2zPQymSADukd3eQxCBn7lHLHzvatI8AdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ZeY6UsKC7eCwHv4wcSrSnSsUsuag1qaOn58/C/zmT0xX572WzZMPPlrZz4RWegQP
         kJ9NtwKaGrAMh06JjnBLeVjJE1LGzB/71TRFQK+nfKrxj2vmLPgdjThYkJlTFAOVos
         M6pKljfWP3EqSEnmUD6Hc98AhL29vGpJQFO+RG4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ruediger Oertel <ro@suse.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mian Yousaf Kaukab <ykaukab@suse.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 272/757] coresight: fix offset by one error in counting ports
Date:   Tue, 27 Oct 2020 14:48:42 +0100
Message-Id: <20201027135503.331941759@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mian Yousaf Kaukab <ykaukab@suse.de>

[ Upstream commit 9554c3551ed35d79b029e5e69383ae33117d9765 ]

Since port-numbers start from 0, add 1 to port-number to get the port
count.

Fix following crash when Coresight is enabled on ACPI based systems:

[   61.061736] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
...
[   61.135494] pc : acpi_coresight_parse_graph+0x1c4/0x37c
[   61.140705] lr : acpi_coresight_parse_graph+0x160/0x37c
[   61.145915] sp : ffff800012f4ba40
[   61.145917] x29: ffff800012f4ba40 x28: ffff00becce62f98
[   61.159896] x27: 0000000000000005 x26: ffff00becd8a7c88
[   61.165195] x25: ffff00becd8a7d88 x24: ffff00becce62f80
[   61.170492] x23: ffff800011ef99c0 x22: ffff009efb8bc010
[   61.175790] x21: 0000000000000018 x20: 0000000000000005
[   61.181087] x19: ffff00becce62e80 x18: 0000000000000020
[   61.186385] x17: 0000000000000001 x16: 00000000000002a8
[   61.191682] x15: ffff000838648550 x14: ffffffffffffffff
[   61.196980] x13: 0000000000000000 x12: ffff00becce62d87
[   61.202277] x11: 00000000ffffff76 x10: 000000000000002e
[   61.207575] x9 : ffff8000107e1a68 x8 : ffff00becce63000
[   61.212873] x7 : 0000000000000018 x6 : 000000000000003f
[   61.218170] x5 : 0000000000000000 x4 : 0000000000000000
[   61.223467] x3 : 0000000000000000 x2 : 0000000000000000
[   61.228764] x1 : ffff00becce62f80 x0 : 0000000000000000
[   61.234062] Call trace:
[   61.236497]  acpi_coresight_parse_graph+0x1c4/0x37c
[   61.241361]  coresight_get_platform_data+0xdc/0x130
[   61.246225]  tmc_probe+0x138/0x2dc
[   61.246227]  amba_probe+0xdc/0x220
[   61.255779]  really_probe+0xe8/0x49c
[   61.255781]  driver_probe_device+0xec/0x140
[   61.255782]  device_driver_attach+0xc8/0xd0
[   61.255785]  __driver_attach+0xac/0x180
[   61.265857]  bus_for_each_dev+0x78/0xcc
[   61.265859]  driver_attach+0x2c/0x40
[   61.265861]  bus_add_driver+0x150/0x244
[   61.265863]  driver_register+0x80/0x13c
[   61.273591]  amba_driver_register+0x60/0x70
[   61.273594]  tmc_driver_init+0x20/0x2c
[   61.281582]  do_one_initcall+0x50/0x230
[   61.281585]  do_initcalls+0x104/0x144
[   61.291831]  kernel_init_freeable+0x168/0x1dc
[   61.291834]  kernel_init+0x1c/0x120
[   61.299215]  ret_from_fork+0x10/0x18
[   61.299219] Code: b9400022 f9400660 9b277c42 8b020000 (f9400404)
[   61.307381] ---[ end trace 63c6c3d7ec6a9b7c ]---
[   61.315225] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Fixes: d375b356e687 ("coresight: Fix support for sparsely populated ports")
Reported-by: Ruediger Oertel <ro@suse.com>
Tested-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200916191737.4001561-4-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-platform.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-platform.c b/drivers/hwtracing/coresight/coresight-platform.c
index bfd44231d7ad5..227e234a24701 100644
--- a/drivers/hwtracing/coresight/coresight-platform.c
+++ b/drivers/hwtracing/coresight/coresight-platform.c
@@ -711,11 +711,11 @@ static int acpi_coresight_parse_graph(struct acpi_device *adev,
 			return dir;
 
 		if (dir == ACPI_CORESIGHT_LINK_MASTER) {
-			if (ptr->outport > pdata->nr_outport)
-				pdata->nr_outport = ptr->outport;
+			if (ptr->outport >= pdata->nr_outport)
+				pdata->nr_outport = ptr->outport + 1;
 			ptr++;
 		} else {
-			WARN_ON(pdata->nr_inport == ptr->child_port);
+			WARN_ON(pdata->nr_inport == ptr->child_port + 1);
 			/*
 			 * We do not track input port connections for a device.
 			 * However we need the highest port number described,
@@ -723,8 +723,8 @@ static int acpi_coresight_parse_graph(struct acpi_device *adev,
 			 * record for an output connection. Hence, do not move
 			 * the ptr for input connections
 			 */
-			if (ptr->child_port > pdata->nr_inport)
-				pdata->nr_inport = ptr->child_port;
+			if (ptr->child_port >= pdata->nr_inport)
+				pdata->nr_inport = ptr->child_port + 1;
 		}
 	}
 
-- 
2.25.1



