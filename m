Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4C63FDABD
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245384AbhIAMes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:34:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343500AbhIAMdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:33:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44F75610CA;
        Wed,  1 Sep 2021 12:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499514;
        bh=KBtAVMP+VFpQhLREu6k36qT5cu56hxJkOwhYETtEKyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHPG/sYWwG9yZikXQFdcTnLquph/nou2d9jmFnZQU0Urfbu/IHV0/TPZG0Y7QBaae
         I6njvFRPNYt6d8ikB7iFs1PnXk3Ur335SgoyI1lQGCtQhyLk+0opH4kkLyrE2WrByW
         7exZVVNZ7Jxu4Zu5f91qtqJ5iBOU+I6hxAxYGsnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/48] opp: remove WARN when no valid OPPs remain
Date:   Wed,  1 Sep 2021 14:28:18 +0200
Message-Id: <20210901122254.340170509@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
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
 drivers/opp/of.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 249738e1e0b7..603c688fe23d 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -682,8 +682,9 @@ static int _of_add_opp_table_v2(struct device *dev, struct opp_table *opp_table)
 		}
 	}
 
-	/* There should be one of more OPP defined */
-	if (WARN_ON(!count)) {
+	/* There should be one or more OPPs defined */
+	if (!count) {
+		dev_err(dev, "%s: no supported OPPs", __func__);
 		ret = -ENOENT;
 		goto remove_static_opp;
 	}
-- 
2.30.2



