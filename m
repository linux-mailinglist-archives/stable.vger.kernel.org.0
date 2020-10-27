Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50CF129B769
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799645AbgJ0Pci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:32:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799642AbgJ0Pch (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:32:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 714B0206D4;
        Tue, 27 Oct 2020 15:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812757;
        bh=lTq8YAs4kJeoFK15O1PjAS4gVGCahk8Trq4elTmRkIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJqtpmeUdvz5LK1YeFE5xBA/V0P+S/D5sSrBW/MM0myQGowSqh6wJySk3XXNlMkn+
         398sNFkEKMst195lY6WWzvNPyS7YqRcisRxWM3zDcIcR4hU/FvBOHgmbt7VOYZeVxM
         VAT5TkDxdBmodZI87MpXepw+2V2Vn8RhugNr4aJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 320/757] mt76: fix a possible NULL pointer dereference in mt76_testmode_dump
Date:   Tue, 27 Oct 2020 14:49:30 +0100
Message-Id: <20201027135505.542793187@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit ce8463a726a5669b200a1c2c17f95bc1394cc6bf ]

Fix a possible NULL pointer dereference in mt76_testmode_dump() since
nla_nest_start returns NULL in case of error

Fixes: f0efa8621550e ("mt76: add API for testmode support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/testmode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/testmode.c b/drivers/net/wireless/mediatek/mt76/testmode.c
index 75bb02cdfdae4..5bd6ac1ba3b5b 100644
--- a/drivers/net/wireless/mediatek/mt76/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/testmode.c
@@ -442,9 +442,13 @@ int mt76_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *msg,
 	mutex_lock(&dev->mutex);
 
 	if (tb[MT76_TM_ATTR_STATS]) {
+		err = -EINVAL;
+
 		a = nla_nest_start(msg, MT76_TM_ATTR_STATS);
-		err = mt76_testmode_dump_stats(dev, msg);
-		nla_nest_end(msg, a);
+		if (a) {
+			err = mt76_testmode_dump_stats(dev, msg);
+			nla_nest_end(msg, a);
+		}
 
 		goto out;
 	}
-- 
2.25.1



