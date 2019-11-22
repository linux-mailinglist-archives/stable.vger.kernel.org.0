Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84AF91077BE
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 19:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfKVS4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 13:56:55 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39386 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727073AbfKVS4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 13:56:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574449013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jBnPiIbqZnW5Cn4vlFkSXflRI7htnpcU1V030aSJGTw=;
        b=SIKZgnN+MF8yYj1clhCLpQ2qRI0Hgbuixd47QESOnceIeIrwq65U7Js3zm+m/rdPpR/2G5
        u8uzBtdS9yKUJi6GUSh5d5iKgrqDxfTheqCSuhAXHCtZMVT5hwQ+xlRaHjHnMeyKjX1+BV
        5DfM+z6dJKuMrjiBVsscl2j9RMwngvk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-xUXxCAKCN12Cs3TQCSuy5A-1; Fri, 22 Nov 2019 13:56:52 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6A9E1800D41;
        Fri, 22 Nov 2019 18:56:50 +0000 (UTC)
Received: from dhcp-44-196.space.revspace.nl (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 268B32937D;
        Fri, 22 Nov 2019 18:56:48 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/2] platform/x86: hp-wmi: Fix ACPI errors caused by passing 0 as input size
Date:   Fri, 22 Nov 2019 19:56:41 +0100
Message-Id: <20191122185641.60711-2-hdegoede@redhat.com>
In-Reply-To: <20191122185641.60711-1-hdegoede@redhat.com>
References: <20191122185641.60711-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: xUXxCAKCN12Cs3TQCSuy5A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The AML code implementing the WMI methods creates a variable length
field to hold the input data we pass like this:

        CreateDWordField (Arg1, 0x0C, DSZI)
        Local5 =3D DSZI /* \HWMC.DSZI */
        CreateField (Arg1, 0x80, (Local5 * 0x08), DAIN)

If we pass 0 as bios_args.datasize argument then (Local5 * 0x08)
is 0 which results in these errors:

[   71.973305] ACPI BIOS Error (bug): Attempt to CreateField of length zero=
 (20190816/dsopcode-133)
[   71.973332] ACPI Error: Aborting method \HWMC due to previous error (AE_=
AML_OPERAND_VALUE) (20190816/psparse-529)
[   71.973413] ACPI Error: Aborting method \_SB.WMID.WMAA due to previous e=
rror (AE_AML_OPERAND_VALUE) (20190816/psparse-529)

And in our HPWMI_WIRELESS2_QUERY calls always failing. for read commands
like HPWMI_WIRELESS2_QUERY the DSZI value is not used / checked, except for
read commands where extra input is needed to specify exactly what to read.

So for HPWMI_WIRELESS2_QUERY we can safely pass the size of the expected
output as insize to hp_wmi_perform_query(), as we are already doing for all
other HPWMI_READ commands we send. Doing so fixes these errors.

Cc: stable@vger.kernel.org
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D197007
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D201981
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=3D1520703
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/hp-wmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index e64ae58ec22b..9579a706fc08 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -380,7 +380,7 @@ static int hp_wmi_rfkill2_refresh(void)
 =09int err, i;
=20
 =09err =3D hp_wmi_perform_query(HPWMI_WIRELESS2_QUERY, HPWMI_READ, &state,
-=09=09=09=09   0, sizeof(state));
+=09=09=09=09   sizeof(state), sizeof(state));
 =09if (err)
 =09=09return err;
=20
@@ -778,7 +778,7 @@ static int __init hp_wmi_rfkill2_setup(struct platform_=
device *device)
 =09int err, i;
=20
 =09err =3D hp_wmi_perform_query(HPWMI_WIRELESS2_QUERY, HPWMI_READ, &state,
-=09=09=09=09   0, sizeof(state));
+=09=09=09=09   sizeof(state), sizeof(state));
 =09if (err)
 =09=09return err < 0 ? err : -EINVAL;
=20
--=20
2.23.0

