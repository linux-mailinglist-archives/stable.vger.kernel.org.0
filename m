Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4F7541BDF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378197AbiFGVzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383072AbiFGVwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:52:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB442408FC;
        Tue,  7 Jun 2022 12:10:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18CDF617DA;
        Tue,  7 Jun 2022 19:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2757DC34115;
        Tue,  7 Jun 2022 19:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629025;
        bh=4JIrRICiYrnw1c2ygg9e+MEN7EFrlrJShWuE87GFz/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VPf4ouNmZs6EbT8etkn2uKPmn7ASyP1HLH12et8rXhJj8CrL9j77uEbNxbgTrLDDx
         jfv+/C/IVj2WU7aOpXQvDb+k6NjU7/YR7Vzt1Tayd+n0W2Hc6vpifKwaB6UpKgdT0P
         LMY9dnqqDJ4GPNr9U/vQXT7qRjgUxtqt/U2Y/fT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 540/879] soc: qcom: smsm: Fix missing of_node_put() in smsm_parse_ipc
Date:   Tue,  7 Jun 2022 19:00:58 +0200
Message-Id: <20220607165018.547238284@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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



