Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C204120F8
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356122AbhITSAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356127AbhITR6n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:58:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86C4C63217;
        Mon, 20 Sep 2021 17:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158113;
        bh=85ln7G8OG8wQeYQZEGI941FywbA3+XinGLsB5eyw+3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UIUASUJ62rXTwcFKJsuiZfrxPReT5uVvB597IuQKZPOd9FSvcBQNSSP0/gUZ6RFNh
         pgTkhvOr8+NuliHibjgPxwaENDXPrjod2o9p/17wf5uTWSlt/jmSwYU3sm03zXsRBW
         wSusBPZ8jEvygJFoKtxhTR21PGhASY85bNe/82S8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 285/293] PCI: Sync __pci_register_driver() stub for CONFIG_PCI=n
Date:   Mon, 20 Sep 2021 18:44:07 +0200
Message-Id: <20210920163943.185731971@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
index 2fda9893962d..6f9ca2f278b3 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1644,8 +1644,9 @@ static inline int pci_enable_device(struct pci_dev *dev) { return -EIO; }
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



