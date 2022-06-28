Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435F555E04D
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243740AbiF1CVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243474AbiF1CVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:21:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D51B2317E;
        Mon, 27 Jun 2022 19:20:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC0FEB81C13;
        Tue, 28 Jun 2022 02:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22DEC385A2;
        Tue, 28 Jun 2022 02:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382826;
        bh=MVgsXYgKxdtiUeIZMEQepRiLIPoup1Qr84Viy2AMcLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2Cxa212kVEk6ppzhJpbkFYim7WXGm6tsB4DrDfGLN6isEeyTwpF7A8t3YKHBBHUp
         UgGJf9WprTg2AnVS/Lv58BC3sqWsOA0SbrgEaJUGkFt314f6/yzR7XE9glf6hFl1S0
         0AgGbSoPYMGerZSZmi777V5eLfrWVrCl5vz6E6IvrnBF7ZhfWgRm7qUBcWYYMP70il
         LI+oqNTxLA2HpbQwOkQ7lW69ukWVDzMc7sURr1533rlvVLqja/vXRO597XEYgJsCcS
         nxky4Zv+IJWkOrR9Lg1RcYGCkVcbL4Uq/8o/jmOIeWQYT/UlN1Nr0Usn0Pvq/3crJv
         HqM+h74gZA5AA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 41/53] mips: ralink: Fix refcount leak in of.c
Date:   Mon, 27 Jun 2022 22:18:27 -0400
Message-Id: <20220628021839.594423-41-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 48ca54e39173d1ed4c4dc8cf045484014bb26eaf ]

In plat_of_remap_node(), plat_of_remap_node() will return a node
pointer with refcount incremented. We should use of_node_put()
when it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/ralink/of.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/ralink/of.c b/arch/mips/ralink/of.c
index 587c7b998769..ea8072acf8d9 100644
--- a/arch/mips/ralink/of.c
+++ b/arch/mips/ralink/of.c
@@ -40,6 +40,8 @@ __iomem void *plat_of_remap_node(const char *node)
 	if (of_address_to_resource(np, 0, &res))
 		panic("Failed to get resource for %s", node);
 
+	of_node_put(np);
+
 	if (!request_mem_region(res.start,
 				resource_size(&res),
 				res.name))
-- 
2.35.1

