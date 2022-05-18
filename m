Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1D452BAC3
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 14:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236947AbiERMdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 08:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236949AbiERMcu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 08:32:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DE514D787;
        Wed, 18 May 2022 05:29:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2627B6147D;
        Wed, 18 May 2022 12:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5974AC385A5;
        Wed, 18 May 2022 12:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876923;
        bh=0/NFO8cYx8eV49vuYrkyZNzByuqpxYe0Qj+VfRawypc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqhK8r7lcjyA0MePeJhLpFkUuJ8oPXlegUQg/QxZQCyW+RnBFaXsuBybAPYzphF6+
         3rcDlO6ZMttfQAi3wWohkn2Hvtobixnu1Iao4ilrXnDDN4fwlNPNIaFR0sqJ/BxyWN
         wuJb3H7PJp8z7aaUF07TQY5RjSPehF/BZqPaqVTAVQkBICKEiFlLDF+XUKKBeleLih
         uN7FNbvdieTKFgH+oQZMedfwnhAxi1e5Xba6/afHMfamIUBb9P2XpNu/d/Do2n6azf
         Pv1Qrd3UNdTlmYQdeiuQUF9qUW3NbcxiPzv8YQbitnP+FztHiDsLHYxzKrFaFuqNCL
         YX+pmcJl9lQRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Schspa Shi <schspa@gmail.com>,
        syzbot+dc7c3ca638e773db07f6@syzkaller.appspotmail.com,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@kernel.org,
        jannh@google.com, Julia.Lawall@inria.fr, jj251510319013@gmail.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 17/17] usb: gadget: fix race when gadget driver register via ioctl
Date:   Wed, 18 May 2022 08:27:51 -0400
Message-Id: <20220518122753.342758-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122753.342758-1-sashal@kernel.org>
References: <20220518122753.342758-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Schspa Shi <schspa@gmail.com>

[ Upstream commit 5f0b5f4d50fa0faa8c76ef9d42a42e8d43f98b44 ]

The usb_gadget_register_driver can be called multi time by to
threads via USB_RAW_IOCTL_RUN ioctl syscall, which will lead
to multiple registrations.

Call trace:
  driver_register+0x220/0x3a0 drivers/base/driver.c:171
  usb_gadget_register_driver_owner+0xfb/0x1e0
    drivers/usb/gadget/udc/core.c:1546
  raw_ioctl_run drivers/usb/gadget/legacy/raw_gadget.c:513 [inline]
  raw_ioctl+0x1883/0x2730 drivers/usb/gadget/legacy/raw_gadget.c:1220
  ioctl USB_RAW_IOCTL_RUN

This routine allows two processes to register the same driver instance
via ioctl syscall. which lead to a race condition.

Please refer to the following scenarios.

           T1                                  T2
------------------------------------------------------------------
usb_gadget_register_driver_owner
  driver_register                    driver_register
    driver_find                       driver_find
    bus_add_driver                    bus_add_driver
      priv alloced                     <context switch>
      drv->p = priv;
      <schedule out>
      kobject_init_and_add // refcount = 1;
   //couldn't find an available UDC or it's busy
   <context switch>
                                       priv alloced
                                       drv->priv = priv;
                                       kobject_init_and_add
                                         ---> refcount = 1 <------
                                       // register success
                                       <context switch>
===================== another ioctl/process ======================
                                      driver_register
                                       driver_find
                                        k = kset_find_obj()
                                         ---> refcount = 2 <------
                                        <context out>
   driver_unregister
   // drv->p become T2's priv
   ---> refcount = 1 <------
   <context switch>
                                        kobject_put(k)
                                         ---> refcount = 0 <------
                                        return priv->driver;
                                        --------UAF here----------

There will be UAF in this scenario.

We can fix it by adding a new STATE_DEV_REGISTERING device state to
avoid double register.

Reported-by: syzbot+dc7c3ca638e773db07f6@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/000000000000e66c2805de55b15a@google.com/
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Schspa Shi <schspa@gmail.com>
Link: https://lore.kernel.org/r/20220508150247.38204-1-schspa@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/legacy/raw_gadget.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
index d86c3a36441e..3427ce37a5c5 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -145,6 +145,7 @@ enum dev_state {
 	STATE_DEV_INVALID = 0,
 	STATE_DEV_OPENED,
 	STATE_DEV_INITIALIZED,
+	STATE_DEV_REGISTERING,
 	STATE_DEV_RUNNING,
 	STATE_DEV_CLOSED,
 	STATE_DEV_FAILED
@@ -508,6 +509,7 @@ static int raw_ioctl_run(struct raw_dev *dev, unsigned long value)
 		ret = -EINVAL;
 		goto out_unlock;
 	}
+	dev->state = STATE_DEV_REGISTERING;
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	ret = usb_gadget_probe_driver(&dev->driver);
-- 
2.35.1

