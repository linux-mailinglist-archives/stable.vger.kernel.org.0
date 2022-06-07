Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E3D5414CE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356067AbiFGUWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376305AbiFGUVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:21:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9647F2CE2F;
        Tue,  7 Jun 2022 11:31:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39E59B822C0;
        Tue,  7 Jun 2022 18:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09D3C385A2;
        Tue,  7 Jun 2022 18:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626663;
        bh=4JIrRICiYrnw1c2ygg9e+MEN7EFrlrJShWuE87GFz/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vozf1zHLErwueonZoPX16JoCJolylOyEpwQErwBkzSekB0F1ZYTHL/ZyAtNBV3W9h
         Rb7gzZ9J3sVmA+K+6lXdzo/E/c2UlpemCBs5uK2q1wttlHjiErijdLWTJ3K+nI4Vi0
         yf9AtirWfC0j2UMcgos+dts6R6hjub7BhEBfZD1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 458/772] soc: qcom: smsm: Fix missing of_node_put() in smsm_parse_ipc
Date:   Tue,  7 Jun 2022 19:00:50 +0200
Message-Id: <20220607165002.499608612@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit aad66a3c78da668f4506356c2fdb70b7a19ecc76 ]

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.

Fixes: c97c4090ff72 ("soc: qcom: smsm: Add driver for Qualcomm SMSM")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220308073648.24634-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/smsm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/qcom/smsm.c b/drivers/soc/qcom/smsm.c
index ef15d014c03a..9df9bba242f3 100644
--- a/drivers/soc/qcom/smsm.c
+++ b/drivers/soc/qcom/smsm.c
@@ -374,6 +374,7 @@ static int smsm_parse_ipc(struct qcom_smsm *smsm, unsigned host_id)
 		return 0;
 
 	host->ipc_regmap = syscon_node_to_regmap(syscon);
+	of_node_put(syscon);
 	if (IS_ERR(host->ipc_regmap))
 		return PTR_ERR(host->ipc_regmap);
 
-- 
2.35.1



