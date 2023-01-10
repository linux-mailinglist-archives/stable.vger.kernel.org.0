Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8A6664B54
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239496AbjAJSlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239659AbjAJSlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:41:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB035EC11
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:35:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9699461868
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EF1C433D2;
        Tue, 10 Jan 2023 18:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375706;
        bh=R11KfLR/mtPLWUd51U0iVynTDRA3SeN70ZC8NXe3XSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7qYP71vHo3GUG6UZCXdtKbAmmGVhW2kDH5/S31chMewoED0icTNJVh+4ChDfd5jj
         6ZekQBb4eT3TnFLL3ryUj7Fxe9y+GZRHNEmIICVXCv3Y6K0GyhBMS3+LZqLssUCpS+
         EBh8w93N6QQp50Xmx00t01RUdSzTQMLwsrUYOclE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, it+linux-fbdev@molgen.mpg.de,
        "Z. Liu" <liuzx@knownsec.com>, Rich Felker <dalias@libc.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 268/290] fbdev: matroxfb: G200eW: Increase max memory from 1 MB to 16 MB
Date:   Tue, 10 Jan 2023 19:06:00 +0100
Message-Id: <20230110180041.215368558@linuxfoundation.org>
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

From: Paul Menzel <pmenzel@molgen.mpg.de>

commit f685dd7a8025f2554f73748cfdb8143a21fb92c7 upstream.

Commit 62d89a7d49af ("video: fbdev: matroxfb: set maxvram of vbG200eW to
the same as vbG200 to avoid black screen") accidently decreases the
maximum memory size for the Matrox G200eW (102b:0532) from 8 MB to 1 MB
by missing one zero. This caused the driver initialization to fail with
the messages below, as the minimum required VRAM size is 2 MB:

     [    9.436420] matroxfb: Matrox MGA-G200eW (PCI) detected
     [    9.444502] matroxfb: cannot determine memory size
     [    9.449316] matroxfb: probe of 0000:0a:03.0 failed with error -1

So, add the missing 0 to make it the intended 16 MB. Successfully tested on
the Dell PowerEdge R910/0KYD3D, BIOS 2.10.0 08/29/2013, that the warning is
gone.

While at it, add a leading 0 to the maxdisplayable entry, so it’s aligned
properly. The value could probably also be increased from 8 MB to 16 MB, as
the G200 uses the same values, but I have not checked any datasheet.

Note, matroxfb is obsolete and superseded by the maintained DRM driver
mga200, which is used by default on most systems where both drivers are
available. Therefore, on most systems it was only a cosmetic issue.

Fixes: 62d89a7d49af ("video: fbdev: matroxfb: set maxvram of vbG200eW to the same as vbG200 to avoid black screen")
Link: https://lore.kernel.org/linux-fbdev/972999d3-b75d-5680-fcef-6e6905c52ac5@suse.de/T/#mb6953a9995ebd18acc8552f99d6db39787aec775
Cc: it+linux-fbdev@molgen.mpg.de
Cc: Z. Liu <liuzx@knownsec.com>
Cc: Rich Felker <dalias@libc.org>
Cc: stable@vger.kernel.org
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/matrox/matroxfb_base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/matrox/matroxfb_base.c
+++ b/drivers/video/fbdev/matrox/matroxfb_base.c
@@ -1377,8 +1377,8 @@ static struct video_board vbG200 = {
 	.lowlevel = &matrox_G100
 };
 static struct video_board vbG200eW = {
-	.maxvram = 0x100000,
-	.maxdisplayable = 0x800000,
+	.maxvram = 0x1000000,
+	.maxdisplayable = 0x0800000,
 	.accelID = FB_ACCEL_MATROX_MGAG200,
 	.lowlevel = &matrox_G100
 };


