Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A33F332718
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 14:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhCIN0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 08:26:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230183AbhCIN0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 08:26:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615296376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yJRyGY28fj0rkMZScQBHawaSNdSw7ttHKXBT6/5pm1o=;
        b=bBje/LB3Viuz17Dzptcnzwx4zYSGj/vrL9buFcHWxirptMSLMhk60s2ojIn96GHJpd+ZiM
        Kr4+lmhcW1OKpzDQ/VaEUP2+92ChvCgk2ITLg4wwwJ0O1+8OGIiEhgKWJgEqtjGwzKNUEq
        dnXGtP4ewF8BT/bPa3v6Yly5enMsdZc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-fM-iSnghOPmBGU44vFFK9Q-1; Tue, 09 Mar 2021 08:26:13 -0500
X-MC-Unique: fM-iSnghOPmBGU44vFFK9Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D39D21842149;
        Tue,  9 Mar 2021 13:26:11 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-112-201.ams2.redhat.com [10.36.112.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CE8710013D6;
        Tue,  9 Mar 2021 13:26:10 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 1/1] ACPICA: Fix race in generic_serial_bus (I2C) and GPIO op_region parameter handling
Date:   Tue,  9 Mar 2021 14:26:07 +0100
Message-Id: <20210309132607.13158-2-hdegoede@redhat.com>
In-Reply-To: <20210309132607.13158-1-hdegoede@redhat.com>
References: <20210309132607.13158-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c27f3d011b08540e68233cf56274fdc34bebb9b5 upstream.

ACPICA commit c9e0116952363b0fa815143dca7e9a2eb4fefa61

The handling of the generic_serial_bus (I2C) and GPIO op_regions in
acpi_ev_address_space_dispatch() passes a number of extra parameters
to the address-space handler through the address-space Context pointer
(instead of using more function parameters).

The Context is shared between threads, so if multiple threads try to
call the handler for the same address-space at the same time, then
a second thread could change the parameters of a first thread while
the handler is running for the first thread.

An example of this race hitting is the Lenovo Yoga Tablet2 1015L,
where there are both attrib_bytes accesses and attrib_byte accesses
to the same address-space. The attrib_bytes access stores the number
of bytes to transfer in Context->access_length. Where as for the
attrib_byte access the number of bytes to transfer is always 1 and
field_obj->Field.access_length is unused (so 0). Both types of
accesses racing from different threads leads to the following problem:

 1. Thread a. starts an attrib_bytes access, stores a non 0 value
    from field_obj->Field.access_length in Context->access_length

 2. Thread b. starts an attrib_byte access, stores 0 in
    Context->access_length

 3. Thread a. calls i2c_acpi_space_handler() (under Linux). Which
    sees that the access-type is ACPI_GSB_ACCESS_ATTRIB_MULTIBYTE
    and calls acpi_gsb_i2c_read_bytes(..., Context->access_length)

 4. At this point Context->access_length is 0 (set by thread b.)

rather then the field_obj->Field.access_length value from thread a.
This 0 length reads leads to the following errors being logged:

 i2c i2c-0: adapter quirk: no zero length (addr 0x0078, size 0, read)
 i2c i2c-0: i2c read 0 bytes from client@0x78 starting at reg 0x0 failed, error: -95

Note this is just an example of the problems which this race can cause.

There are likely many more (sporadic) problems caused by this race.

This commit adds a new context_mutex to struct acpi_object_addr_handler
and makes acpi_ev_address_space_dispatch() take that mutex when
using the shared Context to pass extra parameters to an address-space
handler, fixing this race.

Note the new mutex must be taken *after* exiting the interpreter,
therefor the existing acpi_ex_exit_interpreter() call is moved to above
the code which stores the extra parameters in the Context.

Link: https://github.com/acpica/acpica/commit/c9e01169
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Erik Kaneda <erik.kaneda@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpica/acobject.h  |  1 +
 drivers/acpi/acpica/evhandler.c |  7 ++++
 drivers/acpi/acpica/evregion.c  | 64 ++++++++++++++++++++++++---------
 drivers/acpi/acpica/evxfregn.c  |  2 ++
 4 files changed, 57 insertions(+), 17 deletions(-)

diff --git a/drivers/acpi/acpica/acobject.h b/drivers/acpi/acpica/acobject.h
index 9f0219a8cb98..dd7efafcb103 100644
--- a/drivers/acpi/acpica/acobject.h
+++ b/drivers/acpi/acpica/acobject.h
@@ -284,6 +284,7 @@ struct acpi_object_addr_handler {
 	acpi_adr_space_handler handler;
 	struct acpi_namespace_node *node;	/* Parent device */
 	void *context;
+	acpi_mutex context_mutex;
 	acpi_adr_space_setup setup;
 	union acpi_operand_object *region_list;	/* Regions using this handler */
 	union acpi_operand_object *next;
diff --git a/drivers/acpi/acpica/evhandler.c b/drivers/acpi/acpica/evhandler.c
index 5884eba047f7..3438dc187efb 100644
--- a/drivers/acpi/acpica/evhandler.c
+++ b/drivers/acpi/acpica/evhandler.c
@@ -489,6 +489,13 @@ acpi_ev_install_space_handler(struct acpi_namespace_node *node,
 
 	/* Init handler obj */
 
+	status =
+	    acpi_os_create_mutex(&handler_obj->address_space.context_mutex);
+	if (ACPI_FAILURE(status)) {
+		acpi_ut_remove_reference(handler_obj);
+		goto unlock_and_exit;
+	}
+
 	handler_obj->address_space.space_id = (u8)space_id;
 	handler_obj->address_space.handler_flags = flags;
 	handler_obj->address_space.region_list = NULL;
diff --git a/drivers/acpi/acpica/evregion.c b/drivers/acpi/acpica/evregion.c
index a8a4c8c9b9ef..7701ae67e091 100644
--- a/drivers/acpi/acpica/evregion.c
+++ b/drivers/acpi/acpica/evregion.c
@@ -112,6 +112,8 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 	union acpi_operand_object *region_obj2;
 	void *region_context = NULL;
 	struct acpi_connection_info *context;
+	acpi_mutex context_mutex;
+	u8 context_locked;
 	acpi_physical_address address;
 
 	ACPI_FUNCTION_TRACE(ev_address_space_dispatch);
@@ -136,6 +138,8 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 	}
 
 	context = handler_desc->address_space.context;
+	context_mutex = handler_desc->address_space.context_mutex;
+	context_locked = FALSE;
 
 	/*
 	 * It may be the case that the region has never been initialized.
@@ -204,6 +208,23 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 	handler = handler_desc->address_space.handler;
 	address = (region_obj->region.address + region_offset);
 
+	ACPI_DEBUG_PRINT((ACPI_DB_OPREGION,
+			  "Handler %p (@%p) Address %8.8X%8.8X [%s]\n",
+			  &region_obj->region.handler->address_space, handler,
+			  ACPI_FORMAT_UINT64(address),
+			  acpi_ut_get_region_name(region_obj->region.
+						  space_id)));
+
+	if (!(handler_desc->address_space.handler_flags &
+	      ACPI_ADDR_HANDLER_DEFAULT_INSTALLED)) {
+		/*
+		 * For handlers other than the default (supplied) handlers, we must
+		 * exit the interpreter because the handler *might* block -- we don't
+		 * know what it will do, so we can't hold the lock on the interpreter.
+		 */
+		acpi_ex_exit_interpreter();
+	}
+
 	/*
 	 * Special handling for generic_serial_bus and general_purpose_io:
 	 * There are three extra parameters that must be passed to the
@@ -212,6 +233,11 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 	 *   2) Length of the above buffer
 	 *   3) Actual access length from the access_as() op
 	 *
+	 * Since we pass these extra parameters via the context, which is
+	 * shared between threads, we must lock the context to avoid these
+	 * parameters being changed from another thread before the handler
+	 * has completed running.
+	 *
 	 * In addition, for general_purpose_io, the Address and bit_width fields
 	 * are defined as follows:
 	 *   1) Address is the pin number index of the field (bit offset from
@@ -221,6 +247,14 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 	if ((region_obj->region.space_id == ACPI_ADR_SPACE_GSBUS) &&
 	    context && field_obj) {
 
+		status =
+		    acpi_os_acquire_mutex(context_mutex, ACPI_WAIT_FOREVER);
+		if (ACPI_FAILURE(status)) {
+			goto re_enter_interpreter;
+		}
+
+		context_locked = TRUE;
+
 		/* Get the Connection (resource_template) buffer */
 
 		context->connection = field_obj->field.resource_buffer;
@@ -230,6 +264,14 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 	if ((region_obj->region.space_id == ACPI_ADR_SPACE_GPIO) &&
 	    context && field_obj) {
 
+		status =
+		    acpi_os_acquire_mutex(context_mutex, ACPI_WAIT_FOREVER);
+		if (ACPI_FAILURE(status)) {
+			goto re_enter_interpreter;
+		}
+
+		context_locked = TRUE;
+
 		/* Get the Connection (resource_template) buffer */
 
 		context->connection = field_obj->field.resource_buffer;
@@ -239,28 +281,15 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 		bit_width = field_obj->field.bit_length;
 	}
 
-	ACPI_DEBUG_PRINT((ACPI_DB_OPREGION,
-			  "Handler %p (@%p) Address %8.8X%8.8X [%s]\n",
-			  &region_obj->region.handler->address_space, handler,
-			  ACPI_FORMAT_UINT64(address),
-			  acpi_ut_get_region_name(region_obj->region.
-						  space_id)));
-
-	if (!(handler_desc->address_space.handler_flags &
-	      ACPI_ADDR_HANDLER_DEFAULT_INSTALLED)) {
-		/*
-		 * For handlers other than the default (supplied) handlers, we must
-		 * exit the interpreter because the handler *might* block -- we don't
-		 * know what it will do, so we can't hold the lock on the interpreter.
-		 */
-		acpi_ex_exit_interpreter();
-	}
-
 	/* Call the handler */
 
 	status = handler(function, address, bit_width, value, context,
 			 region_obj2->extra.region_context);
 
+	if (context_locked) {
+		acpi_os_release_mutex(context_mutex);
+	}
+
 	if (ACPI_FAILURE(status)) {
 		ACPI_EXCEPTION((AE_INFO, status, "Returned by Handler for [%s]",
 				acpi_ut_get_region_name(region_obj->region.
@@ -277,6 +306,7 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 		}
 	}
 
+re_enter_interpreter:
 	if (!(handler_desc->address_space.handler_flags &
 	      ACPI_ADDR_HANDLER_DEFAULT_INSTALLED)) {
 		/*
diff --git a/drivers/acpi/acpica/evxfregn.c b/drivers/acpi/acpica/evxfregn.c
index da97fd0c6b51..3bb06f17a18b 100644
--- a/drivers/acpi/acpica/evxfregn.c
+++ b/drivers/acpi/acpica/evxfregn.c
@@ -201,6 +201,8 @@ acpi_remove_address_space_handler(acpi_handle device,
 
 			/* Now we can delete the handler object */
 
+			acpi_os_release_mutex(handler_obj->address_space.
+					      context_mutex);
 			acpi_ut_remove_reference(handler_obj);
 			goto unlock_and_exit;
 		}
-- 
2.30.1

