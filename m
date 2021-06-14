Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD213A62AE
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbhFNLDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:03:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232981AbhFNLAk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:00:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B74E6162D;
        Mon, 14 Jun 2021 10:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667381;
        bh=ZW3JLZfjvqZEDHU5V7iEFM3QKyw+K2Cq+E01twEHqXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2oKBNBdpRjWGGSrd3xz0ugivuhn9J22wnYz//RQe67jDkgW0qZVAL/dLGQMkNneI
         jygDwq/T2/0hQF7d5B6no326Kj75/mAZlo0g7mQclKRBPmRfBD2i2fZFB/HLJ3xK2N
         t/ylwcEYN+y/mMRGLaL/jCMdrWIBaqOm1dClksLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Saravana Kannan <saravanak@google.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/131] spi: Dont have controller clean up spi device before driver unbind
Date:   Mon, 14 Jun 2021 12:26:42 +0200
Message-Id: <20210614102654.412776912@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 27e7db56cf3dffd302bd7ddfacb1d405cf671a2a ]

When a spi device is unregistered and triggers a driver unbind, the
driver might need to access the spi device. So, don't have the
controller clean up the spi device before the driver is unbound. Clean
up the spi device after the driver is unbound.

Fixes: c7299fea6769 ("spi: Fix spi device unregister flow")
Reported-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Tested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210505164734.175546-1-saravanak@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 96560853b3a3..0cf67de741e7 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -709,15 +709,15 @@ void spi_unregister_device(struct spi_device *spi)
 	if (!spi)
 		return;
 
-	spi_cleanup(spi);
-
 	if (spi->dev.of_node) {
 		of_node_clear_flag(spi->dev.of_node, OF_POPULATED);
 		of_node_put(spi->dev.of_node);
 	}
 	if (ACPI_COMPANION(&spi->dev))
 		acpi_device_clear_enumerated(ACPI_COMPANION(&spi->dev));
-	device_unregister(&spi->dev);
+	device_del(&spi->dev);
+	spi_cleanup(spi);
+	put_device(&spi->dev);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_device);
 
-- 
2.30.2



