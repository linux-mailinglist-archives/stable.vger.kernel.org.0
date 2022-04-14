Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 587C2500F22
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244204AbiDNNYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244243AbiDNNXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:23:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E859A987;
        Thu, 14 Apr 2022 06:18:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 854BBCE29B0;
        Thu, 14 Apr 2022 13:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91888C385A9;
        Thu, 14 Apr 2022 13:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942317;
        bh=rMIHqJKmpycu6O2npx9WM/AIg4FfJweXZtKM7+IChyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQdCkaHP1vO6Kqd6EgK2vZeBqeJcp33MxjvzOsKBYT+PemiRzLyu6Xk17EMcn0vBG
         4CTrvWIHfbHY7nCJB12LD944ZD7cJNc2i8f+lVKPslTVSS4gqlklGGQZZiYIGp95+j
         9E50vq7rpuwyigcq8+qYcyonoB5JC3MMbxGQiUwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzkaller <syzkaller@googlegroups.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 092/338] media: em28xx: initialize refcount before kref_get
Date:   Thu, 14 Apr 2022 15:09:55 +0200
Message-Id: <20220414110841.517726604@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
index 06da08f8efdb..c7f79d0f3883 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3822,6 +3822,8 @@ static int em28xx_usb_probe(struct usb_interface *intf,
 		goto err_free;
 	}
 
+	kref_init(&dev->ref);
+
 	dev->devno = nr;
 	dev->model = id->driver_info;
 	dev->alt   = -1;
@@ -3922,6 +3924,8 @@ static int em28xx_usb_probe(struct usb_interface *intf,
 	}
 
 	if (dev->board.has_dual_ts && em28xx_duplicate_dev(dev) == 0) {
+		kref_init(&dev->dev_next->ref);
+
 		dev->dev_next->ts = SECONDARY_TS;
 		dev->dev_next->alt   = -1;
 		dev->dev_next->is_audio_only = has_vendor_audio &&
@@ -3976,12 +3980,8 @@ static int em28xx_usb_probe(struct usb_interface *intf,
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



