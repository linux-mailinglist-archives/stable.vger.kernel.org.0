Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 169F210132F
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbfKSFXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:23:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727936AbfKSFXK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:23:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBE612231A;
        Tue, 19 Nov 2019 05:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140989;
        bh=O/EPpd3UjBDA6PsEDJfUuRGzIrfTKmGZ1gBPhx9iqmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z5JTM0YSAanmUmX3ZMRGL18ZKNBgMjAwlI+77X3LQgfYQYyyYmIJ3mZfYnWhRjMj8
         uy4x+e0BcdQol6d0W4fcDEaCk36/MQYWlOwU9lJtH76AlXczclDUrXDB2koM77pMiv
         eyO0oIjIfMAk1MZPL8NWSBciTH2l2aUt5+05tcpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.3 48/48] mmc: sdhci-of-at91: fix quirk2 overwrite
Date:   Tue, 19 Nov 2019 06:20:08 +0100
Message-Id: <20191119051031.442320103@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

commit fed23c5829ecab4ddc712d7b0046e59610ca3ba4 upstream.

The quirks2 are parsed and set (e.g. from DT) before the quirk for broken
HS200 is set in the driver.
The driver needs to enable just this flag, not rewrite the whole quirk set.

Fixes: 7871aa60ae00 ("mmc: sdhci-of-at91: add quirk for broken HS200")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-at91.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-of-at91.c
+++ b/drivers/mmc/host/sdhci-of-at91.c
@@ -358,7 +358,7 @@ static int sdhci_at91_probe(struct platf
 	pm_runtime_use_autosuspend(&pdev->dev);
 
 	/* HS200 is broken at this moment */
-	host->quirks2 = SDHCI_QUIRK2_BROKEN_HS200;
+	host->quirks2 |= SDHCI_QUIRK2_BROKEN_HS200;
 
 	ret = sdhci_add_host(host);
 	if (ret)


