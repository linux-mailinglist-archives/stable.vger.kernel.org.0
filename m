Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FBD451EE7
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355416AbhKPAh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344653AbhKOTZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80DE663355;
        Mon, 15 Nov 2021 19:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002902;
        bh=/q7KUzS8hthsAiub6qyUJTKBTxR/B0zL+JHTcbM3P3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F3TC3Bx6E/jDfWqFdgZe7TRmKxQQU5iXEeyCDrGfFpMQf5dOHmYl/ieWT9dURSogf
         NPqmuRnNRAD3Z1/SYU/8Q6IaB/+Nfkuannod0WrYybIR854r+l+bl/o7hPn1DRK2i8
         PzsM90ZiKh4IJ91ruumHL65NejB01rxTlek9tOPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kewei Xu <kewei.xu@mediatek.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Qii Wang <qii.wang@mediatek.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 705/917] i2c: mediatek: fixing the incorrect register offset
Date:   Mon, 15 Nov 2021 18:03:20 +0100
Message-Id: <20211115165452.802012723@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kewei Xu <kewei.xu@mediatek.com>

[ Upstream commit b8228aea5a19d5111a7bf44f7de6749d1f5d487a ]

The reason for the modification here is that the previous
offset information is incorrect, OFFSET_DEBUGSTAT = 0xE4 is
the correct value.

Fixes: 25708278f810 ("i2c: mediatek: Add i2c support for MediaTek MT8183")
Signed-off-by: Kewei Xu <kewei.xu@mediatek.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Qii Wang <qii.wang@mediatek.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mt65xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index 7d4b3eb7077ad..72acda59eb399 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -195,7 +195,7 @@ static const u16 mt_i2c_regs_v2[] = {
 	[OFFSET_CLOCK_DIV] = 0x48,
 	[OFFSET_SOFTRESET] = 0x50,
 	[OFFSET_SCL_MIS_COMP_POINT] = 0x90,
-	[OFFSET_DEBUGSTAT] = 0xe0,
+	[OFFSET_DEBUGSTAT] = 0xe4,
 	[OFFSET_DEBUGCTRL] = 0xe8,
 	[OFFSET_FIFO_STAT] = 0xf4,
 	[OFFSET_FIFO_THRESH] = 0xf8,
-- 
2.33.0



