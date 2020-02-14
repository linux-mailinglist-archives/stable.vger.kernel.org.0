Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02E2915DF9E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390623AbgBNQJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:09:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:34222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390591AbgBNQJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:09:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE21C2467E;
        Fri, 14 Feb 2020 16:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696576;
        bh=2o1WWQoBMGzmDpPyFqcjlSZ5s7gYYUk7TLywGJkq9G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKUh7HVTTHVaR8xdgEJF3UgGyAyQDDFG0kqXa9LT6BteY0d+XRAJajeN0uU6oUm9l
         sMTkgLPocZfZIhSIl05eqfayKzvo9Yt7HTkxfX+1VagprUW7oI2HWHy2Hhq7cRkRiw
         LM9Le2F8O/RImJjB9rP2BLrstCHI0wJ/COylbspU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>, Marc Zyngier <maz@kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 365/459] irqchip/mbigen: Set driver .suppress_bind_attrs to avoid remove problems
Date:   Fri, 14 Feb 2020 11:00:15 -0500
Message-Id: <20200214160149.11681-365-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit d6152e6ec9e2171280436f7b31a571509b9287e1 ]

The following crash can be seen for setting
CONFIG_DEBUG_TEST_DRIVER_REMOVE=y for DT FW (which some people still use):

Hisilicon MBIGEN-V2 60080000.interrupt-controller: Failed to create mbi-gen irqdomain
Hisilicon MBIGEN-V2: probe of 60080000.interrupt-controller failed with error -12

[...]

Unable to handle kernel paging request at virtual address 0000000000005008
 Mem abort info:
   ESR = 0x96000004
   EC = 0x25: DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
 Data abort info:
   ISV = 0, ISS = 0x00000004
   CM = 0, WnR = 0
 user pgtable: 4k pages, 48-bit VAs, pgdp=0000041fb9990000
 [0000000000005008] pgd=0000000000000000
 Internal error: Oops: 96000004 [#1] PREEMPT SMP
 Modules linked in:
 CPU: 7 PID: 1 Comm: swapper/0 Not tainted 5.5.0-rc6-00002-g3fc42638a506-dirty #1622
 Hardware name: Huawei Taishan 2280 /D05, BIOS Hisilicon D05 IT21 Nemo 2.0 RC0 04/18/2018
 pstate: 40000085 (nZcv daIf -PAN -UAO)
 pc : mbigen_set_type+0x38/0x60
 lr : __irq_set_trigger+0x6c/0x188
 sp : ffff800014b4b400
 x29: ffff800014b4b400 x28: 0000000000000007
 x27: 0000000000000000 x26: 0000000000000000
 x25: ffff041fd83bd0d4 x24: ffff041fd83bd188
 x23: 0000000000000000 x22: ffff80001193ce00
 x21: 0000000000000004 x20: 0000000000000000
 x19: ffff041fd83bd000 x18: ffffffffffffffff
 x17: 0000000000000000 x16: 0000000000000000
 x15: ffff8000119098c8 x14: ffff041fb94ec91c
 x13: ffff041fb94ec1a1 x12: 0000000000000030
 x11: 0101010101010101 x10: 0000000000000040
 x9 : 0000000000000000 x8 : ffff041fb98c6680
 x7 : ffff800014b4b380 x6 : ffff041fd81636c8
 x5 : 0000000000000000 x4 : 000000000000025f
 x3 : 0000000000005000 x2 : 0000000000005008
 x1 : 0000000000000004 x0 : 0000000080000000
 Call trace:
  mbigen_set_type+0x38/0x60
  __setup_irq+0x744/0x900
  request_threaded_irq+0xe0/0x198
  pcie_pme_probe+0x98/0x118
  pcie_port_probe_service+0x38/0x78
  really_probe+0xa0/0x3e0
  driver_probe_device+0x58/0x100
  __device_attach_driver+0x90/0xb0
  bus_for_each_drv+0x64/0xc8
  __device_attach+0xd8/0x138
  device_initial_probe+0x10/0x18
  bus_probe_device+0x90/0x98
  device_add+0x4c4/0x770
  device_register+0x1c/0x28
  pcie_port_device_register+0x1e4/0x4f0
  pcie_portdrv_probe+0x34/0xd8
  local_pci_probe+0x3c/0xa0
  pci_device_probe+0x128/0x1c0
  really_probe+0xa0/0x3e0
  driver_probe_device+0x58/0x100
  __device_attach_driver+0x90/0xb0
  bus_for_each_drv+0x64/0xc8
  __device_attach+0xd8/0x138
  device_attach+0x10/0x18
  pci_bus_add_device+0x4c/0xb8
  pci_bus_add_devices+0x38/0x88
  pci_host_probe+0x3c/0xc0
  pci_host_common_probe+0xf0/0x208
  hisi_pcie_almost_ecam_probe+0x24/0x30
  platform_drv_probe+0x50/0xa0
  really_probe+0xa0/0x3e0
  driver_probe_device+0x58/0x100
  device_driver_attach+0x6c/0x90
  __driver_attach+0x84/0xc8
  bus_for_each_dev+0x74/0xc8
  driver_attach+0x20/0x28
  bus_add_driver+0x148/0x1f0
  driver_register+0x60/0x110
  __platform_driver_register+0x40/0x48
  hisi_pcie_almost_ecam_driver_init+0x1c/0x24

The specific problem here is that the mbigen driver real probe has failed
as the mbigen_of_create_domain()->of_platform_device_create() call fails,
the reason for that being that we never destroyed the platform device
created during the remove test dry run and there is some conflict.

Since we generally would never want to unbind this driver, and to save
adding a driver tear down path for that, just set the driver
.suppress_bind_attrs member to avoid this possibility.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Link: https://lore.kernel.org/r/1579196323-180137-1-git-send-email-john.garry@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mbigen.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-mbigen.c b/drivers/irqchip/irq-mbigen.c
index 3f09f658e8e29..6b566bba263bd 100644
--- a/drivers/irqchip/irq-mbigen.c
+++ b/drivers/irqchip/irq-mbigen.c
@@ -374,6 +374,7 @@ static struct platform_driver mbigen_platform_driver = {
 		.name		= "Hisilicon MBIGEN-V2",
 		.of_match_table	= mbigen_of_match,
 		.acpi_match_table = ACPI_PTR(mbigen_acpi_match),
+		.suppress_bind_attrs = true,
 	},
 	.probe			= mbigen_device_probe,
 };
-- 
2.20.1

