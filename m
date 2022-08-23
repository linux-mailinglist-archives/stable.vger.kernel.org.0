Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D579959D520
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbiHWJCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241632AbiHWJBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:01:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6077E233;
        Tue, 23 Aug 2022 01:28:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C29D61326;
        Tue, 23 Aug 2022 08:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305CAC433D7;
        Tue, 23 Aug 2022 08:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243236;
        bh=gFrB6xe1KXgTAI+7ObVJ1Fp1IKo64uT9FKvA9uEdWR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obk91VtWGTwE/3sfnlOD/ZS+mtx4agY5M2nX/ptsDJcWUKyb/1Z9L3hfiJA2A316t
         7eEICRcmDnAYFTSVg/yjwUemY04ur/hfSztWknw3E/b0mtYdGavTE389o9kBiovxWs
         8g8eGeQ+kF2jJefPrKObzRbw9ZalzwLI2UL1p0xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 213/365] net: sched: fix misuse of qcpu->backlog in gnet_stats_add_queue_cpu
Date:   Tue, 23 Aug 2022 10:01:54 +0200
Message-Id: <20220823080127.120619852@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

commit de64b6b6fb6f369840d171b7c5a9baf31b8b2630 upstream.

In the gnet_stats_add_queue_cpu function, the qstats->qlen statistics
are incorrectly set to qcpu->backlog.

Fixes: 448e163f8b9b ("gen_stats: Add gnet_stats_add_queue()")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20220815030848.276746-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/gen_stats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -345,7 +345,7 @@ static void gnet_stats_add_queue_cpu(str
 	for_each_possible_cpu(i) {
 		const struct gnet_stats_queue *qcpu = per_cpu_ptr(q, i);
 
-		qstats->qlen += qcpu->backlog;
+		qstats->qlen += qcpu->qlen;
 		qstats->backlog += qcpu->backlog;
 		qstats->drops += qcpu->drops;
 		qstats->requeues += qcpu->requeues;


