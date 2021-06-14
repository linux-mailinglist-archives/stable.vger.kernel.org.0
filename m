Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EEE3A647E
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbhFNLZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235848AbhFNLXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:23:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08D4D619A2;
        Mon, 14 Jun 2021 10:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667985;
        bh=QJdEwiuXfE1cLkoL32HR+rcplTC6nwjYcacGBPjnDXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EN0QGtoLnCvJPgLpvFwd1HryVFXtPONbsmWXmK+tStGqdQmpyQsLnqfkbeAyAsBQO
         oZTzVLahXl/xTxnznSU9NtMJaPTQSjCTaYMUDPr0Sd14hOzenm+EXT2IK0lcSb42b6
         QgI6wQG4Nwo1iYAgoE2vjCrOJFGcImn+JcdIYNHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Donnelly <john.p.donnelly@oracle.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.12 151/173] perf/x86/intel/uncore: Fix a kernel WARNING triggered by maxcpus=1
Date:   Mon, 14 Jun 2021 12:28:03 +0200
Message-Id: <20210614102703.195306414@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit 4a0e3ff30980b7601b13dd3b7ee275212b852843 upstream.

A kernel WARNING may be triggered when setting maxcpus=1.

The uncore counters are Die-scope. When probing a PCI device, only the
BUS information can be retrieved. The uncore driver has to maintain a
mapping table used to calculate the logical Die ID from a given BUS#.

Before the patch ba9506be4e40, the mapping table stores the mapping
information from the BUS# -> a Physical Socket ID. To calculate the
logical die ID, perf does,
- In snbep_pci2phy_map_init(), retrieve the BUS# -> a Physical Socket ID
  from the UBOX PCI configure space.
- Calculate the mapping information (a BUS# -> a Physical Socket ID) for
  the other PCI BUS.
- In the uncore_pci_probe(), get the physical Socket ID from a given BUS
  and the mapping table.
- Calculate the logical Die ID

Since only the logical Die ID is required, with the patch ba9506be4e40,
the mapping table stores the mapping information from the BUS# -> a
logical Die ID. Now perf does,
- In snbep_pci2phy_map_init(), retrieve the BUS# -> a Physical Socket ID
  from the UBOX PCI configure space.
- Calculate the logical Die ID
- Calculate the mapping information (a BUS# -> a logical Die ID) for the
  other PCI BUS.
- In the uncore_pci_probe(), get the logical die ID from a given BUS and
  the mapping table.

When calculating the logical Die ID, -1 may be returned, especially when
maxcpus=1. Here, -1 means the logical Die ID is not found. But when
calculating the mapping information for the other PCI BUS, -1 indicates
that it's the other PCI BUS that requires the calculation of the
mapping. The driver will mistakenly do the calculation.

Uses the -ENODEV to indicate the case which the logical Die ID is not
found. The driver will not mess up the mapping table anymore.

Fixes: ba9506be4e40 ("perf/x86/intel/uncore: Store the logical die id instead of the physical die id.")
Reported-by: John Donnelly <john.p.donnelly@oracle.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: John Donnelly <john.p.donnelly@oracle.com>
Tested-by: John Donnelly <john.p.donnelly@oracle.com>
Link: https://lkml.kernel.org/r/1622037527-156028-1-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore_snbep.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -1406,6 +1406,8 @@ static int snbep_pci2phy_map_init(int de
 						die_id = i;
 					else
 						die_id = topology_phys_to_logical_pkg(i);
+					if (die_id < 0)
+						die_id = -ENODEV;
 					map->pbus_to_dieid[bus] = die_id;
 					break;
 				}
@@ -1452,14 +1454,14 @@ static int snbep_pci2phy_map_init(int de
 			i = -1;
 			if (reverse) {
 				for (bus = 255; bus >= 0; bus--) {
-					if (map->pbus_to_dieid[bus] >= 0)
+					if (map->pbus_to_dieid[bus] != -1)
 						i = map->pbus_to_dieid[bus];
 					else
 						map->pbus_to_dieid[bus] = i;
 				}
 			} else {
 				for (bus = 0; bus <= 255; bus++) {
-					if (map->pbus_to_dieid[bus] >= 0)
+					if (map->pbus_to_dieid[bus] != -1)
 						i = map->pbus_to_dieid[bus];
 					else
 						map->pbus_to_dieid[bus] = i;


