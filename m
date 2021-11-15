Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D414525D4
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345494AbhKPB7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:59:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:49946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240445AbhKOSJq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:09:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA8EF633B8;
        Mon, 15 Nov 2021 17:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998420;
        bh=/RpRwCksZUxbLjNIHbcpeijJBhoNGuPrTDZrhoNMOXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUOl81Gg62USLcoRlU6VUSfLvY8f6iX5tNGd/HimeZM2D+d6yVuyH7AqxqdnJHDYM
         keuZpas98nZjzmbescPBBKlZcqK+gADdmkR4uFQP4CLHXxDcwN4X9xDJu7pMlA6ljZ
         4gvkpxNdOaxPRgSR+mv2GuI0bP7J9LVISFHP0H2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kewei Xu <kewei.xu@mediatek.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Qii Wang <qii.wang@mediatek.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 470/575] i2c: mediatek: fixing the incorrect register offset
Date:   Mon, 15 Nov 2021 18:03:15 +0100
Message-Id: <20211115165359.985188192@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 0af2784cbd0d9..265635db29aa5 100644
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



