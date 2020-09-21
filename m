Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E717327304D
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730085AbgIUREE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728555AbgIUQgG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:36:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38770206DC;
        Mon, 21 Sep 2020 16:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706165;
        bh=+75dQvfxz1bJXuAr8kB2Cj9zXGeWdLdW2fHe9F4A/Gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGOyYL+uKyBxEj5iE/+zhT5xiokNbrgQqWjvvrpgnoxTpmkjFLR73icpVQi+nndXN
         dMj2ZZabFhWIxxi4V6gAh5E97cpFnJ1Tjgx2xywakwxyj9aesHeJUV8nY1pADQVYRH
         YZFYjIQuazCfr9Q0TE3i4/3Iw5S28Mab9+l2uC+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 4.9 34/70] rbd: require global CAP_SYS_ADMIN for mapping and unmapping
Date:   Mon, 21 Sep 2020 18:27:34 +0200
Message-Id: <20200921162036.677281080@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
@@ -4614,6 +4614,9 @@ static ssize_t rbd_config_info_show(stru
 {
 	struct rbd_device *rbd_dev = dev_to_rbd_dev(dev);
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	return sprintf(buf, "%s\n", rbd_dev->config_info);
 }
 
@@ -4715,6 +4718,9 @@ static ssize_t rbd_image_refresh(struct
 	struct rbd_device *rbd_dev = dev_to_rbd_dev(dev);
 	int ret;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	ret = rbd_dev_refresh(rbd_dev);
 	if (ret)
 		return ret;
@@ -6192,6 +6198,9 @@ static ssize_t do_rbd_add(struct bus_typ
 	bool read_only;
 	int rc;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
 
@@ -6340,6 +6349,9 @@ static ssize_t do_rbd_remove(struct bus_
 	bool force = false;
 	int ret;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	dev_id = -1;
 	opt_buf[0] = '\0';
 	sscanf(buf, "%d %5s", &dev_id, opt_buf);


