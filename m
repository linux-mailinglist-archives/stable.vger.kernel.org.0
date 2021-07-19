Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587173CE61E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350068AbhGSQCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 12:02:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348808AbhGSPty (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:49:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9BE261922;
        Mon, 19 Jul 2021 16:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712132;
        bh=2+MsUU1qD01QYJ+C4Q7O0OtPPhzn6gJUJ/d30FmS3DU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qtrv08H56Ya3X+kSMLXOYZ+l9fH9dhmV0eE32U4yy3tutU5O3FozfkJ+VC6S++MAa
         oegaKcaaN8FMtouNrlMwpTmPXpbsXBh5sj/bBdixVm2Yis35FYJyvyf5pPrX/642zF
         F9Mt/OupoYtimO/DqtHCD8YWo7MLEAw4H5ZW6cvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 229/292] ARM: exynos: add missing of_node_put for loop iteration
Date:   Mon, 19 Jul 2021 16:54:51 +0200
Message-Id: <20210719144950.495132760@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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
index 25b01da4771b..8b48326be9fd 100644
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



