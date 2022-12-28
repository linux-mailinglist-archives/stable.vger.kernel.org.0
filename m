Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F2165829B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbiL1Qip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbiL1QiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:38:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D2B1DA73
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:33:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27DC36157C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D4EC433D2;
        Wed, 28 Dec 2022 16:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245233;
        bh=0yZi8jFDCBEDUZL6d7RxL5mQsYs00S36dgR+MnEeqLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqjajcc0oUOjqxKT2iKpXiSzewCndgb3zcGNIP7lQPAHxHS1RMcpqkommzmJio223
         KCRMEYUKdrKMqELDqF9h1H/I9qXXKU9+9U8EH+FvL5mAwD50A8mghgz7mUoLqqHfQ6
         fG7FTEp2mWkGnq6pOPgSvb1DQSPwmW7j+F+ewaQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0824/1073] remoteproc: qcom_q6v5_pas: Fix missing of_node_put() in adsp_alloc_memory_region()
Date:   Wed, 28 Dec 2022 15:40:12 +0100
Message-Id: <20221228144350.396530977@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index a14ff1142e76..dc6f07ca8341 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -449,6 +449,7 @@ static int adsp_alloc_memory_region(struct qcom_adsp *adsp)
 	}
 
 	ret = of_address_to_resource(node, 0, &r);
+	of_node_put(node);
 	if (ret)
 		return ret;
 
-- 
2.35.1



