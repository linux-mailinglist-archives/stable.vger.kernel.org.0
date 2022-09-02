Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E8C5AAEB4
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbiIBM2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235829AbiIBM1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:27:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5539DD743;
        Fri,  2 Sep 2022 05:24:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CE8AB82A91;
        Fri,  2 Sep 2022 12:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B22EC433D7;
        Fri,  2 Sep 2022 12:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121397;
        bh=X2kyHRGmPFA4IG7DMX7lJ498RS9kJ6XcbHqpncdeLrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQ9kEfMu7pUEKUbPr2XJr+iLy9uJHs9jsMiC5kbi3ZLTuTYgZz40jnfhWDZxsEXai
         LlIwKpcPz5EfF7CEX9lOcJBQvqKh+x1Vp1AAr9zhamQBbDmCCtEZ4t30FOAAnFJkQn
         ATDFMOGwO2DB02SYN8ibchlMMSHMxHvfx5eXqNpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Letu Ren <fantasquex@gmail.com>, Helge Deller <deller@gmx.de>
Subject: [PATCH 4.14 35/42] fbdev: fb_pm2fb: Avoid potential divide by zero error
Date:   Fri,  2 Sep 2022 14:18:59 +0200
Message-Id: <20220902121359.998704160@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121358.773776406@linuxfoundation.org>
References: <20220902121358.773776406@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Letu Ren <fantasquex@gmail.com>

commit 19f953e7435644b81332dd632ba1b2d80b1e37af upstream.

In `do_fb_ioctl()` of fbmem.c, if cmd is FBIOPUT_VSCREENINFO, var will be
copied from user, then go through `fb_set_var()` and
`info->fbops->fb_check_var()` which could may be `pm2fb_check_var()`.
Along the path, `var->pixclock` won't be modified. This function checks
whether reciprocal of `var->pixclock` is too high. If `var->pixclock` is
zero, there will be a divide by zero error. So, it is necessary to check
whether denominator is zero to avoid crash. As this bug is found by
Syzkaller, logs are listed below.

divide error in pm2fb_check_var
Call Trace:
 <TASK>
 fb_set_var+0x367/0xeb0 drivers/video/fbdev/core/fbmem.c:1015
 do_fb_ioctl+0x234/0x670 drivers/video/fbdev/core/fbmem.c:1110
 fb_ioctl+0xdd/0x130 drivers/video/fbdev/core/fbmem.c:1189

Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Letu Ren <fantasquex@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/pm2fb.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/video/fbdev/pm2fb.c
+++ b/drivers/video/fbdev/pm2fb.c
@@ -614,6 +614,11 @@ static int pm2fb_check_var(struct fb_var
 		return -EINVAL;
 	}
 
+	if (!var->pixclock) {
+		DPRINTK("pixclock is zero\n");
+		return -EINVAL;
+	}
+
 	if (PICOS2KHZ(var->pixclock) > PM2_MAX_PIXCLOCK) {
 		DPRINTK("pixclock too high (%ldKHz)\n",
 			PICOS2KHZ(var->pixclock));


