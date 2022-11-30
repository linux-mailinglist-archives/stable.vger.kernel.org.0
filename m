Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AE263DE66
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiK3Sgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiK3Sg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:36:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854159208A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:36:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37237B81B37
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE0AC433D6;
        Wed, 30 Nov 2022 18:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833384;
        bh=igflZgYMzKeilMrkzZu32VaQSFE3nYNVYzSKS3WcPG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZtibVVbdVExT2zelRvYPWLjj/u0W35J2PbHR4lsgiBS3gqQ+yS/JmPQYhVaBl+ki
         HDmVpt7ZhMD8YUqpEZz4lHek8hQ7CxDR/y5H5rzPO98Yld7oUBSFQtvMCvhQGW1LLc
         K33km7tEWTz7G23660SnRrc35T6bBYTxfbwsNWBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Yongjun <zhengyongjun3@huawei.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/206] ARM: mxs: fix memory leak in mxs_machine_init()
Date:   Wed, 30 Nov 2022 19:22:19 +0100
Message-Id: <20221130180535.221437228@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit f31e3c204d1844b8680a442a48868af5ac3d5481 ]

If of_property_read_string() failed, 'soc_dev_attr' should be
freed before return. Otherwise there is a memory leak.

Fixes: 2046338dcbc6 ("ARM: mxs: Use soc bus infrastructure")
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-mxs/mach-mxs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
index 25c9d184fa4c..1c57ac401649 100644
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@ -393,8 +393,10 @@ static void __init mxs_machine_init(void)
 
 	root = of_find_node_by_path("/");
 	ret = of_property_read_string(root, "model", &soc_dev_attr->machine);
-	if (ret)
+	if (ret) {
+		kfree(soc_dev_attr);
 		return;
+	}
 
 	soc_dev_attr->family = "Freescale MXS Family";
 	soc_dev_attr->soc_id = mxs_get_soc_id();
-- 
2.35.1



