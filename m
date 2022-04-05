Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328AF4F337C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344665AbiDEKkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243622AbiDEJkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:40:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3769BAC900;
        Tue,  5 Apr 2022 02:24:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94C5A61659;
        Tue,  5 Apr 2022 09:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D89C385A2;
        Tue,  5 Apr 2022 09:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150687;
        bh=T2hstRTN2DoQMvevAT+LYxm/af106Jsj9SpEV7aDvFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SkQJ+u0G0K52H9yar62RE+4Su6im/xbPE0wWg3biitqwKwBIDJ78Ue0J+fHXg7rLd
         NwPSNePJB6fvh+8JJw2xtGJ+pbFU5J/iQbrDTvxhGj+7gVYce9n18WWDe7qHDPspiP
         2n3/K3QOnJq5KhH/GV6eBtKxpawqKQqcDFsSy01k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 144/913] video: fbdev: atari: Atari 2 bpp (STe) palette bugfix
Date:   Tue,  5 Apr 2022 09:20:06 +0200
Message-Id: <20220405070344.150928974@linuxfoundation.org>
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

From: Michael Schmitz <schmitzmic@gmail.com>

commit c8be5edbd36ceed2ff3d6b8f8e40643c3f396ea3 upstream.

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
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/atafb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/video/fbdev/atafb.c
+++ b/drivers/video/fbdev/atafb.c
@@ -1683,9 +1683,9 @@ static int falcon_setcolreg(unsigned int
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
@@ -1971,9 +1971,9 @@ static int stste_setcolreg(unsigned int
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


