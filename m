Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0495BB777
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 11:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiIQJQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 05:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIQJQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 05:16:39 -0400
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32B045F63;
        Sat, 17 Sep 2022 02:16:36 -0700 (PDT)
Date:   Sat, 17 Sep 2022 09:16:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1663406192; x=1663665392;
        bh=WtH1XiJMuAo2t7Ag08kalVAzbnlWzm46SLxhU7NTyU4=;
        h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID;
        b=wrMZSanWm0KJNnm3ykOCdOL3myVpKchYhLarOh+NsiXJB3cNn0XiZL2PXDM6LtgBL
         3apqAbQLnHqEh+eoVn63MLzOc906v+d+cUbfJ7xjwtZPIpLDp0VA5MAShrxzjReeR5
         M7EvduAsjV/qy4vIacG6Y4U/isHOKKOzBg/bah+2GmOqPNKtrznVv1st9g2xOZEqkV
         XUeyh6D0dktGbx7x+5AFx72NVxUZP4NlfAo2XDtrCaycemsJPpqV6rVhIEdjUd7wzp
         0MAp+ypX4PO1Rlcbi6BYF02vair4YktlZi5QGPL6Pye/WVA25lTRB3xEw+Nwd0/b0a
         sZMpKhkpZNHrw==
To:     linux-kernel@vger.kernel.org
From:   Orlando Chamberlain <redecorating@protonmail.com>
Cc:     jarkko@kernel.org, zohar@linux.ibm.com, dmitry.kasatkin@gmail.com,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
        gargaditya08@live.com, linux-integrity@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        Orlando Chamberlain <redecorating@protonmail.com>,
        stable@vger.kernel.org, Samuel Jiang <chyishian.jiang@gmail.com>
Subject: [PATCHv2 1/1] efi: Correct Macmini DMI match in uefi cert quirk
Message-ID: <20220917091532.3607-1-redecorating@protonmail.com>
Feedback-ID: 28131841:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It turns out Apple doesn't capitalise the "mini" in "Macmini" in DMI, which
is inconsistent with other model line names.

Correct the capitalisation of Macmini in the quirk for skipping loading
platform certs on T2 Macs.

Currently users get:

------------[ cut here ]------------
[Firmware Bug]: Page fault caused by firmware at PA: 0xffffa30640054000
WARNING: CPU: 1 PID: 8 at arch/x86/platform/efi/quirks.c:735 efi_crash_grac=
efully_on_page_fault+0x55/0xe0
Modules linked in:
CPU: 1 PID: 8 Comm: kworker/u12:0 Not tainted 5.18.14-arch1-2-t2 #1 4535eb3=
fc40fd08edab32a509fbf4c9bc52d111e
Hardware name: Apple Inc. Macmini8,1/Mac-7BA5B2DFE22DDD8C, BIOS 1731.120.10=
.0.0 (iBridge: 19.16.15071.0.0,0) 04/24/2022
Workqueue: efi_rts_wq efi_call_rts
...
---[ end trace 0000000000000000 ]---
efi: Froze efi_rts_wq and disabled EFI Runtime Services
integrity: Couldn't get size: 0x8000000000000015
integrity: MODSIGN: Couldn't get UEFI db list
efi: EFI Runtime Services are disabled!
integrity: Couldn't get size: 0x8000000000000015
integrity: Couldn't get UEFI dbx list

Fixes: 155ca952c7ca ("efi: Do not import certificates from UEFI Secure Boot=
 for T2 Macs")
Cc: stable@vger.kernel.org
Cc: Aditya Garg <gargaditya08@live.com>
Tested-by: Samuel Jiang <chyishian.jiang@gmail.com>
Signed-off-by: Orlando Chamberlain <redecorating@protonmail.com>
---
v1->v2: Clarified in commit message that this is for a dmi match string
 security/integrity/platform_certs/load_uefi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/integrity/platform_certs/load_uefi.c b/security/integ=
rity/platform_certs/load_uefi.c
index 093894a640dc..b78753d27d8e 100644
--- a/security/integrity/platform_certs/load_uefi.c
+++ b/security/integrity/platform_certs/load_uefi.c
@@ -31,7 +31,7 @@ static const struct dmi_system_id uefi_skip_cert[] =3D {
 =09{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,1") },
 =09{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,2") },
 =09{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir9,1") },
-=09{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacMini8,1") },
+=09{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "Macmini8,1") },
 =09{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacPro7,1") },
 =09{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,1") },
 =09{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,2") },
--=20
2.37.1


