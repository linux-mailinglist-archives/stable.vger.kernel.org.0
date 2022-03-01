Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D811C4C95A7
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237702AbiCAUPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237719AbiCAUP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:15:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD88C77A86;
        Tue,  1 Mar 2022 12:14:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 518C9B81D0F;
        Tue,  1 Mar 2022 20:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39E3C340EF;
        Tue,  1 Mar 2022 20:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165682;
        bh=juecZkJ+lgMGyMxfnL3NZc+gJKSkICxxpn3nc4R/AEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQhEQHd9W9smJEGF6FPb9t6UYaSSmBPwYMCBnNmHoC/VpEemoM9KNYQgw1SG6X6+8
         ydVYFi4K8FARW+wOA1HTA1UgaYBSAZW30ZT9xx8HouqTJeMiyCSinkk4jWTUFH5ERd
         k2TVeAX04pjzppVyA2aG8OpNbAnFAepGS+rPvQc8/ehY32U61TLQFCuerBkC0Uqc5N
         b2QoPrgurMYlxG35/kprINAMQTx1c6BN/j2TAFURVXxZTjc/w/YvPQypscTdWqqE08
         TfC39grEITGunJgmLAvP1gv20jebzjT17Z9/Exy4TFYChCrp2pOS2ehUJCLqwxKuYc
         2XsaCm2oGwGnw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikhil Gupta <nikhil.gupta@nxp.com>, Rob Herring <robh@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        frowand.list@gmail.com, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 11/28] of/fdt: move elfcorehdr reservation early for crash dump kernel
Date:   Tue,  1 Mar 2022 15:13:16 -0500
Message-Id: <20220301201344.18191-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201344.18191-1-sashal@kernel.org>
References: <20220301201344.18191-1-sashal@kernel.org>
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

From: Nikhil Gupta <nikhil.gupta@nxp.com>

[ Upstream commit 132507ed04ce0c5559be04dd378fec4f3bbc00e8 ]

elfcorehdr_addr is fixed address passed to Second kernel which may be conflicted
with potential reserved memory in Second kernel,so fdt_reserve_elfcorehdr() ahead
of fdt_init_reserved_mem() can relieve this situation.

Signed-off-by: Nikhil Gupta <nikhil.gupta@nxp.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220128042321.15228-1-nikhil.gupta@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 7e868e5995b7e..f66abb496ed16 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -644,8 +644,8 @@ void __init early_init_fdt_scan_reserved_mem(void)
 	}
 
 	fdt_scan_reserved_mem();
-	fdt_init_reserved_mem();
 	fdt_reserve_elfcorehdr();
+	fdt_init_reserved_mem();
 }
 
 /**
-- 
2.34.1

