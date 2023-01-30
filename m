Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E05681320
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237771AbjA3O2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237598AbjA3O2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:28:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372F240BD1
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:26:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEFDFB8117E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6BEC4339B;
        Mon, 30 Jan 2023 14:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088809;
        bh=Fs4O7yNNkJaVBuTo+BxpRGzHOGEJ8b9hW7bwfAVHSAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqmvsaPtvsE0214SP91fg5fMV8FPWH4nX3bdnXywJZMSPbZjvHQe8L6oPT9fh6mtb
         Z2e8n+vW3kzG/u6zv+CEhbVpzt62mTChgWGxXOb9k/G9FBllcpBIv2/I2S5nGoaQEp
         r0Vz0nP+ZcgV5U2fFBIJtY9nHXYj+ROgulTZWWwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Colin Ian King <colin.i.king@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ian Rogers <irogers@google.com>,
        Kim Phillips <kim.phillips@amd.com>
Subject: [PATCH 5.10 142/143] perf/x86/amd: fix potential integer overflow on shift of a int
Date:   Mon, 30 Jan 2023 14:53:19 +0100
Message-Id: <20230130134312.718915545@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
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
@@ -976,7 +976,7 @@ static int __init amd_core_pmu_init(void
 		 * numbered counter following it.
 		 */
 		for (i = 0; i < x86_pmu.num_counters - 1; i += 2)
-			even_ctr_mask |= 1 << i;
+			even_ctr_mask |= BIT_ULL(i);
 
 		pair_constraint = (struct event_constraint)
 				    __EVENT_CONSTRAINT(0, even_ctr_mask, 0,


