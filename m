Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB114F2E4D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbiDEIdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239539AbiDEIUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23713108D;
        Tue,  5 Apr 2022 01:15:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4F1C609AD;
        Tue,  5 Apr 2022 08:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11D3C385A0;
        Tue,  5 Apr 2022 08:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146542;
        bh=vW3aZppNUsxHLSbPNy/WFu/pdlhv+bbciT+wAcuOJ0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZOVnNI27NEqB0rv+ZgIGje6qhDNm2dGcOxj3M6ABx7cnPA50Ta5DZ/NicoJU3Syn
         0PN8mFLSD+YPfzuZ8c7gDcNeUQ1CVmeZoQ3CHzj+ajR/f4KL0/Rfg1MDtfrPoJedsd
         x/vbGVtoQiPB/yYQNMFOdF5g5Hgng5ZF8bEn1ndE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0753/1126] remoteproc: qcom_q6v5_mss: Fix some leaks in q6v5_alloc_memory_region
Date:   Tue,  5 Apr 2022 09:25:00 +0200
Message-Id: <20220405070429.687880174@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 07a5dcc4bed9d7cae54adf5aa10ff9f037a3204b ]

The device_node pointer is returned by of_parse_phandle() or
of_get_child_by_name() with refcount incremented.
We should use of_node_put() on it when done.

This function only call of_node_put(node) when of_address_to_resource
succeeds, missing error cases.

Fixes: 278d744c46fd ("remoteproc: qcom: Fix potential device node leaks")
Fixes: 051fb70fd4ea ("remoteproc: qcom: Driver for the self-authenticating Hexagon v5")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220308064522.13804-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_mss.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index 43ea8455546c..b9ab91540b00 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -1806,18 +1806,20 @@ static int q6v5_alloc_memory_region(struct q6v5 *qproc)
 	 * reserved memory regions from device's memory-region property.
 	 */
 	child = of_get_child_by_name(qproc->dev->of_node, "mba");
-	if (!child)
+	if (!child) {
 		node = of_parse_phandle(qproc->dev->of_node,
 					"memory-region", 0);
-	else
+	} else {
 		node = of_parse_phandle(child, "memory-region", 0);
+		of_node_put(child);
+	}
 
 	ret = of_address_to_resource(node, 0, &r);
+	of_node_put(node);
 	if (ret) {
 		dev_err(qproc->dev, "unable to resolve mba region\n");
 		return ret;
 	}
-	of_node_put(node);
 
 	qproc->mba_phys = r.start;
 	qproc->mba_size = resource_size(&r);
@@ -1828,14 +1830,15 @@ static int q6v5_alloc_memory_region(struct q6v5 *qproc)
 	} else {
 		child = of_get_child_by_name(qproc->dev->of_node, "mpss");
 		node = of_parse_phandle(child, "memory-region", 0);
+		of_node_put(child);
 	}
 
 	ret = of_address_to_resource(node, 0, &r);
+	of_node_put(node);
 	if (ret) {
 		dev_err(qproc->dev, "unable to resolve mpss region\n");
 		return ret;
 	}
-	of_node_put(node);
 
 	qproc->mpss_phys = qproc->mpss_reloc = r.start;
 	qproc->mpss_size = resource_size(&r);
-- 
2.34.1



