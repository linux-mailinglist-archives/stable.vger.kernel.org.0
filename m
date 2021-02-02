Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9168F30CCC3
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240334AbhBBUHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:07:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232818AbhBBNmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:42:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 449B364EC5;
        Tue,  2 Feb 2021 13:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273191;
        bh=R/JNgvcx5++pHtaSHCV/Ib7M1brnwIVRgTiQHU/uw9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yjuF1o8WwO77k+7PmpjoSofoGiCKCZhK35RnRBs3/MOGhE3Al4ECxwummtZOZvDLz
         cMwidjQJfhsy/NuFjEMtsFDOayXrJSbP8lWdiG3vhgvtefZeNRjIKRDAm3DWpFb9RE
         f0+/xKYcRwbEIhxRF6PMRIsDKW8YR39Z/+bLhOac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 015/142] media: rc: ensure that uevent can be read directly after rc device register
Date:   Tue,  2 Feb 2021 14:36:18 +0100
Message-Id: <20210202132958.334957819@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit 896111dc4bcf887b835b3ef54f48b450d4692a1d upstream.

There is a race condition where if the /sys/class/rc0/uevent file is read
before rc_dev->registered is set to true, -ENODEV will be returned.

Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1901089

Cc: stable@vger.kernel.org
Fixes: a2e2d73fa281 ("media: rc: do not access device via sysfs after rc_unregister_device()")
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/rc/rc-main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1928,6 +1928,8 @@ int rc_register_device(struct rc_dev *de
 			goto out_raw;
 	}
 
+	dev->registered = true;
+
 	rc = device_add(&dev->dev);
 	if (rc)
 		goto out_rx_free;
@@ -1937,8 +1939,6 @@ int rc_register_device(struct rc_dev *de
 		 dev->device_name ?: "Unspecified device", path ?: "N/A");
 	kfree(path);
 
-	dev->registered = true;
-
 	/*
 	 * once the the input device is registered in rc_setup_rx_device,
 	 * userspace can open the input device and rc_open() will be called


