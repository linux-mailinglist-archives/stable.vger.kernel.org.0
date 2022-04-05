Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474A94F2EE9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344957AbiDEKkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244037AbiDEJlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:41:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1162CBAB85;
        Tue,  5 Apr 2022 02:25:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2218B81CA1;
        Tue,  5 Apr 2022 09:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA28C385A4;
        Tue,  5 Apr 2022 09:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150706;
        bh=0IXNH02d04Pp3qo3nL8AHAf9mxn0yRHztLc0LEJHT3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsbO9boT9rs1b+MFc9Ldp5XmeWDtHQri5ClAQUjMMy7vULC66XDZL3zAALq11DPIO
         eQYBwqeZRnIfjYBOpcU2YPlBsMHVw/VpeYM2Ensrdx2RSaExvMz8ZBUEhy6kgVkNy9
         RdGCTELOAoZ3dod0rzAJ/KZffKq/TmEnYOfACvEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jocelyn Falempe <jfalempe@redhat.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Lyude Paul <lyude@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.15 151/913] mgag200 fix memmapsl configuration in GCTL6 register
Date:   Tue,  5 Apr 2022 09:20:13 +0200
Message-Id: <20220405070344.363816649@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jocelyn Falempe <jfalempe@redhat.com>

commit 028a73e10705af1ffd51f2537460f616dc58680e upstream.

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
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220119102905.1194787-1-jfalempe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mgag200/mgag200_mode.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -529,7 +529,10 @@ static void mgag200_set_format_regs(stru
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
 


