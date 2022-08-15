Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBFE593844
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240115AbiHOSmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240650AbiHOSjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:39:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26262E693;
        Mon, 15 Aug 2022 11:24:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F0C960F23;
        Mon, 15 Aug 2022 18:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0540BC433C1;
        Mon, 15 Aug 2022 18:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587846;
        bh=fRAAddhRsAHDwptBTq1uHqpI89s3n65ppRpfsul8gAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yBjuSUx/c9QI5hhGh43fWq503vQ5wRh5PydkZp6+WTnfHFCt2HWVFvfzv0bOhYEWH
         7Memzk8QwfwPBAAtDaeSWrfcEI24fCOxeXn/NDqeMAMKgETv0VsYW5jSIfw80P+rYw
         ETpek1tZIZAFL4ld8qjDziTj+dEn3MeJvRnb0Hz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsin-Yi Wang <hsinyi@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 213/779] PM: domains: Ensure genpd_debugfs_dir exists before remove
Date:   Mon, 15 Aug 2022 19:57:37 +0200
Message-Id: <20220815180346.383118585@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 0f2e42f36851..7f3d21e6fdfb 100644
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



