Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985EF38A379
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbhETJwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:52:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233989AbhETJum (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:50:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9372161402;
        Thu, 20 May 2021 09:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503332;
        bh=JEjMomRIq32gl4H5PYOHlwhLrF4zZdk8IYE7TeuQxAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCV9YAvG6CynAlsYSWxHU7RmowbH1NiJZzlsXX/Ew1OzgBJ8arqjRV9kplggOAt3r
         qyH2POkesvTFjAizJlMr30Ud7DrszHZnAqDIUgQSQRqHb4mVgLqI6MowLQ0WDXPRjz
         bjIYdgwdLn2nDV1uhFCXALxBc6zhHDOvNMM62AAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Li <Meng.Li@windriver.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 172/425] regmap: set debugfs_name to NULL after it is freed
Date:   Thu, 20 May 2021 11:19:01 +0200
Message-Id: <20210520092137.096545972@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meng Li <Meng.Li@windriver.com>

[ Upstream commit e41a962f82e7afb5b1ee644f48ad0b3aee656268 ]

There is a upstream commit cffa4b2122f5("regmap:debugfs:
Fix a memory leak when calling regmap_attach_dev") that
adds a if condition when create name for debugfs_name.
With below function invoking logical, debugfs_name is
freed in regmap_debugfs_exit(), but it is not created again
because of the if condition introduced by above commit.
regmap_reinit_cache()
	regmap_debugfs_exit()
	...
	regmap_debugfs_init()
So, set debugfs_name to NULL after it is freed.

Fixes: cffa4b2122f5 ("regmap: debugfs: Fix a memory leak when calling regmap_attach_dev")
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Link: https://lore.kernel.org/r/20210226021737.7690-1-Meng.Li@windriver.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index c9e5381a887b..de706734b921 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -665,6 +665,7 @@ void regmap_debugfs_exit(struct regmap *map)
 		regmap_debugfs_free_dump_cache(map);
 		mutex_unlock(&map->cache_lock);
 		kfree(map->debugfs_name);
+		map->debugfs_name = NULL;
 	} else {
 		struct regmap_debugfs_node *node, *tmp;
 
-- 
2.30.2



