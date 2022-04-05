Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7530D4F34D3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239594AbiDEJNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244874AbiDEIwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664E423BEC;
        Tue,  5 Apr 2022 01:45:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2123AB81A32;
        Tue,  5 Apr 2022 08:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED6CC385A1;
        Tue,  5 Apr 2022 08:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148317;
        bh=vPVLp60ofXI704P8vIcvQjUYK/V4SPah6vO9kL+FYpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rVZTaGZFl2sZiwwRoVeCGRCLdVThSAsidIn98qQ6pLQ8dqSkepcINhLe2mK2CYExL
         FX3Oe3dcjFTHdlsJ8gOu04UURuMwMVIadNRUrwJwfxoAey/dVLxUb4ZVggYhdo3IRr
         WKitwDEsc9VIqTNdrpF5tEEKvpSNAuW46qa40SRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0314/1017] soc: qcom: aoss: Fix missing put_device call in qmp_get
Date:   Tue,  5 Apr 2022 09:20:27 +0200
Message-Id: <20220405070403.597456413@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

[ Upstream commit 4b41a9d0fe3db5f91078a380f62f0572c3ecf2dd ]

The reference taken by 'of_find_device_by_node()' must be released when
not needed anymore.
Add the corresponding 'put_device()' in the error handling paths.

Fixes: 8c75d585b931 ("soc: qcom: aoss: Expose send for generic usecase")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220108095931.21527-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom_aoss.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/qcom_aoss.c b/drivers/soc/qcom/qcom_aoss.c
index 34acf58bbb0d..e234d78b33e7 100644
--- a/drivers/soc/qcom/qcom_aoss.c
+++ b/drivers/soc/qcom/qcom_aoss.c
@@ -451,7 +451,11 @@ struct qmp *qmp_get(struct device *dev)
 
 	qmp = platform_get_drvdata(pdev);
 
-	return qmp ? qmp : ERR_PTR(-EPROBE_DEFER);
+	if (!qmp) {
+		put_device(&pdev->dev);
+		return ERR_PTR(-EPROBE_DEFER);
+	}
+	return qmp;
 }
 EXPORT_SYMBOL(qmp_get);
 
-- 
2.34.1



