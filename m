Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D3B6CC499
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbjC1PGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbjC1PGZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:06:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB50EB7A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:05:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFA566184B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DF8C4339C;
        Tue, 28 Mar 2023 15:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015912;
        bh=86f1pvuyY5a/USY7jbAohKe72v3zX8VEGSpnECTcB30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/XxsETCRGFHpjM8CIvi/IJL0tdtl4XXiphRHa+0m1kKQF21Pxu5Ti6rFVxBiF4//
         lGd32IU6218vTY69rBVsZx2aa8bWwMPCJmlppB2UQGzCfeD8LkttfDrTmTvK47SnkY
         MojSFuLPK3CKYZj88dPkgzXKvHgF6fjdsXgXB2dQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ivan Bornyakov <i.bornyakov@metrotek.ru>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.1 214/224] bus: imx-weim: fix branch condition evaluates to a garbage value
Date:   Tue, 28 Mar 2023 16:43:30 +0200
Message-Id: <20230328142626.255823898@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Bornyakov <i.bornyakov@metrotek.ru>

commit 1adab2922c58e7ff4fa9f0b43695079402cce876 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/imx-weim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bus/imx-weim.c
+++ b/drivers/bus/imx-weim.c
@@ -204,8 +204,8 @@ static int weim_parse_dt(struct platform
 	const struct of_device_id *of_id = of_match_device(weim_id_table,
 							   &pdev->dev);
 	const struct imx_weim_devtype *devtype = of_id->data;
+	int ret = 0, have_child = 0;
 	struct device_node *child;
-	int ret, have_child = 0;
 	struct weim_priv *priv;
 	void __iomem *base;
 	u32 reg;


