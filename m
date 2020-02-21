Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED04F167312
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732290AbgBUIJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:09:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:43744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732284AbgBUIJB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:09:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6BBC222C4;
        Fri, 21 Feb 2020 08:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272540;
        bh=teUobBFCXUBEpKpDbbEGdq0BcRMk1aP5qnU0nEch0KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ma16ei1uLtk6T9vJAjlCcWNPBgnGK3ocPVMaboKxj6MlgS4bUI4MLrciOXMVeflYX
         o0KLoXVBUb1euFDXbaYXv0W4MjrCek8IasaPI4USUezQy+RBYVtTm9k+8Yjjffhj5U
         jgo5Z7eVAPmENZVT0wqkzNz3I7IevmqnIPPGBs3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elia Geretto <elia.f.geretto@gmail.com>,
        Bob Moore <robert.moore@intel.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 144/344] ACPICA: Disassembler: create buffer fields in ACPI_PARSE_LOAD_PASS1
Date:   Fri, 21 Feb 2020 08:39:03 +0100
Message-Id: <20200221072401.882481704@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index cf4e061bb0f0b..8438e33aa4474 100644
--- a/drivers/acpi/acpica/dsfield.c
+++ b/drivers/acpi/acpica/dsfield.c
@@ -244,7 +244,7 @@ cleanup:
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



