Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF4966CB4D
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbjAPRND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:13:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234341AbjAPRMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:12:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7D14B180
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:52:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8564961018
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9765CC433EF;
        Mon, 16 Jan 2023 16:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887948;
        bh=JykKPLp5E47Pvk3hvRluPHp4WzY1rFpWUUIEsM5pWQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rdNoaawkprpeAdPEn0BL1FQpOXgnh/LkEOMghSOgpsKVW5GRgsAi8gBNmcfpZO+W4
         bzWPTO26pUD+MNYKMAe2xfNKrVQSjVbCbDdK7i8iiA/70/MprJcvQSFSMeFzZ2nhk+
         cetlhy3CqC2fMkvBpd4B98xouE8USaO0MC+zveSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 343/521] clk: st: Fix memory leak in st_of_quadfs_setup()
Date:   Mon, 16 Jan 2023 16:50:05 +0100
Message-Id: <20230116154902.497534504@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit cfd3ffb36f0d566846163118651d868e607300ba ]

If st_clk_register_quadfs_pll() fails, @lock should be freed before goto
@err_exit, otherwise will cause meory leak issue, fix it.

Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Link: https://lore.kernel.org/r/20221122133614.184910-1-xiujianfeng@huawei.com
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/st/clkgen-fsyn.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/st/clkgen-fsyn.c b/drivers/clk/st/clkgen-fsyn.c
index a79d81985c4e..bbe113159bc6 100644
--- a/drivers/clk/st/clkgen-fsyn.c
+++ b/drivers/clk/st/clkgen-fsyn.c
@@ -948,9 +948,10 @@ static void __init st_of_quadfs_setup(struct device_node *np,
 
 	clk = st_clk_register_quadfs_pll(pll_name, clk_parent_name, data,
 			reg, lock);
-	if (IS_ERR(clk))
+	if (IS_ERR(clk)) {
+		kfree(lock);
 		goto err_exit;
-	else
+	} else
 		pr_debug("%s: parent %s rate %u\n",
 			__clk_get_name(clk),
 			__clk_get_name(clk_get_parent(clk)),
-- 
2.35.1



