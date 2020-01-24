Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6637B148263
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403979AbgAXL1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:27:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:43204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403974AbgAXL1g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:27:36 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E5EC206D4;
        Fri, 24 Jan 2020 11:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865255;
        bh=PpV52MBBkqaaQBnB7A/QBShT+Hi+PB9fQkUgRK78POo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DsBPui5UwltwxNjnIuAYCjltQM+OdoJSeZanaeAp1kny2eOjvkxv75P7tVZ4aPDIm
         YWRZzih2SCFJGA9C7IzGPJvV5yPSgO6mgBSh+NqsJxUm9/M+uEyOLB9roCow9C7hWS
         wFlvWtxpUg4o1I2YsJfXbgnT83Zk3wGQqbbgizjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 483/639] libertas_tf: Use correct channel range in lbtf_geo_init
Date:   Fri, 24 Jan 2020 10:30:53 +0100
Message-Id: <20200124093149.056376421@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 2ec4ad49b98e4a14147d04f914717135eca7c8b1 ]

It seems we should use 'range' instead of 'priv->range'
in lbtf_geo_init(), because 'range' is the corret one
related to current regioncode.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 691cdb49388b ("libertas_tf: command helper functions for libertas_tf")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas_tf/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/cmd.c b/drivers/net/wireless/marvell/libertas_tf/cmd.c
index 909ac3685010f..2b193f1257a5a 100644
--- a/drivers/net/wireless/marvell/libertas_tf/cmd.c
+++ b/drivers/net/wireless/marvell/libertas_tf/cmd.c
@@ -69,7 +69,7 @@ static void lbtf_geo_init(struct lbtf_private *priv)
 			break;
 		}
 
-	for (ch = priv->range.start; ch < priv->range.end; ch++)
+	for (ch = range->start; ch < range->end; ch++)
 		priv->channels[CHAN_TO_IDX(ch)].flags = 0;
 }
 
-- 
2.20.1



