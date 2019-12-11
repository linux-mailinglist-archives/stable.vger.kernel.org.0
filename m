Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 116EF11B4F7
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732184AbfLKPui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:50:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732235AbfLKPW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:22:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B66C6208C3;
        Wed, 11 Dec 2019 15:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077779;
        bh=0bDLDS4ZuQlvEv4vzWIIcKsFVIJMicqrSVRGeE7dx+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/0tknN2AATn8gN3jsDruihIwjvRiBefGtwYikSRd24VFTnHcsmnjWWYoPKouzMzj
         5QWGwmHSD13CD1qm4oZd6ub+PmoMbV0QhBgSLhmlG2b7NHv9bwA8Ha9RbSb4yyMqTG
         I8i8uylwaS/wqzgT4Za4V/cwlcnzCI1GaFe7qYYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 150/243] soc: renesas: r8a77980-sysc: Correct A3VIP[012] power domain hierarchy
Date:   Wed, 11 Dec 2019 16:05:12 +0100
Message-Id: <20191211150349.298368868@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 160bfa7c724b348a90a12dd9694f351927a15b8e ]

The R-Car Gen3 HardWare Manual Errata for Rev. 0.80 (Feb 28, 2018)
renamed the A3VIP power domain on R-Car V3H to A3VIP0, and clarified the
power domain hierarchy for the A3VIP[012] power domains.

As the definition for the A3VIP0 domain is not yet used from DT, it can
just be renamed.

Fixes: 7755b40d07a8dba7 ("dt-bindings: power: add R8A77980 SYSC power domain definitions")
Fixes: 41d6d8bd8ae94ca9 ("soc: renesas: rcar-sysc: add R8A77980 support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/renesas/r8a77980-sysc.c       | 6 +++---
 include/dt-bindings/power/r8a77980-sysc.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/renesas/r8a77980-sysc.c b/drivers/soc/renesas/r8a77980-sysc.c
index dbb2621ce4e3e..a8dbe55e8ba82 100644
--- a/drivers/soc/renesas/r8a77980-sysc.c
+++ b/drivers/soc/renesas/r8a77980-sysc.c
@@ -41,9 +41,9 @@ static const struct rcar_sysc_area r8a77980_areas[] __initconst = {
 	{ "a2dp0",	0x400, 11, R8A77980_PD_A2DP0,	R8A77980_PD_A3IR },
 	{ "a2dp1",	0x400, 12, R8A77980_PD_A2DP1,	R8A77980_PD_A3IR },
 	{ "a2cn",	0x400, 13, R8A77980_PD_A2CN,	R8A77980_PD_A3IR },
-	{ "a3vip",	0x2c0, 0, R8A77980_PD_A3VIP,	R8A77980_PD_ALWAYS_ON },
-	{ "a3vip1",	0x300, 0, R8A77980_PD_A3VIP1,	R8A77980_PD_A3VIP },
-	{ "a3vip2",	0x280, 0, R8A77980_PD_A3VIP2,	R8A77980_PD_A3VIP },
+	{ "a3vip0",	0x2c0, 0, R8A77980_PD_A3VIP0,	R8A77980_PD_ALWAYS_ON },
+	{ "a3vip1",	0x300, 0, R8A77980_PD_A3VIP1,	R8A77980_PD_ALWAYS_ON },
+	{ "a3vip2",	0x280, 0, R8A77980_PD_A3VIP2,	R8A77980_PD_ALWAYS_ON },
 };
 
 const struct rcar_sysc_info r8a77980_sysc_info __initconst = {
diff --git a/include/dt-bindings/power/r8a77980-sysc.h b/include/dt-bindings/power/r8a77980-sysc.h
index 7bebe7e8dbdbb..e12c8587b87ec 100644
--- a/include/dt-bindings/power/r8a77980-sysc.h
+++ b/include/dt-bindings/power/r8a77980-sysc.h
@@ -22,7 +22,7 @@
 #define R8A77980_PD_CA53_CPU2		7
 #define R8A77980_PD_CA53_CPU3		8
 #define R8A77980_PD_A2CN		10
-#define R8A77980_PD_A3VIP		11
+#define R8A77980_PD_A3VIP0		11
 #define R8A77980_PD_A2IR5		12
 #define R8A77980_PD_CR7			13
 #define R8A77980_PD_A2IR4		15
-- 
2.20.1



