Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61C153A6C6
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353693AbiFANzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353706AbiFANzX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:55:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C76C8CB38;
        Wed,  1 Jun 2022 06:54:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6B6E9CE1A1E;
        Wed,  1 Jun 2022 13:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7642C385A5;
        Wed,  1 Jun 2022 13:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091636;
        bh=ctIJdYl0vlNt157giC31wNXX7wsg81SlduRBQ1uUmGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9+Vc4PBtN7MloQ9mUsfLBfaHAkG58FRjOQaqSt9yCFuD8w4zE0MWnPENzMScYGDe
         lSMp4yVvEA81gkgCt+ClS7rt9oJFDirycqKbwA/7OKoQY7eKWKf4ecz1D76uFEmjAo
         f1be02F5zaqjNSdQx2yX28TrqRsE5uG1RKjQXFhMAS9H8fmNRx1pHokg9uy4RSnE+i
         udaaAnC100B9zB2GUUPkriQdqEJFIcWeDsbtrgXq1lYReKsiv4i+P2Jk853KPmiedN
         sLBm2PrW5WW3MqrU6fycK9Cco1MnPHDTTl74qwMJNx+M+YAKAldYVRt7xsx3ORkRiu
         +ONk6Bpc6D7ww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, nick.child@ibm.com,
        maz@kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.18 40/49] powerpc/xics: fix refcount leak in icp_opal_init()
Date:   Wed,  1 Jun 2022 09:52:04 -0400
Message-Id: <20220601135214.2002647-40-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135214.2002647-1-sashal@kernel.org>
References: <20220601135214.2002647-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

[ Upstream commit 5dd9e27ea4a39f7edd4bf81e9e70208e7ac0b7c9 ]

The of_find_compatible_node() function returns a node pointer with
refcount incremented, use of_node_put() on it when done.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220402013419.2410298-1-lv.ruyi@zte.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xics/icp-opal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/sysdev/xics/icp-opal.c b/arch/powerpc/sysdev/xics/icp-opal.c
index bda4c32582d9..4dae624b9f2f 100644
--- a/arch/powerpc/sysdev/xics/icp-opal.c
+++ b/arch/powerpc/sysdev/xics/icp-opal.c
@@ -196,6 +196,7 @@ int __init icp_opal_init(void)
 
 	printk("XICS: Using OPAL ICP fallbacks\n");
 
+	of_node_put(np);
 	return 0;
 }
 
-- 
2.35.1

