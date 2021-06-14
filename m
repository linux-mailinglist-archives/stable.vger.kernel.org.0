Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B763A61DB
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234246AbhFNKwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233942AbhFNKua (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:50:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB96461245;
        Mon, 14 Jun 2021 10:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667114;
        bh=JkCZs82iG4e06idckWE3/bz81UWbR8WRtHwtfj+Hh0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KA6hyFvbGRS4G75jNJlUCSlHpSUm42yMfJpx1CiptUXCQzXHqcbMbK/vZyfP0eCLw
         aZR8y+sxpDagXRlhvE8Jk3ZCKA1+c5RHWiL3I9VfNvriiju1uoao9MV+advXLwb78A
         qH8UjcKDg/eKnQdu6aY3PkV/2TwIfnvRSqUOp1OQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Saravana Kannan <saravanak@google.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/84] spi: Dont have controller clean up spi device before driver unbind
Date:   Mon, 14 Jun 2021 12:27:11 +0200
Message-Id: <20210614102647.494513276@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
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
index c4b80cf825b8..f8f3434d5ab1 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -708,15 +708,15 @@ void spi_unregister_device(struct spi_device *spi)
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



