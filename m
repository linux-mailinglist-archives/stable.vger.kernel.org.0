Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC474EF362
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349638AbiDAPHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349964AbiDAO61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:58:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCCD1760E1;
        Fri,  1 Apr 2022 07:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AC3660A53;
        Fri,  1 Apr 2022 14:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25698C3410F;
        Fri,  1 Apr 2022 14:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824340;
        bh=BPY4iL0mfZ8AciSKgUHRdxdkSURMUlxvIQOFjDnHAw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fHcs0wIgLxan+ZvEd3iniLDFuOv1h/x8cSMaQyFVXY/Opq8I5MEcmN5ukX63J5VSx
         JHgjjYLcxU/MhrloNSSI4OeQ2EODP1shiBtEzZIpKtc0mz4UilImkevPm0ZwqTJNTG
         rGOpYciHZbP+vUdMSLG9GDsbudK8Mfthr1v5OUxOeHWt0OJMeuQQtAf7gFn5LRETNI
         E3erBDsPkhP8tqsuojLjYtwEjJYW9bg1kcvxF/eKek6mwh/k7U5kUVZMIdegb9f9hr
         W1MNuKDujv6r7sQjM2U5EIqdwhCsGw/2rq/7VnfS2wt3mN+tXIAa6b+oFAI0eqdMjQ
         COXw1UVtS0lvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 24/37] mips: ralink: fix a refcount leak in ill_acc_of_setup()
Date:   Fri,  1 Apr 2022 10:44:33 -0400
Message-Id: <20220401144446.1954694-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144446.1954694-1-sashal@kernel.org>
References: <20220401144446.1954694-1-sashal@kernel.org>
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
index 0ddeb31afa93..45ca2b84f096 100644
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

