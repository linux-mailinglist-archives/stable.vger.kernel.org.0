Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FF9246B53
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387882AbgHQPwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387873AbgHQPws (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:52:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 222E620657;
        Mon, 17 Aug 2020 15:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679567;
        bh=ZKVk/wxZoh+1ON43O4MrsASnLMbbya2SkuJcqE5JLhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqntu5NhahF7z7oZhD2qzxBOQ7kaAEB9tRPjeaTGg5GarIkW5XRDlgaeexhi2HaUN
         nsnL9Ro04gFKauNF5tPVKoy8PaZ+dc0QwivXYBQBXhPBKB2OkbVa74FxeakENpY4vd
         oOQapaWFBqUBXDjr2p/8kuLyo8PFZbO5tntjOu2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Leach <mike.leach@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 228/393] coresight: etmv4: Fix resource selector constant
Date:   Mon, 17 Aug 2020 17:14:38 +0200
Message-Id: <20200817143830.684637147@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Leach <mike.leach@linaro.org>

[ Upstream commit cb8bba907a4ff4ba42f1d245cb506d55829674b8 ]

ETMv4 max resource selector constant incorrectly set to 16. Updated to the
correct 32 value, and adjustments made to limited code using it.

Signed-off-by: Mike Leach <mike.leach@linaro.org>
Fixes: 2e1cdfe184b52 ("coresight-etm4x: Adding CoreSight ETM4x driver")
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200716175746.3338735-10-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index 4a695bf90582e..b0d633daf7162 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -133,7 +133,7 @@
 #define ETMv4_MAX_CTXID_CMP		8
 #define ETM_MAX_VMID_CMP		8
 #define ETM_MAX_PE_CMP			8
-#define ETM_MAX_RES_SEL			16
+#define ETM_MAX_RES_SEL			32
 #define ETM_MAX_SS_CMP			8
 
 #define ETM_ARCH_V4			0x40
@@ -325,7 +325,7 @@ struct etmv4_save_state {
 	u32	trccntctlr[ETMv4_MAX_CNTR];
 	u32	trccntvr[ETMv4_MAX_CNTR];
 
-	u32	trcrsctlr[ETM_MAX_RES_SEL * 2];
+	u32	trcrsctlr[ETM_MAX_RES_SEL];
 
 	u32	trcssccr[ETM_MAX_SS_CMP];
 	u32	trcsscsr[ETM_MAX_SS_CMP];
-- 
2.25.1



