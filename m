Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568EF5418AB
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379849AbiFGVNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379837AbiFGVMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:12:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFF815352E;
        Tue,  7 Jun 2022 11:54:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7330616A9;
        Tue,  7 Jun 2022 18:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8DFC385A2;
        Tue,  7 Jun 2022 18:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628050;
        bh=goT196KiQfwpElqIN5celghRGMAp8wKph89erWgkuJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zW85+kwkfkATKmxAoLVFUNVHznd8lVt7LLxa0nDj99QMur4zyezO41jO+cQQ0lp83
         sZ3FYEZtlUB7B/RqSe9Rb7ECoqLUFm7b3bYfbaPgpIPXmeTn6fkZfGpEWYRjdFmoZj
         c97LCeaArHoNKCUKY3OlR69mbH8XqlZlSwiDmz/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ross Burton <ross.burton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 187/879] of/fdt: Ignore disabled memory nodes
Date:   Tue,  7 Jun 2022 18:55:05 +0200
Message-Id: <20220607165008.270554431@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit df5cd369876114f91f9ae60658fea80acfb15890 ]

When we boot a machine using a devicetree, the generic DT code goes
through all nodes with a 'device_type = "memory"' property, and collects
all memory banks mentioned there. However it does not check for the
status property, so any nodes which are explicitly "disabled" will still
be added as a memblock.
This ends up badly for QEMU, when booting with secure firmware on
arm/arm64 machines, because QEMU adds a node describing secure-only
memory:
===================
	secram@e000000 {
		secure-status = "okay";
		status = "disabled";
		reg = <0x00 0xe000000 0x00 0x1000000>;
		device_type = "memory";
	};
===================

The kernel will eventually use that memory block (which is located below
the main DRAM bank), but accesses to that will be answered with an
SError:
===================
[    0.000000] Internal error: synchronous external abort: 96000050 [#1] PREEMPT SMP
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.18.0-rc6-00014-g10c8acb8b679 #524
[    0.000000] Hardware name: linux,dummy-virt (DT)
[    0.000000] pstate: 200000c5 (nzCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.000000] pc : new_slab+0x190/0x340
[    0.000000] lr : new_slab+0x184/0x340
[    0.000000] sp : ffff80000a4b3d10
....
==================
The actual crash location and call stack will be somewhat random, and
depend on the specific allocation of that physical memory range.

As the DT spec[1] explicitly mentions standard properties, add a simple
check to skip over disabled memory nodes, so that we only use memory
that is meant for non-secure code to use.

That fixes booting a QEMU arm64 VM with EL3 enabled ("secure=on"), when
not using UEFI. In this case the QEMU generated DT will be handed on
to the kernel, which will see the secram node.
This issue is reproducible when using TF-A together with U-Boot as
firmware, then booting with the "booti" command.

When using U-Boot as an UEFI provider, the code there [2] explicitly
filters for disabled nodes when generating the UEFI memory map, so we
are safe.
EDK/2 only reads the first bank of the first DT memory node [3] to learn
about memory, so we got lucky there.

[1] https://github.com/devicetree-org/devicetree-specification/blob/main/source/chapter3-devicenodes.rst#memory-node (after the table)
[2] https://source.denx.de/u-boot/u-boot/-/blob/master/lib/fdtdec.c#L1061-1063
[3] https://github.com/tianocore/edk2/blob/master/ArmVirtPkg/PrePi/FdtParser.c

Reported-by: Ross Burton <ross.burton@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220517101410.3493781-1-andre.przywara@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index ec315b060cd5..0f30496ce80b 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1105,6 +1105,9 @@ int __init early_init_dt_scan_memory(void)
 		if (type == NULL || strcmp(type, "memory") != 0)
 			continue;
 
+		if (!of_fdt_device_is_available(fdt, node))
+			continue;
+
 		reg = of_get_flat_dt_prop(node, "linux,usable-memory", &l);
 		if (reg == NULL)
 			reg = of_get_flat_dt_prop(node, "reg", &l);
-- 
2.35.1



