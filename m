Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81AF1F2FDB
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgFIAyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:54:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726904AbgFHXJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FFD3208B8;
        Mon,  8 Jun 2020 23:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657775;
        bh=lo+IN4r4Bg9TSjj4yw/aqNpns9X/UoYTuCNNSVl6eSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w0DptA3knK0uweaUxcJFmOXSek+JBokg3HeUXUOHpH5fUrn2EvjLo8v7PvJEPZsAx
         Hc5bGn7wQem0CEy9Mr5sAOsywZEykcnz/3QI3Q5f3WwihxoUtUs1L+HMb3lrzksupO
         vOe0+Qe73xeFCOzmAm8reN2zO5pV/534SiAuWotM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Chen-Yu Tsai <wens@csie.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 158/274] media: sun8i: Fix an error handling path in 'deinterlace_runtime_resume()'
Date:   Mon,  8 Jun 2020 19:04:11 -0400
Message-Id: <20200608230607.3361041-158-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 62eedb356188376acd0368384a9b294d5180c00b ]

It is spurious to call 'clk_disable_unprepare()' when
'clk_prepare_enable()' has not been called yet.
Re-order the error handling path to avoid it.

Fixes: a4260ea49547 ("media: sun4i: Add H3 deinterlace driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
[hverkuil-cisco@xs4all.nl: err_exlusive_rate -> err_exclusive_rate]
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sunxi/sun8i-di/sun8i-di.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/sunxi/sun8i-di/sun8i-di.c b/drivers/media/platform/sunxi/sun8i-di/sun8i-di.c
index d78f6593ddd1..ba5d07886607 100644
--- a/drivers/media/platform/sunxi/sun8i-di/sun8i-di.c
+++ b/drivers/media/platform/sunxi/sun8i-di/sun8i-di.c
@@ -941,7 +941,7 @@ static int deinterlace_runtime_resume(struct device *device)
 	if (ret) {
 		dev_err(dev->dev, "Failed to enable bus clock\n");
 
-		goto err_exlusive_rate;
+		goto err_exclusive_rate;
 	}
 
 	ret = clk_prepare_enable(dev->mod_clk);
@@ -969,14 +969,14 @@ static int deinterlace_runtime_resume(struct device *device)
 
 	return 0;
 
-err_exlusive_rate:
-	clk_rate_exclusive_put(dev->mod_clk);
 err_ram_clk:
 	clk_disable_unprepare(dev->ram_clk);
 err_mod_clk:
 	clk_disable_unprepare(dev->mod_clk);
 err_bus_clk:
 	clk_disable_unprepare(dev->bus_clk);
+err_exclusive_rate:
+	clk_rate_exclusive_put(dev->mod_clk);
 
 	return ret;
 }
-- 
2.25.1

