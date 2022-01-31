Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A933F4A43A4
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377126AbiAaLWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:22:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52422 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378663AbiAaLUa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7206760B28;
        Mon, 31 Jan 2022 11:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3254AC340E8;
        Mon, 31 Jan 2022 11:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628029;
        bh=sGtb7XmLTJ08oegV1tBbS9O4MF7N9lsnWCMTQzVTpX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TQBZ8TJsgJyAR16S9K5vHtzBSS0rIYOD1J6aMekDgfZ9wKIJhNpckgZx9T2WXHycq
         eOMrHmMYrTO2P01+/UibUl54r7kI5pQpJnW2H6nWSmGbKLPorVJKLO9GQ4tR8tooJ9
         3HduUl3W5GjeL7GjVrYXJNm/4pnS8VK9XPqRbyc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 5.16 103/200] rpmsg: char: Fix race between the release of rpmsg_eptdev and cdev
Date:   Mon, 31 Jan 2022 11:56:06 +0100
Message-Id: <20220131105237.053802986@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Kaehlcke <mka@chromium.org>

commit 7a534ae89e34e9b51acb5a63dd0f88308178b46a upstream.

struct rpmsg_eptdev contains a struct cdev. The current code frees
the rpmsg_eptdev struct in rpmsg_eptdev_destroy(), but the cdev is
a managed object, therefore its release is not predictable and the
rpmsg_eptdev could be freed before the cdev is entirely released.

The cdev_device_add/del() API was created to address this issue
(see commit '233ed09d7fda ("chardev: add helper function to register
char devs with a struct device")'), use it instead of cdev add/del().

Fixes: c0cdc19f84a4 ("rpmsg: Driver for user space endpoint interface")
Suggested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220110104706.v6.2.Idde68b05b88d4a2e6e54766c653f3a6d9e419ce6@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rpmsg/rpmsg_char.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/rpmsg/rpmsg_char.c
+++ b/drivers/rpmsg/rpmsg_char.c
@@ -90,7 +90,7 @@ static int rpmsg_eptdev_destroy(struct d
 	/* wake up any blocked readers */
 	wake_up_interruptible(&eptdev->readq);
 
-	device_del(&eptdev->dev);
+	cdev_device_del(&eptdev->cdev, &eptdev->dev);
 	put_device(&eptdev->dev);
 
 	return 0;
@@ -333,7 +333,6 @@ static void rpmsg_eptdev_release_device(
 
 	ida_simple_remove(&rpmsg_ept_ida, dev->id);
 	ida_simple_remove(&rpmsg_minor_ida, MINOR(eptdev->dev.devt));
-	cdev_del(&eptdev->cdev);
 	kfree(eptdev);
 }
 
@@ -378,19 +377,13 @@ static int rpmsg_eptdev_create(struct rp
 	dev->id = ret;
 	dev_set_name(dev, "rpmsg%d", ret);
 
-	ret = cdev_add(&eptdev->cdev, dev->devt, 1);
+	ret = cdev_device_add(&eptdev->cdev, &eptdev->dev);
 	if (ret)
 		goto free_ept_ida;
 
 	/* We can now rely on the release function for cleanup */
 	dev->release = rpmsg_eptdev_release_device;
 
-	ret = device_add(dev);
-	if (ret) {
-		dev_err(dev, "device_add failed: %d\n", ret);
-		put_device(dev);
-	}
-
 	return ret;
 
 free_ept_ida:


