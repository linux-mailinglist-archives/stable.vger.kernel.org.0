Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 100AA13F66B
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388294AbgAPRCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:02:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:54612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388292AbgAPRCM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40D9C20730;
        Thu, 16 Jan 2020 17:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194131;
        bh=4FwwNBMxPQsMF1REKzY3u6wC+rgjFHSdFCTiwJQWwUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKJlT9iQRPPEyx5xPP1S2zzkqUUwk+LsqQUDlNcFKfgUUD0uJfOxYfAFew5HVtSdJ
         VUOdRGTjfihENyOyF5wPdqXh1Vorf8DmR/8cF2L9+qMR0GbtpdAfhIP4GWWeQekvXR
         0pk+vSR0Rrz20Rsnm0H5+k6f0YFntzIglyMZXm0w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Murzin <vladimir.murzin@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 221/671] ARM: 8848/1: virt: Align GIC version check with arm64 counterpart
Date:   Thu, 16 Jan 2020 11:52:10 -0500
Message-Id: <20200116165940.10720-104-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit 9db043d36bd379f4cc99054c079de0dabfc38d03 ]

arm64 has got relaxation on GIC version check at early boot stage due
to update of the GIC architecture let's align ARM with that.

To help backports (even though the code was correct at the time of writing)
Fixes: e59941b9b381 ("ARM: 8527/1: virt: enable GICv3 system registers")
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/hyp-stub.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index 60146e32619a..82a942894fc0 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -180,8 +180,8 @@ ARM_BE8(orr	r7, r7, #(1 << 25))     @ HSCTLR.EE
 	@ Check whether GICv3 system registers are available
 	mrc	p15, 0, r7, c0, c1, 1	@ ID_PFR1
 	ubfx	r7, r7, #28, #4
-	cmp	r7, #1
-	bne	2f
+	teq	r7, #0
+	beq	2f
 
 	@ Enable system register accesses
 	mrc	p15, 4, r7, c12, c9, 5	@ ICC_HSRE
-- 
2.20.1

