Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AFE45C474
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349700AbhKXNtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:49:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351311AbhKXNrl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:47:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8271261A08;
        Wed, 24 Nov 2021 13:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758909;
        bh=DYyIzSGTQ8W6spGmBqd+117i5tD1eiwjX3gTuBDc7F4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSYslFeAdCiqCJiU856O60dUPAttxpN1LeIneNZVnGzFGdR3c44JVWVEc4h3m3QI3
         9FP0bjUdx2Cgd5dkUSOS2SPMAviltqPkMJcMyLh4fz7VaHtqwwwHj4Nc3lKJrLjGIa
         2bbs1inQ7AG3s1/qb0j8EJmQNLgnKGBABrVU1Zu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Chauvet <kwizart@gmail.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/279] memory: tegra20-emc: Add runtime dependency on devfreq governor module
Date:   Wed, 24 Nov 2021 12:55:57 +0100
Message-Id: <20211124115721.121320398@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 14b43c20c283de36131da0cb44f3170b9ffa7630 ]

Tegra20 EMC driver uses simple devfreq governor. Add simple devfreq
governor to the list of the Tegra20 EMC driver module softdeps to allow
userspace initramfs tools like dracut to automatically pull the devfreq
module into ramfs image together with the EMC module.

Reported-by: Nicolas Chauvet <kwizart@gmail.com>
Suggested-by: Nicolas Chauvet <kwizart@gmail.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20211019231524.888-1-digetx@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/tegra/tegra20-emc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/memory/tegra/tegra20-emc.c b/drivers/memory/tegra/tegra20-emc.c
index c3462dbc8c22b..6fc90f2160e93 100644
--- a/drivers/memory/tegra/tegra20-emc.c
+++ b/drivers/memory/tegra/tegra20-emc.c
@@ -1117,4 +1117,5 @@ module_platform_driver(tegra_emc_driver);
 
 MODULE_AUTHOR("Dmitry Osipenko <digetx@gmail.com>");
 MODULE_DESCRIPTION("NVIDIA Tegra20 EMC driver");
+MODULE_SOFTDEP("pre: governor_simpleondemand");
 MODULE_LICENSE("GPL v2");
-- 
2.33.0



