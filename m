Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C80856DA21
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbfGSD7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:59:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727552AbfGSD7e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:59:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B81D218A6;
        Fri, 19 Jul 2019 03:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508773;
        bh=NYLQY7CIaREfcBXHdDoypSwOWFVeme//3LD3XmnDecE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RW+ZnqV3ax8KxK/d4eqen+3jTsW4PZwAXv7QnJ/Sr7i5yv71VOHuzDaC0Yaak4GTq
         UKRFkxG6f0qYSyPiar8OoSDbQFeOcfnw60X6hXuWs69P8Hk8l6RXvfV20hKS/PHeqM
         lqGEj1HGoF78AK1DHSQqZOIBZFnKgSIslYhvNgB4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marek.vasut+renesas@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Tejun Heo <tj@kernel.org>, Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 082/171] PCI: sysfs: Ignore lockdep for remove attribute
Date:   Thu, 18 Jul 2019 23:55:13 -0400
Message-Id: <20190719035643.14300-82-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marek.vasut+renesas@gmail.com>

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
index 6d27475e39b2..4e83c347de5d 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -477,7 +477,7 @@ static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
 		pci_stop_and_remove_bus_device_locked(to_pci_dev(dev));
 	return count;
 }
-static struct device_attribute dev_remove_attr = __ATTR(remove,
+static struct device_attribute dev_remove_attr = __ATTR_IGNORE_LOCKDEP(remove,
 							(S_IWUSR|S_IWGRP),
 							NULL, remove_store);
 
-- 
2.20.1

