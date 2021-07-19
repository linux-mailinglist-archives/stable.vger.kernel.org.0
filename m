Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D293CE2A9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348588AbhGSPbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:31:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347853AbhGSPWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:22:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A9466113C;
        Mon, 19 Jul 2021 15:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710373;
        bh=64RdvcXyX7BUZUOJA4et+AYBUcmDtFbYt/ytQXdenZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZP0yPLKpLbNJuxjIrAWY+JisGeYwjUryXnGzasMzC1xUsj9UGDeF9MnokUIr7cYJ
         WXcdiwSVxeplLii/ShN/sTz1PZubrylBenPHcj2DUALMxv47Gs+60oEHglHB8f+XzU
         igTR5rYuP6SBjluumP3oH83BN6lrmnLjvWq2ppnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 190/243] ARM: exynos: add missing of_node_put for loop iteration
Date:   Mon, 19 Jul 2021 16:53:39 +0200
Message-Id: <20210719144947.051920274@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit 48d551bf20858240f38a0276be3016ff379918ac ]

Early exits from for_each_compatible_node() should decrement the
node reference counter.  Reported by Coccinelle:

  arch/arm/mach-exynos/exynos.c:52:1-25: WARNING:
    Function "for_each_compatible_node" should have of_node_put() before break around line 58.

Fixes: b3205dea8fbf ("ARM: EXYNOS: Map SYSRAM through generic DT bindings")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20210425174945.164612-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-exynos/exynos.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 700763e07083..83d1d1327f96 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -55,6 +55,7 @@ void __init exynos_sysram_init(void)
 		sysram_base_addr = of_iomap(node, 0);
 		sysram_base_phys = of_translate_address(node,
 					   of_get_address(node, 0, NULL, NULL));
+		of_node_put(node);
 		break;
 	}
 
@@ -62,6 +63,7 @@ void __init exynos_sysram_init(void)
 		if (!of_device_is_available(node))
 			continue;
 		sysram_ns_base_addr = of_iomap(node, 0);
+		of_node_put(node);
 		break;
 	}
 }
-- 
2.30.2



