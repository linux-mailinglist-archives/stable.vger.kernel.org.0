Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71DA950577A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240556AbiDRNzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343657AbiDRNyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:54:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922E047ADF;
        Mon, 18 Apr 2022 06:03:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB44D609EE;
        Mon, 18 Apr 2022 13:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29EBC385A1;
        Mon, 18 Apr 2022 13:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287003;
        bh=i7d4IMjg68LsHEXJVgI+Q2DYKMuVrFSB7ixi9ScfLgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lznvGKm7N+PbdpruS5S8IqbfptTYHfTp+I8ATTu5oM7kid+2K9O0QEZavsqJsGqPl
         0LG7qCc04DhyhN63CjrLaV7yDMdBgceeR2WTzMvTfNuEyJZWohlO7k/orlWkwBciZ3
         wTG9Dd8hpLLNE0rTXRSxw1pSBjlVE2PZgEVb79hQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.9 028/218] video: fbdev: atari: Atari 2 bpp (STe) palette bugfix
Date:   Mon, 18 Apr 2022 14:11:34 +0200
Message-Id: <20220418121200.144995671@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -1713,9 +1713,9 @@ static int falcon_setcolreg(unsigned int
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
@@ -2001,9 +2001,9 @@ static int stste_setcolreg(unsigned int
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


