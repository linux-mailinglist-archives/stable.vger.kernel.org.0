Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6126C18EB
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbjCTP2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbjCTP23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:28:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F27E9768
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:21:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A0C26CE12F6
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69820C433EF;
        Mon, 20 Mar 2023 15:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325687;
        bh=yJ+vsaZMKxn5vdwyAOZuPKPz0Uww03nMVYoFS4Qa8RI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AEG7hPCu/lsCaieb11NOWb5vJzWfQdxTDhjn0neX3jBqL59/UQNGfcYpM+i2DV7Aa
         DjU2tg3Ng+VGjY2ctWbsWkg5AVa3d6MgG4a9MPKtGTrT3x87e6fLDyP9vRnjkrzfI9
         Yy2Z6UHIo67TDBBH0e5GapiNcF+RBemECzPbrCqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dmitry Osipenko <digetx@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 6.1 123/198] memory: tegra: fix interconnect registration race
Date:   Mon, 20 Mar 2023 15:54:21 +0100
Message-Id: <20230320145512.711634116@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit 5553055c62683ce339f9ef5fb2a26c8331485d68 upstream.

The current interconnect provider registration interface is inherently
racy as nodes are not added until the after adding the provider. This
can specifically cause racing DT lookups to fail.

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: 06f079816d4c ("memory: tegra-mc: Add interconnect framework")
Cc: stable@vger.kernel.org      # 5.11
Cc: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230306075651.2449-18-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memory/tegra/mc.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/drivers/memory/tegra/mc.c
+++ b/drivers/memory/tegra/mc.c
@@ -769,16 +769,12 @@ static int tegra_mc_interconnect_setup(s
 	mc->provider.aggregate = mc->soc->icc_ops->aggregate;
 	mc->provider.xlate_extended = mc->soc->icc_ops->xlate_extended;
 
-	err = icc_provider_add(&mc->provider);
-	if (err)
-		return err;
+	icc_provider_init(&mc->provider);
 
 	/* create Memory Controller node */
 	node = icc_node_create(TEGRA_ICC_MC);
-	if (IS_ERR(node)) {
-		err = PTR_ERR(node);
-		goto del_provider;
-	}
+	if (IS_ERR(node))
+		return PTR_ERR(node);
 
 	node->name = "Memory Controller";
 	icc_node_add(node, &mc->provider);
@@ -805,12 +801,14 @@ static int tegra_mc_interconnect_setup(s
 			goto remove_nodes;
 	}
 
+	err = icc_provider_register(&mc->provider);
+	if (err)
+		goto remove_nodes;
+
 	return 0;
 
 remove_nodes:
 	icc_nodes_remove(&mc->provider);
-del_provider:
-	icc_provider_del(&mc->provider);
 
 	return err;
 }


