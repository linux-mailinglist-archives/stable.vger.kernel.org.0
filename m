Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8731255DBD9
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244066AbiF1CXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244067AbiF1CWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:22:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB410252B3;
        Mon, 27 Jun 2022 19:22:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BB54B808C0;
        Tue, 28 Jun 2022 02:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C015C341CA;
        Tue, 28 Jun 2022 02:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382930;
        bh=cNWXwd3nFvahHzVuU+BPWzeymECLibRGiyZaoGJs7c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oghlXhimPgBtMIcE1a9oeQzISlnKIDiBLGH2yi8RxOqzyO7uE3KVnvGzMxd1f22qw
         Iy/sm2X80Zxiu47s+TEr4FNK4D7ZqvSGUf58qxR8FvQoqv1dQmG5GeNTwyzC505eBK
         mhCiyg6NcbboEPSceIyH9uyeysWpq3NEqhUR4Zezisv2BvWyqjGP6Ihfmw3+BpTnNW
         9EpwaoAAhUqS1cG01KK29GIZkI51BCUw/MCMSSLrHFPkv+7ce4Xp6ViYlI4a9j8XEE
         BKVb7BG3Zn5gIds45v83+46RlQJOGOHzHpJtAfmrB29+NYLPMeR3Za7xNoYZ1LvTPU
         WcGJSzQU0ljvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 28/41] mips: mti-malta: Fix refcount leak in malta-time.c
Date:   Mon, 27 Jun 2022 22:20:47 -0400
Message-Id: <20220628022100.595243-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022100.595243-1-sashal@kernel.org>
References: <20220628022100.595243-1-sashal@kernel.org>
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

[ Upstream commit 608d94cb84c42585058d692f2fe5d327f8868cdb ]

In update_gic_frequency_dt(), of_find_compatible_node() will return
a node pointer with refcount incremented. We should use of_node_put()
when it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mti-malta/malta-time.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/mti-malta/malta-time.c b/arch/mips/mti-malta/malta-time.c
index bbf1e38e1431..2cb708cdf01a 100644
--- a/arch/mips/mti-malta/malta-time.c
+++ b/arch/mips/mti-malta/malta-time.c
@@ -214,6 +214,8 @@ static void update_gic_frequency_dt(void)
 
 	if (of_update_property(node, &gic_frequency_prop) < 0)
 		pr_err("error updating gic frequency property\n");
+
+	of_node_put(node);
 }
 
 #endif
-- 
2.35.1

