Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31878376D81
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 01:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhEGXyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 19:54:55 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:31048 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhEGXyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 19:54:55 -0400
Date:   Fri, 07 May 2021 23:53:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1620431633;
        bh=pUF9ygArXXTjymauOLFgoYrPve2e0r7z5fiJ/eIXyDY=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=dvRXW7vsNtU+mxey1GGhsXAylpCHJuDV4bieKnTC3JGUwZQzuzqSyURXynbNdplom
         kRQDgfi+mkxrCElV6WCIKRe1jwx3okbyTZJshiOGSZXQNNIt+HmL2aAbVK1J7JCtvS
         J+ItM9H4scvtVvXk/0LPeraFRDpJsWCS2VOj6BLQ=
To:     hdegoede@redhat.com, mgross@linux.intel.com, ike.pan@canonical.com,
        platform-driver-x86@vger.kernel.org
From:   =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     stable@vger.kernel.org
Reply-To: =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Subject: [PATCH] platform/x86: ideapad-laptop: fix method name typo
Message-ID: <20210507235333.286505-1-pobrn@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"smbc" should be "sbmc". `eval_smbc()` incorrectly called
the SMBC ACPI method instead of SBMC. This resulted in
partial loss of functionality. Rectify that by calling
the correct ACPI method (SBMC), and also rename
methods and constants.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D212985
Fixes: 0b765671cb80 ("platform/x86: ideapad-laptop: group and separate (un)=
related constants into enums")
Fixes: ff36b0d953dc ("platform/x86: ideapad-laptop: rework and create new A=
CPI helpers")
Cc: stable@vger.kernel.org # 5.12
Signed-off-by: Barnab=C3=A1s P=C5=91cze <pobrn@protonmail.com>
---
 drivers/platform/x86/ideapad-laptop.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/i=
deapad-laptop.c
index 6cb5ad4be231..8472aa4c5017 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -57,8 +57,8 @@ enum {
 };

 enum {
-=09SMBC_CONSERVATION_ON  =3D 3,
-=09SMBC_CONSERVATION_OFF =3D 5,
+=09SBMC_CONSERVATION_ON  =3D 3,
+=09SBMC_CONSERVATION_OFF =3D 5,
 };

 enum {
@@ -182,9 +182,9 @@ static int eval_gbmd(acpi_handle handle, unsigned long =
*res)
 =09return eval_int(handle, "GBMD", res);
 }

-static int exec_smbc(acpi_handle handle, unsigned long arg)
+static int exec_sbmc(acpi_handle handle, unsigned long arg)
 {
-=09return exec_simple_method(handle, "SMBC", arg);
+=09return exec_simple_method(handle, "SBMC", arg);
 }

 static int eval_hals(acpi_handle handle, unsigned long *res)
@@ -477,7 +477,7 @@ static ssize_t conservation_mode_store(struct device *d=
ev,
 =09if (err)
 =09=09return err;

-=09err =3D exec_smbc(priv->adev->handle, state ? SMBC_CONSERVATION_ON : SM=
BC_CONSERVATION_OFF);
+=09err =3D exec_sbmc(priv->adev->handle, state ? SBMC_CONSERVATION_ON : SB=
MC_CONSERVATION_OFF);
 =09if (err)
 =09=09return err;

--
2.31.1


