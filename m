Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918B845C48F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351965AbhKXNto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:49:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:40066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354044AbhKXNso (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:48:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D79361074;
        Wed, 24 Nov 2021 13:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758931;
        bh=a0Cro++qhmuF6Bm4xZmuXmLi0pMKBpnB/iLX8qruxKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToUm47LWaew6Nwn+wgv6e6hdL/xgt19IAourb5HBaROCkdgW441LkfvdfQ4Mq5H9n
         ucQE80EsapkLjM9TKlW13eOrsEf+q1OodS8zQDsuuylX9P7IgJlWbN3r2TAMGgud5z
         24Mi0+5tfdHEevkkZenz4eevNaQFOtD883yTVmK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik@protonmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Hector Martin <marcan@marcan.st>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/279] iommu/dart: Initialize DART_STREAMS_ENABLE
Date:   Wed, 24 Nov 2021 12:56:04 +0100
Message-Id: <20211124115721.367632505@linuxfoundation.org>
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

From: Sven Peter <sven@svenpeter.dev>

[ Upstream commit 5a009fc1364170b240a4d351b345e69bb3728b3e ]

DART has an additional global register to control which streams are
isolated. This register is a bit redundant since DART_TCR can already
be used to control isolation and is usually initialized to DART_STREAM_ALL
by the time we get control. Some DARTs (namely the one used for the audio
controller) however have some streams disabled initially. Make sure those
work by initializing DART_STREAMS_ENABLE during reset.

Reported-by: Martin Povišer <povik@protonmail.com>
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Reviewed-by: Hector Martin <marcan@marcan.st>
Link: https://lore.kernel.org/r/20211019162253.45919-1-sven@svenpeter.dev
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/apple-dart.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/iommu/apple-dart.c b/drivers/iommu/apple-dart.c
index fdfa39ec2a4d4..ad69eeb5ac5ba 100644
--- a/drivers/iommu/apple-dart.c
+++ b/drivers/iommu/apple-dart.c
@@ -70,6 +70,8 @@
 #define DART_ERROR_ADDR_HI 0x54
 #define DART_ERROR_ADDR_LO 0x50
 
+#define DART_STREAMS_ENABLE 0xfc
+
 #define DART_TCR(sid) (0x100 + 4 * (sid))
 #define DART_TCR_TRANSLATE_ENABLE BIT(7)
 #define DART_TCR_BYPASS0_ENABLE BIT(8)
@@ -301,6 +303,9 @@ static int apple_dart_hw_reset(struct apple_dart *dart)
 	apple_dart_hw_disable_dma(&stream_map);
 	apple_dart_hw_clear_all_ttbrs(&stream_map);
 
+	/* enable all streams globally since TCR is used to control isolation */
+	writel(DART_STREAM_ALL, dart->regs + DART_STREAMS_ENABLE);
+
 	/* clear any pending errors before the interrupt is unmasked */
 	writel(readl(dart->regs + DART_ERROR), dart->regs + DART_ERROR);
 
-- 
2.33.0



