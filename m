Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2650B55D528
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237016AbiF0LnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237174AbiF0Lmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7BFDF00;
        Mon, 27 Jun 2022 04:36:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37DCFB8111D;
        Mon, 27 Jun 2022 11:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92949C3411D;
        Mon, 27 Jun 2022 11:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329783;
        bh=0u83o4b8jqVxJj96kjDZk5MoeLJqvngsmEsDtEas6KE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6j8SH/EE/IQFyb3N2zWJ7Ojrj5nDsW7tePLLTLZPDV9+aJiHXI+bGnnnt2uc5L6U
         Wf6oINjS2fCoNhBpscK+xA1UGb6AogkgAdE3Z2pW/rhewg2g3qqQ1DNPQw/EMM5V95
         kxOAGYqedm1NxMjr1xLGPRoichXw99QkNcTRgimM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.15 113/135] xtensa: Fix refcount leak bug in time.c
Date:   Mon, 27 Jun 2022 13:22:00 +0200
Message-Id: <20220627111941.432898235@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
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


