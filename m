Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4DF34C97E
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbhC2IaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234343AbhC2I2L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:28:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF5FA619AA;
        Mon, 29 Mar 2021 08:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006453;
        bh=yxX0FLuRXUvKfkI80AY4jUSGujZRQSN6ROA9siunq10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkhxIsVhmxjhfCv8gqJqx6/2S+oMdaqCiAFz5IaV1cyVKBCDMVjpXuIRQBdB92x/H
         bXPyn1piWorz0D+BlbyLRpmUPwjV/GbjTleVs+nynahGSZRIneiOaM2fYAO1QoUqIN
         BErT81jEWQZglSbNN9Y1vGD1zfDEjFNjc3Ay9Y8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 025/254] net: davicom: Use platform_get_irq_optional()
Date:   Mon, 29 Mar 2021 09:55:41 +0200
Message-Id: <20210329075633.966972561@linuxfoundation.org>
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

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 2e2696223676d56db1a93acfca722c1b96cd552d ]

The second IRQ line really is optional, so use
platform_get_irq_optional() to obtain it.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/davicom/dm9000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index a95e95ce9438..252adfa5d837 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1507,7 +1507,7 @@ dm9000_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	db->irq_wake = platform_get_irq(pdev, 1);
+	db->irq_wake = platform_get_irq_optional(pdev, 1);
 	if (db->irq_wake >= 0) {
 		dev_dbg(db->dev, "wakeup irq %d\n", db->irq_wake);
 
-- 
2.30.1



