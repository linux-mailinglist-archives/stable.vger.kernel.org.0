Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0791D493872
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 11:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353707AbiASKaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 05:30:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52390 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240412AbiASKaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 05:30:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642588209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b1u3aFt23Q8cXZP69tEtyJ6IQ7TUp089FnaGsa9cy9s=;
        b=b7y4Yqas/3LyLwdSP6AGU3KMEI6SUgvI+LPkbiaWN22EFz8h0jyrZwUsYn3vb6EUQGU5M1
        qEZTiN0jiC7g3QWw5Z4JMunj/hyeN2JcBqfh6Et8s25jul/T49/GvW58PlzftmOCYW1Xa9
        P3xZVC66GPkwzoyKpNOUKIuU1VdHW50=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-416-2tAzsSr3M3K00THrb2n5LA-1; Wed, 19 Jan 2022 05:30:08 -0500
X-MC-Unique: 2tAzsSr3M3K00THrb2n5LA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AD26192AB6E;
        Wed, 19 Jan 2022 10:30:06 +0000 (UTC)
Received: from hydra.redhat.com (unknown [10.39.194.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2949673172;
        Wed, 19 Jan 2022 10:29:43 +0000 (UTC)
From:   Jocelyn Falempe <jfalempe@redhat.com>
To:     dri-devel@lists.freedesktop.org
Cc:     michel@daenzer.net, lyude@redhat.com, tzimmermann@suse.de,
        javierm@redhat.com, Jocelyn Falempe <jfalempe@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] mgag200 fix memmapsl configuration in GCTL6 register
Date:   Wed, 19 Jan 2022 11:29:05 +0100
Message-Id: <20220119102905.1194787-1-jfalempe@redhat.com>
In-Reply-To: <20220114094754.522401-1-jfalempe@redhat.com>
References: <20220114094754.522401-1-jfalempe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On some servers with MGA G200_SE_A (rev 42), booting with Legacy BIOS,
the hardware hangs when using kdump and kexec into the kdump kernel.
This happens when the uncompress code tries to write "Decompressing Linux"
to the VGA Console.

It can be reproduced by writing to the VGA console (0xB8000) after
booting to graphic mode, it generates the following error:

kernel:NMI: PCI system error (SERR) for reason a0 on CPU 0.
kernel:Dazed and confused, but trying to continue

The root cause is the configuration of the MGA GCTL6 register

According to the GCTL6 register documentation:

bit 0 is gcgrmode:
    0: Enables alpha mode, and the character generator addressing system is
     activated.
    1: Enables graphics mode, and the character addressing system is not
     used.

bit 1 is chainodd even:
    0: The A0 signal of the memory address bus is used during system memory
     addressing.
    1: Allows A0 to be replaced by either the A16 signal of the system
     address (ifmemmapsl is ‘00’), or by the hpgoddev (MISC<5>, odd/even
     page select) field, described on page 3-294).

bit 3-2 are memmapsl:
    Memory map select bits 1 and 0. VGA.
    These bits select where the video memory is mapped, as shown below:
        00 => A0000h - BFFFFh
        01 => A0000h - AFFFFh
        10 => B0000h - B7FFFh
        11 => B8000h - BFFFFh

bit 7-4 are reserved.

Current code set it to 0x05 => memmapsl to b01 => 0xa0000 (graphic mode)
But on x86, the VGA console is at 0xb8000 (text mode)
In arch/x86/boot/compressed/misc.c debug strings are written to 0xb8000
As the driver doesn't use this mapping at 0xa0000, it is safe to set it to
0xb8000 instead, to avoid kernel hang on G200_SE_A rev42, with kexec/kdump.

Thus changing the value 0x05 to 0x0d

Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
---

v2: Add clear statement that it's not the right configuration, but it
    prevents an annoying bug with kexec/kdump.

 drivers/gpu/drm/mgag200/mgag200_mode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index b983541a4c53..cd9ba13ad5fc 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -529,7 +529,10 @@ static void mgag200_set_format_regs(struct mga_device *mdev,
 	WREG_GFX(3, 0x00);
 	WREG_GFX(4, 0x00);
 	WREG_GFX(5, 0x40);
-	WREG_GFX(6, 0x05);
+	/* GCTL6 should be 0x05, but we configure memmapsl to 0xb8000 (text mode),
+	 * so that it doesn't hang when running kexec/kdump on G200_SE rev42.
+	 */
+	WREG_GFX(6, 0x0d);
 	WREG_GFX(7, 0x0f);
 	WREG_GFX(8, 0x0f);
 
-- 
2.34.1

