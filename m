Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19EB44B621
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343860AbhKIWZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:25:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344246AbhKIWXP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:23:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 899316128B;
        Tue,  9 Nov 2021 22:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496324;
        bh=DYyIzSGTQ8W6spGmBqd+117i5tD1eiwjX3gTuBDc7F4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xi2EKuz1CyHXcQv2NiJKkl47wnJSjHjSxIG3MG/EP2f4VEOw0uG3S2TYHCCX+AS/p
         DTtfZLzVXLshAX0GSYUjHGrDJylkxWOuDLJEGyDnQ7UI7O8dVr0EruE2dbWV+ldQrY
         y82uq8HDjaQJOEQ6tvJXTc8IIL9eAp9Uqk+NZ+7eDNBd7+ioYte3bUFzSDS7bWI0Uo
         8xjrxf6ENeohK0Rgmk1SvJpgIEe2/OF6+hX44MnpUcvctbC60++EeE/i09VEf/us+s
         LCTIlpxflCFlTjDbnzMNtTWzIPjmdGuU5Dotvq4JHQsep88+whga4yvxSVrzWFMjDR
         99Loa5zQTwzcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Nicolas Chauvet <kwizart@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, gnurou@gmail.com,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 71/82] memory: tegra20-emc: Add runtime dependency on devfreq governor module
Date:   Tue,  9 Nov 2021 17:16:29 -0500
Message-Id: <20211109221641.1233217-71-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

