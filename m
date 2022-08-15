Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF397593A06
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244958AbiHOTaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244443AbiHOT2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:28:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F1C5D0C6;
        Mon, 15 Aug 2022 11:43:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5C6C1CE1273;
        Mon, 15 Aug 2022 18:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B6BC433D6;
        Mon, 15 Aug 2022 18:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589033;
        bh=XodYGOdnVgsklnX4DOkSbhBIo4TlJdS6kPEufjU+TnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kTYredGdHAx/wIJ7Pq37zkmB76564zN1/q7Uxm7IJM/GdvbSH/nkqSRCQb4sg8GBU
         mL82fAw+pPMgFEE44KyHEx+YizPr3/c8Hi4mA5eHO6NaP4ThlclGl7WXPfbD4n0lyF
         bmC0tOiFtfXnFI9oELVUpd7p2iAZ2+2vN3DVWBrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Miaoqian Lin <linmq006@gmail.com>
Subject: [PATCH 5.15 591/779] ASoC: qcom: Fix missing of_node_put() in asoc_qcom_lpass_cpu_platform_probe()
Date:   Mon, 15 Aug 2022 20:03:55 +0200
Message-Id: <20220815180402.591391486@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit f507c0c67dac57d2bcd5dcae4b6139b0305d8957 ]

We should call of_node_put() for the reference 'dsp_of_node' returned by
of_parse_phandle() which will increase the refcount.

Fixes: 9bae4880acee ("ASoC: qcom: move ipq806x specific bits out of lpass driver.")
Co-authored-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220702020109.263980-1-windhl@126.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index 3bd9eb3cc688..5e89d280e355 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -880,6 +880,7 @@ int asoc_qcom_lpass_cpu_platform_probe(struct platform_device *pdev)
 	dsp_of_node = of_parse_phandle(pdev->dev.of_node, "qcom,adsp", 0);
 	if (dsp_of_node) {
 		dev_err(dev, "DSP exists and holds audio resources\n");
+		of_node_put(dsp_of_node);
 		return -EBUSY;
 	}
 
-- 
2.35.1



