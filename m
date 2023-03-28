Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC20D6CBF5E
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 14:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbjC1Mkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 08:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbjC1Mkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 08:40:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E274C9EFA
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 05:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57588B81CA2
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 12:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE182C433D2;
        Tue, 28 Mar 2023 12:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680007202;
        bh=17b2SvD6DQSxPphEXuYXsBpvcoQ/yY0EpGnj8JiwgPc=;
        h=Subject:To:Cc:From:Date:From;
        b=D7Zt7/UbkHJhdW4ErJbhhXBVtncECtr+H1YIeClcGe7VfORItbvN3tLVWclyRkFOF
         sxPY9vSBFWlj7d2OGniF+655RE0KLrQ/LoD+pq+0NOIG+oN1SFzPfrkxERjs+LvnNM
         HCunYknAg1PxLQMfzC4Z2eF+PivqxLNGLp57vQdo=
Subject: FAILED: patch "[PATCH] bus: imx-weim: fix branch condition evaluates to a garbage" failed to apply to 4.19-stable tree
To:     i.bornyakov@metrotek.ru, festevam@gmail.com, shawnguo@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 14:39:55 +0200
Message-ID: <16800071954128@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x 1adab2922c58e7ff4fa9f0b43695079402cce876
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16800071954128@kroah.com' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

1adab2922c58 ("bus: imx-weim: fix branch condition evaluates to a garbage value")
e6cb5408289f ("bus: imx-weim: add DT overlay support for WEIM bus")
3b1261fb72c7 ("bus: imx-weim: remove incorrect __init annotations")
4a92f07816ba ("bus: imx-weim: use module_platform_driver()")
77266e722fea ("bus: imx-weim: optionally enable burst clock mode")
c7995bcb36ef ("bus: imx-weim: guard against timing configuration conflicts")
8b8cb52af34d ("bus: imx-weim: support multiple address ranges per child node")
b1a23445364d ("bus: imx-weim: drop unnecessary DT node name NULL check")

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

