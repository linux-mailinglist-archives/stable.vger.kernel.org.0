Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6BD4EF0E4
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347711AbiDAOfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348220AbiDAOdu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:33:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A97A1EB83B;
        Fri,  1 Apr 2022 07:31:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECE8961CD6;
        Fri,  1 Apr 2022 14:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF67C36AE7;
        Fri,  1 Apr 2022 14:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823479;
        bh=a3sH1FXWEsqzAR7EqetbE0Xg8y7tDvMLkEatyCxM4Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGYKVH1efYuLhUNqOSE/nKdXNq6LfpTjISDkLrh0+JgR8JTOeMY3HjoYaJpuGZTby
         scG+oc91Bd40ngMPIpHEyzN5WvseBLaSGl/wx4fxoKEYA4806lJQ4qlDU/npsgPlvy
         ycqPUeUEBfJta4riL+YmgAFWie7sV9XkGSEbVtXd5JsYvBis8cEpHq4IxYitNpD8Ej
         00EYGBs6g4HsHSwS9U6WCzBHUBpiKSY4TavKFr6AM2J9Fu0ICJ1UvF5RXTejCl8CmB
         rE8J5Bj9dlcYILFP/zcU+1AfVyrD5PAOI8JJHnayGwS7PIz0CNYR+JHmX2A8iQHnlu
         nMAWaEH2gVg0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 110/149] mips: ralink: fix a refcount leak in ill_acc_of_setup()
Date:   Fri,  1 Apr 2022 10:24:57 -0400
Message-Id: <20220401142536.1948161-110-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 4a0a1436053b17e50b7c88858fb0824326641793 ]

of_node_put(np) needs to be called when pdev == NULL.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/ralink/ill_acc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/ralink/ill_acc.c b/arch/mips/ralink/ill_acc.c
index 115a69fc20ca..f395ae218470 100644
--- a/arch/mips/ralink/ill_acc.c
+++ b/arch/mips/ralink/ill_acc.c
@@ -61,6 +61,7 @@ static int __init ill_acc_of_setup(void)
 	pdev = of_find_device_by_node(np);
 	if (!pdev) {
 		pr_err("%pOFn: failed to lookup pdev\n", np);
+		of_node_put(np);
 		return -EINVAL;
 	}
 
-- 
2.34.1

