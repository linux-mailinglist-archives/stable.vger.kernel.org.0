Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A7948E651
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240576AbiANI0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240812AbiANIYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:24:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC37EC06175E;
        Fri, 14 Jan 2022 00:23:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85940B8243F;
        Fri, 14 Jan 2022 08:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C005CC36AE9;
        Fri, 14 Jan 2022 08:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148589;
        bh=llGa54CHGgSoUWro7/IfQugybuDw1Wtd5HuNjlqL9mM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0X9I6H0gZhERmc88+ZJ40mCOejleQFTa+6okcz6DMVFwlZCIkzZRVxAknSFfAObxy
         ZXuwjvIv8+38uAH/+hRWfQi3O+fD2O3THCZzM5tCrU8/VW1LWG8cawfukvpHpBihQM
         mBnmOv5+SZvPWfgNBRUcVF68FEmkMO3+c0SlhenU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Aditya Garg <gargaditya08@live.com>
Subject: [PATCH 5.16 26/37] mfd: intel-lpss-pci: Fix clock speed for 38a8 UART
Date:   Fri, 14 Jan 2022 09:16:40 +0100
Message-Id: <20220114081545.711615516@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
References: <20220114081544.849748488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Orlando Chamberlain <redecorating@protonmail.com>

commit 9651cf2cb14726c785240e9dc01b274a68e9959e upstream.

This device is found in the MacBookPro16,2, and as the MacBookPro16,1 is
from the same generation of MacBooks and has a UART with bxt_uart_info,
it was incorrectly assumed that the MacBookPro16,2's UART would have the
same info.

This led to the wrong clock speed being used, and the Bluetooth
controller exposed by the UART receiving and sending random data, which
was incorrectly assumed to be an issue with the Bluetooth stuff, not an
error with the UART side of things.

Changing the info to spt_uart_info changes the clock speed and makes it
send and receive data correctly.

Fixes: ddb1ada416fd ("mfd: intel-lpss: Add support for MacBookPro16,2 ICL-N UART")
Signed-off-by: Orlando Chamberlain <redecorating@protonmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Cc: Aditya Garg <gargaditya08@live.com>
Link: https://lore.kernel.org/r/20211124091846.11114-1-redecorating@protonmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/intel-lpss-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/intel-lpss-pci.c
+++ b/drivers/mfd/intel-lpss-pci.c
@@ -254,7 +254,7 @@ static const struct pci_device_id intel_
 	{ PCI_VDEVICE(INTEL, 0x34eb), (kernel_ulong_t)&bxt_i2c_info },
 	{ PCI_VDEVICE(INTEL, 0x34fb), (kernel_ulong_t)&spt_info },
 	/* ICL-N */
-	{ PCI_VDEVICE(INTEL, 0x38a8), (kernel_ulong_t)&bxt_uart_info },
+	{ PCI_VDEVICE(INTEL, 0x38a8), (kernel_ulong_t)&spt_uart_info },
 	/* TGL-H */
 	{ PCI_VDEVICE(INTEL, 0x43a7), (kernel_ulong_t)&bxt_uart_info },
 	{ PCI_VDEVICE(INTEL, 0x43a8), (kernel_ulong_t)&bxt_uart_info },


