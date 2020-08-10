Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF43240F37
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgHJTNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729826AbgHJTNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:13:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0D442224D;
        Mon, 10 Aug 2020 19:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086822;
        bh=45VWdcIbF/o2v52taxnXd8WBDS6fFL77M2ekQL3Ub8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTs0bkox31Jo1+rr0s9L/C8bOo3dQSg5sjzG+8k16pA1q6bztYrxzGfYpgKUgLYU7
         F1FdTepueP9ZXFhWlZmB8FnJELi/D825qDhwlsFAJ20i148x/J4MZ7Rfjnq0JYNckj
         ovLxaQfsVZtuXZP2nlp83uDFq9mwf1jYGo63YCaQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erik Kaneda <erik.kaneda@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 4.19 30/31] ACPICA: Do not increment operation_region reference counts for field units
Date:   Mon, 10 Aug 2020 15:12:58 -0400
Message-Id: <20200810191259.3794858-30-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191259.3794858-1-sashal@kernel.org>
References: <20200810191259.3794858-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erik Kaneda <erik.kaneda@intel.com>

[ Upstream commit 6a54ebae6d047c988a31f5ac5a64ab5cf83797a2 ]

ACPICA commit e17b28cfcc31918d0db9547b6b274b09c413eb70

Object reference counts are used as a part of ACPICA's garbage
collection mechanism. This mechanism keeps track of references to
heap-allocated structures such as the ACPI operand objects.

Recent server firmware has revealed that this reference count can
overflow on large servers that declare many field units under the
same operation_region. This occurs because each field unit declaration
will add a reference count to the source operation_region.

This change solves the reference count overflow for operation_regions
objects by preventing fieldunits from incrementing their
operation_region's reference count. Each operation_region's reference
count will not be changed by named objects declared under the Field
operator. During namespace deletion, the operation_region namespace
node will be deleted and each fieldunit will be deleted without
touching the deleted operation_region object.

Link: https://github.com/acpica/acpica/commit/e17b28cf
Signed-off-by: Erik Kaneda <erik.kaneda@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/exprep.c   | 4 ----
 drivers/acpi/acpica/utdelete.c | 6 +-----
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/acpi/acpica/exprep.c b/drivers/acpi/acpica/exprep.c
index 738f3c732363a..228feeea555f1 100644
--- a/drivers/acpi/acpica/exprep.c
+++ b/drivers/acpi/acpica/exprep.c
@@ -473,10 +473,6 @@ acpi_status acpi_ex_prep_field_value(struct acpi_create_field_info *info)
 				    (u8)access_byte_width;
 			}
 		}
-		/* An additional reference for the container */
-
-		acpi_ut_add_reference(obj_desc->field.region_obj);
-
 		ACPI_DEBUG_PRINT((ACPI_DB_BFIELD,
 				  "RegionField: BitOff %X, Off %X, Gran %X, Region %p\n",
 				  obj_desc->field.start_field_bit_offset,
diff --git a/drivers/acpi/acpica/utdelete.c b/drivers/acpi/acpica/utdelete.c
index 8cc4392c61f33..0dc8dea815823 100644
--- a/drivers/acpi/acpica/utdelete.c
+++ b/drivers/acpi/acpica/utdelete.c
@@ -563,11 +563,6 @@ acpi_ut_update_object_reference(union acpi_operand_object *object, u16 action)
 			next_object = object->buffer_field.buffer_obj;
 			break;
 
-		case ACPI_TYPE_LOCAL_REGION_FIELD:
-
-			next_object = object->field.region_obj;
-			break;
-
 		case ACPI_TYPE_LOCAL_BANK_FIELD:
 
 			next_object = object->bank_field.bank_obj;
@@ -608,6 +603,7 @@ acpi_ut_update_object_reference(union acpi_operand_object *object, u16 action)
 			}
 			break;
 
+		case ACPI_TYPE_LOCAL_REGION_FIELD:
 		case ACPI_TYPE_REGION:
 		default:
 
-- 
2.25.1

