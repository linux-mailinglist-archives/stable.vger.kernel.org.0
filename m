Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329A0329176
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243159AbhCAU0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:26:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242841AbhCAUUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:20:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E23F2653E8;
        Mon,  1 Mar 2021 18:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621855;
        bh=oKSzDqF61nr6aUtGB+t5hAaQn1ggM1TLcNzR1smF+iI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7csNPxUJAMWT8g+eAJ6BRxunl/2zFxRQvHJLvaj4FAz+giZ2welY3wT7+BsBmq9m
         WecC55DBSAvedxhhF7FqBcGIUm/GLA5pQPa5/DJHO3opb15eNtd6DxFh2npCK4cOns
         u1X88QUXQEWmSy4bkDWxgejBtkMMP/dQV2/qpdYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.11 669/775] media: marvell-ccic: power up the device on mclk enable
Date:   Mon,  1 Mar 2021 17:13:57 +0100
Message-Id: <20210301161234.443688593@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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


