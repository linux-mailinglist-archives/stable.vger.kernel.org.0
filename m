Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A25C412618
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386038AbhITSxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:53:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385513AbhITSue (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:50:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23C8063388;
        Mon, 20 Sep 2021 17:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159300;
        bh=sX5b8JoeFfHZzYyBd4omOF5TuWeokLyGeF1c9CTjjq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxK3r7exj3W3GgvTd4SqxQ9mMKuQMTwp/Za24gB79kypt4oHdoPlqMkv9tpLUZuDX
         Qe4I82nJCWDeU7/wAAJXj64RFw/u63MKF+pmsaaRMAxmaLsnPaCqn6KiOzBftmoXba
         Fok6EWlzIrOqFZ4j2VnhHn1RUz74YOSpV4FEcN3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 136/168] PCI: Sync __pci_register_driver() stub for CONFIG_PCI=n
Date:   Mon, 20 Sep 2021 18:44:34 +0200
Message-Id: <20210920163926.131715683@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
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
index 540b377ca8f6..acbed2ecf6e8 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1740,8 +1740,9 @@ static inline void pci_disable_device(struct pci_dev *dev) { }
 static inline int pcim_enable_device(struct pci_dev *pdev) { return -EIO; }
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



