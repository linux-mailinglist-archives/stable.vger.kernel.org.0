Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD9E0123565
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 20:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfLQTIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 14:08:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47594 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726731AbfLQTIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 14:08:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576609696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9SZztgkt4hsOS7juNUs09VjfZrBBGCxfzt1D6SjtF+4=;
        b=J6UWjNhy32HqBt+qItWFVbZX+fa46lPmsjGef+k3jWgTs4uwQgDDtNh4ukCQbBxXLYb0VF
        fzE4KJL/fmxGii4cdyPvKlOB+hCPfm3Hixy2zTo8EgbMzxEPo3w0veeecRWdeJbBLjb6TT
        wz7hFZJDkoDiN1h+jAInSEhbMyjv5Ys=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-EL6cZdH6MhWpyFGjU07UyA-1; Tue, 17 Dec 2019 14:08:14 -0500
X-MC-Unique: EL6cZdH6MhWpyFGjU07UyA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5A5FA1CD7;
        Tue, 17 Dec 2019 19:08:13 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-227.ams2.redhat.com [10.36.116.227])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 881917C82C;
        Tue, 17 Dec 2019 19:08:12 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] ACPI: video: Do not export a non working backlight interface on MSI MS-7721 boards
Date:   Tue, 17 Dec 2019 20:08:11 +0100
Message-Id: <20191217190811.638607-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Despite our heuristics to not wrongly export a non working ACPI backlight
interface on desktop machines, we still end up exporting one on desktops
using a motherboard from the MSI MS-7721 series.

I've looked at improving the heuristics, but in this case a quirk seems
to be the only way to solve this.

While at it also add a comment to separate the video_detect_force_none
entries in the video_detect_dmi_table from other type of entries, as we
already do for the other entry types.

Cc: stable@vger.kernel.org
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=3D1783786
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/acpi/video_detect.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 31014c7d3793..e63fd7bfd3a5 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -336,6 +336,11 @@ static const struct dmi_system_id video_detect_dmi_t=
able[] =3D {
 		DMI_MATCH(DMI_PRODUCT_NAME, "Precision 7510"),
 		},
 	},
+
+	/*
+	 * Desktops which falsely report a backlight and which our heuristics
+	 * for this do not catch.
+	 */
 	{
 	 .callback =3D video_detect_force_none,
 	 .ident =3D "Dell OptiPlex 9020M",
@@ -344,6 +349,14 @@ static const struct dmi_system_id video_detect_dmi_t=
able[] =3D {
 		DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 9020M"),
 		},
 	},
+	{
+	 .callback =3D video_detect_force_none,
+	 .ident =3D "MSI MS-7721",
+	 .matches =3D {
+		DMI_MATCH(DMI_SYS_VENDOR, "MSI"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "MS-7721"),
+		},
+	},
 	{ },
 };
=20
--=20
2.23.0

