Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB796187FCC
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgCQLEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:04:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728312AbgCQLEi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:04:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36E5420658;
        Tue, 17 Mar 2020 11:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443077;
        bh=0dvnIHjIvrMzVSv9CLZhGvjeFyWFTtD1oWPl5DeL6NA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQS93WGeabGvKuPRnboaetedfBX7I5D+6mzPd6oixLpH8jepFC/C2IL44F/VuKXKt
         lGNr1v7OudwyMDoD926ElMnquwDi6ju0XpqP5FMuseoozmRgWBeYcL01aTMYv9qNdZ
         hQa5Q50LnxvmWv0LQ5raMkUZshHO5/lsLoTAeyso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 5.4 089/123] i2c: designware-pci: Fix BUG_ON during device removal
Date:   Tue, 17 Mar 2020 11:55:16 +0100
Message-Id: <20200317103316.846384251@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

commit 9be8bc4dd6177cf992b93b0bd014c4f611283896 upstream.

Function i2c_dw_pci_remove() -> pci_free_irq_vectors() ->
pci_disable_msi() -> free_msi_irqs() will throw a BUG_ON() for MSI
enabled device since the driver has not released the requested IRQ before
calling the pci_free_irq_vectors().

Here driver requests an IRQ using devm_request_irq() but automatic
release happens only after remove callback. Fix this by explicitly
freeing the IRQ before calling pci_free_irq_vectors().

Fixes: 21aa3983d619 ("i2c: designware-pci: Switch over to MSI interrupts")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-designware-pcidrv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -313,6 +313,7 @@ static void i2c_dw_pci_remove(struct pci
 	pm_runtime_get_noresume(&pdev->dev);
 
 	i2c_del_adapter(&dev->adapter);
+	devm_free_irq(&pdev->dev, dev->irq, dev);
 	pci_free_irq_vectors(pdev);
 }
 


