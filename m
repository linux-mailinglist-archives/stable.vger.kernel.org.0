Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A734F388F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbiDELZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349474AbiDEJtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE3A27CEF;
        Tue,  5 Apr 2022 02:46:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A195B818F3;
        Tue,  5 Apr 2022 09:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B70C385A1;
        Tue,  5 Apr 2022 09:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152016;
        bh=gNHrehMZgZje2ewnnw7KjUsMgqBeRD6jduXfTGBTdkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ji9w8NH86koKxRRmKPJLir9PAhyqJByrPAL9HomQ2X8BNlBuOnufxG6iiiiBsakcQ
         D33zHaZkgH0ZRWMCyjGskIfHfR2aZOxRsEQqlm7M5//Vq7EJ+S3go4Gp4d+vB9Abjt
         5+DyrPn6fDhepkuSCv5Q1nFzWkFlLBQO/2YFq/D0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 617/913] remoteproc: qcom_q6v5_mss: Fix some leaks in q6v5_alloc_memory_region
Date:   Tue,  5 Apr 2022 09:27:59 +0200
Message-Id: <20220405070358.335445001@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index 423b31dfa574..ca1c7387776b 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -1624,18 +1624,20 @@ static int q6v5_alloc_memory_region(struct q6v5 *qproc)
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
@@ -1646,14 +1648,15 @@ static int q6v5_alloc_memory_region(struct q6v5 *qproc)
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



