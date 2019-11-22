Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5F291077BC
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 19:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfKVS4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 13:56:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60564 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726703AbfKVS4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 13:56:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574449011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=o7UQGsdc4PZZnnBT3bf9nk8GRbUpAvujWuHFxrAdQpo=;
        b=SL5NLUpIdlzbA3g8IPSYmum/RZ+h9KARO0JenplfuOr/+7DqhB+Ut6MJC4jsWHo1xwsQ/u
        pwtuv+4yXRtXjQZrQU08t/I6lgr1Fbfv1zy6FD/ODjs36qS5S11/b8yhUlec6v//g00xEt
        2HcHehT2Ys/YIaFewtlxuVNQirBVZMw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-6M9qtd2wP8WoJT3OZJATWQ-1; Fri, 22 Nov 2019 13:56:50 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA1548018A3;
        Fri, 22 Nov 2019 18:56:48 +0000 (UTC)
Received: from dhcp-44-196.space.revspace.nl (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 062552937D;
        Fri, 22 Nov 2019 18:56:46 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/2] platform/x86: hp-wmi: Fix ACPI errors caused by too small buffer
Date:   Fri, 22 Nov 2019 19:56:40 +0100
Message-Id: <20191122185641.60711-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 6M9qtd2wP8WoJT3OZJATWQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The HP WMI calls may take up to 128 bytes of data as input, and
the AML methods implementing the WMI calls, declare a couple of fields for
accessing input in different sizes, specifycally the HWMC method contains:

        CreateField (Arg1, 0x80, 0x0400, D128)

Even though we do not use any of the WMI command-types which need a buffer
of this size, the APCI interpreter still tries to create it as it is
declared in generoc code at the top of the HWMC method which runs before
the code looks at which command-type is requested.

This results in many of these errors on many different HP laptop models:

[   14.459261] ACPI Error: Field [D128] at 1152 exceeds Buffer [NULL] size =
160 (bits) (20170303/dsopcode-236)
[   14.459268] ACPI Error: Method parse/execution failed [\HWMC] (Node ffff=
8edcc61507f8), AE_AML_BUFFER_LIMIT (20170303/psparse-543)
[   14.459279] ACPI Error: Method parse/execution failed [\_SB.WMID.WMAA] (=
Node ffff8edcc61523c0), AE_AML_BUFFER_LIMIT (20170303/psparse-543)

This commit increases the size of the data element of the bios_args struct
to 128 bytes fixing these errors.

Cc: stable@vger.kernel.org
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D197007
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D201981
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=3D1520703
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/hp-wmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 6bcbbb375401..e64ae58ec22b 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -65,7 +65,7 @@ struct bios_args {
 =09u32 command;
 =09u32 commandtype;
 =09u32 datasize;
-=09u32 data;
+=09u8 data[128];
 };
=20
 enum hp_wmi_commandtype {
@@ -216,7 +216,7 @@ static int hp_wmi_perform_query(int query, enum hp_wmi_=
command command,
 =09=09.command =3D command,
 =09=09.commandtype =3D query,
 =09=09.datasize =3D insize,
-=09=09.data =3D 0,
+=09=09.data =3D { 0 },
 =09};
 =09struct acpi_buffer input =3D { sizeof(struct bios_args), &args };
 =09struct acpi_buffer output =3D { ACPI_ALLOCATE_BUFFER, NULL };
@@ -228,7 +228,7 @@ static int hp_wmi_perform_query(int query, enum hp_wmi_=
command command,
=20
 =09if (WARN_ON(insize > sizeof(args.data)))
 =09=09return -EINVAL;
-=09memcpy(&args.data, buffer, insize);
+=09memcpy(&args.data[0], buffer, insize);
=20
 =09wmi_evaluate_method(HPWMI_BIOS_GUID, 0, mid, &input, &output);
=20
--=20
2.23.0

