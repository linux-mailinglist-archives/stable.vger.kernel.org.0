Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C3934C5B9
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhC2ICX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231794AbhC2IBw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:01:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E8E861974;
        Mon, 29 Mar 2021 08:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004911;
        bh=796XK1fpdEtnF+BeXuqvdxkJ3JhwrCxFlzAY/6NgDkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kreGkA9UM1siSujQlNwUzmzk+htm+dUVoEh+hQy46MCLOsrLrpz08hNdAY+mEulAE
         j3vp2wdwic49R9IIC8D/00o52zrrUxsPhUnx4O1p8ZgCT0Ywo28Hy5yyk57li9BZib
         nGIexNlJJwe5WHMnwX5pL+LRWZ7J+gIB8eQ3jg3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 12/53] atm: idt77252: fix null-ptr-dereference
Date:   Mon, 29 Mar 2021 09:57:47 +0200
Message-Id: <20210329075607.953308260@linuxfoundation.org>
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

[ Upstream commit 4416e98594dc04590ebc498fc4e530009535c511 ]

this one is similar to the phy_data allocation fix in uPD98402, the
driver allocate the idt77105_priv and store to dev_data but later
dereference using dev->dev_data, which will cause null-ptr-dereference.

fix this issue by changing dev_data to phy_data so that PRIV(dev) can
work correctly.

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/idt77105.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/idt77105.c b/drivers/atm/idt77105.c
index feb023d7eebd..40644670cff2 100644
--- a/drivers/atm/idt77105.c
+++ b/drivers/atm/idt77105.c
@@ -261,7 +261,7 @@ static int idt77105_start(struct atm_dev *dev)
 {
 	unsigned long flags;
 
-	if (!(dev->dev_data = kmalloc(sizeof(struct idt77105_priv),GFP_KERNEL)))
+	if (!(dev->phy_data = kmalloc(sizeof(struct idt77105_priv),GFP_KERNEL)))
 		return -ENOMEM;
 	PRIV(dev)->dev = dev;
 	spin_lock_irqsave(&idt77105_priv_lock, flags);
@@ -338,7 +338,7 @@ static int idt77105_stop(struct atm_dev *dev)
                 else
                     idt77105_all = walk->next;
 	        dev->phy = NULL;
-                dev->dev_data = NULL;
+                dev->phy_data = NULL;
                 kfree(walk);
                 break;
             }
-- 
2.30.1



