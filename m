Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC17328728
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237727AbhCARUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:20:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237847AbhCARNe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:13:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B956664EF4;
        Mon,  1 Mar 2021 16:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617066;
        bh=+amFEaX6YjAjhN2OgmQjdKQ+gqTpkn+fpxnSV39yhbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gAr7+Femvk8NBScZzPAshGIb9mizM49w/poGxfctmTfQ/OSo4TZdMefLy1kpQtUnP
         eQGwzU5nnVtNC7o+gdWEyeRa7U0i6n6ANs0GkJDn9++jMNuP1D+abXcvkWNVnA4tGX
         p5u+GuvY0XHL1fvZ7Uvinj1W3zkexNT614edZDB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 161/247] regmap: sdw: use _no_pm functions in regmap_read/write
Date:   Mon,  1 Mar 2021 17:13:01 +0100
Message-Id: <20210301161039.554979488@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit d288a5712ef961e16d588bbdb2d846e00b5ef154 ]

sdw_update_slave_status will be invoked when a codec is attached,
and the codec driver will initialize the codec with regmap functions
while the codec device is pm_runtime suspended.

regmap routines currently rely on regular SoundWire IO functions,
which will call pm_runtime_get_sync()/put_autosuspend.

This causes a deadlock where the resume routine waits for an
initialization complete signal that while the initialization complete
can only be reached when the resume completes.

The only solution if we allow regmap functions to be used in resume
operations as well as during codec initialization is to use _no_pm
routines. The duty of making sure the bus is operational needs to be
handled above the regmap level.

Fixes: 7c22ce6e21840 ('regmap: Add SoundWire bus support')
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210122070634.12825-6-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-sdw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap-sdw.c b/drivers/base/regmap/regmap-sdw.c
index 50a66382d87d0..e75168b941d0c 100644
--- a/drivers/base/regmap/regmap-sdw.c
+++ b/drivers/base/regmap/regmap-sdw.c
@@ -12,7 +12,7 @@ static int regmap_sdw_write(void *context, unsigned int reg, unsigned int val)
 	struct device *dev = context;
 	struct sdw_slave *slave = dev_to_sdw_dev(dev);
 
-	return sdw_write(slave, reg, val);
+	return sdw_write_no_pm(slave, reg, val);
 }
 
 static int regmap_sdw_read(void *context, unsigned int reg, unsigned int *val)
@@ -21,7 +21,7 @@ static int regmap_sdw_read(void *context, unsigned int reg, unsigned int *val)
 	struct sdw_slave *slave = dev_to_sdw_dev(dev);
 	int read;
 
-	read = sdw_read(slave, reg);
+	read = sdw_read_no_pm(slave, reg);
 	if (read < 0)
 		return read;
 
-- 
2.27.0



