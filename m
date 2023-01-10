Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C0E664B65
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbjAJSmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239604AbjAJSmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:42:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12272C74F
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:35:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1D7061846
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4931EC433D2;
        Tue, 10 Jan 2023 18:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375750;
        bh=GeIU/RfEM1DKdtrrxhN+tEBZak4N4wNsk+Ouw2aFx9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F10P/htnHYwfC3HDm3D/Inx8JpTOFkenh8z6j9U+ABav+E0qxx7amPctEqfEIfEFr
         uwL3FNtDcbiBpXvQhOBrgTwq3c0QR5vOghu6Bz7hPgc8D+JVagvr823UimGCyQH1BE
         DRJakeyNJNatKnFAr+QSWq/bfVb3yyLNkk1qqX8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jocelyn Falempe <jfalempe@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.15 290/290] drm/mgag200: Fix PLL setup for G200_SE_A rev >=4
Date:   Tue, 10 Jan 2023 19:06:22 +0100
Message-Id: <20230110180041.912212964@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jocelyn Falempe <jfalempe@redhat.com>

commit b389286d0234e1edbaf62ed8bc0892a568c33662 upstream.

For G200_SE_A, PLL M setting is wrong, which leads to blank screen,
or "signal out of range" on VGA display.
previous code had "m |= 0x80" which was changed to
m |= ((pixpllcn & BIT(8)) >> 1);

Tested on G200_SE_A rev 42

This line of code was moved to another file with
commit 877507bb954e ("drm/mgag200: Provide per-device callbacks for
PIXPLLC") but can be easily backported before this commit.

v2: * put BIT(7) First to respect MSB-to-LSB (Thomas)
    * Add a comment to explain that this bit must be set (Thomas)

Fixes: 2dd040946ecf ("drm/mgag200: Store values (not bits) in struct mgag200_pll_values")
Cc: stable@vger.kernel.org
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20221013132810.521945-1-jfalempe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mgag200/mgag200_pll.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/mgag200/mgag200_pll.c
+++ b/drivers/gpu/drm/mgag200/mgag200_pll.c
@@ -268,7 +268,8 @@ static void mgag200_pixpll_update_g200se
 	pixpllcp = pixpllc->p - 1;
 	pixpllcs = pixpllc->s;
 
-	xpixpllcm = pixpllcm | ((pixpllcn & BIT(8)) >> 1);
+	// For G200SE A, BIT(7) should be set unconditionally.
+	xpixpllcm = BIT(7) | pixpllcm;
 	xpixpllcn = pixpllcn;
 	xpixpllcp = (pixpllcs << 3) | pixpllcp;
 


