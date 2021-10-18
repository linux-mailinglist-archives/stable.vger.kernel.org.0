Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A810431E36
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbhJRN7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:59:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232970AbhJRN5P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:57:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B41AC61352;
        Mon, 18 Oct 2021 13:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564449;
        bh=xilPZk9/nZia+eYlSf6R1c5WQTZjPZOxSrt8QTci9yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGmyO7pTaPFhQvbyrMzRAaStFXjpnMFCzToAb6/oWOT60xtefFzSjU/+izfdoELRB
         nnHnrml3BvyF5aA1Ivf+1P1EARMkXe6mdU+2qsq9RBzkkPfKZSRy/lh7sHlWTBzFBt
         p6h+SoudwotFC4RnGyv1b3PJiyN/AFGDlJXtDetw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Wiklander <jens.wiklander@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 5.14 093/151] firmware: arm_ffa: Add missing remove callback to ffa_bus_type
Date:   Mon, 18 Oct 2021 15:24:32 +0200
Message-Id: <20211018132343.706120091@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

commit 244f5d597e1ea519c2085fbd9819458688775e42 upstream.

Currently the arm_ffa firmware driver can be built as module and hence
all the users of FFA driver. If any driver on the ffa bus is removed or
unregistered, the remove callback on all the device bound to the driver
being removed should be callback. For that to happen, we must register
a remove callback on the ffa_bus which is currently missing. This results
in the probe getting called again without the previous remove callback
on a device which may result in kernel crash.

Fix the issue by registering the remove callback on the FFA bus.

Link: https://lore.kernel.org/r/20210924092859.3057562-1-sudeep.holla@arm.com
Fixes: e781858488b9 ("firmware: arm_ffa: Add initial FFA bus support for device enumeration")
Reported-by: Jens Wiklander <jens.wiklander@linaro.org>
Tested-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_ffa/bus.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/firmware/arm_ffa/bus.c
+++ b/drivers/firmware/arm_ffa/bus.c
@@ -49,6 +49,13 @@ static int ffa_device_probe(struct devic
 	return ffa_drv->probe(ffa_dev);
 }
 
+static void ffa_device_remove(struct device *dev)
+{
+	struct ffa_driver *ffa_drv = to_ffa_driver(dev->driver);
+
+	ffa_drv->remove(to_ffa_dev(dev));
+}
+
 static int ffa_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct ffa_device *ffa_dev = to_ffa_dev(dev);
@@ -86,6 +93,7 @@ struct bus_type ffa_bus_type = {
 	.name		= "arm_ffa",
 	.match		= ffa_device_match,
 	.probe		= ffa_device_probe,
+	.remove		= ffa_device_remove,
 	.uevent		= ffa_device_uevent,
 	.dev_groups	= ffa_device_attributes_groups,
 };


