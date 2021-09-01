Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE823FDB5F
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344369AbhIAMlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344505AbhIAMjf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:39:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 052F6611C6;
        Wed,  1 Sep 2021 12:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499712;
        bh=ZZcorKwKzcJ2Pe7iZyvuFq8GrwRmhRqlcU1yR0JcaVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wh7YZ642lYiuNiXofVkyHftF38LiifuUvwrvRlqQvxsWytKxMII6kjWLg56Ptpky8
         SgXJr6w4dLyRnLXq11w+0YZHsIsm6HvxL4chtt4QKNF/FF5p+PY4cisvzTrlAhHP6f
         Yz9sXod23x0oNtoUw24Yr2hnXZCo3yDMuQttgja0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/103] opp: remove WARN when no valid OPPs remain
Date:   Wed,  1 Sep 2021 14:28:05 +0200
Message-Id: <20210901122302.424091085@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
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
index 363277b31ecb..d92a1bfe1690 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -870,8 +870,9 @@ static int _of_add_opp_table_v2(struct device *dev, struct opp_table *opp_table)
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



