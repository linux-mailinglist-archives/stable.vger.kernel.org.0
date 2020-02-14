Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E01A915F272
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392886AbgBNSJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:09:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731398AbgBNPyD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:54:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBEFE24673;
        Fri, 14 Feb 2020 15:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695642;
        bh=a+0P4OBWj0cgdkkZQxHaAz1SpkpOLfghHWdDzLg8tj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Swwb9bs7DMktFX0cPgSP7+MBPh+yd+qDaqrH5fwBDa7ncF0NNfhyzIwbGqh/zZ/p/
         BD5rFHEQbI/DMNHExaG+rOKXxXmXv9ZzHFVR0rW8AKDYwgplBiVIRhw5Q5LA7qczir
         R8H6g7qm/9NgYFrs5KnLwLdYnzBEF/cnvtIJRR/g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erik Kaneda <erik.kaneda@intel.com>,
        Elia Geretto <elia.f.geretto@gmail.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 5.5 237/542] ACPICA: Disassembler: create buffer fields in ACPI_PARSE_LOAD_PASS1
Date:   Fri, 14 Feb 2020 10:43:49 -0500
Message-Id: <20200214154854.6746-237-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erik Kaneda <erik.kaneda@intel.com>

[ Upstream commit 5ddbd77181dfca61b16d2e2222382ea65637f1b9 ]

ACPICA commit 29cc8dbc5463a93625bed87d7550a8bed8913bf4

create_buffer_field is a deferred op that is typically processed in
load pass 2. However, disassembly of control method contents walk the
parse tree with ACPI_PARSE_LOAD_PASS1 and AML_CREATE operators are
processed in a later walk. This is a problem when there is a control
method that has the same name as the AML_CREATE object. In this case,
any use of the name segment will be detected as a method call rather
than a reference to a buffer field. If this is detected as a method
call, it can result in a mal-formed parse tree if the control methods
have parameters.

This change in processing AML_CREATE ops earlier solves this issue by
inserting the named object in the ACPI namespace so that references
to this name would be detected as a name string rather than a method
call.

Link: https://github.com/acpica/acpica/commit/29cc8dbc
Reported-by: Elia Geretto <elia.f.geretto@gmail.com>
Tested-by: Elia Geretto <elia.f.geretto@gmail.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Erik Kaneda <erik.kaneda@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/dsfield.c |  2 +-
 drivers/acpi/acpica/dswload.c | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/dsfield.c b/drivers/acpi/acpica/dsfield.c
index faa38a22263ad..ae713d746c8b8 100644
--- a/drivers/acpi/acpica/dsfield.c
+++ b/drivers/acpi/acpica/dsfield.c
@@ -243,7 +243,7 @@ acpi_ds_create_buffer_field(union acpi_parse_object *op,
  * FUNCTION:    acpi_ds_get_field_names
  *
  * PARAMETERS:  info            - create_field info structure
- *  `           walk_state      - Current method state
+ *              walk_state      - Current method state
  *              arg             - First parser arg for the field name list
  *
  * RETURN:      Status
diff --git a/drivers/acpi/acpica/dswload.c b/drivers/acpi/acpica/dswload.c
index c88fd31208a5b..4bcf15bf03ded 100644
--- a/drivers/acpi/acpica/dswload.c
+++ b/drivers/acpi/acpica/dswload.c
@@ -410,6 +410,27 @@ acpi_status acpi_ds_load1_end_op(struct acpi_walk_state *walk_state)
 	ACPI_DEBUG_PRINT((ACPI_DB_DISPATCH, "Op=%p State=%p\n", op,
 			  walk_state));
 
+	/*
+	 * Disassembler: handle create field operators here.
+	 *
+	 * create_buffer_field is a deferred op that is typically processed in load
+	 * pass 2. However, disassembly of control method contents walk the parse
+	 * tree with ACPI_PARSE_LOAD_PASS1 and AML_CREATE operators are processed
+	 * in a later walk. This is a problem when there is a control method that
+	 * has the same name as the AML_CREATE object. In this case, any use of the
+	 * name segment will be detected as a method call rather than a reference
+	 * to a buffer field.
+	 *
+	 * This earlier creation during disassembly solves this issue by inserting
+	 * the named object in the ACPI namespace so that references to this name
+	 * would be a name string rather than a method call.
+	 */
+	if ((walk_state->parse_flags & ACPI_PARSE_DISASSEMBLE) &&
+	    (walk_state->op_info->flags & AML_CREATE)) {
+		status = acpi_ds_create_buffer_field(op, walk_state);
+		return_ACPI_STATUS(status);
+	}
+
 	/* We are only interested in opcodes that have an associated name */
 
 	if (!(walk_state->op_info->flags & (AML_NAMED | AML_FIELD))) {
-- 
2.20.1

