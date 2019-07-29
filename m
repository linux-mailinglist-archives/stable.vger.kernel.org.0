Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61D9C794D8
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388389AbfG2TgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:36:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730286AbfG2TgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:36:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53DBE21773;
        Mon, 29 Jul 2019 19:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428971;
        bh=xZFm5Pxm9Nvx1f01japX8gzzAAlWXsiskPpGAU5xF1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKDmmepPYsdzHuFkFLXMnFDxwVs0DTVAVlnwT2x4xBrNZnNe3D8npGhOfLwyBF5EA
         TaCpXIBvUKGeWskTco0/CS98YNi/YjbY8VzAWLhxZl/QVxht6mceEsjPSZZrF8WKH3
         WzBhWfDevf2ZEYY8sVRx39BeqCkmWth/tEupIruE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Vasut <marek.vasut+renesas@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Tejun Heo <tj@kernel.org>, Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 245/293] PCI: sysfs: Ignore lockdep for remove attribute
Date:   Mon, 29 Jul 2019 21:22:16 +0200
Message-Id: <20190729190843.227353086@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit dc6b698a86fe40a50525433eb8e92a267847f6f9 ]

With CONFIG_PROVE_LOCKING=y, using sysfs to remove a bridge with a device
below it causes a lockdep warning, e.g.,

  # echo 1 > /sys/class/pci_bus/0000:00/device/0000:00:00.0/remove
  ============================================
  WARNING: possible recursive locking detected
  ...
  pci_bus 0000:01: busn_res: [bus 01] is released

The remove recursively removes the subtree below the bridge.  Each call
uses a different lock so there's no deadlock, but the locks were all
created with the same lockdep key so the lockdep checker can't tell them
apart.

Mark the "remove" sysfs attribute with __ATTR_IGNORE_LOCKDEP() as it is
safe to ignore the lockdep check between different "remove" kernfs
instances.

There's discussion about a similar issue in USB at [1], which resulted in
356c05d58af0 ("sysfs: get rid of some lockdep false positives") and
e9b526fe7048 ("i2c: suppress lockdep warning on delete_device"), which do
basically the same thing for USB "remove" and i2c "delete_device" files.

[1] https://lore.kernel.org/r/Pine.LNX.4.44L0.1204251436140.1206-100000@iolanthe.rowland.org
Link: https://lore.kernel.org/r/20190526225151.3865-1-marek.vasut@gmail.com
Signed-off-by: Marek Vasut <marek.vasut+renesas@gmail.com>
[bhelgaas: trim commit log, details at above links]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Phil Edworthy <phil.edworthy@renesas.com>
Cc: Simon Horman <horms+renesas@verge.net.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index c3f0473d1afa..ee7dccab771d 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -496,7 +496,7 @@ static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
 		pci_stop_and_remove_bus_device_locked(to_pci_dev(dev));
 	return count;
 }
-static struct device_attribute dev_remove_attr = __ATTR(remove,
+static struct device_attribute dev_remove_attr = __ATTR_IGNORE_LOCKDEP(remove,
 							(S_IWUSR|S_IWGRP),
 							NULL, remove_store);
 
-- 
2.20.1



