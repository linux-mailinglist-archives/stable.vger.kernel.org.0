Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8F14F2C14
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343821AbiDEJOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244917AbiDEIwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B34D2495F;
        Tue,  5 Apr 2022 01:46:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA3A06117A;
        Tue,  5 Apr 2022 08:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CE0C385A0;
        Tue,  5 Apr 2022 08:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148378;
        bh=EP+trxRMqCa49C7lsnG5DgO4UCe6fjvRQibVs25nJNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1a2H/JofUiiFlPPCi/T/q+GVJZX74zIEQ7YYRm9h89XYw9EVk0xRsoU4XnOODOQnO
         NwwhIxWIYrrA+tG7dpBjEZXEbPa7MIMvzCmbSIpD2FzhOXytS5CoCbXf6XVQ3mLOhN
         YOE9rVmwrVRAT6apcZAbXnKXb9DmxjD7FqHYifhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzkaller <syzkaller@googlegroups.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0334/1017] media: em28xx: initialize refcount before kref_get
Date:   Tue,  5 Apr 2022 09:20:47 +0200
Message-Id: <20220405070404.196666256@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit c08eadca1bdfa099e20a32f8fa4b52b2f672236d ]

The commit 47677e51e2a4("[media] em28xx: Only deallocate struct
em28xx after finishing all extensions") adds kref_get to many init
functions (e.g., em28xx_audio_init). However, kref_init is called too
late in em28xx_usb_probe, since em28xx_init_dev before will invoke
those init functions and call kref_get function. Then refcount bug
occurs in my local syzkaller instance.

Fix it by moving kref_init before em28xx_init_dev. This issue occurs
not only in dev but also dev->dev_next.

Fixes: 47677e51e2a4 ("[media] em28xx: Only deallocate struct em28xx after finishing all extensions")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index b451ce3cb169..f3b56c065ee1 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3936,6 +3936,8 @@ static int em28xx_usb_probe(struct usb_interface *intf,
 		goto err_free;
 	}
 
+	kref_init(&dev->ref);
+
 	dev->devno = nr;
 	dev->model = id->driver_info;
 	dev->alt   = -1;
@@ -4036,6 +4038,8 @@ static int em28xx_usb_probe(struct usb_interface *intf,
 	}
 
 	if (dev->board.has_dual_ts && em28xx_duplicate_dev(dev) == 0) {
+		kref_init(&dev->dev_next->ref);
+
 		dev->dev_next->ts = SECONDARY_TS;
 		dev->dev_next->alt   = -1;
 		dev->dev_next->is_audio_only = has_vendor_audio &&
@@ -4090,12 +4094,8 @@ static int em28xx_usb_probe(struct usb_interface *intf,
 			em28xx_write_reg(dev, 0x0b, 0x82);
 			mdelay(100);
 		}
-
-		kref_init(&dev->dev_next->ref);
 	}
 
-	kref_init(&dev->ref);
-
 	request_modules(dev);
 
 	/*
-- 
2.34.1



