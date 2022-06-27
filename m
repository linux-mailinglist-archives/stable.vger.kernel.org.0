Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11F955C276
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235191AbiF0L3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235322AbiF0L2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:28:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20E9A189;
        Mon, 27 Jun 2022 04:27:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69402614A0;
        Mon, 27 Jun 2022 11:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BC5C3411D;
        Mon, 27 Jun 2022 11:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329238;
        bh=YfwcNSiIhwhdnf99HY/KHAoQytjC7vOUMwai1NvGiYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVi7KYSurA/rH/l0ZmPAoXCtiZKoigkw+QOVruEFYtNrANMK4z1w9hMfjLppXaPfE
         dd6aniS+LEbeI06K8kJbluhqzpxBu4k5NCCYcM/iJdFXWKJp00jRhpq8PMYldLZdIL
         /9lwXYmXtR7EkYHfeGnhfhoS1Nhpi83Dk5UOuTbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.10 097/102] memory: samsung: exynos5422-dmc: Fix refcount leak in of_get_dram_timings
Date:   Mon, 27 Jun 2022 13:21:48 +0200
Message-Id: <20220627111936.343926340@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit 1332661e09304b7b8e84e5edc11811ba08d12abe upstream.

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
This function doesn't call of_node_put() in some error paths.
To unify the structure, Add put_node label and goto it on errors.

Fixes: 6e7674c3c6df ("memory: Add DMC driver for Exynos5422")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://lore.kernel.org/r/20220602041721.64348-1-linmq006@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memory/samsung/exynos5422-dmc.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/drivers/memory/samsung/exynos5422-dmc.c
+++ b/drivers/memory/samsung/exynos5422-dmc.c
@@ -1192,33 +1192,39 @@ static int of_get_dram_timings(struct ex
 
 	dmc->timing_row = devm_kmalloc_array(dmc->dev, TIMING_COUNT,
 					     sizeof(u32), GFP_KERNEL);
-	if (!dmc->timing_row)
-		return -ENOMEM;
+	if (!dmc->timing_row) {
+		ret = -ENOMEM;
+		goto put_node;
+	}
 
 	dmc->timing_data = devm_kmalloc_array(dmc->dev, TIMING_COUNT,
 					      sizeof(u32), GFP_KERNEL);
-	if (!dmc->timing_data)
-		return -ENOMEM;
+	if (!dmc->timing_data) {
+		ret = -ENOMEM;
+		goto put_node;
+	}
 
 	dmc->timing_power = devm_kmalloc_array(dmc->dev, TIMING_COUNT,
 					       sizeof(u32), GFP_KERNEL);
-	if (!dmc->timing_power)
-		return -ENOMEM;
+	if (!dmc->timing_power) {
+		ret = -ENOMEM;
+		goto put_node;
+	}
 
 	dmc->timings = of_lpddr3_get_ddr_timings(np_ddr, dmc->dev,
 						 DDR_TYPE_LPDDR3,
 						 &dmc->timings_arr_size);
 	if (!dmc->timings) {
-		of_node_put(np_ddr);
 		dev_warn(dmc->dev, "could not get timings from DT\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_node;
 	}
 
 	dmc->min_tck = of_lpddr3_get_min_tck(np_ddr, dmc->dev);
 	if (!dmc->min_tck) {
-		of_node_put(np_ddr);
 		dev_warn(dmc->dev, "could not get tck from DT\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_node;
 	}
 
 	/* Sorted array of OPPs with frequency ascending */
@@ -1232,13 +1238,14 @@ static int of_get_dram_timings(struct ex
 					     clk_period_ps);
 	}
 
-	of_node_put(np_ddr);
 
 	/* Take the highest frequency's timings as 'bypass' */
 	dmc->bypass_timing_row = dmc->timing_row[idx - 1];
 	dmc->bypass_timing_data = dmc->timing_data[idx - 1];
 	dmc->bypass_timing_power = dmc->timing_power[idx - 1];
 
+put_node:
+	of_node_put(np_ddr);
 	return ret;
 }
 


