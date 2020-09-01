Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FEC2597F0
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgIAQUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731126AbgIAPcj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:32:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEC63205F4;
        Tue,  1 Sep 2020 15:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974359;
        bh=Io4p9WMxBPOmvvvDV5Rh1K3tXuBa/vm5am+uOFzQy5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gp0/TRottRSBcdkoqmTqKzaImY/UT7tE/Qm0Efj4zcZOkJqiU0M14eornOMu3nP9P
         v/SNcYxpHz3+Q48qrUwJH3VclyfVNgX7QmUigm5jISavknt5HjOaFAAaSw9JXmMqDY
         hGOLxOiJ7yPQTMlo/3dGbTrMOHnFzQPSDG8XWyfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sumera Priyadarsini <sylphrenadin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 145/214] net: gianfar: Add of_node_put() before goto statement
Date:   Tue,  1 Sep 2020 17:10:25 +0200
Message-Id: <20200901150959.924956957@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumera Priyadarsini <sylphrenadin@gmail.com>

[ Upstream commit 989e4da042ca4a56bbaca9223d1a93639ad11e17 ]

Every iteration of for_each_available_child_of_node() decrements
reference count of the previous node, however when control
is transferred from the middle of the loop, as in the case of
a return or break or goto, there is no decrement thus ultimately
resulting in a memory leak.

Fix a potential memory leak in gianfar.c by inserting of_node_put()
before the goto statement.

Issue found with Coccinelle.

Signed-off-by: Sumera Priyadarsini <sylphrenadin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/gianfar.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 2580bcd850253..3978d82c95989 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -751,8 +751,10 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 				continue;
 
 			err = gfar_parse_group(child, priv, model);
-			if (err)
+			if (err) {
+				of_node_put(child);
 				goto err_grp_init;
+			}
 		}
 	} else { /* SQ_SG_MODE */
 		err = gfar_parse_group(np, priv, model);
-- 
2.25.1



