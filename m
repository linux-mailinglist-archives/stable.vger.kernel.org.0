Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C835EE689
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 22:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiI1UTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 16:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234345AbiI1UTr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 16:19:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460162DD7;
        Wed, 28 Sep 2022 13:19:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6439B821BC;
        Wed, 28 Sep 2022 20:19:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D5FC433C1;
        Wed, 28 Sep 2022 20:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664396373;
        bh=ebQnjLYFYN8w5ZtbeBDwH2D+lWjENaVVH7SS/7ucfec=;
        h=From:To:Cc:Subject:Date:From;
        b=DoHRgmj3cGoFFCjxMVKp/SOAkLuEBfXoidm6NHmbibMeRFS94utwF9nJ9gMvIO8gv
         fZU5/d3PX7WHyBKr6YKWXaYHVZnqgNHT9Rqt3NByzlp6vv8OS9APEx3JuFKmg8LhW7
         uW+v12iCkMvAfjzukPwC8WLfvPzLjn3huBIT+nXizLehulHxch+K9Ek0DlKpHLOZAA
         GtpLgBM5C96uQkkbnt4H8465IGXX8xU7ZjU9eGHWPbtj5J/s9B9rJJzqXrHL/pr8js
         9/nn9G5L+BBWDqren5qKMXpourbCo6I8bMzBzeC+9In6HPOQBK19dztfkTR6vb6u2T
         vrgWOB7jGOfRg==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] usb: gadget: uvc: Fix argument to sizeof() in uvc_register_video()
Date:   Wed, 28 Sep 2022 13:19:21 -0700
Message-Id: <20220928201921.3152163-1-nathan@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/usb/gadget/function/f_uvc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index 71669e0e4d00..86bb0098fb66 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -421,7 +421,7 @@ uvc_register_video(struct uvc_device *uvc)
 	int ret;
 
 	/* TODO reference counting. */
-	memset(&uvc->vdev, 0, sizeof(uvc->video));
+	memset(&uvc->vdev, 0, sizeof(uvc->vdev));
 	uvc->vdev.v4l2_dev = &uvc->v4l2_dev;
 	uvc->vdev.v4l2_dev->dev = &cdev->gadget->dev;
 	uvc->vdev.fops = &uvc_v4l2_fops;

base-commit: f76349cf41451c5c42a99f18a9163377e4b364ff
-- 
2.37.3

