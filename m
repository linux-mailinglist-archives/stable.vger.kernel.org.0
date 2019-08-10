Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFE2288D86
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfHJUqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:46:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55354 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726909AbfHJUoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:07 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDc-00053P-0z; Sat, 10 Aug 2019 21:44:04 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDL-0003dc-EA; Sat, 10 Aug 2019 21:43:47 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Bob Moore" <robert.moore@intel.com>,
        "Erik Schmauss" <erik.schmauss@intel.com>,
        "Michael J Gruber" <mjg@fedoraproject.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.941232992@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 077/157] ACPICA: Namespace: remove address node from
 global list after method termination
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Erik Schmauss <erik.schmauss@intel.com>

commit c5781ffbbd4f742a58263458145fe7f0ac01d9e0 upstream.

ACPICA commit b233720031a480abd438f2e9c643080929d144c3

ASL operation_regions declare a range of addresses that it uses. In a
perfect world, the range of addresses should be used exclusively by
the AML interpreter. The OS can use this information to decide which
drivers to load so that the AML interpreter and device drivers use
different regions of memory.

During table load, the address information is added to a global
address range list. Each node in this list contains an address range
as well as a namespace node of the operation_region. This list is
deleted at ACPI shutdown.

Unfortunately, ASL operation_regions can be declared inside of control
methods. Although this is not recommended, modern firmware contains
such code. New module level code changes unintentionally removed the
functionality of adding and removing nodes to the global address
range list.

A few months ago, support for adding addresses has been re-
implemented. However, the removal of the address range list was
missed and resulted in some systems to crash due to the address list
containing bogus namespace nodes from operation_regions declared in
control methods. In order to fix the crash, this change removes
dynamic operation_regions after control method termination.

Link: https://github.com/acpica/acpica/commit/b2337200
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202475
Fixes: 4abb951b73ff ("ACPICA: AML interpreter: add region addresses in global list during initialization")
Reported-by: Michael J Gruber <mjg@fedoraproject.org>
Signed-off-by: Erik Schmauss <erik.schmauss@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/acpica/nsobject.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/acpi/acpica/nsobject.c
+++ b/drivers/acpi/acpica/nsobject.c
@@ -222,6 +222,10 @@ void acpi_ns_detach_object(struct acpi_n
 		}
 	}
 
+	if (obj_desc->common.type == ACPI_TYPE_REGION) {
+		acpi_ut_remove_address_range(obj_desc->region.space_id, node);
+	}
+
 	/* Clear the Node entry in all cases */
 
 	node->object = NULL;

