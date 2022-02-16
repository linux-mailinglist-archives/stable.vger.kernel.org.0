Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C214B817D
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 08:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiBPH0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 02:26:47 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:57454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiBPH0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 02:26:44 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9FB2DD5B;
        Tue, 15 Feb 2022 23:26:32 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id z4so1372361pgh.12;
        Tue, 15 Feb 2022 23:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=HO6taZEnI8YA7qrP/AT0huv3lF5MGGX042n8Oc6pmjE=;
        b=jbUFkgdVvvEXPqiJ+t2gDnE+y8iI1g1Er9neTmVbz9Cl3DhQUIln4lo/92HclKYh6l
         qWTTJ08Co9WvclPu3pIHcrLurkpZ5vJqowBqk7tH7nbOUDAxO5HzU9iMa03VKGa+JIvR
         ZKJP1F7TWfh48MXKToLNGUtZJl6pULLxkBPD6hLNG2eyEj8bU2pGC6veBaukFd0PA8QZ
         o8Wf8i59/6z0d8KZV71RiBn4x/vdLGTvSh0iTarawz2xj/FMcQddyVBpbVcJJfuWSqfj
         QrdeUYBO9Xm9dE5lJdRjZpbkqFTksMWWLcukxgnR4L4f2ZXpMCOsSrbtYc4C/uQo/e8q
         r/NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HO6taZEnI8YA7qrP/AT0huv3lF5MGGX042n8Oc6pmjE=;
        b=c+8XXE+7PAk+adlNBVgb0wXJS37GpgIExZ4gyASujabGSajrLtceIwqY7iOI9/FfRs
         7e1j4mXtxHEssD4RJO7rkUkf4P8F5lAqG7EWgtW/8IlQtbW1vRXgjiEvk1zYDz4w2eDc
         zT3HaljbeU6liazSwXSUpBhHDj12DJU2JcNYT6S/cwLdGXgpSPJlYE2UumZni6f1hWEk
         ZZ1qPv/rZUtWKgN3xLwMaWKQ8XPoDNpi5CHN/HqxHhkNX+lBPuY07PUfApLx8s/VNYYD
         4rdFJXQXS/kgjp0BtiKaioAi2heYZfKV0rlIvyhHBW4VMW6Z1BNFzKkAoivPfxMijDFA
         5HIg==
X-Gm-Message-State: AOAM533uGSE3r6oEf5jYPYG70W4hj04QPjbbwDosBncmMn9qngoYWUPp
        /q6WVC2a9Ups2c0nsGtqxyI=
X-Google-Smtp-Source: ABdhPJxWX73tl16/82RaCvzO0r1M6TT4cX2b655gMiclRI3BkcJonEV5wVvNqQc8BehzyUnpR41K7g==
X-Received: by 2002:a62:ee12:0:b0:4e1:2ec1:cba2 with SMTP id e18-20020a62ee12000000b004e12ec1cba2mr1886990pfi.71.1644996391734;
        Tue, 15 Feb 2022 23:26:31 -0800 (PST)
Received: from xplor.waratah.dyndns.org (222-155-5-102-adsl.sparkbb.co.nz. [222.155.5.102])
        by smtp.gmail.com with ESMTPSA id e3sm4545515pgc.41.2022.02.15.23.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 23:26:31 -0800 (PST)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 131BA36020A; Wed, 16 Feb 2022 20:26:27 +1300 (NZDT)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     deller@gmx.de, linux-fbdev@vger.kernel.org,
        linux-m68k@vger.kernel.org
Cc:     geert@linux-m68k.org, Michael Schmitz <schmitzmic@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v1] video/fbdev: Atari 2 bpp (STe) palette bugfix
Date:   Wed, 16 Feb 2022 20:26:25 +1300
Message-Id: <20220216072625.16947-1-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The code to set the shifter STe palette registers has a long
standing operator precedence bug, manifesting as colors set
on a 2 bits per pixel frame buffer coming up with a distinctive
blue tint.

Add parentheses around the calculation of the per-color palette
data before shifting those into their respective bit field position.

This bug goes back a long way (2.4 days at the very least) so there
won't be a Fixes: tag.

Tested on ARAnyM as well on Falcon030 hardware.

Cc: stable@vger.kernel.org
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/all/CAMuHMdU3ievhXxKR_xi_v3aumnYW7UNUO6qMdhgfyWTyVSsCkQ@mail.gmail.com
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
---
 drivers/video/fbdev/atafb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/atafb.c b/drivers/video/fbdev/atafb.c
index e3812a8ff55a..29e650ecfceb 100644
--- a/drivers/video/fbdev/atafb.c
+++ b/drivers/video/fbdev/atafb.c
@@ -1683,9 +1683,9 @@ static int falcon_setcolreg(unsigned int regno, unsigned int red,
 			   ((blue & 0xfc00) >> 8));
 	if (regno < 16) {
 		shifter_tt.color_reg[regno] =
-			(((red & 0xe000) >> 13) | ((red & 0x1000) >> 12) << 8) |
-			(((green & 0xe000) >> 13) | ((green & 0x1000) >> 12) << 4) |
-			((blue & 0xe000) >> 13) | ((blue & 0x1000) >> 12);
+			((((red & 0xe000) >> 13)   | ((red & 0x1000) >> 12)) << 8)   |
+			((((green & 0xe000) >> 13) | ((green & 0x1000) >> 12)) << 4) |
+			   ((blue & 0xe000) >> 13) | ((blue & 0x1000) >> 12);
 		((u32 *)info->pseudo_palette)[regno] = ((red & 0xf800) |
 						       ((green & 0xfc00) >> 5) |
 						       ((blue & 0xf800) >> 11));
@@ -1971,9 +1971,9 @@ static int stste_setcolreg(unsigned int regno, unsigned int red,
 	green >>= 12;
 	if (ATARIHW_PRESENT(EXTD_SHIFTER))
 		shifter_tt.color_reg[regno] =
-			(((red & 0xe) >> 1) | ((red & 1) << 3) << 8) |
-			(((green & 0xe) >> 1) | ((green & 1) << 3) << 4) |
-			((blue & 0xe) >> 1) | ((blue & 1) << 3);
+			((((red & 0xe)   >> 1) | ((red & 1)   << 3)) << 8) |
+			((((green & 0xe) >> 1) | ((green & 1) << 3)) << 4) |
+			  ((blue & 0xe)  >> 1) | ((blue & 1)  << 3);
 	else
 		shifter_tt.color_reg[regno] =
 			((red & 0xe) << 7) |
-- 
2.17.1

