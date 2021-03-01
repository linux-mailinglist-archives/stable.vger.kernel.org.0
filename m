Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D166328BE7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240199AbhCASm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:42:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240116AbhCASgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:36:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AEE465079;
        Mon,  1 Mar 2021 17:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619741;
        bh=oKSzDqF61nr6aUtGB+t5hAaQn1ggM1TLcNzR1smF+iI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTEsf1Heyf3PeWxCG3sbn84jhZxdh6VjV4+n5V1eJeYCedHMWQuLo7+rCdbWL0Dzv
         rShopXr/XoB40jYqf/1pbO8MfMnkIrJN6NzRF+7wTt6kF5BQsBQcocKBuZUeKoGd1W
         RevLvTDaOuBD9T1B9N+/OPipvaurPjD0X9O3zEbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 565/663] media: marvell-ccic: power up the device on mclk enable
Date:   Mon,  1 Mar 2021 17:13:33 +0100
Message-Id: <20210301161209.824721905@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>

commit 655ae29da72a693cf294bba3c3322e662ff75bd3 upstream.

Writing to REG_CLKCTRL with the power off causes a hang. Enable the
device first.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/marvell-ccic/mcam-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -931,6 +931,7 @@ static int mclk_enable(struct clk_hw *hw
 		mclk_div = 2;
 	}
 
+	pm_runtime_get_sync(cam->dev);
 	clk_enable(cam->clk[0]);
 	mcam_reg_write(cam, REG_CLKCTRL, (mclk_src << 29) | mclk_div);
 	mcam_ctlr_power_up(cam);
@@ -944,6 +945,7 @@ static void mclk_disable(struct clk_hw *
 
 	mcam_ctlr_power_down(cam);
 	clk_disable(cam->clk[0]);
+	pm_runtime_put(cam->dev);
 }
 
 static unsigned long mclk_recalc_rate(struct clk_hw *hw,


