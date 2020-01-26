Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3C79149B38
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 16:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgAZPCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 10:02:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21740 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725773AbgAZPCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jan 2020 10:02:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580050959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6/+tHocZErL7Y6LXRM3rxyHptPaj/JOElin4yBKSSZU=;
        b=OlD4HTQIRcKlRjXeAAueW0ir9oUOTsu5ZpiS78CMTMjeZB+oMlUadsSGrqs4iii+8vk42T
        s9tbiVaLRgKIEqC1VTjBGGEfn4viZjFHeQWUv2TbivrWDV6RA4ia//nEk3mMJ/Z376f6Er
        QKs029K/5ZoD/wRcGJQl0ZXUBnYLhSQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-qJ8BVGLqPLqXazyL2SLcRg-1; Sun, 26 Jan 2020 10:02:34 -0500
X-MC-Unique: qJ8BVGLqPLqXazyL2SLcRg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B427A800D41;
        Sun, 26 Jan 2020 15:02:33 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-101.ams2.redhat.com [10.36.116.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9895E806B7;
        Sun, 26 Jan 2020 15:02:32 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-efi@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] efi/bgrt: Accept BGRT tables with a version of 0 on Lenovo laptops
Date:   Sun, 26 Jan 2020 16:02:31 +0100
Message-Id: <20200126150231.6021-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some (somewhat older) Lenovo laptops have a correct BGRT table, except
that the version field is 0 instead of 1.

Quickly after finding this out, even before submitting a first version of
this patch upstream, the list of DMI matches for affected models grew to
3 models (all Ivy Bridge based).

So rather then maintaining an ever growing list with DMI matches for
affected Lenovo models, this commit simply checks if the vendor is Lenovo
when the version is 0 and in that case accepts the out of spec version
working around the Lenovo firmware bug.

Cc: stable@vger.kernel.org
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=3D1791273
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/firmware/efi/efi-bgrt.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi-bgrt.c b/drivers/firmware/efi/efi-b=
grt.c
index b07c17643210..3a2d6d3a590b 100644
--- a/drivers/firmware/efi/efi-bgrt.c
+++ b/drivers/firmware/efi/efi-bgrt.c
@@ -15,6 +15,7 @@
 #include <linux/acpi.h>
 #include <linux/efi.h>
 #include <linux/efi-bgrt.h>
+#include <linux/dmi.h>
=20
 struct acpi_table_bgrt bgrt_tab;
 size_t bgrt_image_size;
@@ -42,7 +43,12 @@ void __init efi_bgrt_init(struct acpi_table_header *ta=
ble)
 		return;
 	}
 	*bgrt =3D *(struct acpi_table_bgrt *)table;
-	if (bgrt->version !=3D 1) {
+	/*
+	 * Some older Lenovo laptops have a correct BGRT table, except that
+	 * the version field is 0 instead of 1.
+	 */
+	if (bgrt->version !=3D 1 &&
+	    !(bgrt->version =3D=3D 0 && dmi_name_in_vendors("LENOVO"))) {
 		pr_notice("Ignoring BGRT: invalid version %u (expected 1)\n",
 		       bgrt->version);
 		goto out;
--=20
2.24.1

