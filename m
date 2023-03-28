Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFFC06CBF5D
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 14:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbjC1Mkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 08:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbjC1Mki (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 08:40:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225D4A269
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 05:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3464B81C1E
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 12:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25007C433EF;
        Tue, 28 Mar 2023 12:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680007199;
        bh=+kSIgOq/e6m1orM9Qhc6dKcs9suGC2l12nYq+vQLCJg=;
        h=Subject:To:Cc:From:Date:From;
        b=d0WkZoNJwM5EQn2GYpa7m8+T2khIpvrxFAFVlNJe5d2hLphMN9O8FgxaMZj2UItKV
         BCdiaAm5rRKr8bWT5/3ymCGHmBtTzfzWDv8uUlwH9/a0dQnoY0Hw9g8LxJir+woRBR
         8NWxPNnxI5+c2XhpsS0F841W/XsLKbbZrb0SYSoE=
Subject: FAILED: patch "[PATCH] bus: imx-weim: fix branch condition evaluates to a garbage" failed to apply to 5.10-stable tree
To:     i.bornyakov@metrotek.ru, festevam@gmail.com, shawnguo@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 14:39:54 +0200
Message-ID: <168000719457118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 1adab2922c58e7ff4fa9f0b43695079402cce876
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '168000719457118@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

1adab2922c58 ("bus: imx-weim: fix branch condition evaluates to a garbage value")
e6cb5408289f ("bus: imx-weim: add DT overlay support for WEIM bus")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1adab2922c58e7ff4fa9f0b43695079402cce876 Mon Sep 17 00:00:00 2001
From: Ivan Bornyakov <i.bornyakov@metrotek.ru>
Date: Mon, 6 Mar 2023 16:25:26 +0300
Subject: [PATCH] bus: imx-weim: fix branch condition evaluates to a garbage
 value

If bus type is other than imx50_weim_devtype and have no child devices,
variable 'ret' in function weim_parse_dt() will not be initialized, but
will be used as branch condition and return value. Fix this by
initializing 'ret' with 0.

This was discovered with help of clang-analyzer, but the situation is
quite possible in real life.

Fixes: 52c47b63412b ("bus: imx-weim: improve error handling upon child probe-failure")
Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc: stable@vger.kernel.org
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>

diff --git a/drivers/bus/imx-weim.c b/drivers/bus/imx-weim.c
index 2a6b4f676458..36d42484142a 100644
--- a/drivers/bus/imx-weim.c
+++ b/drivers/bus/imx-weim.c
@@ -204,8 +204,8 @@ static int weim_parse_dt(struct platform_device *pdev)
 	const struct of_device_id *of_id = of_match_device(weim_id_table,
 							   &pdev->dev);
 	const struct imx_weim_devtype *devtype = of_id->data;
+	int ret = 0, have_child = 0;
 	struct device_node *child;
-	int ret, have_child = 0;
 	struct weim_priv *priv;
 	void __iomem *base;
 	u32 reg;

