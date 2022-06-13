Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5AA5498C9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377520AbiFMNdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378252AbiFMNbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:31:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEE56FA18;
        Mon, 13 Jun 2022 04:25:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 81CC3CE1171;
        Mon, 13 Jun 2022 11:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FD9C34114;
        Mon, 13 Jun 2022 11:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119545;
        bh=/2108pRDFRfrsSrSUV7Yy/lazrzX7KKagVieVpc9FoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSzJElPfR8eY9wE59zNg/uOQTpfprYGCk/UuotySXyVgYEvkmxvLL+qG+GnAahl9v
         7xof9n+5gGq+n6s1CCCfIjQaN8ByMoCn6sS7e6kr5XNABrvlwVEl20qh+PGXovmNCB
         OAH1/k/eRFG6i36MhORoGDdtkL9qFAFWGGEv18Vc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 052/339] soundwire: qcom: return error when pm_runtime_get_sync fails
Date:   Mon, 13 Jun 2022 12:07:57 +0200
Message-Id: <20220613094928.101275873@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit f6ee6c8499226eb158ca30457d346511f5e329ce ]

For some reason there's a missing error return in two places.

Fixes: 74e79da9fd46a ("soundwire: qcom: add runtime pm support")
Fixes: 04d46a7b38375 ("soundwire: qcom: add in-band wake up interrupt support")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220426235623.4253-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/qcom.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index dd9f67f895b2..b38525b35bec 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -516,6 +516,7 @@ static irqreturn_t qcom_swrm_wake_irq_handler(int irq, void *dev_id)
 				    "pm_runtime_get_sync failed in %s, ret %d\n",
 				    __func__, ret);
 		pm_runtime_put_noidle(swrm->dev);
+		return ret;
 	}
 
 	if (swrm->wake_irq > 0) {
@@ -1258,6 +1259,7 @@ static int swrm_reg_show(struct seq_file *s_file, void *data)
 				    "pm_runtime_get_sync failed in %s, ret %d\n",
 				    __func__, ret);
 		pm_runtime_put_noidle(swrm->dev);
+		return ret;
 	}
 
 	for (reg = 0; reg <= SWR_MSTR_MAX_REG_ADDR; reg += 4) {
-- 
2.35.1



