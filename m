Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49E82EC05
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbfE3DRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:17:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731202AbfE3DRk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:40 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB522245D7;
        Thu, 30 May 2019 03:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186259;
        bh=Cu5HcXtfpOXX1SPNQ97FVBeMtj3UnXi78tznb/syzG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x3ssG0s0vYuqxnXuioLrCEDRPD/O5ojj3O6qrw6ULWkXHdIOGH26anOWI/lnAoGRR
         fgp+JXPmc2Rmpcw/DGsmYHRq/2ibRU2DvcfXdpWCv3MWnkNJl1FJdL8U7Slk9lYTUq
         GfjaVgxpBslwFbAfJox52qnx0a6XzGXtwq39KSik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 192/276] mwifiex: Fix mem leak in mwifiex_tm_cmd
Date:   Wed, 29 May 2019 20:05:50 -0700
Message-Id: <20190530030537.167162805@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 003b686ace820ce2d635a83f10f2d7f9c147dabc ]

'hostcmd' is alloced by kzalloc, should be freed before
leaving from the error handling cases, otherwise it will
cause mem leak.

Fixes: 3935ccc14d2c ("mwifiex: add cfg80211 testmode support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 2d87ebbfa4dab..47ec5293c045d 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4045,16 +4045,20 @@ static int mwifiex_tm_cmd(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 		if (mwifiex_send_cmd(priv, 0, 0, 0, hostcmd, true)) {
 			dev_err(priv->adapter->dev, "Failed to process hostcmd\n");
+			kfree(hostcmd);
 			return -EFAULT;
 		}
 
 		/* process hostcmd response*/
 		skb = cfg80211_testmode_alloc_reply_skb(wiphy, hostcmd->len);
-		if (!skb)
+		if (!skb) {
+			kfree(hostcmd);
 			return -ENOMEM;
+		}
 		err = nla_put(skb, MWIFIEX_TM_ATTR_DATA,
 			      hostcmd->len, hostcmd->cmd);
 		if (err) {
+			kfree(hostcmd);
 			kfree_skb(skb);
 			return -EMSGSIZE;
 		}
-- 
2.20.1



