Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B961E3C53EC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348192AbhGLH4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350801AbhGLHvT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3602C61166;
        Mon, 12 Jul 2021 07:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076111;
        bh=IFP+P4UwomRUUw+waaadzncjbbSrdQyaIPd+jdo/zsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZLFcvaJS8HLQKei1522qGAw/hlVFFJnqfiCJiJfio2CVXVJ4Hy39kvPFX9Y4KoJY1
         wujRqJ9vWN3c6XG0moGGOOWcxm9bG0ZxfqJ263NLOcMDJ4bkDXhDliFSPIV+l8/egb
         gg27LuD//aP4/xisFYuUZ0cqHwOoh4GmKmyZymi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 502/800] mt76: testmode: remove undefined behaviour in mt76_testmode_alloc_skb
Date:   Mon, 12 Jul 2021 08:08:45 +0200
Message-Id: <20210712061020.594807158@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 223cea6d3c974acd393bfac2d168b2945a6cf1e5 ]

Get rid of an undefined behaviour in mt76_testmode_alloc_skb routine
allocating skb frames

Fixes: 2601dda8faa76 ("mt76: testmode: add support to send larger packet")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/testmode.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/testmode.c b/drivers/net/wireless/mediatek/mt76/testmode.c
index f40387a866ee..f614c887f323 100644
--- a/drivers/net/wireless/mediatek/mt76/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/testmode.c
@@ -168,12 +168,8 @@ int mt76_testmode_alloc_skb(struct mt76_phy *phy, u32 len)
 		head->len += frag->len;
 		head->data_len += frag->len;
 
-		if (*frag_tail) {
-			(*frag_tail)->next = frag;
-			frag_tail = &frag;
-		} else {
-			*frag_tail = frag;
-		}
+		*frag_tail = frag;
+		frag_tail = &(*frag_tail)->next;
 	}
 
 	mt76_testmode_free_skb(phy);
-- 
2.30.2



