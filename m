Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B479C30CB81
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239639AbhBBT0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:26:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233563AbhBBN7p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:59:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC8A964FF8;
        Tue,  2 Feb 2021 13:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273590;
        bh=/YGFy/krvT3m0oyWJsbmb3oH7WnUVVgEUAbnBhwSZLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TN4GO1otIAalCs8fjR+wl5GOifyeXZCWspwg7D9H0Wd0Oxxa522M5+jpVODx0Qve4
         xWPgfckHMZUiMw9pkCNtJfw1hrNMCvwGvi1BMXtQrzazF+RWVJrlAlRRAgZSHPw+eR
         huIATUleuyTfd2R254k7YU8d17JN2kNciKFnl3EY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 08/61] media: rc: ensure that uevent can be read directly after rc device register
Date:   Tue,  2 Feb 2021 14:37:46 +0100
Message-Id: <20210202132946.833046604@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
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
@@ -1892,6 +1892,8 @@ int rc_register_device(struct rc_dev *de
 			goto out_raw;
 	}
 
+	dev->registered = true;
+
 	rc = device_add(&dev->dev);
 	if (rc)
 		goto out_rx_free;
@@ -1901,8 +1903,6 @@ int rc_register_device(struct rc_dev *de
 		 dev->device_name ?: "Unspecified device", path ?: "N/A");
 	kfree(path);
 
-	dev->registered = true;
-
 	/*
 	 * once the the input device is registered in rc_setup_rx_device,
 	 * userspace can open the input device and rc_open() will be called


