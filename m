Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED815C0300
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbiIUP6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbiIUP5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:57:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE41A025A;
        Wed, 21 Sep 2022 08:51:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 922BE6313C;
        Wed, 21 Sep 2022 15:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E46C433D6;
        Wed, 21 Sep 2022 15:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775491;
        bh=/svY6D8V5JfD8BnwrmWDILcFtql5BiIckjIaZs3HME4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nePOkMx/r8QfHiGHtgwp5tP7kTBUL0Nb/c2+bxbpL3LL6U0SJwqHwdfWSUZAUPQ3C
         1xAU8QU0aMvafLl9Ki7/u0swdaQHuaMGvLArEqKym8MA0ZP6v7xVr64xerz4cAU/jk
         raW9CMEOlM7AhfPmg3ds0tuFLLYeKrcr/YL0QSGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Helge Deller <deller@gmx.de>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.10 24/39] video: fbdev: i740fb: Error out if pixclock equals zero
Date:   Wed, 21 Sep 2022 17:46:29 +0200
Message-Id: <20220921153646.522403400@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
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

From: Zheyu Ma <zheyuma97@gmail.com>

commit 15cf0b82271b1823fb02ab8c377badba614d95d5 upstream.

The userspace program could pass any values to the driver through
ioctl() interface. If the driver doesn't check the value of 'pixclock',
it may cause divide error.

Fix this by checking whether 'pixclock' is zero in the function
i740fb_check_var().

The following log reveals it:

divide error: 0000 [#1] PREEMPT SMP KASAN PTI
RIP: 0010:i740fb_decode_var drivers/video/fbdev/i740fb.c:444 [inline]
RIP: 0010:i740fb_set_par+0x272f/0x3bb0 drivers/video/fbdev/i740fb.c:739
Call Trace:
    fb_set_var+0x604/0xeb0 drivers/video/fbdev/core/fbmem.c:1036
    do_fb_ioctl+0x234/0x670 drivers/video/fbdev/core/fbmem.c:1112
    fb_ioctl+0xdd/0x130 drivers/video/fbdev/core/fbmem.c:1191
    vfs_ioctl fs/ioctl.c:51 [inline]
    __do_sys_ioctl fs/ioctl.c:874 [inline]

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/i740fb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/fbdev/i740fb.c
+++ b/drivers/video/fbdev/i740fb.c
@@ -662,6 +662,9 @@ static int i740fb_decode_var(const struc
 
 static int i740fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
+	if (!var->pixclock)
+		return -EINVAL;
+
 	switch (var->bits_per_pixel) {
 	case 8:
 		var->red.offset	= var->green.offset = var->blue.offset = 0;


