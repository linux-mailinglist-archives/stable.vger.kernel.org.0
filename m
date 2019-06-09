Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6563AA00
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732853AbfFIRPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732471AbfFIQzt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:55:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2BEC206C3;
        Sun,  9 Jun 2019 16:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099349;
        bh=8rpexdRlXS07AU/V7aHnfaonXuhHuHbIxQ3tY/kmtvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gk9sDODq/pN9cLnWBKE+0UQv6a2E5ngI44fuY7IUBuMURsnHXh+ofIlbbAoe6ExkS
         +TTCfIhoQzZre6erWMFKTsd4p0iHPyie/45tkE/Jm5zvwo08lQp/RNYISysc672dsb
         5kiA43OHAYLsdLxJ/hwTe2s/NiamR6VTJVnOjtzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 4.4 003/241] ARM: exynos: Fix a leaked reference by adding missing of_node_put
Date:   Sun,  9 Jun 2019 18:39:05 +0200
Message-Id: <20190609164147.884451775@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

commit 629266bf7229cd6a550075f5961f95607b823b59 upstream.

The call to of_get_next_child returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with warnings like:
    arch/arm/mach-exynos/firmware.c:201:2-8: ERROR: missing of_node_put;
        acquired a node pointer with refcount incremented on line 193,
        but without a corresponding object release within this function.

Cc: stable@vger.kernel.org
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-exynos/firmware.c |    1 +
 arch/arm/mach-exynos/suspend.c  |    2 ++
 2 files changed, 3 insertions(+)

--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -207,6 +207,7 @@ void __init exynos_firmware_init(void)
 		return;
 
 	addr = of_get_address(nd, 0, NULL, NULL);
+	of_node_put(nd);
 	if (!addr) {
 		pr_err("%s: No address specified.\n", __func__);
 		return;
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -725,8 +725,10 @@ void __init exynos_pm_init(void)
 
 	if (WARN_ON(!of_find_property(np, "interrupt-controller", NULL))) {
 		pr_warn("Outdated DT detected, suspend/resume will NOT work\n");
+		of_node_put(np);
 		return;
 	}
+	of_node_put(np);
 
 	pm_data = (const struct exynos_pm_data *) match->data;
 


