Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D29A55D7FF
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbiF0L3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235085AbiF0L25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:28:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25F69FC7;
        Mon, 27 Jun 2022 04:27:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E81661366;
        Mon, 27 Jun 2022 11:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92029C3411D;
        Mon, 27 Jun 2022 11:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329260;
        bh=0u83o4b8jqVxJj96kjDZk5MoeLJqvngsmEsDtEas6KE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqnuVxpLB5lWpzza5r1IoAwjtAOvOoaKJ9PepWMIOdFUwz3O6qSoaDf9CiK340Zno
         eSwWonxUL8wbsd0/SXZPL2prZR/Qu6kRpCsdDWuIYfMfbvB3Xg2znzP6yd2rpH30m7
         nE4bD9Vw8wtdIMb6bzVj9alRILrxHdMoHkv6ODXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.10 086/102] xtensa: Fix refcount leak bug in time.c
Date:   Mon, 27 Jun 2022 13:21:37 +0200
Message-Id: <20220627111936.017437780@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit a0117dc956429f2ede17b323046e1968d1849150 upstream.

In calibrate_ccount(), of_find_compatible_node() will return a node
pointer with refcount incremented. We should use of_node_put() when
it is not used anymore.

Cc: stable@vger.kernel.org
Signed-off-by: Liang He <windhl@126.com>
Message-Id: <20220617124432.4049006-1-windhl@126.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/kernel/time.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -154,6 +154,7 @@ static void __init calibrate_ccount(void
 	cpu = of_find_compatible_node(NULL, NULL, "cdns,xtensa-cpu");
 	if (cpu) {
 		clk = of_clk_get(cpu, 0);
+		of_node_put(cpu);
 		if (!IS_ERR(clk)) {
 			ccount_freq = clk_get_rate(clk);
 			return;


