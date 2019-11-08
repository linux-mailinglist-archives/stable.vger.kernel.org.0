Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C79F5510
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389563AbfKHTAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:00:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:57254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389528AbfKHTAM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:00:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5914F20865;
        Fri,  8 Nov 2019 18:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239437;
        bh=NhFgaETRNIdu3H6KVQg/gsjF9aOflfa/TtuGfDhAfsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BINZZl72TS5AT2wtw9Qae0KuYtlu0supKa4csgYFNTEM1VMqyZpbI1O7laTqBz4dF
         J0pNyp8VMcooCp/7C8/YtHgclGEj3xAsRHmO2RcHYkvF4JddTq1ano0m8ItZVQGBi1
         UhLk+Z9/zXI59JGAq5dNwh5Y7CjFo+Ah4rPHRbgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 13/34] ARM: davinci: dm365: Fix McBSP dma_slave_map entry
Date:   Fri,  8 Nov 2019 19:50:20 +0100
Message-Id: <20191108174633.284473354@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174618.266472504@linuxfoundation.org>
References: <20191108174618.266472504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit 564b6bb9d42d31fc80c006658cf38940a9b99616 ]

dm365 have only single McBSP, so the device name is without .0

Fixes: 0c750e1fe481d ("ARM: davinci: dm365: Add dma_slave_map to edma")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-davinci/dm365.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index ef3add9992631..8db549c56914d 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -864,8 +864,8 @@ static s8 dm365_queue_priority_mapping[][2] = {
 };
 
 static const struct dma_slave_map dm365_edma_map[] = {
-	{ "davinci-mcbsp.0", "tx", EDMA_FILTER_PARAM(0, 2) },
-	{ "davinci-mcbsp.0", "rx", EDMA_FILTER_PARAM(0, 3) },
+	{ "davinci-mcbsp", "tx", EDMA_FILTER_PARAM(0, 2) },
+	{ "davinci-mcbsp", "rx", EDMA_FILTER_PARAM(0, 3) },
 	{ "davinci_voicecodec", "tx", EDMA_FILTER_PARAM(0, 2) },
 	{ "davinci_voicecodec", "rx", EDMA_FILTER_PARAM(0, 3) },
 	{ "spi_davinci.2", "tx", EDMA_FILTER_PARAM(0, 10) },
-- 
2.20.1



