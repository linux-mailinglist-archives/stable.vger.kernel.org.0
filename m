Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDCB540B4D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350636AbiFGS1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352476AbiFGSVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:21:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196CD3466C;
        Tue,  7 Jun 2022 10:53:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D34E06137B;
        Tue,  7 Jun 2022 17:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFF3C385A5;
        Tue,  7 Jun 2022 17:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624433;
        bh=0/OPehuoJpxf3SgM/ilGfsr7BWC3yKaBiuwbOz7xEW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IGrZrtMTH9gRLwB8yPNJd5A0TLZQxYh2B/IDe2O2nSOs3/BWGfxNWPbpnfZr5kJjB
         nei/fz9+FoC6pHZM9n2m7j8GaWCWZ6o3PQgiGmsU86+oVymQA/89k8vtCLB8Hfj4fF
         2nd9TexvB5eFW7dk/funp9gxwzhv6BTYlAK7aRas29ItS9hxeswr8fAR67pqLAVI1y
         5feZYp9yQxBIaTH1tfpCjBIpvOYjoVxsqh3WODlnXR9bxKLiKCQvQ67m0l+uIdoqPL
         1T5YFUiEHDuai7IOqq9aKcMvilW+mEt69vtpql6IwvGiz/kXrADGOo5K3D/fMq0I7Y
         z+FS2YOauiSaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        agross@kernel.org, bjorn.andersson@linaro.org,
        yung-chuan.liao@linux.intel.com, linux-arm-msm@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 20/60] soundwire: qcom: adjust autoenumeration timeout
Date:   Tue,  7 Jun 2022 13:52:17 -0400
Message-Id: <20220607175259.478835-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 74da272400b46f2e898f115d1b1cd60828766919 ]

Currently timeout for autoenumeration during probe and bus reset is set to
2 secs which is really a big value. This can have an adverse effect on
boot time if the slave device is not ready/reset.
This was the case with wcd938x which was not reset yet but we spent 2
secs waiting in the soundwire controller probe. Reduce this time to
1/10 of Hz which should be good enough time to finish autoenumeration
if any slaves are available on the bus.

Reported-by: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220506084705.18525-1-srinivas.kandagatla@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index 54813417ef8e..249f1b69ec94 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -99,7 +99,7 @@
 
 #define SWRM_SPECIAL_CMD_ID	0xF
 #define MAX_FREQ_NUM		1
-#define TIMEOUT_MS		(2 * HZ)
+#define TIMEOUT_MS		100
 #define QCOM_SWRM_MAX_RD_LEN	0x1
 #define QCOM_SDW_MAX_PORTS	14
 #define DEFAULT_CLK_FREQ	9600000
-- 
2.35.1

