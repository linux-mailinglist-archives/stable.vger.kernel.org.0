Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03EF012C84B
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbfL2RxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:53:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:39930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729174AbfL2RxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:53:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EF5D206DB;
        Sun, 29 Dec 2019 17:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641990;
        bh=u1vbAAODFFibUTO2yMqM38STXoTtYukUrreTORXp/oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zWp1WRfcBY9EqGoZ1WEtVaHjYvYCLoU1WDFDKLT+Vd+sNG/O1g0z52PCLdGP9zylr
         hgoJI6IAtuo9ilMR/3LdaUIuS3kNQlqrjD7fq8+gYpESzRbPGAbEhGzVnmL4aCIhfL
         VbeQryDEdkAKsJy5zyail2+hsvcYF/wh0CYYBeS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 297/434] parport: load lowlevel driver if ports not found
Date:   Sun, 29 Dec 2019 18:25:50 +0100
Message-Id: <20191229172721.677214074@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7b4ee33c1935..15c81cffd2de 100644
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -230,6 +230,18 @@ static int port_check(struct device *dev, void *dev_drv)
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
@@ -282,6 +294,15 @@ int __parport_register_driver(struct parport_driver *drv, struct module *owner,
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



