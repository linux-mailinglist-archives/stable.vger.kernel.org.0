Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AE834C983
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbhC2IaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:30:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234348AbhC2I2L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:28:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3A2061996;
        Mon, 29 Mar 2021 08:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006462;
        bh=Fki+6t2i693xmHEl2L3+HBbS1O+MLL5WTpNnEgLEha8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/JSCnIpRZO6hb/DSr/nlxkPDLPR8gZ6lHpcgaFfh6yDttDD7khY8yN0MpMRt3p5o
         QflGhDw3TloCpb6RgvoBJfHNSlW9dLGoF7HfA3W7pYKZDnwe6hQG/S7RR9rf2gCk3Y
         l+dnHhGXOC0fSjJA01q+uhHJpwHclUv+dSvdCseE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 027/254] atm: uPD98402: fix incorrect allocation
Date:   Mon, 29 Mar 2021 09:55:43 +0200
Message-Id: <20210329075634.036662533@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 3153724fc084d8ef640c611f269ddfb576d1dcb1 ]

dev->dev_data is set in zatm.c, calling zatm_start() will overwrite this
dev->dev_data in uPD98402_start() and a subsequent PRIV(dev)->lock
(i.e dev->phy_data->lock) will result in a null-ptr-dereference.

I believe this is a typo and what it actually want to do is to allocate
phy_data instead of dev_data.

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/uPD98402.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/uPD98402.c b/drivers/atm/uPD98402.c
index 7850758b5bb8..239852d85558 100644
--- a/drivers/atm/uPD98402.c
+++ b/drivers/atm/uPD98402.c
@@ -211,7 +211,7 @@ static void uPD98402_int(struct atm_dev *dev)
 static int uPD98402_start(struct atm_dev *dev)
 {
 	DPRINTK("phy_start\n");
-	if (!(dev->dev_data = kmalloc(sizeof(struct uPD98402_priv),GFP_KERNEL)))
+	if (!(dev->phy_data = kmalloc(sizeof(struct uPD98402_priv),GFP_KERNEL)))
 		return -ENOMEM;
 	spin_lock_init(&PRIV(dev)->lock);
 	memset(&PRIV(dev)->sonet_stats,0,sizeof(struct k_sonet_stats));
-- 
2.30.1



