Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A311127C7CD
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730573AbgI2L4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:56:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730806AbgI2Lnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:43:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25A5220702;
        Tue, 29 Sep 2020 11:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379823;
        bh=8MljDeggPdi9vFj6AXRrmOaExwKwArRNdb/1KDKnZxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9YjJ/70xZHi6Bh/1X+r9pRdknq48LsghN4dF+bK75/2dlm+BYB33gE+5iFhZo6I9
         DbBTXhOXYCUMl2xqeC3Tmlwr3R/xUgOoB0y1ek9pHMES8baYiEry52SgowSJal8ZKG
         3hVvpPnFJ8EWa0w9/NoAsphKq6s+yN5eqi/ytAeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Walter Lozano <walter.lozano@collabora.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 316/388] opp: Increase parsed_static_opps in _of_add_opp_table_v1()
Date:   Tue, 29 Sep 2020 13:00:47 +0200
Message-Id: <20200929110025.765499256@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Walter Lozano <walter.lozano@collabora.com>

[ Upstream commit 6544abc520f0fff701e9da382110dc29676c683a ]

Currently, when using _of_add_opp_table_v2 parsed_static_opps is
increased and this value is used in _opp_remove_all_static() to
check if there are static opp entries that need to be freed.
Unfortunately this does not happen when using _of_add_opp_table_v1(),
which leads to warnings.

This patch increases parsed_static_opps in _of_add_opp_table_v1() in a
similar way as in _of_add_opp_table_v2().

Fixes: 03758d60265c ("opp: Replace list_kref with a local counter")
Cc: v5.6+ <stable@vger.kernel.org> # v5.6+
Signed-off-by: Walter Lozano <walter.lozano@collabora.com>
[ Viresh: Do the operation with lock held and set the value to 1 instead
	  of incrementing it ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 9cd8f0adacae4..249738e1e0b7a 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -733,6 +733,10 @@ static int _of_add_opp_table_v1(struct device *dev, struct opp_table *opp_table)
 		return -EINVAL;
 	}
 
+	mutex_lock(&opp_table->lock);
+	opp_table->parsed_static_opps = 1;
+	mutex_unlock(&opp_table->lock);
+
 	val = prop->value;
 	while (nr) {
 		unsigned long freq = be32_to_cpup(val++) * 1000;
-- 
2.25.1



