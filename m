Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58165EF4B1
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 13:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235104AbiI2LuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 07:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235050AbiI2LuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 07:50:19 -0400
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1C2AE222;
        Thu, 29 Sep 2022 04:50:08 -0700 (PDT)
Date:   Thu, 29 Sep 2022 11:49:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1664452202; x=1664711402;
        bh=WtH1XiJMuAo2t7Ag08kalVAzbnlWzm46SLxhU7NTyU4=;
        h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID;
        b=Mp2BmKbJWOuTGrcIJoPHC0MHj8lnJeeNTqljJjrOsuOCJ+Ez6hyCL4UtQwJjtsTXd
         GHCEMsJF44x6y7o/G+wZmEDul2Vr+orSquypidICfFOc2IMgxFbF0H8neHs2bInJ5F
         eXe7fHcQqlp3bzgS5K7qoID3/Hc5zme5zWlr92NxIvrD1YjXOn2w8MB0LeqkeEr53W
         pRi/a4VzWQ3tyqOMPoIVPkV1JD0Xam6/PKC0tW/OPNyMH6iVEczKnIC7K19tqbBHCF
         7TRx/ODy0XrvBhaZh4tV1OcKG8f4tdC7kN8hGk7iO0YS8qpJdvdnZX7spkEedd4QTL
         dkPUjNfVseQkg==
To:     linux-kernel@vger.kernel.org
From:   Orlando Chamberlain <redecorating@protonmail.com>
Cc:     jarkko@kernel.org, zohar@linux.ibm.com, dmitry.kasatkin@gmail.com,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
        gargaditya08@live.com, linux-integrity@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        Orlando Chamberlain <redecorating@protonmail.com>,
        stable@vger.kernel.org, Samuel Jiang <chyishian.jiang@gmail.com>
Subject: [PATCHv2 RESEND] efi: Correct Macmini DMI match in uefi cert quirk
Message-ID: <20220929114906.85021-1-redecorating@protonmail.com>
Feedback-ID: 28131841:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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


