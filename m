Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8480680FAE
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236510AbjA3N4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235917AbjA3Nz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:55:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FDF2687E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:55:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A800B81150
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68889C433EF;
        Mon, 30 Jan 2023 13:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086955;
        bh=IjdQCOwY+5jE7+z9IGogYRj0Y2flj86Xw072f41f4iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UAKyGlHHKnketxe29GokqmA0b2xGRctkUQQihEcI+QxFYSoALbBXuWUBTEovW2BEj
         7ZZZf93eeRy0hdigweCjyxYz2EYvUnVUIMhONUw9de52o/3GMobP4fmKoCV4gvog/v
         1g1m5CkO6pgSCKIL4XmXx/TimWaM6gryZ9xznBO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/313] PM: AVS: qcom-cpr: Fix an error handling path in cpr_probe()
Date:   Mon, 30 Jan 2023 14:48:07 +0100
Message-Id: <20230130134339.126370127@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index e9b854ed1bdf..144ea68e0920 100644
--- a/drivers/soc/qcom/cpr.c
+++ b/drivers/soc/qcom/cpr.c
@@ -1708,12 +1708,16 @@ static int cpr_probe(struct platform_device *pdev)
 
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



