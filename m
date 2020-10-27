Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B86529B6D4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368718AbgJ0P1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797636AbgJ0PYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:24:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EC7120728;
        Tue, 27 Oct 2020 15:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812282;
        bh=RWI66fzNuLXWJHH8o+kA9gx7YpfLXHZgKJso3sM8pe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2RA8K4PUq7Q2hIywo8LK4ZgGt8goinYFcyGTNKahoV1yoPFwcv5oUCRxNEqpMm4wr
         nyAw7m+p/lLwKj6gW+q0QDkAkIqLnrIhB2iz6YqWvQO5/c7viG/q5sE2LQpmkB6FaX
         Y8AyLHytoygyMzQsF2cXux3lGLNAcyY59UllbOJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 155/757] regmap: debugfs: Fix more error path regressions
Date:   Tue, 27 Oct 2020 14:46:45 +0100
Message-Id: <20201027135457.877208827@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 1d512ee861b80da63cbc501b973c53131aa22f29 ]

Many error paths in __regmap_init rely on ret being pre-initialised to
-EINVAL, add an extra initialisation in after the new call to
regmap_set_name.

Fixes: 94cc89eb8fa5 ("regmap: debugfs: Fix handling of name string for debugfs init delays")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20200918152212.22200-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index b71f9ecddff5d..fff0547c26c53 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -711,6 +711,8 @@ struct regmap *__regmap_init(struct device *dev,
 	if (ret)
 		goto err_map;
 
+	ret = -EINVAL; /* Later error paths rely on this */
+
 	if (config->disable_locking) {
 		map->lock = map->unlock = regmap_lock_unlock_none;
 		regmap_debugfs_disable(map);
-- 
2.25.1



