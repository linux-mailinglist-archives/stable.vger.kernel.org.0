Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A1C594810
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240242AbiHOXHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241419AbiHOXD4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:03:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B28C86065;
        Mon, 15 Aug 2022 12:58:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0828B612AC;
        Mon, 15 Aug 2022 19:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0FEC433D6;
        Mon, 15 Aug 2022 19:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593508;
        bh=rO6j8LMjktGpC8KRSmNNYA45x/kxmmEIE5Y/UjH+cug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvUQPq233F+z6aGmtcp4PapZngqQdikSOvAgkAtKvPyoIcIgWIyJRbvXHPX9iP8sK
         awzOkQVG9L7iwx7Ha+oMGi+7Hsjmp1augc40jMxOxKQ/JN/8f/ycGvwYJ6cdw41gHi
         Uvb3a8u8G5am0yTTeqY+0crgXPgDAvP584JXwoSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0280/1157] regulator: of: Fix refcount leak bug in of_get_regulation_constraints()
Date:   Mon, 15 Aug 2022 19:53:56 +0200
Message-Id: <20220815180450.809683939@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit 66efb665cd5ad69b27dca8571bf89fc6b9c628a4 ]

We should call the of_node_put() for the reference returned by
of_get_child_by_name() which has increased the refcount.

Fixes: 40e20d68bb3f ("regulator: of: Add support for parsing regulator_state for suspend state")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220715111027.391032-1-windhl@126.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/of_regulator.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index f54d4f176882..e12b681c72e5 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -264,8 +264,12 @@ static int of_get_regulation_constraints(struct device *dev,
 		}
 
 		suspend_np = of_get_child_by_name(np, regulator_states[i]);
-		if (!suspend_np || !suspend_state)
+		if (!suspend_np)
 			continue;
+		if (!suspend_state) {
+			of_node_put(suspend_np);
+			continue;
+		}
 
 		if (!of_property_read_u32(suspend_np, "regulator-mode",
 					  &pval)) {
-- 
2.35.1



