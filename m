Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A033328FFD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237951AbhCAUAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:00:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241823AbhCATrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:47:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7D3764FA1;
        Mon,  1 Mar 2021 17:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619473;
        bh=CYijl/QOwgK9+/hTXIC3+0/4oA2jUChSIdl3Z+/1XhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDvHto4/DU6ryp+j6d/2YVgfuk+BrxkUkASVFqmZyHg6TvEf824GmVsdrDb2z/4lg
         elJpbCW/6PQSnhrNi+LN6lGMgGJCgc0t4w9HPUpT4aiw3J+ZENrIoe0jaiQL8/NhCT
         wZ6TjLAUScusxOuVUZr7XR/cKvtNGnSxzZSEGpSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 467/663] i2c: brcmstb: Fix brcmstd_send_i2c_cmd condition
Date:   Mon,  1 Mar 2021 17:11:55 +0100
Message-Id: <20210301161204.966399954@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit a1858ce0cfe31368b23ba55794e409fb57ced4a4 ]

The brcmstb_send_i2c_cmd currently has a condition that is (CMD_RD ||
CMD_WR) which always evaluates to true, while the obvious fix is to test
whether the cmd variable passed as parameter holds one of these two
values.

Fixes: dd1aa2524bc5 ("i2c: brcmstb: Add Broadcom settop SoC i2c controller driver")
Reported-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-brcmstb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-brcmstb.c b/drivers/i2c/busses/i2c-brcmstb.c
index d4e0a0f6732ae..ba766d24219ef 100644
--- a/drivers/i2c/busses/i2c-brcmstb.c
+++ b/drivers/i2c/busses/i2c-brcmstb.c
@@ -316,7 +316,7 @@ static int brcmstb_send_i2c_cmd(struct brcmstb_i2c_dev *dev,
 		goto cmd_out;
 	}
 
-	if ((CMD_RD || CMD_WR) &&
+	if ((cmd == CMD_RD || cmd == CMD_WR) &&
 	    bsc_readl(dev, iic_enable) & BSC_IIC_EN_NOACK_MASK) {
 		rc = -EREMOTEIO;
 		dev_dbg(dev->device, "controller received NOACK intr for %s\n",
-- 
2.27.0



