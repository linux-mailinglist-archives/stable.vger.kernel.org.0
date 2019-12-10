Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8C46119D29
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbfLJWf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:35:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:55788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730312AbfLJWeZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:34:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58C6120836;
        Tue, 10 Dec 2019 22:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017264;
        bh=38FFUr4wJcSHZUo18xjwL//0/s+aUyFXP8m0Ec/39v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AK5QDvCxSNyhcwrB6ujF6dB2CM19kDLrHGqqljbekTvZqwnffOmDpPY0H9cTPqJPY
         FPY8hmsUuRkm0U5CjpUy0ci5Rj7jHKNNB4/CNfwdraEoP9v6cFw5BwGsJhMHjXL23J
         2CzrxOSrOmvTyhDC2lxClBpbt5Tu8VMMdOjVTJ/s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 58/71] parport: load lowlevel driver if ports not found
Date:   Tue, 10 Dec 2019 17:33:03 -0500
Message-Id: <20191210223316.14988-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223316.14988-1-sashal@kernel.org>
References: <20191210223316.14988-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

[ Upstream commit 231ec2f24dad18d021b361045bbd618ba62a274e ]

Usually all the distro will load the parport low level driver as part
of their initialization. But we can get into a situation where all the
parallel port drivers are built as module and we unload all the modules
at a later time. Then if we just do "modprobe parport" it will only
load the parport module and will not load the low level driver which
will actually register the ports. So, check the bus if there is any
parport registered, if not, load the low level driver.

We can get into the above situation with all distro but only Suse has
setup the alias for "parport_lowlevel" and so it only works in Suse.
Users of Debian based distro will need to load the lowlevel module
manually.

Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Link: https://lore.kernel.org/r/20191016144540.18810-3-sudipm.mukherjee@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parport/share.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/parport/share.c b/drivers/parport/share.c
index f26af0214ab3e..3be1f4a041d49 100644
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -228,6 +228,18 @@ static int port_check(struct device *dev, void *dev_drv)
 	return 0;
 }
 
+/*
+ * Iterates through all the devices connected to the bus and return 1
+ * if the device is a parallel port.
+ */
+
+static int port_detect(struct device *dev, void *dev_drv)
+{
+	if (is_parport(dev))
+		return 1;
+	return 0;
+}
+
 /**
  *	parport_register_driver - register a parallel port device driver
  *	@drv: structure describing the driver
@@ -280,6 +292,15 @@ int __parport_register_driver(struct parport_driver *drv, struct module *owner,
 		if (ret)
 			return ret;
 
+		/*
+		 * check if bus has any parallel port registered, if
+		 * none is found then load the lowlevel driver.
+		 */
+		ret = bus_for_each_dev(&parport_bus_type, NULL, NULL,
+				       port_detect);
+		if (!ret)
+			get_lowlevel_driver();
+
 		mutex_lock(&registration_lock);
 		if (drv->match_port)
 			bus_for_each_dev(&parport_bus_type, NULL, drv,
-- 
2.20.1

