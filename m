Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CE46877A5
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 09:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjBBIhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 03:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjBBIhE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 03:37:04 -0500
X-Greylist: delayed 575 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Feb 2023 00:36:35 PST
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4BF10273
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 00:36:34 -0800 (PST)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id E8FC013ED236;
        Thu,  2 Feb 2023 11:26:56 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru E8FC013ED236
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1675326417; bh=P4Sz+Or5QkPB22EwbVluoSpgaCwjgCRN0S/0gr+vhzU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=hUfRX5pCc32k5dkeDAzM5xQL98bzrQ3Aao7+lHC3atpQrZSEvTGKrTJgTNCRdhInz
         5Cq+8V1yFtZMGIhjlZFI0zE7ML7YCTbolOQOMvmQvQFF+5Z5pJZab22Xz2YBBsjUKM
         UWgefXPVUtuUUnMigIUKSqrqLVjIX2b9cqwahszs=
Received: from msk-exch-01.infotecs-nt (msk-exch-01.infotecs-nt [10.0.7.191])
        by mx0.infotecs-nt (Postfix) with ESMTP id E388D3069DA4;
        Thu,  2 Feb 2023 11:26:56 +0300 (MSK)
From:   Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
To:     "kim.phillips@amd.com" <kim.phillips@amd.com>
CC:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>,
        "Vincent.Wan@amd.com" <Vincent.Wan@amd.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "will@kernel.org" <will@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2] iommu/amd: Add a length limitation for the ivrs_acpihid
 command-line parameter
Thread-Topic: [PATCH v2] iommu/amd: Add a length limitation for the
 ivrs_acpihid command-line parameter
Thread-Index: AQHZNuAcYYi++x82V0GUoMRoGydTPg==
Date:   Thu, 2 Feb 2023 08:26:56 +0000
Message-ID: <20230202082719.1513849-1-Ilia.Gavrilov@infotecs.ru>
References: <39506e9f-9bbb-fcf6-b488-542fd3657eae@amd.com>
In-Reply-To: <39506e9f-9bbb-fcf6-b488-542fd3657eae@amd.com>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.17.0.10]
x-exclaimer-md-config: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 175194 [Feb 02 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_from_domain_doesnt_match_to}, infotecs.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/02/02 07:35:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/02/02 02:42:00 #20830374
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The 'acpiid' buffer in the parse_ivrs_acpihid function may overflow,
because the string specifier in the format string sscanf()
has no width limitation.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: ca3bf5d47cec ("iommu/amd: Introduces ivrs_acpihid kernel parameter")
Cc: stable@vger.kernel.org
Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
---
V2: Fix typo in the subject
 drivers/iommu/amd/init.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 467b194975b3..19a46b9f7357 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3475,15 +3475,26 @@ static int __init parse_ivrs_hpet(char *str)
 	return 1;
 }
=20
+#define ACPIID_LEN (ACPIHID_UID_LEN + ACPIHID_HID_LEN)
+
 static int __init parse_ivrs_acpihid(char *str)
 {
 	u32 seg =3D 0, bus, dev, fn;
 	char *hid, *uid, *p, *addr;
-	char acpiid[ACPIHID_UID_LEN + ACPIHID_HID_LEN] =3D {0};
+	char acpiid[ACPIID_LEN] =3D {0};
 	int i;
=20
 	addr =3D strchr(str, '@');
 	if (!addr) {
+		addr =3D strchr(str, '=3D');
+		if (!addr)
+			goto not_found;
+
+		++addr;
+
+		if (strlen(addr) > ACPIID_LEN)
+			goto not_found;
+
 		if (sscanf(str, "[%x:%x.%x]=3D%s", &bus, &dev, &fn, acpiid) =3D=3D 4 ||
 		    sscanf(str, "[%x:%x:%x.%x]=3D%s", &seg, &bus, &dev, &fn, acpiid) =3D=
=3D 5) {
 			pr_warn("ivrs_acpihid%s option format deprecated; use ivrs_acpihid=3D%s=
@%04x:%02x:%02x.%d instead\n",
@@ -3496,6 +3507,9 @@ static int __init parse_ivrs_acpihid(char *str)
 	/* We have the '@', make it the terminator to get just the acpiid */
 	*addr++ =3D 0;
=20
+	if (strlen(str) > ACPIID_LEN + 1)
+		goto not_found;
+
 	if (sscanf(str, "=3D%s", acpiid) !=3D 1)
 		goto not_found;
=20
--=20
2.30.2
