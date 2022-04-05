Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4F44F3867
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356013AbiDELXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349473AbiDEJtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A27215809;
        Tue,  5 Apr 2022 02:46:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED104B81B14;
        Tue,  5 Apr 2022 09:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E75C385A2;
        Tue,  5 Apr 2022 09:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152013;
        bh=2xrrqqAmurLYBbNH7gEODCEGzcqKSrwq1J93E5yRers=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irblOKDdx5TPwfPPV8xanHFkqVhVvUDSoBtAhA66ge1vohFU8eeaXZ23tT/xIInhT
         lC+uZKdaE9YVUa++4pRlm96xeNLok4kKQElrjmKvD+4YZN3/ia3etyGZ9Uad6md6tK
         fdAATaTql/vRemPArdg34fp3EJdMlgVPYZuelntA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Sondhauss <jan.sondhauss@wago.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 575/913] drivers: ethernet: cpsw: fix panic when interrupt coaleceing is set via ethtool
Date:   Tue,  5 Apr 2022 09:27:17 +0200
Message-Id: <20220405070357.082424924@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Sondhauß, Jan <Jan.Sondhauss@wago.com>

[ Upstream commit 2844e2434385819f674d1fb4130c308c50ba681e ]

cpsw_ethtool_begin directly returns the result of pm_runtime_get_sync
when successful.
pm_runtime_get_sync returns -error code on failure and 0 on successful
resume but also 1 when the device is already active. So the common case
for cpsw_ethtool_begin is to return 1. That leads to inconsistent calls
to pm_runtime_put in the call-chain so that pm_runtime_put is called
one too many times and as result leaving the cpsw dev behind suspended.

The suspended cpsw dev leads to an access violation later on by
different parts of the cpsw driver.

Fix this by calling the return-friendly pm_runtime_resume_and_get
function.

Fixes: d43c65b05b84 ("ethtool: runtime-resume netdev parent in ethnl_ops_begin")
Signed-off-by: Jan Sondhauss <jan.sondhauss@wago.com>
Reviewed-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20220323084725.65864-1-jan.sondhauss@wago.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw_ethtool.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index 158c8d3793f4..b5bae6324970 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -364,11 +364,9 @@ int cpsw_ethtool_op_begin(struct net_device *ndev)
 	struct cpsw_common *cpsw = priv->cpsw;
 	int ret;
 
-	ret = pm_runtime_get_sync(cpsw->dev);
-	if (ret < 0) {
+	ret = pm_runtime_resume_and_get(cpsw->dev);
+	if (ret < 0)
 		cpsw_err(priv, drv, "ethtool begin failed %d\n", ret);
-		pm_runtime_put_noidle(cpsw->dev);
-	}
 
 	return ret;
 }
-- 
2.34.1



