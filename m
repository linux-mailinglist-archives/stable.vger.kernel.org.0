Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C016F5904DC
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238475AbiHKQ37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238275AbiHKQ2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:28:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCC745068;
        Thu, 11 Aug 2022 09:08:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1B6D61426;
        Thu, 11 Aug 2022 16:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB9AC433D6;
        Thu, 11 Aug 2022 16:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234131;
        bh=SGTpKFtvpWTeRk3mipvgbkhMbS+YsOcmKS0+1nJgO9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XC7QrVaw3DzuKXslv80NB7vkMzQTEL3/GoGeCTPRi7ib3rm2Dt2IBAmlhrqnFx/s2
         y9fohqXzeXNM9Ws+nZ+O1t7s6z7XlULHzuWJXsvOKzKWIdkyMCfJHkfta14R3K4oEY
         CMPh5h9ndnpvlThgoZFQgxoh16rUa83OMP8exWMJRVfyVTJX4hUmJUMfkyyuchNnya
         PXLwYa4aNRCbPNJCmGv8O/2q27AN9K7FO7/a6PmHxsQUD/7DnYOtBzkLLVsjtP3xgW
         uK3n0y3yZ2qsbi1lrZrokKptZNPni89i+CV/32rsi03vv7xbthnmayWElwkU2MC0IJ
         QAsgg9zExir7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, johan@kernel.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com, cai.huoqing@linux.dev,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/25] media: davinci: vpif: add missing of_node_put() in vpif_probe()
Date:   Thu, 11 Aug 2022 12:08:06 -0400
Message-Id: <20220811160826.1541971-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160826.1541971-1-sashal@kernel.org>
References: <20220811160826.1541971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit bb45f5433f23cf103ba29c9692ee553e061f2cb4 ]

of_graph_get_next_endpoint() returns an 'endpoint' node pointer
with refcount incremented. The refcount should be decremented
before returning from vpif_probe().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/davinci/vpif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index e7e8eba048ac..a05fbb367d3a 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -450,6 +450,7 @@ static int vpif_probe(struct platform_device *pdev)
 					      endpoint);
 	if (!endpoint)
 		return 0;
+	of_node_put(endpoint);
 
 	/*
 	 * For DT platforms, manually create platform_devices for
-- 
2.35.1

