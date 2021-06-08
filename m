Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D48A3A029D
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237003AbhFHTHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237590AbhFHTFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:05:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88337613BE;
        Tue,  8 Jun 2021 18:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177967;
        bh=6/dQ3e1N39nc6+g6u0y4oMaO1BVCa32BZXODgh/fbZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OeOcP6g420/vdtGF/bvHwTxCK0rBk4cknS6/rBDZF0OgHpesp0QuBsqH6+Nm9rDCh
         O+uzMSlslF+9aNZ5ovqRVTJ8GUvmF5LWo7+xFdvnbc5uefGhip0qXIDeaexKjEPo7F
         4fyic6l43oONaSSqtr0sALK2bUdQymo/2nmt+WEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 028/161] ACPICA: Clean up context mutex during object deletion
Date:   Tue,  8 Jun 2021 20:25:58 +0200
Message-Id: <20210608175946.399982667@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
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
index 624a26794d55..e5ba9795ec69 100644
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



