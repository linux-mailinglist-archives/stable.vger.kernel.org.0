Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700E92594DF
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731302AbgIAPoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:44:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730539AbgIAPoC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:44:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 406A6206EB;
        Tue,  1 Sep 2020 15:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975041;
        bh=JrO0rNYfZZRRiSSWbnJS7Bxk9mHDi4/rY9wiVVge+Hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0v/GySt8gd9kHtOOJM8ZKVdvreG/+LrzEcKs0bpHNwf7XJKeXc9EnUDHlURiK4L60
         gs44Anh1uxeg/Bz9OxPuM7cxYk5jmJRU4oIuvO+p5751DoqUTYF1TSk29HxEfDlJtY
         RX0aatnVkGpam8iyhiGkgbHFhDttqjaGTPWsgQCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sumera Priyadarsini <sylphrenadin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 156/255] net: gianfar: Add of_node_put() before goto statement
Date:   Tue,  1 Sep 2020 17:10:12 +0200
Message-Id: <20200901151008.164431671@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
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
index b513b8c5c3b5e..41dd3d0f34524 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -750,8 +750,10 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
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



