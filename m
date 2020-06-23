Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46615206620
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388207AbgFWVhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388033AbgFWUIi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:08:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 049C42080C;
        Tue, 23 Jun 2020 20:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942917;
        bh=00LaLXwHMBQRfAvmBDri+hTtcKQVEn7pCEdWW67VnxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AEmUFeQoqpTb5XZdtQLpgm6QWvxHydj/mch5UOHCyHY89vZ9gRW2rQMvEAOdTzgsy
         yq0YBYmsVmiFPKUxI+ztc3XbcNKAU97jM3ib1721ZouIyZASKsLSlB/pu9YeyOhmQv
         VrXGrtcXLqM5SvMHOkzdQ2hCgl5nU2F11qL3caEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jerome Pouiller <Jerome.Pouiller@silabs.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 169/477] staging: wfx: avoid compiler warning on empty array
Date:   Tue, 23 Jun 2020 21:52:46 +0200
Message-Id: <20200623195415.573848247@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2eeefd3787fdc6319124945d453774be95b97897 ]

When CONFIG_OF is disabled, gcc-9 produces a warning about the
wfx_sdio_of_match[] array having a declaration without a dimension:

drivers/staging/wfx/bus_sdio.c:159:34: error: array 'wfx_sdio_of_match' assumed to have one element [-Werror]
  159 | static const struct of_device_id wfx_sdio_of_match[];
      |                                  ^~~~~~~~~~~~~~~~~

Move the proper declaration up and out of the #ifdef instead.

Fixes: a7a91ca5a23d ("staging: wfx: add infrastructure for new driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jerome Pouiller <Jerome.Pouiller@silabs.com>
Link: https://lore.kernel.org/r/20200429142119.1735196-1-arnd@arndb.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wfx/bus_sdio.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wfx/bus_sdio.c b/drivers/staging/wfx/bus_sdio.c
index dedc3ff58d3eb..c2e4bd1e3b0a0 100644
--- a/drivers/staging/wfx/bus_sdio.c
+++ b/drivers/staging/wfx/bus_sdio.c
@@ -156,7 +156,13 @@ static const struct hwbus_ops wfx_sdio_hwbus_ops = {
 	.align_size		= wfx_sdio_align_size,
 };
 
-static const struct of_device_id wfx_sdio_of_match[];
+static const struct of_device_id wfx_sdio_of_match[] = {
+	{ .compatible = "silabs,wfx-sdio" },
+	{ .compatible = "silabs,wf200" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, wfx_sdio_of_match);
+
 static int wfx_sdio_probe(struct sdio_func *func,
 			  const struct sdio_device_id *id)
 {
@@ -248,15 +254,6 @@ static const struct sdio_device_id wfx_sdio_ids[] = {
 };
 MODULE_DEVICE_TABLE(sdio, wfx_sdio_ids);
 
-#ifdef CONFIG_OF
-static const struct of_device_id wfx_sdio_of_match[] = {
-	{ .compatible = "silabs,wfx-sdio" },
-	{ .compatible = "silabs,wf200" },
-	{ },
-};
-MODULE_DEVICE_TABLE(of, wfx_sdio_of_match);
-#endif
-
 struct sdio_driver wfx_sdio_driver = {
 	.name = "wfx-sdio",
 	.id_table = wfx_sdio_ids,
@@ -264,6 +261,6 @@ struct sdio_driver wfx_sdio_driver = {
 	.remove = wfx_sdio_remove,
 	.drv = {
 		.owner = THIS_MODULE,
-		.of_match_table = of_match_ptr(wfx_sdio_of_match),
+		.of_match_table = wfx_sdio_of_match,
 	}
 };
-- 
2.25.1



