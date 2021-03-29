Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94FF534C5BA
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbhC2IC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231783AbhC2IBt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:01:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83D386196B;
        Mon, 29 Mar 2021 08:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004909;
        bh=0gKLLVIRJWhIHFvivJy0eQKipnuQ6vBS+4w/XlrwzBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWU3Lh1frnmKN24VnXMkazcJ9eaWnOfDJEylE8zdEqlDMq6e8Eut6lMaJ6eKLmJ/W
         1U6BB5KBMV9juZQo3SNyy+F6TsMNstIyFe/kTnk/UGZJVdbWJytu4pTWD2f0RE6FPX
         0gFDgmxrB5E3wAT8BbRkhgGYXv4Uu/Au7squ/1qE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 11/53] atm: uPD98402: fix incorrect allocation
Date:   Mon, 29 Mar 2021 09:57:46 +0200
Message-Id: <20210329075607.923709532@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
References: <20210329075607.561619583@linuxfoundation.org>
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
index 5120a96b3a89..b2f4e8df1591 100644
--- a/drivers/atm/uPD98402.c
+++ b/drivers/atm/uPD98402.c
@@ -210,7 +210,7 @@ static void uPD98402_int(struct atm_dev *dev)
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



