Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1393137CA
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbhBHPbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:31:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:36904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232216AbhBHP0x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:26:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D36564F00;
        Mon,  8 Feb 2021 15:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797337;
        bh=7MTfk6n6glJXE0u304vVJG6k0fJP8beLHRBuhlEp31U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fR3/pkTNyF89wLDA4l904G5Ohw+1H9rvYZz1zBSTxYd+tS9roq0mVNmxGyQFmKQAx
         J7Myko80GzZsYfa1uiBFgt0IDfs4XNIbVJ2M/MSyKPcJO71SECM3zZz30t/VGgJRQR
         TrvGsSuqwTdeWG216mgxdKPqakoplACP/ElSRrZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Nicolas Schichan <nschichan@freeebox.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 075/120] mmc: sdhci-pltfm: Fix linking err for sdhci-brcmstb
Date:   Mon,  8 Feb 2021 16:01:02 +0100
Message-Id: <20210208145821.401880161@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit d7fb9c24209556478e65211d7a1f056f2d43cceb upstream.

The implementation of sdhci_pltfm_suspend() is only available when
CONFIG_PM_SLEEP is set, which triggers a linking error:

"undefined symbol: sdhci_pltfm_suspend" when building sdhci-brcmstb.c.

Fix this by implementing the missing stubs when CONFIG_PM_SLEEP is unset.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Fixes: 5b191dcba719 ("mmc: sdhci-brcmstb: Fix mmc timeout errors on S5 suspend")
Cc: stable@vger.kernel.org
Tested-By: Nicolas Schichan <nschichan@freeebox.fr>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pltfm.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-pltfm.h
+++ b/drivers/mmc/host/sdhci-pltfm.h
@@ -111,8 +111,13 @@ static inline void *sdhci_pltfm_priv(str
 	return host->private;
 }
 
+extern const struct dev_pm_ops sdhci_pltfm_pmops;
+#ifdef CONFIG_PM_SLEEP
 int sdhci_pltfm_suspend(struct device *dev);
 int sdhci_pltfm_resume(struct device *dev);
-extern const struct dev_pm_ops sdhci_pltfm_pmops;
+#else
+static inline int sdhci_pltfm_suspend(struct device *dev) { return 0; }
+static inline int sdhci_pltfm_resume(struct device *dev) { return 0; }
+#endif
 
 #endif /* _DRIVERS_MMC_SDHCI_PLTFM_H */


