Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B660824B830
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgHTLMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727115AbgHTKJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:09:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB23B20738;
        Thu, 20 Aug 2020 10:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918180;
        bh=pxd0E58xEB4rCRxoOo1iwUKlzaG7Rk6Psxh5cGCreKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eaNaq49oxgezNY3vs9yV3Uv/lofK51u8hzW1YLHN6yEqzjz0IAYs/D6lepJgK9RAM
         EfcZm5f6uNvDZFEytcmMQXgqqBDKmj9V6pCKyW76rrL4Cwaiuuzrr5H3E+rw871f4E
         ZWHggqXRLI/5jTW9zLmpIi+EbHFBt+y0aTxdyMrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erik Kaneda <erik.kaneda@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 080/228] ACPICA: Do not increment operation_region reference counts for field units
Date:   Thu, 20 Aug 2020 11:20:55 +0200
Message-Id: <20200820091611.605995544@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8de060664204e..e23f3d54bb31c 100644
--- a/drivers/acpi/acpica/exprep.c
+++ b/drivers/acpi/acpica/exprep.c
@@ -507,10 +507,6 @@ acpi_status acpi_ex_prep_field_value(struct acpi_create_field_info *info)
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
index c6eb9fae70f9a..61a979d0fbc5a 100644
--- a/drivers/acpi/acpica/utdelete.c
+++ b/drivers/acpi/acpica/utdelete.c
@@ -593,11 +593,6 @@ acpi_ut_update_object_reference(union acpi_operand_object *object, u16 action)
 			next_object = object->buffer_field.buffer_obj;
 			break;
 
-		case ACPI_TYPE_LOCAL_REGION_FIELD:
-
-			next_object = object->field.region_obj;
-			break;
-
 		case ACPI_TYPE_LOCAL_BANK_FIELD:
 
 			next_object = object->bank_field.bank_obj;
@@ -638,6 +633,7 @@ acpi_ut_update_object_reference(union acpi_operand_object *object, u16 action)
 			}
 			break;
 
+		case ACPI_TYPE_LOCAL_REGION_FIELD:
 		case ACPI_TYPE_REGION:
 		default:
 
-- 
2.25.1



