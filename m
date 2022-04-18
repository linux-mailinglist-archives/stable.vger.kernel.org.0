Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682D7505325
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240134AbiDRMzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240406AbiDRMzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:55:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EC223143;
        Mon, 18 Apr 2022 05:35:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E7B9611A9;
        Mon, 18 Apr 2022 12:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E33AC385A7;
        Mon, 18 Apr 2022 12:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285343;
        bh=YPMbbLIAUrOz/F2QyLrf7EQrMAlFpXdWqGq42AxwZwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjSW9deWpf4DQ3Qca74QDiN0d0MXxcW67UGWh61Qe7VPl1+9gr/bruxIM/P7IMo9O
         JpTfYC+9X24L+SwEVqPchOYVEqiDBRyg4EQ5nexnR80eo54fF1lzmSy5OUxtdaXh6H
         C5qBcYM1RI7zcarZd+sYoU5uqZq+zzGvgc9hvu/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.15 179/189] soc: qcom: aoss: Fix missing put_device call in qmp_get
Date:   Mon, 18 Apr 2022 14:13:19 +0200
Message-Id: <20220418121208.151534900@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Miaoqian Lin <linmq006@gmail.com>

commit 4b41a9d0fe3db5f91078a380f62f0572c3ecf2dd upstream.

The reference taken by 'of_find_device_by_node()' must be released when
not needed anymore.
Add the corresponding 'put_device()' in the error handling paths.

Fixes: 8c75d585b931 ("soc: qcom: aoss: Expose send for generic usecase")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220108095931.21527-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/qcom_aoss.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/soc/qcom/qcom_aoss.c
+++ b/drivers/soc/qcom/qcom_aoss.c
@@ -551,7 +551,11 @@ struct qmp *qmp_get(struct device *dev)
 
 	qmp = platform_get_drvdata(pdev);
 
-	return qmp ? qmp : ERR_PTR(-EPROBE_DEFER);
+	if (!qmp) {
+		put_device(&pdev->dev);
+		return ERR_PTR(-EPROBE_DEFER);
+	}
+	return qmp;
 }
 EXPORT_SYMBOL(qmp_get);
 


