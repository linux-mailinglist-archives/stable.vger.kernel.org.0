Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7CA55D6CE
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244527AbiF1CaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244743AbiF1C1z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:27:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F5426100;
        Mon, 27 Jun 2022 19:25:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F16D61799;
        Tue, 28 Jun 2022 02:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB28C36AE2;
        Tue, 28 Jun 2022 02:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383153;
        bh=7k2kLI+LWAGXILLrGN3IgTWV98zgUQw3YiOqNApUtzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qECeJ2ClBJsRTzo95wjRtvR3I2ZQkljqodUfqrenx/H2rhp7l4PbXQuvzvrG+12C3
         tUtCt7/XKQNn9w+ItBiah1xqEbCSfmJ51J/mwruonwc8DSFamCkhbI16IU/lMI2Iqk
         8tcBu5+8WS4DBV0Q1grWCmYjPCPVaApp6I2c3L8jLtxKKoHTkwm/1A5GeMdV3eDDZl
         X+tgBRP1E/J94In4Dv/pyZ5aPux9tn+0r78bIEQQ2iWNQvgB+yGS8FOWHQ4xKeYT8w
         DC7JEntC6RPyHoWXwYEW2I+qpElimMvfIUcSyIvbp2kGnogtKq9Doxc7gzQ+PV/srV
         l3ZFC8EEVl77A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/22] mips: mti-malta: Fix refcount leak in malta-time.c
Date:   Mon, 27 Jun 2022 22:25:09 -0400
Message-Id: <20220628022518.596687-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022518.596687-1-sashal@kernel.org>
References: <20220628022518.596687-1-sashal@kernel.org>
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
index d22b7edc3886..d6f5dc822680 100644
--- a/arch/mips/mti-malta/malta-time.c
+++ b/arch/mips/mti-malta/malta-time.c
@@ -231,6 +231,8 @@ static void update_gic_frequency_dt(void)
 
 	if (of_update_property(node, &gic_frequency_prop) < 0)
 		pr_err("error updating gic frequency property\n");
+
+	of_node_put(node);
 }
 
 #endif
-- 
2.35.1

