Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627025920E5
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240597AbiHNPcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240535AbiHNPbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:31:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6641AD9C;
        Sun, 14 Aug 2022 08:29:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DB2D60C48;
        Sun, 14 Aug 2022 15:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB282C433B5;
        Sun, 14 Aug 2022 15:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660490980;
        bh=lNsKvYULFuuzdlBwjeh6X66QvKsJxp5dxnGGth5+T8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQtuE5VYSZslodre0dKCxn5HdtHmzz1a2sXuMEbx3P6em4JDXooEOR7iHcehAO/H8
         o7KnxoyYUfqMmNSKnyRzeSVolj+5grAr4uVndxY8mQTM7Jcaf1dLOpIn3cCn6S7nuj
         zfk0WCvmg96+7aOQH1i4hFUIBR4+mt+uS3j08cNj+XtKMHEbKe59lkhtVT0Ucr5qca
         0+dmeGUgNTrdcoDlXFSp6fKwRipiH4Yt/I71n/1mcP0b6QLQRE12K4PYZiasP6jvM+
         TtpGIeCWVR5vhdH/LlrIZFmIKB4tuDAbIZKb1cm4I35wdxB6AwMekwroGVa/2XdqZp
         3rOtASZRwVjIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Frank Rowand <frank.rowand@sony.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        pantelis.antoniou@konsulko.com, frowand.list@gmail.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 43/64] of: overlay: Move devicetree_corrupt() check up
Date:   Sun, 14 Aug 2022 11:24:16 -0400
Message-Id: <20220814152437.2374207-43-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814152437.2374207-1-sashal@kernel.org>
References: <20220814152437.2374207-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

