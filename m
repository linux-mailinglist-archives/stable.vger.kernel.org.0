Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3889F657D5A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbiL1Pmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233977AbiL1PmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:42:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B6217062
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:42:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DFFADCE1369
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4441C433EF;
        Wed, 28 Dec 2022 15:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242130;
        bh=/CAQNq+QTcBM5KOL1Sc6/ynFJBWsurVNYbhvrr3CQXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kcNLeSxpuoHI7dhQNKbUHW5Sa0eqzuwy6KfVYlQ3O6ArhS9wksk5kkAjH4cIe5qum
         5zno1NUYLwYGwbROq4paXWl6CedPowFhMz/f3RNMLt5ELViAAaa46kjuR2YbY8OtPP
         q+ymXP+lhQNAn3PJ+Aty/DILuVv1Ofl22ohMSeAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 566/731] remoteproc: sysmon: fix memory leak in qcom_add_sysmon_subdev()
Date:   Wed, 28 Dec 2022 15:41:13 +0100
Message-Id: <20221228144312.966781841@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index a9f04dd83ab6..fbfaf2637a91 100644
--- a/drivers/remoteproc/qcom_sysmon.c
+++ b/drivers/remoteproc/qcom_sysmon.c
@@ -650,7 +650,9 @@ struct qcom_sysmon *qcom_add_sysmon_subdev(struct rproc *rproc,
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
@@ -661,6 +663,7 @@ struct qcom_sysmon *qcom_add_sysmon_subdev(struct rproc *rproc,
 		if (ret) {
 			dev_err(sysmon->dev,
 				"failed to acquire shutdown-ack IRQ\n");
+			kfree(sysmon);
 			return ERR_PTR(ret);
 		}
 	}
-- 
2.35.1



