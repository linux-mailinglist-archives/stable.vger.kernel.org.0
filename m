Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37BA86047FA
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbiJSNsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233095AbiJSNqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:46:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CECDDE;
        Wed, 19 Oct 2022 06:32:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02F59B82437;
        Wed, 19 Oct 2022 08:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CE1C433C1;
        Wed, 19 Oct 2022 08:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169876;
        bh=pW7ZV2htvWXgiyX1QUvqOjs93tLozdPizpyCV7uPREA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtxdAufgr86HGQERGGCMVFZB7gN/FvrkQ2YoGVGrUGovQKLjoMznn2eLnflyCNwjt
         xAjYKcGtcSui0nQw+NK0Xe5Hl58Qb7MCfk+hM7vJocO1Qle7lYOZLNX24Z0PeBI3Uu
         u+Q09MWYxjyadqzEcAT8PDWo2GaWBNqMKskb6SRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 441/862] soc/tegra: fuse: Add missing of_node_put() in tegra_init_fuse()
Date:   Wed, 19 Oct 2022 10:28:48 +0200
Message-Id: <20221019083309.480396516@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit e941712cccab8a96f03b5d3274159c1ed338efee ]

In this function, of_find_matching_node() will return a node pointer
with refcount incremented. We should use of_node_put() when the "np"
pointer is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/tegra/fuse/fuse-tegra.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/soc/tegra/fuse/fuse-tegra.c
+++ b/drivers/soc/tegra/fuse/fuse-tegra.c
@@ -568,6 +568,7 @@ static int __init tegra_init_fuse(void)
 	np = of_find_matching_node(NULL, car_match);
 	if (np) {
 		void __iomem *base = of_iomap(np, 0);
+		of_node_put(np);
 		if (base) {
 			tegra_enable_fuse_clk(base);
 			iounmap(base);


