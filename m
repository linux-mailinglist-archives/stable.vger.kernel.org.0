Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE953283F7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhCAQ2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:28:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:59992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235394AbhCAQXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:23:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00E9A64F2D;
        Mon,  1 Mar 2021 16:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615608;
        bh=XQYK2PmfdpJKmGxOOLLvgLtSLiAUaZVaQm7CpIAWRXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWEE+XOPT9mPTEIHiaeNg3IC63qBQ1eOAMMpPtX8DDajUHw0ezKZQ69lbiPAS9S6N
         8LvlBFmr6v1/RvOis5eI6n1rAeM3Kw7NQNGZepg4rPKi8wF6bnGHO/wdT2HulUjfc4
         hFCcRT5yp1/35G5l9BY4xHs1o8hY0N8IjDvjTUfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 60/93] i2c: brcmstb: Fix brcmstd_send_i2c_cmd condition
Date:   Mon,  1 Mar 2021 17:13:12 +0100
Message-Id: <20210301161009.837817817@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
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
index 81115abf3c1f5..6e9007adad849 100644
--- a/drivers/i2c/busses/i2c-brcmstb.c
+++ b/drivers/i2c/busses/i2c-brcmstb.c
@@ -304,7 +304,7 @@ static int brcmstb_send_i2c_cmd(struct brcmstb_i2c_dev *dev,
 		goto cmd_out;
 	}
 
-	if ((CMD_RD || CMD_WR) &&
+	if ((cmd == CMD_RD || cmd == CMD_WR) &&
 	    bsc_readl(dev, iic_enable) & BSC_IIC_EN_NOACK_MASK) {
 		rc = -EREMOTEIO;
 		dev_dbg(dev->device, "controller received NOACK intr for %s\n",
-- 
2.27.0



