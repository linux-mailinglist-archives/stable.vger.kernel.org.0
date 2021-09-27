Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAFA419B55
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236650AbhI0RRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:17:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235739AbhI0RPb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:15:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADC1A6138B;
        Mon, 27 Sep 2021 17:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762662;
        bh=aXLmOY90TRxwWn1nxs/VzEt9fTzOlYxaZvSCB50OY0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IiTBeyEx+5toSdG88jLuA0HWwsOg0A3NO6woDfbTQRMck2eg+sonZECKhuvgcB5jp
         OVH8UJkKmXqsJZ0bsZISByn787/hh2qQdoPeSYJdFJsCzUrVcGNMIpEay67//R0UeV
         xcypYloIx/D19dzUGhr06KDh8hxdRQXnaSanWmHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/103] spi: Fix tegra20 build with CONFIG_PM=n
Date:   Mon, 27 Sep 2021 19:03:09 +0200
Message-Id: <20210927170229.125778530@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit efafec27c5658ed987e720130772f8933c685e87 ]

Without CONFIG_PM enabled, the SET_RUNTIME_PM_OPS() macro ends up being
empty, and the only use of tegra_slink_runtime_{resume,suspend} goes
away, resulting in

  drivers/spi/spi-tegra20-slink.c:1200:12: error: ‘tegra_slink_runtime_resume’ defined but not used [-Werror=unused-function]
   1200 | static int tegra_slink_runtime_resume(struct device *dev)
        |            ^~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/spi/spi-tegra20-slink.c:1188:12: error: ‘tegra_slink_runtime_suspend’ defined but not used [-Werror=unused-function]
   1188 | static int tegra_slink_runtime_suspend(struct device *dev)
        |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~

mark the functions __maybe_unused to make the build happy.

This hits the alpha allmodconfig build (and others).

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra20-slink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index f7c832fd4003..669fc4286231 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -1201,7 +1201,7 @@ static int tegra_slink_resume(struct device *dev)
 }
 #endif
 
-static int tegra_slink_runtime_suspend(struct device *dev)
+static int __maybe_unused tegra_slink_runtime_suspend(struct device *dev)
 {
 	struct spi_master *master = dev_get_drvdata(dev);
 	struct tegra_slink_data *tspi = spi_master_get_devdata(master);
@@ -1213,7 +1213,7 @@ static int tegra_slink_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int tegra_slink_runtime_resume(struct device *dev)
+static int __maybe_unused tegra_slink_runtime_resume(struct device *dev)
 {
 	struct spi_master *master = dev_get_drvdata(dev);
 	struct tegra_slink_data *tspi = spi_master_get_devdata(master);
-- 
2.33.0



