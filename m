Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774EE55D7FC
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243536AbiF1CVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243610AbiF1CVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:21:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74DA24BF2;
        Mon, 27 Jun 2022 19:20:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72BADB81C0B;
        Tue, 28 Jun 2022 02:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80271C34115;
        Tue, 28 Jun 2022 02:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382825;
        bh=cNWXwd3nFvahHzVuU+BPWzeymECLibRGiyZaoGJs7c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uhy3tTznobJa03bhal1j3ETJwwgHA9m3kM78EvX6NPUfBCcaOEdChBN3FE/ufD8Gg
         S/Y0I7+tR4YaIWkExv7GH4zvc80pUcUD5PPLm3Vf3zEIuxw/b0fj+zyZxbYmHs5JZz
         /7LHghQfKe6Zt44bJPl2lm7zcIZKd6hWtDy7BDmEgcaNexVmiCJ4D1jGvHacAV2Afi
         gsDBXK7ZLlsKZ9W24sqoV2iUu6UdY9mQV9iy+rMf91aRy1eBZYJLszD0THy1PJ4Hda
         6ZpRxHshClv9ae3GlPSrgezkFMt4H+LyI7xbSnqcbSWHdOcOjczUkH4xLDnyofAbyQ
         XAD6B5VWeiBHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 40/53] mips: mti-malta: Fix refcount leak in malta-time.c
Date:   Mon, 27 Jun 2022 22:18:26 -0400
Message-Id: <20220628021839.594423-40-sashal@kernel.org>
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

