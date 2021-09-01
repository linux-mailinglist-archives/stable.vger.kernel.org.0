Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A143FDA05
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244478AbhIAM3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:29:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244535AbhIAM3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:29:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9296860ED4;
        Wed,  1 Sep 2021 12:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499298;
        bh=bnBkk0NiyPqH6Vk3oytWYHUV9E1rehpOcbgz00l6VxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e8vJt9A/MA5uBlRbbGN/4LPjXlfhQK8D9DxNvKrzfalLTxdL1yV/q4GECkB6ciNWJ
         yW6UryYLc8YDiyZWncy4EV8iRSkwT/JX0npn2EUwaOxn1qbc1biYjgsbLjjSHw8umn
         F8TJ3nMZCTedimE8ZFlhLwMI+rhBqJzLrvwlEKio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 13/23] opp: remove WARN when no valid OPPs remain
Date:   Wed,  1 Sep 2021 14:26:58 +0200
Message-Id: <20210901122250.214313905@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122249.786673285@linuxfoundation.org>
References: <20210901122249.786673285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

[ Upstream commit 335ffab3ef864539e814b9a2903b0ae420c1c067 ]

This WARN can be triggered per-core and the stack trace is not useful.
Replace it with plain dev_err(). Fix a comment while at it.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/opp/of.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/opp/of.c b/drivers/base/power/opp/of.c
index 87509cb69f79..68ae8e9c1edc 100644
--- a/drivers/base/power/opp/of.c
+++ b/drivers/base/power/opp/of.c
@@ -402,8 +402,9 @@ static int _of_add_opp_table_v2(struct device *dev, struct device_node *opp_np)
 		}
 	}
 
-	/* There should be one of more OPP defined */
-	if (WARN_ON(!count)) {
+	/* There should be one or more OPPs defined */
+	if (!count) {
+		dev_err(dev, "%s: no supported OPPs", __func__);
 		ret = -ENOENT;
 		goto put_opp_table;
 	}
-- 
2.30.2



