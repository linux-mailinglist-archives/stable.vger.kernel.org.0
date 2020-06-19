Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F742012ED
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392601AbgFSPTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390347AbgFSPRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:17:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F62F206DB;
        Fri, 19 Jun 2020 15:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579873;
        bh=0dgaXx1o/v3uoLpNkiitvqOB3bdGazxh/NQXbfODV44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSyjkdpT21GGH8XO3hAMsd+T6otdz4CrQALBRrzN09J/ZDD83JvCkJgwz2U/beER9
         i8xVIEEU2BsVlIswVu59exPrweJr0mWZ+1T1yIgzz3Z8q8Tx25uys5yBi/L0kszzRh
         AvU/JiZNAfckvrqPljI1HHz5HphzkwyTvBgUO7dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kurt Kennett <kurt_kennett@hotmail.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 036/376] ACPICA: Dispatcher: add status checks
Date:   Fri, 19 Jun 2020 16:29:14 +0200
Message-Id: <20200619141712.062231634@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erik Kaneda <erik.kaneda@intel.com>

[ Upstream commit 6bfe5344b2956d0bee116f1c640aef05e5cddd76 ]

ACPICA commit 3244c1eeba9f9fb9ccedb875f7923a3d85e0c6aa

The status chekcs are used to to avoid NULL pointer dereference on
field objects

Link: https://github.com/acpica/acpica/commit/3244c1ee
Reported-by: Kurt Kennett <kurt_kennett@hotmail.com>
Signed-off-by: Erik Kaneda <erik.kaneda@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/dsfield.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpica/dsfield.c b/drivers/acpi/acpica/dsfield.c
index c901f5aec739..5725baec60f3 100644
--- a/drivers/acpi/acpica/dsfield.c
+++ b/drivers/acpi/acpica/dsfield.c
@@ -514,13 +514,20 @@ acpi_ds_create_field(union acpi_parse_object *op,
 	info.region_node = region_node;
 
 	status = acpi_ds_get_field_names(&info, walk_state, arg->common.next);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
 	if (info.region_node->object->region.space_id ==
-	    ACPI_ADR_SPACE_PLATFORM_COMM
-	    && !(region_node->object->field.internal_pcc_buffer =
-		 ACPI_ALLOCATE_ZEROED(info.region_node->object->region.
-				      length))) {
-		return_ACPI_STATUS(AE_NO_MEMORY);
+	    ACPI_ADR_SPACE_PLATFORM_COMM) {
+		region_node->object->field.internal_pcc_buffer =
+		    ACPI_ALLOCATE_ZEROED(info.region_node->object->region.
+					 length);
+		if (!region_node->object->field.internal_pcc_buffer) {
+			return_ACPI_STATUS(AE_NO_MEMORY);
+		}
 	}
+
 	return_ACPI_STATUS(status);
 }
 
-- 
2.25.1



