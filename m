Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D0537C41B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbhELP2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:28:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232870AbhELPWW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:22:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5367961966;
        Wed, 12 May 2021 15:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832148;
        bh=ZnaCbQXZlGO59K2ocfYHQFO6X6jHkl4oWlg5s3IID7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8YwAFmuOlchok37RKnI/BBYZbXBTOZ/8DsCWftLZsp/kVqODaKOPa6aoMGuTWiee
         7Xn5lm4FLuWRfdf7mEFC84omB3Ziq3DSwXyFG0SvcKqaDosX3HqMPeMi4R4WqJiuh9
         noXSfY2FrbiKHF0WdBo8usRmh6WSIdoEkBxTjYps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 144/530] usb: typec: tps6598x: Fix return value check in tps6598x_probe()
Date:   Wed, 12 May 2021 16:44:14 +0200
Message-Id: <20210512144824.558445336@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 604c75893a01c8a3b5bd6dac55535963cd44c3f5 ]

In case of error, the function device_get_named_child_node() returns
NULL pointer not ERR_PTR(). The IS_ERR() test in the return value check
should be replaced with NULL test.

Fixes: 18a6c866bb19 ("usb: typec: tps6598x: Add USB role switching logic")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20210308094841.3587751-1-weiyongjun1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tps6598x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/tps6598x.c b/drivers/usb/typec/tps6598x.c
index d8e4594fe009..30bfc314b743 100644
--- a/drivers/usb/typec/tps6598x.c
+++ b/drivers/usb/typec/tps6598x.c
@@ -515,8 +515,8 @@ static int tps6598x_probe(struct i2c_client *client)
 		return ret;
 
 	fwnode = device_get_named_child_node(&client->dev, "connector");
-	if (IS_ERR(fwnode))
-		return PTR_ERR(fwnode);
+	if (!fwnode)
+		return -ENODEV;
 
 	tps->role_sw = fwnode_usb_role_switch_get(fwnode);
 	if (IS_ERR(tps->role_sw)) {
-- 
2.30.2



