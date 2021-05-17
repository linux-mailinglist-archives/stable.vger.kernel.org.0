Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5022E383D16
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 21:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhEQTTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 15:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbhEQTTp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 15:19:45 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD34C061573;
        Mon, 17 May 2021 12:18:24 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id j10so10407936lfb.12;
        Mon, 17 May 2021 12:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7BU0ow4QR93mOB74FmJ4kFwJgWXgNPCN3wgoS7EpDVg=;
        b=VHB5JqmkcVWB42P5/6IQUPbsTgEhLAj+tpXRJrXIfQWzJ01MJA26rN9sr0AtYsdP7k
         JxLYIGh5aPbTbFQXZ+uUjTkxkKfCPotg4mU7nfMaXvV0p2nYw/MMReHdEuVJKGndusty
         NO9KvOWLfKfq1Y7UW8mUjfgw6A+yP0LV5Aws6Ty7LePGhtilU0gx5pVhUODGFFdDPeqE
         ITtrq0CjjIxM66bjMy3/i5MvJ6So5A1XQIakybLDK2ytE6HYa9kEfNM17c/aUqr85LaE
         o8lqlT0tzSfSdZSfsGJLKQnlCFOFyzagoPAHbj479aF/CMV+hyqtmol3o6RtgMonyzYi
         rBYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7BU0ow4QR93mOB74FmJ4kFwJgWXgNPCN3wgoS7EpDVg=;
        b=G+892r92pF0XVQmSryV7BrsKFYIHBpg/dvwwvuUlD/lHVQ+12ywFXKO8NjOtrfkAw4
         twyWU0o+xTUfZ24MYr5cH3b0NQwm+2fby56jQmT22NPGt2JnHeCOavjYWDzBvIgzoFAO
         iwNlm+fxS96QkA/89CLuyyLrEHHnGU6sbDYq4h/WLg79ACxBnelWJXw69HxWwLDrGrtW
         LtJkvRWQlQPvchtlitcNa03JWWbmnE2IRD9TXB0Fxatd9KzB4uaAJUX7L3TgW0P3e+cB
         iWZVhg85OnO4dTK41nmKYWiQpxBRvJq6gMMJKnJPhH6hOm99Fjhyblhi7BYh6sMdBRxh
         zb7g==
X-Gm-Message-State: AOAM532OZ7rJwhTJqDHnssD148Y0iuJV34ti/yYWsWuJXFkYS4YuTDHZ
        knBkwtAuP/zmwu1NkbDFyVs=
X-Google-Smtp-Source: ABdhPJxfJ5AnQ0NtLlstk6v0EMuNUrDW4o3QNS5RnVAO91gR4wfH20CQNbXTGvla4RxqSeO4zaogGw==
X-Received: by 2002:a05:6512:3090:: with SMTP id z16mr910138lfd.402.1621279103243;
        Mon, 17 May 2021 12:18:23 -0700 (PDT)
Received: from localhost.localdomain ([94.103.227.227])
        by smtp.gmail.com with ESMTPSA id 8sm3017947ljj.138.2021.05.17.12.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 12:18:22 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     royale@zerezo.com, mchehab@kernel.org, lamarque@gmail.com
Cc:     linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>, stable@vger.kernel.org,
        syzbot+af4fa391ef18efdd5f69@syzkaller.appspotmail.com
Subject: [PATCH] media: zr364xx: fix memory leak in zr364xx_start_readpipe
Date:   Mon, 17 May 2021 22:18:14 +0300
Message-Id: <20210517191814.1761-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot reported memory leak in zr364xx driver.
The problem was in non-freed urb in case of
usb_submit_urb() fail.

backtrace:
  [<ffffffff82baedf6>] kmalloc include/linux/slab.h:561 [inline]
  [<ffffffff82baedf6>] usb_alloc_urb+0x66/0xe0 drivers/usb/core/urb.c:74
  [<ffffffff82f7cce8>] zr364xx_start_readpipe+0x78/0x130 drivers/media/usb/zr364xx/zr364xx.c:1022
  [<ffffffff84251dfc>] zr364xx_board_init drivers/media/usb/zr364xx/zr364xx.c:1383 [inline]
  [<ffffffff84251dfc>] zr364xx_probe+0x6a3/0x851 drivers/media/usb/zr364xx/zr364xx.c:1516
  [<ffffffff82bb6507>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
  [<ffffffff826018a9>] really_probe+0x159/0x500 drivers/base/dd.c:576

Fixes: ccbf035ae5de ("V4L/DVB (12278): zr364xx: implement V4L2_CAP_STREAMING")
Cc: stable@vger.kernel.org
Reported-by: syzbot+af4fa391ef18efdd5f69@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/media/usb/zr364xx/zr364xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index 1ef611e08323..538a330046ec 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -1032,6 +1032,7 @@ static int zr364xx_start_readpipe(struct zr364xx_camera *cam)
 	DBG("submitting URB %p\n", pipe_info->stream_urb);
 	retval = usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL);
 	if (retval) {
+		usb_free_urb(pipe_info->stream_urb);
 		printk(KERN_ERR KBUILD_MODNAME ": start read pipe failed\n");
 		return retval;
 	}
-- 
2.31.1

