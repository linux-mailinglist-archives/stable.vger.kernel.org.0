Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCB01A5A4D
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgDKXmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728507AbgDKXGr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:06:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE46120CC7;
        Sat, 11 Apr 2020 23:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646407;
        bh=uFeRP47vXTEoEuaRzJQknWLtUU6Ua3oYSHBDHgpJuts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gu9EBF99rNFX9jBbGES6lSTlwn/BouZTczmGqUaqAT4cWsef3w7ovLk2682Dpjls7
         mFQifs6Q6T54fHrXEPMj15bjYeRIUeULA2Ubzj0FFJzyU6pKT2jQ5+GBGZ7haBt5Ay
         7kcJpm8BuWz1Tp/oTp7o0VTp9gIbqydvkChHya/g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 143/149] nvmem: fix memory leak in error path
Date:   Sat, 11 Apr 2020 19:03:40 -0400
Message-Id: <20200411230347.22371-143-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

[ Upstream commit f7d8d7dcd978382dd1dd36e240dcddbfa6697796 ]

We need to free the ida mapping and nvmem struct if the write-protect
GPIO lookup fails.

Fixes: 2a127da461a9 ("nvmem: add support for the write-protect pin")
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20200310132257.23358-7-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 5f1988498d752..415ed8c5583a3 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -353,8 +353,12 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 	else
 		nvmem->wp_gpio = gpiod_get_optional(config->dev, "wp",
 						    GPIOD_OUT_HIGH);
-	if (IS_ERR(nvmem->wp_gpio))
-		return ERR_CAST(nvmem->wp_gpio);
+	if (IS_ERR(nvmem->wp_gpio)) {
+		ida_simple_remove(&nvmem_ida, nvmem->id);
+		rval = PTR_ERR(nvmem->wp_gpio);
+		kfree(nvmem);
+		return ERR_PTR(rval);
+	}
 
 
 	kref_init(&nvmem->refcnt);
-- 
2.20.1

