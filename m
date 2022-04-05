Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7D54F2C49
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353700AbiDEKI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345262AbiDEJWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:22:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CB03F8B7;
        Tue,  5 Apr 2022 02:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E77FB81A22;
        Tue,  5 Apr 2022 09:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8038EC385A2;
        Tue,  5 Apr 2022 09:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149798;
        bh=Cah0xlxi9vX/JXqn6RvksIYmQRGk5+CJsMN43zZ9Jn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jgn4sJdczJ9fV/yjdFXrbYAiDJurA5XtG+nsbNjwk6+bGhjAK7mD/XJNe0GdwDyAK
         YCVCfhhoB3Hsrj3yp6HVvioEQsUjAQpQ17h0JMcfxhOrJOvhHHpG73GjshMTSjLlGU
         y3VYlD8J5o5GKW3p9TzEJs/teih9h2c/lUB/+M5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Maximilian=20B=C3=B6hm?= <maximilian.boehm@elbmurf.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0846/1017] media: Revert "media: em28xx: add missing em28xx_close_extension"
Date:   Tue,  5 Apr 2022 09:29:19 +0200
Message-Id: <20220405070419.352052052@linuxfoundation.org>
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

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit fde18c3bac3f964d8333ae53b304d8fee430502b ]

This reverts commit 2c98b8a3458df03abdc6945bbef67ef91d181938.

Reverted patch causes problems with Hauppauge WinTV dualHD as Maximilian
reported [1]. Since quick solution didn't come up let's just revert it
to make this device work with upstream kernels.

Link: https://lore.kernel.org/all/6a72a37b-e972-187d-0322-16336e12bdc5@elbmurf.de/ [1]

Reported-by: Maximilian Böhm <maximilian.boehm@elbmurf.de>
Tested-by: Maximilian Böhm <maximilian.boehm@elbmurf.de>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index f3b56c065ee1..ae25d2cbfdfe 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -4150,11 +4150,8 @@ static void em28xx_usb_disconnect(struct usb_interface *intf)
 
 	em28xx_close_extension(dev);
 
-	if (dev->dev_next) {
-		em28xx_close_extension(dev->dev_next);
+	if (dev->dev_next)
 		em28xx_release_resources(dev->dev_next);
-	}
-
 	em28xx_release_resources(dev);
 
 	if (dev->dev_next) {
-- 
2.34.1



