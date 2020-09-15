Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB5326B611
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbgIOX4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:56:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbgIOOb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:31:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1010522B42;
        Tue, 15 Sep 2020 14:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179763;
        bh=d0FQJwrhvmcBBIqNG69O3ky0ueUn5MUUwfHItqR3IMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F8hejsxpKbQbzkMB9JJhnqlC34xXa/b036XKegWDc/0Le6ASFQuFCBziBWAYSAFKk
         IA4IeXVU8GeuSMtyhVhX6ND7kXFozd0ho9bJnGe26AC15bVmDYsLsvti6BjIngWd/n
         3STN2hADffP/go/wMQcX99B+hWIBb8+vkdgfYExA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.4 109/132] rbd: require global CAP_SYS_ADMIN for mapping and unmapping
Date:   Tue, 15 Sep 2020 16:13:31 +0200
Message-Id: <20200915140649.591993124@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

commit f44d04e696feaf13d192d942c4f14ad2e117065a upstream.

It turns out that currently we rely only on sysfs attribute
permissions:

  $ ll /sys/bus/rbd/{add*,remove*}
  --w------- 1 root root 4096 Sep  3 20:37 /sys/bus/rbd/add
  --w------- 1 root root 4096 Sep  3 20:37 /sys/bus/rbd/add_single_major
  --w------- 1 root root 4096 Sep  3 20:37 /sys/bus/rbd/remove
  --w------- 1 root root 4096 Sep  3 20:38 /sys/bus/rbd/remove_single_major

This means that images can be mapped and unmapped (i.e. block devices
can be created and deleted) by a UID 0 process even after it drops all
privileges or by any process with CAP_DAC_OVERRIDE in its user namespace
as long as UID 0 is mapped into that user namespace.

Be consistent with other virtual block devices (loop, nbd, dm, md, etc)
and require CAP_SYS_ADMIN in the initial user namespace for mapping and
unmapping, and also for dumping the configuration string and refreshing
the image header.

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/rbd.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5280,6 +5280,9 @@ static ssize_t rbd_config_info_show(stru
 {
 	struct rbd_device *rbd_dev = dev_to_rbd_dev(dev);
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	return sprintf(buf, "%s\n", rbd_dev->config_info);
 }
 
@@ -5391,6 +5394,9 @@ static ssize_t rbd_image_refresh(struct
 	struct rbd_device *rbd_dev = dev_to_rbd_dev(dev);
 	int ret;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	ret = rbd_dev_refresh(rbd_dev);
 	if (ret)
 		return ret;
@@ -7059,6 +7065,9 @@ static ssize_t do_rbd_add(struct bus_typ
 	struct rbd_client *rbdc;
 	int rc;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
 
@@ -7208,6 +7217,9 @@ static ssize_t do_rbd_remove(struct bus_
 	bool force = false;
 	int ret;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	dev_id = -1;
 	opt_buf[0] = '\0';
 	sscanf(buf, "%d %5s", &dev_id, opt_buf);


