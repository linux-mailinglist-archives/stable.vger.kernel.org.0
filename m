Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6803659D7D6
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344548AbiHWJRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347542AbiHWJPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:15:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437646DAE1;
        Tue, 23 Aug 2022 01:32:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79B4CB81C4D;
        Tue, 23 Aug 2022 08:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B204CC433C1;
        Tue, 23 Aug 2022 08:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243528;
        bh=lNsKvYULFuuzdlBwjeh6X66QvKsJxp5dxnGGth5+T8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhYs0J5YdFDA1qT2WLL/asf73ma/wDOmYHoPNv55wDFj+iBFz1vJVI2E92eQpGidg
         YhS3D8W1WVSvkRe+ce7qrpBWSlzwc4KTL5XI0ZI176B32kXNbLjxrqedRQgbGSY5hi
         Bocct2XlUHUyo9gYn3oCEFPlDJvgz+DoKkO17KpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Frank Rowand <frank.rowand@sony.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 298/365] of: overlay: Move devicetree_corrupt() check up
Date:   Tue, 23 Aug 2022 10:03:19 +0200
Message-Id: <20220823080130.638816561@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit e385b0ba6a137f34953e746d70d543660c2de1a0 ]

There is no point in doing several preparatory steps in
of_overlay_fdt_apply(), only to see of_overlay_apply() return early
because of a corrupt device tree.

Move the check for a corrupt device tree from of_overlay_apply() to
of_overlay_fdt_apply(), to check for this as early as possible.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Frank Rowand <frank.rowand@sony.com>
Tested-by: Frank Rowand <frank.rowand@sony.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/c91ce7112eb5167ea46a43d8a980e76b920010ba.1657893306.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/overlay.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index 4044ddcb02c6..84a8d402009c 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -903,12 +903,6 @@ static int of_overlay_apply(struct overlay_changeset *ovcs)
 {
 	int ret = 0, ret_revert, ret_tmp;
 
-	if (devicetree_corrupt()) {
-		pr_err("devicetree state suspect, refuse to apply overlay\n");
-		ret = -EBUSY;
-		goto out;
-	}
-
 	ret = of_resolve_phandles(ovcs->overlay_root);
 	if (ret)
 		goto out;
@@ -983,6 +977,11 @@ int of_overlay_fdt_apply(const void *overlay_fdt, u32 overlay_fdt_size,
 
 	*ret_ovcs_id = 0;
 
+	if (devicetree_corrupt()) {
+		pr_err("devicetree state suspect, refuse to apply overlay\n");
+		return -EBUSY;
+	}
+
 	if (overlay_fdt_size < sizeof(struct fdt_header) ||
 	    fdt_check_header(overlay_fdt)) {
 		pr_err("Invalid overlay_fdt header\n");
-- 
2.35.1



