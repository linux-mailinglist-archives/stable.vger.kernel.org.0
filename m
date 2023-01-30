Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617456810FD
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237146AbjA3OJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjA3OJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:09:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43618303E7
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:09:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D432561083
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B55C433D2;
        Mon, 30 Jan 2023 14:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087752;
        bh=kvdoUrQJvrPeZnMH1863X/Nxidy+MGmJm9pXOFZTgg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rVg/06/JccUGqP6ft1sbAp0Y8i0UaphQs2JQRgaqWYkT5xdK46WPbmZj9CZAhgeCM
         ZpijZIU4zWwuZteVxNcSbh1TiqyuUl7ioQhqnXMWC6JJOaXM8s0sjKjx2d1YIcBPm3
         vH8YKT8YCiALQVqzm8N7HBdDnCO3mYj2Sul4R6t0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Colin Ian King <colin.i.king@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ian Rogers <irogers@google.com>,
        Kim Phillips <kim.phillips@amd.com>
Subject: [PATCH 6.1 313/313] perf/x86/amd: fix potential integer overflow on shift of a int
Date:   Mon, 30 Jan 2023 14:52:28 +0100
Message-Id: <20230130134351.326412106@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.i.king@gmail.com>

commit 08245672cdc6505550d1a5020603b0a8d4a6dcc7 upstream.

The left shift of int 32 bit integer constant 1 is evaluated using 32 bit
arithmetic and then passed as a 64 bit function argument. In the case where
i is 32 or more this can lead to an overflow.  Avoid this by shifting
using the BIT_ULL macro instead.

Fixes: 471af006a747 ("perf/x86/amd: Constrain Large Increment per Cycle events")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Ian Rogers <irogers@google.com>
Acked-by: Kim Phillips <kim.phillips@amd.com>
Link: https://lore.kernel.org/r/20221202135149.1797974-1-colin.i.king@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/amd/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -1387,7 +1387,7 @@ static int __init amd_core_pmu_init(void
 		 * numbered counter following it.
 		 */
 		for (i = 0; i < x86_pmu.num_counters - 1; i += 2)
-			even_ctr_mask |= 1 << i;
+			even_ctr_mask |= BIT_ULL(i);
 
 		pair_constraint = (struct event_constraint)
 				    __EVENT_CONSTRAINT(0, even_ctr_mask, 0,


