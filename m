Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FD16812BC
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237526AbjA3OYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237654AbjA3OYW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:24:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A799F402E3
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:23:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B79B0B80C9B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4D9C433D2;
        Mon, 30 Jan 2023 14:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088528;
        bh=drVAsldnW3O9CJWK+whpTw7IruDzat7EhGN7XbQRmeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqlOJ5grWdmmZB5HY6jBs5W1OiSDDTQ/2kUcDqDo5erfAmow0fhrQkp980nnLyLxk
         gftqWkUxf7sBZYSS/6R1NYb6Fu3mp9eiSv6RUAI+qZqWXwGZo19KbG67e1xoDV1Vqk
         umy9qyjZuMtGSjgfvZyOqUUxw4DIDBwgNv+Ud8rg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/143] PM: AVS: qcom-cpr: Fix an error handling path in cpr_probe()
Date:   Mon, 30 Jan 2023 14:51:19 +0100
Message-Id: <20230130134307.785643392@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 6049aae52392539e505bfb8ccbcff3c26f1d2f0b ]

If an error occurs after a successful pm_genpd_init() call, it should be
undone by a corresponding pm_genpd_remove().

Add the missing call in the error handling path, as already done in the
remove function.

Fixes: bf6910abf548 ("power: avs: Add support for CPR (Core Power Reduction)")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/0f520597dbad89ab99c217c8986912fa53eaf5f9.1671293108.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/cpr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/cpr.c b/drivers/soc/qcom/cpr.c
index 6298561bc29c..fac0414c3731 100644
--- a/drivers/soc/qcom/cpr.c
+++ b/drivers/soc/qcom/cpr.c
@@ -1743,12 +1743,16 @@ static int cpr_probe(struct platform_device *pdev)
 
 	ret = of_genpd_add_provider_simple(dev->of_node, &drv->pd);
 	if (ret)
-		return ret;
+		goto err_remove_genpd;
 
 	platform_set_drvdata(pdev, drv);
 	cpr_debugfs_init(drv);
 
 	return 0;
+
+err_remove_genpd:
+	pm_genpd_remove(&drv->pd);
+	return ret;
 }
 
 static int cpr_remove(struct platform_device *pdev)
-- 
2.39.0



