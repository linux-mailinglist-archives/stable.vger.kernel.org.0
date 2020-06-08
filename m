Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466331F2B3A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731361AbgFIAN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730784AbgFHXTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:19:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0637520842;
        Mon,  8 Jun 2020 23:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658364;
        bh=liv92CA1wv+KMzl3ebp8kxsuQiCx/MmzeQG6u0qcm6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1oqYrqzmc0iL1GiRGn//HqipH6vvYp2mwwrSbmf2/tbQnC58veTvynuv0oP/PtbBO
         v/3GxFAApNn53aLAqwuVCd5jlZqgXXb1NkfxFTeZON+UZV/O46QVab5E4Mkbu5c+IA
         orWCOiDKNlnRve5QoCZMKsXG0dYgPh5xk3qNzzes=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erik Kaneda <erik.kaneda@intel.com>,
        Kurt Kennett <kurt_kennett@hotmail.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 5.4 029/175] ACPICA: Dispatcher: add status checks
Date:   Mon,  8 Jun 2020 19:16:22 -0400
Message-Id: <20200608231848.3366970-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 8438e33aa447..fd9028a6bc20 100644
--- a/drivers/acpi/acpica/dsfield.c
+++ b/drivers/acpi/acpica/dsfield.c
@@ -518,13 +518,20 @@ acpi_ds_create_field(union acpi_parse_object *op,
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

