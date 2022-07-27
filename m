Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B23C5830BB
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242840AbiG0RlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242174AbiG0Rk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:40:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFCE88E31;
        Wed, 27 Jul 2022 09:51:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33470B821C5;
        Wed, 27 Jul 2022 16:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE0DC433C1;
        Wed, 27 Jul 2022 16:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940678;
        bh=laAW4N7hZQuQqUG5fJRWifvSw1PQRaXRy9+COPCqzQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmD3zVrDUGL+E7CJmQGdYzg1dtwkxnFPYZ/Ojz4GeYNf4oP5jbu9UThAQw2N5Dyfc
         4s9ZUGcmx5ybaitb5QHYupcnGUoChCNR645QJuNFVeuwWp8hzVI1AyTwDfE5j0WpB7
         /cAdz3S+qlBiMALjlQbdUCmKSKZe1NzrldotD9FA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 110/158] drm/imx/dcss: Add missing of_node_put() in fail path
Date:   Wed, 27 Jul 2022 18:12:54 +0200
Message-Id: <20220727161025.880308594@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 02c87df2480ac855d88ee308ce3fa857d9bd55a8 ]

In dcss_dev_create() and dcss_dev_destroy(), we should call of_node_put()
in fail path or before the dcss's destroy as of_graph_get_port_by_id() has
increased the refcount.

Fixes: 9021c317b770 ("drm/imx: Add initial support for DCSS on iMX8MQ")
Signed-off-by: Liang He <windhl@126.com>
Reviewed-by: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
Signed-off-by: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220714081337.374761-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/dcss/dcss-dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/imx/dcss/dcss-dev.c b/drivers/gpu/drm/imx/dcss/dcss-dev.c
index c849533ca83e..3f5750cc2673 100644
--- a/drivers/gpu/drm/imx/dcss/dcss-dev.c
+++ b/drivers/gpu/drm/imx/dcss/dcss-dev.c
@@ -207,6 +207,7 @@ struct dcss_dev *dcss_dev_create(struct device *dev, bool hdmi_output)
 
 	ret = dcss_submodules_init(dcss);
 	if (ret) {
+		of_node_put(dcss->of_port);
 		dev_err(dev, "submodules initialization failed\n");
 		goto clks_err;
 	}
@@ -237,6 +238,8 @@ void dcss_dev_destroy(struct dcss_dev *dcss)
 		dcss_clocks_disable(dcss);
 	}
 
+	of_node_put(dcss->of_port);
+
 	pm_runtime_disable(dcss->dev);
 
 	dcss_submodules_stop(dcss);
-- 
2.35.1



