Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0708667667
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237665AbjALOb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236952AbjALOae (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:30:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2E85E090
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:22:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C120CB81DCC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC825C433D2;
        Thu, 12 Jan 2023 14:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533344;
        bh=8sqdTsWFYP3san1PFpsmlfbUMGekp50NGrDGRL77oSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hb3MrqN94gmyjooYyxzi7BCEAfFgX6TDNHqH7qnbrNjgEggYxtOUaLhviZ5+U0/Sn
         8+RjpyG6RPcCFGhLMNmMt0d1vFR0wbx3DjYPUHtQu6962cDcrnO972rU0QDFQr/iT2
         J/SsuMTpTkbLP9iBe9Jxh7ZiOHkLsmwXaWPFpx3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 449/783] remoteproc: qcom_q6v5_pas: Fix missing of_node_put() in adsp_alloc_memory_region()
Date:   Thu, 12 Jan 2023 14:52:45 +0100
Message-Id: <20230112135545.069599124@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 38e7d9c19276832ebb0277f415b9214bf7baeb37 ]

The pointer node is returned by of_parse_phandle() with refcount
incremented. We should use of_node_put() on it when done.

Fixes: b9e718e950c3 ("remoteproc: Introduce Qualcomm ADSP PIL")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221203070639.15128-1-yuancan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index d8ef10fba8e8..1a0d6eb9425b 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -365,6 +365,7 @@ static int adsp_alloc_memory_region(struct qcom_adsp *adsp)
 	}
 
 	ret = of_address_to_resource(node, 0, &r);
+	of_node_put(node);
 	if (ret)
 		return ret;
 
-- 
2.35.1



