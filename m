Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F6228C03C
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 21:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731027AbgJLTCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 15:02:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730977AbgJLTCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 15:02:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23D952067C;
        Mon, 12 Oct 2020 19:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529370;
        bh=7h9TvESMrhhKu6jYFRB16daB7q5SKQLUEEx2WKhSA1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yNqkhBXAmyQM1AUuaaFDiRne3tulIyZCd+BFv/WXBQDz5A+EiX9PfhFM51w9QoNDn
         YF2WWMFbq7rQfiKmC0K8xwn9jlSJjxSggIFTukIm612dndbwoYUy1Q5P1go8yx95Ox
         4n0MEt0os2YqywNSJBKGR+QoSPhxHp/aVkiiQQHM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 08/24] net: mscc: ocelot: fix fields offset in SG_CONFIG_REG_3
Date:   Mon, 12 Oct 2020 15:02:23 -0400
Message-Id: <20201012190239.3279198-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190239.3279198-1-sashal@kernel.org>
References: <20201012190239.3279198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

[ Upstream commit 4ab810a4e04ab6c851007033d39c13e6d3f55110 ]

INIT_IPS and GATE_ENABLE fields have a wrong offset in SG_CONFIG_REG_3.
This register is used by stream gate control of PSFP, and it has not
been used before, because PSFP is not implemented in ocelot driver.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/soc/mscc/ocelot_ana.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/soc/mscc/ocelot_ana.h b/include/soc/mscc/ocelot_ana.h
index 841c6ec22b641..1669481d97794 100644
--- a/include/soc/mscc/ocelot_ana.h
+++ b/include/soc/mscc/ocelot_ana.h
@@ -252,10 +252,10 @@
 #define ANA_SG_CONFIG_REG_3_LIST_LENGTH_M                 GENMASK(18, 16)
 #define ANA_SG_CONFIG_REG_3_LIST_LENGTH_X(x)              (((x) & GENMASK(18, 16)) >> 16)
 #define ANA_SG_CONFIG_REG_3_GATE_ENABLE                   BIT(20)
-#define ANA_SG_CONFIG_REG_3_INIT_IPS(x)                   (((x) << 24) & GENMASK(27, 24))
-#define ANA_SG_CONFIG_REG_3_INIT_IPS_M                    GENMASK(27, 24)
-#define ANA_SG_CONFIG_REG_3_INIT_IPS_X(x)                 (((x) & GENMASK(27, 24)) >> 24)
-#define ANA_SG_CONFIG_REG_3_INIT_GATE_STATE               BIT(28)
+#define ANA_SG_CONFIG_REG_3_INIT_IPS(x)                   (((x) << 21) & GENMASK(24, 21))
+#define ANA_SG_CONFIG_REG_3_INIT_IPS_M                    GENMASK(24, 21)
+#define ANA_SG_CONFIG_REG_3_INIT_IPS_X(x)                 (((x) & GENMASK(24, 21)) >> 21)
+#define ANA_SG_CONFIG_REG_3_INIT_GATE_STATE               BIT(25)
 
 #define ANA_SG_GCL_GS_CONFIG_RSZ                          0x4
 
-- 
2.25.1

