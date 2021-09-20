Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D54412372
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352116AbhITSZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:25:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351954AbhITSWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:22:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22A93632B5;
        Mon, 20 Sep 2021 17:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158647;
        bh=L6WM1aTLdwLszvmaKezF1OmMbD/Ou2uHCn3ZmDl21rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MW4GKhJadIUNxQUmJOol/whn3PMqcb0HijCsv30TGgbwQP55Z3D8Wo/FEbuv5jBHi
         14Wjt0a2nm8AcUHsOM2FjKSap8jv7/xV28DJHl7lkJfk49Z92e+dol2KsOaisubCqT
         CyYJlTjWRbbWJScN0UkfCB3Xou+YxPomyZ/2xvKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 251/260] PCI: Sync __pci_register_driver() stub for CONFIG_PCI=n
Date:   Mon, 20 Sep 2021 18:44:29 +0200
Message-Id: <20210920163939.639844872@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 817f9916a6e96ae43acdd4e75459ef4f92d96eb1 ]

The CONFIG_PCI=y case got a new parameter long time ago.  Sync the stub as
well.

[bhelgaas: add parameter names]
Fixes: 725522b5453d ("PCI: add the sysfs driver name to all modules")
Link: https://lore.kernel.org/r/20210813153619.89574-1-andriy.shevchenko@linux.intel.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6a6a819c5b49..9a937f8b2783 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1688,8 +1688,9 @@ static inline int pci_enable_device(struct pci_dev *dev) { return -EIO; }
 static inline void pci_disable_device(struct pci_dev *dev) { }
 static inline int pci_assign_resource(struct pci_dev *dev, int i)
 { return -EBUSY; }
-static inline int __pci_register_driver(struct pci_driver *drv,
-					struct module *owner)
+static inline int __must_check __pci_register_driver(struct pci_driver *drv,
+						     struct module *owner,
+						     const char *mod_name)
 { return 0; }
 static inline int pci_register_driver(struct pci_driver *drv)
 { return 0; }
-- 
2.30.2



