Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF5C593E83
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345674AbiHOUoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347730AbiHOUnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:43:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF64B276E;
        Mon, 15 Aug 2022 12:08:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8FB2612D4;
        Mon, 15 Aug 2022 19:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A791AC433C1;
        Mon, 15 Aug 2022 19:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590482;
        bh=f2ZDIQR03Ul4WMl90N5wWSJrgIfPJ5LQWqEKoR7ldPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6qTJA4n/NZTxepLKBpsgyVxdRx9frFp/Ji1q2Z3Gx3HCiIvf3HCN2EWRL2ls3491
         uEjmTlWUUzmkdGOkAkOBwPM+aPrqEdaSJ2u5kyS97bgtsKooN98e2cyr5BOBFUrDGd
         pf+7luojfFJCdw13j8tcVNzAewiE0zP2+nUZDmBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsin-Yi Wang <hsinyi@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0274/1095] PM: domains: Ensure genpd_debugfs_dir exists before remove
Date:   Mon, 15 Aug 2022 19:54:33 +0200
Message-Id: <20220815180441.088467642@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit 37101d3c719386040ded735a5ec06974f1d94d1f ]

Both genpd_debug_add() and genpd_debug_remove() may be called
indirectly by other drivers while genpd_debugfs_dir is not yet
set. For example, drivers can call pm_genpd_init() in probe or
pm_genpd_init() in probe fail/cleanup path:

pm_genpd_init()
 --> genpd_debug_add()

pm_genpd_remove()
 --> genpd_remove()
   --> genpd_debug_remove()

At this time, genpd_debug_init() may not yet be called.

genpd_debug_add() checks that if genpd_debugfs_dir is NULL, it
will return directly. Make sure this is also checked
in pm_genpd_remove(), otherwise components under debugfs root
which has the same name as other components under pm_genpd may
be accidentally removed, since NULL represents debugfs root.

Fixes: 718072ceb211 ("PM: domains: create debugfs nodes when adding power domains")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/domain.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index f0e4b0ea93e8..59a706a126e5 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -219,6 +219,9 @@ static void genpd_debug_remove(struct generic_pm_domain *genpd)
 {
 	struct dentry *d;
 
+	if (!genpd_debugfs_dir)
+		return;
+
 	d = debugfs_lookup(genpd->name, genpd_debugfs_dir);
 	debugfs_remove(d);
 }
-- 
2.35.1



