Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF2C3A0096
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbhFHSpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235277AbhFHSmW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:42:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 843646143E;
        Tue,  8 Jun 2021 18:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177339;
        bh=n7jHnSCUhWTcbzPHUkPCGxMPD1LYam3aJehWBgA4Bn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CM2XrnhjgOO7sMobcWt2m06d7vKTqEx4JeULDthYZr5VqllD2EldBRNOLpY9JatQc
         zzltTvlugOKVzHk60kenx4eCfmstNFNVBO9nhJhBZgILygd+KdrbA53jhGcqtopzL1
         hB4+TQeIexjLYJVM8F//MegEsTbb04HGDZQEK0Xg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/78] ACPICA: Clean up context mutex during object deletion
Date:   Tue,  8 Jun 2021 20:26:46 +0200
Message-Id: <20210608175935.852114464@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erik Kaneda <erik.kaneda@intel.com>

[ Upstream commit e4dfe108371214500ee10c2cf19268f53acaa803 ]

ACPICA commit bc43c878fd4ff27ba75b1d111b97ee90d4a82707

Fixes: c27f3d011b08 ("Fix race in GenericSerialBus (I2C) and GPIO OpRegion parameter handling")
Link: https://github.com/acpica/acpica/commit/bc43c878
Reported-by: John Garry <john.garry@huawei.com>
Reported-by: Xiang Chen <chenxiang66@hisilicon.com>
Tested-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Erik Kaneda <erik.kaneda@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/utdelete.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/acpica/utdelete.c b/drivers/acpi/acpica/utdelete.c
index 4c0d4e434196..72d2c0b65633 100644
--- a/drivers/acpi/acpica/utdelete.c
+++ b/drivers/acpi/acpica/utdelete.c
@@ -285,6 +285,14 @@ static void acpi_ut_delete_internal_obj(union acpi_operand_object *object)
 		}
 		break;
 
+	case ACPI_TYPE_LOCAL_ADDRESS_HANDLER:
+
+		ACPI_DEBUG_PRINT((ACPI_DB_ALLOCATIONS,
+				  "***** Address handler %p\n", object));
+
+		acpi_os_delete_mutex(object->address_space.context_mutex);
+		break;
+
 	default:
 
 		break;
-- 
2.30.2



