Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1341F183
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730841AbfEOLSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:18:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730400AbfEOLSv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:18:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 846CE206BF;
        Wed, 15 May 2019 11:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919130;
        bh=1daR3BF2dO/1u7K6IxBHv9ObefRc1KdNfMU6URtTw6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fz1RoWPZDIOreZjpe/yhy22jjacdq7ptP+9tDl6rbwNdJpuAKnNbgejBAdN0DbZFM
         9bP3d0Ud3LEpnBclyBgEwAIvxbMituPgnv9dLgyEe21Cnb3kY6KWCYaB/nSEl+UZfE
         /jCl3ycGh+TRYO/oFfaYQPDKa9FjbwovJnV3uQJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael J Gruber <mjg@fedoraproject.org>,
        Erik Schmauss <erik.schmauss@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 078/115] ACPICA: Namespace: remove address node from global list after method termination
Date:   Wed, 15 May 2019 12:55:58 +0200
Message-Id: <20190515090705.057141163@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c5781ffbbd4f742a58263458145fe7f0ac01d9e0 ]

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
Cc: 4.20+ <stable@vger.kernel.org> # 4.20+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/acpi/acpica/nsobject.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/acpica/nsobject.c b/drivers/acpi/acpica/nsobject.c
index 707b2aa501e1b..099be64242556 100644
--- a/drivers/acpi/acpica/nsobject.c
+++ b/drivers/acpi/acpica/nsobject.c
@@ -222,6 +222,10 @@ void acpi_ns_detach_object(struct acpi_namespace_node *node)
 		}
 	}
 
+	if (obj_desc->common.type == ACPI_TYPE_REGION) {
+		acpi_ut_remove_address_range(obj_desc->region.space_id, node);
+	}
+
 	/* Clear the Node entry in all cases */
 
 	node->object = NULL;
-- 
2.20.1



