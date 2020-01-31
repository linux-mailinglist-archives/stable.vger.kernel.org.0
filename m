Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AED8E14ECEC
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 14:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbgAaNGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 08:06:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55525 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728544AbgAaNGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 08:06:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580475992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oyWbxDiWwx0o1DWN8s0a2KTquRs9xNqQuo7yNFc8UJk=;
        b=UmzODbmpLECJcgFBnOLEppVNbHXf/g93EHezHt+GBUkjLLL1C20h30M/7u5k2Z94jJF1B/
        lpkJIIbQ6OYTURNt/BT2IERbIW+7x0J3utXg8OvKixLSCKDSw+rVR1sE5a3a4pG0tAFSd8
        1eT9DDZjFsXpfwC/8xW7m3d3R23AAwU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-Rz5p1LzWNRWrYMuIpaZ-nA-1; Fri, 31 Jan 2020 08:06:30 -0500
X-MC-Unique: Rz5p1LzWNRWrYMuIpaZ-nA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A30BB8010E9;
        Fri, 31 Jan 2020 13:06:28 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-36.ams2.redhat.com [10.36.112.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 422C063147;
        Fri, 31 Jan 2020 13:06:26 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-efi@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] efi/bgrt: Accept BGRT tables with a version of 0
Date:   Fri, 31 Jan 2020 14:06:23 +0100
Message-Id: <20200131130623.33875-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some (somewhat older) laptops have a correct BGRT table, except that the
version field is 0 instead of 1.

This has been seen on several Ivy Bridge based Lenovo models.

For now the spec. only defines version 1, so it is reasonably safe to
assume that tables with a version of 0 really are version 1 too,
which is what this commit does so that the BGRT table will be accepted
by the kernel on laptop models with this issue.

Cc: stable@vger.kernel.org
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=3D1791273
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
- Simply always accept version 0 everywhere as suggested by Ard
---
 drivers/firmware/efi/efi-bgrt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi-bgrt.c b/drivers/firmware/efi/efi-b=
grt.c
index b07c17643210..6aafdb67dbca 100644
--- a/drivers/firmware/efi/efi-bgrt.c
+++ b/drivers/firmware/efi/efi-bgrt.c
@@ -42,7 +42,12 @@ void __init efi_bgrt_init(struct acpi_table_header *ta=
ble)
 		return;
 	}
 	*bgrt =3D *(struct acpi_table_bgrt *)table;
-	if (bgrt->version !=3D 1) {
+	/*
+	 * Only version 1 is defined but some older laptops (seen on Lenovo
+	 * Ivy Bridge models) have a correct version 1 BGRT table with the
+	 * version set to 0, so we accept version 0 and 1.
+	 */
+	if (bgrt->version > 1) {
 		pr_notice("Ignoring BGRT: invalid version %u (expected 1)\n",
 		       bgrt->version);
 		goto out;
--=20
2.23.0

