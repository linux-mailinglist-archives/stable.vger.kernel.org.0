Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1EB4F362D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245248AbiDEK71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347190AbiDEJqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:46:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39ECDD95A;
        Tue,  5 Apr 2022 02:32:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BDFA616C1;
        Tue,  5 Apr 2022 09:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B84C385A0;
        Tue,  5 Apr 2022 09:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151153;
        bh=+sX6eT4etelquzx7SDWaJwJw7R7+rWeSw+xS7cKPHDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kj8sRnDRvMrIbie7VNBhBviXQM74RGLgPqAzsHPLF9E99cKdSRShoy9tIwCwwkHn/
         d+ggeRXX8iFh98Ov4//SFFwr5leUN4GXog0mYJqdJaTNd1JioriL5Jenef6tFeq4AV
         FWkzlXZ4RSOis402KEwwKg/ykzBQq6XgqoWHZngY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzkaller <syzkaller@googlegroups.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 313/913] media: em28xx: initialize refcount before kref_get
Date:   Tue,  5 Apr 2022 09:22:55 +0200
Message-Id: <20220405070349.235758782@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index ebc430b05f21..c415b1d195c4 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3931,6 +3931,8 @@ static int em28xx_usb_probe(struct usb_interface *intf,
 		goto err_free;
 	}
 
+	kref_init(&dev->ref);
+
 	dev->devno = nr;
 	dev->model = id->driver_info;
 	dev->alt   = -1;
@@ -4031,6 +4033,8 @@ static int em28xx_usb_probe(struct usb_interface *intf,
 	}
 
 	if (dev->board.has_dual_ts && em28xx_duplicate_dev(dev) == 0) {
+		kref_init(&dev->dev_next->ref);
+
 		dev->dev_next->ts = SECONDARY_TS;
 		dev->dev_next->alt   = -1;
 		dev->dev_next->is_audio_only = has_vendor_audio &&
@@ -4085,12 +4089,8 @@ static int em28xx_usb_probe(struct usb_interface *intf,
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



