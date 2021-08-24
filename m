Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC32A3F54FF
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbhHXA63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234791AbhHXA4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:56:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CA55613E6;
        Tue, 24 Aug 2021 00:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766530;
        bh=bnBkk0NiyPqH6Vk3oytWYHUV9E1rehpOcbgz00l6VxE=;
        h=From:To:Cc:Subject:Date:From;
        b=F76kt5mQSnzqPxy+6xGNORU3ABh3/Dig7jcCtZHqHPJMzm8wl4LZpAnuRQmHAoGIB
         OS6P0vatfDBtkReIEXgM8ZOnLIZMRCPy4mGkVI+uqysql07zEEDJ29Q0SMs/Q/p3WS
         k0817TMeKXPAy3HdLXdsumqd2RjM/AlMKhkX5QClNcr7K8VCL/QVGDaBv3GeYjVc9x
         2C++v4ZJ5yD+/dN9LllIFWk2DEtaMCWihyznnkLgmqDNZyw+4CjVesfaiFlgfjytNa
         hS/+vXxBH7ekJ82luL8zcEYDxJPGp+INq3oA3qRVxEVHRq7Mx4rArUbSj2+IzwZYUP
         hvzN+94jOG3JA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 1/7] opp: remove WARN when no valid OPPs remain
Date:   Mon, 23 Aug 2021 20:55:22 -0400
Message-Id: <20210824005528.631702-1-sashal@kernel.org>
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

