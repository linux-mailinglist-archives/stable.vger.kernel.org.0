Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3272603C09
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiJSImm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiJSIlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:41:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B0911C09;
        Wed, 19 Oct 2022 01:39:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 720B9617D1;
        Wed, 19 Oct 2022 08:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65550C433D7;
        Wed, 19 Oct 2022 08:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168768;
        bh=r6sndrCPLnTm7kILdqqn2LD7psgBrGdbjQMZY6nBT90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPH7jBxNwf/TkMy0LMu/vZpKfcUFXv79JFsqr0Ln6HAxVTySCMQDzbJqgWGBHC4XJ
         yegBzSDtNHhWOkrcJZfotCcHylY3tQnXoF1t0h1hu5fPxQPsiu1ocB+Xig9uYp2rrk
         eeRVcYHzNwzi2OXy74zwrLtmmZe2RSbS6p3GDqDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.0 030/862] usb: gadget: uvc: Fix argument to sizeof() in uvc_register_video()
Date:   Wed, 19 Oct 2022 10:21:57 +0200
Message-Id: <20221019083251.346309144@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit a15e17acce5aaae54243f55a7349c2225450b9bc upstream.

When building s390 allmodconfig after commit 9b91a6523078 ("usb: gadget:
uvc: increase worker prio to WQ_HIGHPRI"), the following error occurs:

  In file included from ../include/linux/string.h:253,
                   from ../include/linux/bitmap.h:11,
                   from ../include/linux/cpumask.h:12,
                   from ../include/linux/smp.h:13,
                   from ../include/linux/lockdep.h:14,
                   from ../include/linux/rcupdate.h:29,
                   from ../include/linux/rculist.h:11,
                   from ../include/linux/pid.h:5,
                   from ../include/linux/sched.h:14,
                   from ../include/linux/ratelimit.h:6,
                   from ../include/linux/dev_printk.h:16,
                   from ../include/linux/device.h:15,
                   from ../drivers/usb/gadget/function/f_uvc.c:9:
  In function ‘fortify_memset_chk’,
      inlined from ‘uvc_register_video’ at ../drivers/usb/gadget/function/f_uvc.c:424:2:
  ../include/linux/fortify-string.h:301:25: error: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
    301 |                         __write_overflow_field(p_size_field, size);
        |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This points to the memset() in uvc_register_video(). It is clear that
the argument to sizeof() is incorrect, as uvc->vdev (a 'struct
video_device') is being zeroed out but the size of uvc->video (a 'struct
uvc_video') is being used as the third arugment to memset().

pahole shows that prior to commit 9b91a6523078 ("usb: gadget: uvc:
increase worker prio to WQ_HIGHPRI"), 'struct video_device' and
'struct ucv_video' had the same size, meaning that the argument to
sizeof() is incorrect semantically but there is no visible issue:

  $ pahole -s build/drivers/usb/gadget/function/f_uvc.o | grep -E "(uvc_video|video_device)\s+"
  video_device    1400    4
  uvc_video       1400    3

After that change, uvc_video becomes slightly larger, meaning that the
memset() will overwrite by 8 bytes:

  $ pahole -s build/drivers/usb/gadget/function/f_uvc.o | grep -E "(uvc_video|video_device)\s+"
  video_device    1400    4
  uvc_video       1408    3

Fix the arugment to sizeof() so that there is no overwrite.

Cc: stable@vger.kernel.org
Fixes: e4ce9ed835bc ("usb: gadget: uvc: ensure the vdev is unset")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220928201921.3152163-1-nathan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uvc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -421,7 +421,7 @@ uvc_register_video(struct uvc_device *uv
 	int ret;
 
 	/* TODO reference counting. */
-	memset(&uvc->vdev, 0, sizeof(uvc->video));
+	memset(&uvc->vdev, 0, sizeof(uvc->vdev));
 	uvc->vdev.v4l2_dev = &uvc->v4l2_dev;
 	uvc->vdev.v4l2_dev->dev = &cdev->gadget->dev;
 	uvc->vdev.fops = &uvc_v4l2_fops;


