Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE79A3F54EE
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbhHXA5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234264AbhHXA4N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:56:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F12561507;
        Tue, 24 Aug 2021 00:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766515;
        bh=oZLfST+fZeckfbcHYORaBw8qhlYlN8ehRkZ4EU2b5KU=;
        h=From:To:Cc:Subject:Date:From;
        b=iqmvV2HSdShB3t6kygaU014jTyvDZ9FFa+3EVVgxN8zmK6Z+z4YaSMjlwGi20p6Hy
         JwX/jlAZhDdqnLk37uf7E0EoWSRbkOov2oj8D/KIBu9uc0Lpqwz7fp36oAX18/s7S0
         /2CyMrO8AdC63tugYta06wLenfHqx1PO+uZ7MH0yPCo4jYQYgddxcHJMCj//OP3e+R
         m88R28hRNOmSixflJ/tVYAb6PTOR2qJXOSiHomP6T2McxUMD3zlctuCIzuTcJ9Zoi9
         6Ej93U/3tchfBWWddWD6ta+bM/G8Ib9D8HIFlHud65YOgSG8aHhQuidNMHQKtWDgsl
         /fiWvkPMJ3LUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/10] opp: remove WARN when no valid OPPs remain
Date:   Mon, 23 Aug 2021 20:55:03 -0400
Message-Id: <20210824005513.631557-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index d64a13d7881b..a53123356697 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -423,8 +423,9 @@ static int _of_add_opp_table_v2(struct device *dev, struct device_node *opp_np)
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

