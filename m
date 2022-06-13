Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C11C548813
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349069AbiFMK4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350144AbiFMKym (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:54:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E283624975;
        Mon, 13 Jun 2022 03:29:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F9B3B80E59;
        Mon, 13 Jun 2022 10:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CABC34114;
        Mon, 13 Jun 2022 10:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116165;
        bh=ti9jrMRGdyqhhn4ch0mqYiWFn+RKGi9w8d6oSR6mKfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmv+GiUTiGmWMvlqgfGwSFspKybAzbqvOQ3LFcSLY8+FqOPi9TKSfv1JNPzIAOzIM
         ubO8HGcBJ8Oo4HUPHSZ4jfmndPD6cI0EGKY6Sayz/RROW7it8AN2002d+1HY4B1tRW
         Y94bbskWZl3qT6SF16PAMt9iM21izprR7mq1JO2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Hangyu Hua <hbh25y@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 143/218] usb: usbip: fix a refcount leak in stub_probe()
Date:   Mon, 13 Jun 2022 12:10:01 +0200
Message-Id: <20220613094924.926928296@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 9ec4cbf1cc55d126759051acfe328d489c5d6e60 ]

usb_get_dev() is called in stub_device_alloc(). When stub_probe() fails
after that, usb_put_dev() needs to be called to release the reference.

Fix this by moving usb_put_dev() to sdev_free error path handling.

Find this by code review.

Fixes: 3ff67445750a ("usbip: fix error handling in stub_probe()")
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20220412020257.9767-1-hbh25y@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/usbip/stub_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
index 1b3aad59d6c9..16bb3197d658 100644
--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -441,7 +441,6 @@ static int stub_probe(struct usb_device *udev)
 			     (struct usb_dev_state *) udev);
 err_port:
 	dev_set_drvdata(&udev->dev, NULL);
-	usb_put_dev(udev);
 
 	/* we already have busid_priv, just lock busid_lock */
 	spin_lock(&busid_priv->busid_lock);
@@ -456,6 +455,7 @@ static int stub_probe(struct usb_device *udev)
 	put_busid_priv(busid_priv);
 
 sdev_free:
+	usb_put_dev(udev);
 	stub_device_free(sdev);
 
 	return rc;
-- 
2.35.1



