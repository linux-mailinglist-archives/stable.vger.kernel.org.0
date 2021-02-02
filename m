Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE5430C770
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbhBBRVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:21:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:49660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234246AbhBBOOt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:14:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4CD165056;
        Tue,  2 Feb 2021 13:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612274007;
        bh=IXqvt+B48gssb3f8jBwHjc71B7gfjnJEyFUhe+3ndk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxAqaQIPr0C0/vrI+F19pueJU7G+JpS+9NLdPLk5CEAxfC58gHRfeCqHydh7E/47V
         omdLIOp5HrNDzugICY1vqAnacgsd6u+/IPu4Ngf5d07umJXn2QNB3iXoQIAKAqVe6i
         F6/DCnbCrF1F9QyHbP2q5M1NLctxm+P50dnzbAIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 06/37] media: rc: ensure that uevent can be read directly after rc device register
Date:   Tue,  2 Feb 2021 14:38:49 +0100
Message-Id: <20210202132943.163106090@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.915040339@linuxfoundation.org>
References: <20210202132942.915040339@linuxfoundation.org>
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
@@ -1875,6 +1875,8 @@ int rc_register_device(struct rc_dev *de
 			goto out_raw;
 	}
 
+	dev->registered = true;
+
 	rc = device_add(&dev->dev);
 	if (rc)
 		goto out_rx_free;
@@ -1884,8 +1886,6 @@ int rc_register_device(struct rc_dev *de
 		 dev->device_name ?: "Unspecified device", path ?: "N/A");
 	kfree(path);
 
-	dev->registered = true;
-
 	/*
 	 * once the the input device is registered in rc_setup_rx_device,
 	 * userspace can open the input device and rc_open() will be called


