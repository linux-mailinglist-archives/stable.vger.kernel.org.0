Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D526C677
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389884AbfGRDRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:17:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391883AbfGRDOt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:14:49 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89C5821851;
        Thu, 18 Jul 2019 03:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419688;
        bh=EqMCJwsmvfEOJAE3+0D3yjjIjbFPTvzfK92bOfuADhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DuwqHRYAPpCa2k6NqSoOdO6VaKVXIkFLi24UPbtjNcy5RW0dO6sqJ2WNsn5gCzC73
         N3ZZL/WXvi2DvaI8qIeF274y97pSPuPFna733K7X+9BPO+V0pFyWSYdkBLKHBXRLqn
         PNDkElOiKB40/zSE+yipV2n3KAL+1Cz+z/LoJgi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sekhar Nori <nsekhar@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 08/40] ARM: davinci: da850-evm: call regulator_has_full_constraints()
Date:   Thu, 18 Jul 2019 12:02:04 +0900
Message-Id: <20190718030041.283149287@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030039.676518610@linuxfoundation.org>
References: <20190718030039.676518610@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0c0c9b5753cd04601b17de09da1ed2885a3b42fe ]

The BB expander at 0x21 i2c bus 1 fails to probe on da850-evm because
the board doesn't set has_full_constraints to true in the regulator
API.

Call regulator_has_full_constraints() at the end of board registration
just like we do in da850-lcdk and da830-evm.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-davinci/board-da850-evm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 1ed545cc2b83..99356e23776d 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1479,6 +1479,8 @@ static __init void da850_evm_init(void)
 	if (ret)
 		pr_warn("%s: dsp/rproc registration failed: %d\n",
 			__func__, ret);
+
+	regulator_has_full_constraints();
 }
 
 #ifdef CONFIG_SERIAL_8250_CONSOLE
-- 
2.20.1



