Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4E21C1640
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbgEANmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731540AbgEANmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:42:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33866208DB;
        Fri,  1 May 2020 13:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340558;
        bh=4me/jR2ZnSatyCNKpFLzx58lk7Br2uuCIqzGWtW55sY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROwwFzjj3UFNa85FFcUBL547M8K2RlgViL8dZVx92sgs8rvwy+ZHPnod460XzP07Z
         FooUXEtt6cUXC4lJGonHqHuAZXF7KR3Dcsk5KlC6KO6uUMWkotYWmQ6r4lFuSK/SfJ
         Bf6KKuXfLtc//nHtHOw7uXxMl/hOX5kG2+VKhhA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.6 031/106] rtw88: avoid unused function warnings
Date:   Fri,  1 May 2020 15:23:04 +0200
Message-Id: <20200501131547.705097613@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 7dc7c41607d192ff660ba4ea82d517745c1d7523 upstream.

The rtw88 driver defines emtpy functions with multiple indirections
but gets one of these wrong:

drivers/net/wireless/realtek/rtw88/pci.c:1347:12: error: 'rtw_pci_resume' defined but not used [-Werror=unused-function]
 1347 | static int rtw_pci_resume(struct device *dev)
      |            ^~~~~~~~~~~~~~
drivers/net/wireless/realtek/rtw88/pci.c:1342:12: error: 'rtw_pci_suspend' defined but not used [-Werror=unused-function]
 1342 | static int rtw_pci_suspend(struct device *dev)

Better simplify it to rely on the conditional reference in
SIMPLE_DEV_PM_OPS(), and mark the functions as __maybe_unused to avoid
warning about it.

I'm not sure if these are needed at all given that the functions
don't do anything, but they were only recently added.

Fixes: 44bc17f7f5b3 ("rtw88: support wowlan feature for 8822c")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200408185413.218643-1-arnd@arndb.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/realtek/rtw88/pci.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1287,22 +1287,17 @@ static void rtw_pci_phy_cfg(struct rtw_d
 	rtw_pci_link_cfg(rtwdev);
 }
 
-#ifdef CONFIG_PM
-static int rtw_pci_suspend(struct device *dev)
+static int __maybe_unused rtw_pci_suspend(struct device *dev)
 {
 	return 0;
 }
 
-static int rtw_pci_resume(struct device *dev)
+static int __maybe_unused rtw_pci_resume(struct device *dev)
 {
 	return 0;
 }
 
 static SIMPLE_DEV_PM_OPS(rtw_pm_ops, rtw_pci_suspend, rtw_pci_resume);
-#define RTW_PM_OPS (&rtw_pm_ops)
-#else
-#define RTW_PM_OPS NULL
-#endif
 
 static int rtw_pci_claim(struct rtw_dev *rtwdev, struct pci_dev *pdev)
 {
@@ -1530,7 +1525,7 @@ static struct pci_driver rtw_pci_driver
 	.id_table = rtw_pci_id_table,
 	.probe = rtw_pci_probe,
 	.remove = rtw_pci_remove,
-	.driver.pm = RTW_PM_OPS,
+	.driver.pm = &rtw_pm_ops,
 };
 module_pci_driver(rtw_pci_driver);
 


