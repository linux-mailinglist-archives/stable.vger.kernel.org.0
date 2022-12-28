Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CFD658307
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbiL1QoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbiL1Qnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:43:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A40C324
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:38:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC7B1B816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A12C433F0;
        Wed, 28 Dec 2022 16:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245493;
        bh=AJI6k/9Bs1e+aX6ppx/bBe1+BG7dZm6i6FA2mQ1gwcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoN0uMdNP9xszvSEMScpBAvnE4es46RHcRzQRIkhd0Utwis5kYAiim5L1cLPG7dZJ
         E873LqsVUAT6Pln0hRlZZ7SWVx65OEdlx7eALWUc9KxVHI1lY6vEWcBrG5TjlBcOol
         hx8HOLIFbHe/26fh7j2TaatAyslgplwv5kI7KH+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0870/1146] remoteproc: sysmon: fix memory leak in qcom_add_sysmon_subdev()
Date:   Wed, 28 Dec 2022 15:40:09 +0100
Message-Id: <20221228144353.799074997@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit e01ce676aaef3b13d02343d7e70f9637d93a3367 ]

The kfree() should be called when of_irq_get_byname() fails or
devm_request_threaded_irq() fails in qcom_add_sysmon_subdev(),
otherwise there will be a memory leak, so add kfree() to fix it.

Fixes: 027045a6e2b7 ("remoteproc: qcom: Add shutdown-ack irq")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221129105650.1539187-1-cuigaosheng1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_sysmon.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_sysmon.c b/drivers/remoteproc/qcom_sysmon.c
index 57dde2a69b9d..15af52f8499e 100644
--- a/drivers/remoteproc/qcom_sysmon.c
+++ b/drivers/remoteproc/qcom_sysmon.c
@@ -652,7 +652,9 @@ struct qcom_sysmon *qcom_add_sysmon_subdev(struct rproc *rproc,
 		if (sysmon->shutdown_irq != -ENODATA) {
 			dev_err(sysmon->dev,
 				"failed to retrieve shutdown-ack IRQ\n");
-			return ERR_PTR(sysmon->shutdown_irq);
+			ret = sysmon->shutdown_irq;
+			kfree(sysmon);
+			return ERR_PTR(ret);
 		}
 	} else {
 		ret = devm_request_threaded_irq(sysmon->dev,
@@ -663,6 +665,7 @@ struct qcom_sysmon *qcom_add_sysmon_subdev(struct rproc *rproc,
 		if (ret) {
 			dev_err(sysmon->dev,
 				"failed to acquire shutdown-ack IRQ\n");
+			kfree(sysmon);
 			return ERR_PTR(ret);
 		}
 	}
-- 
2.35.1



