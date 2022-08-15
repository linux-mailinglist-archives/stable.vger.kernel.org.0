Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C90A594741
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243968AbiHOX2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245630AbiHOXZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:25:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5332804BF;
        Mon, 15 Aug 2022 13:06:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67A60B80EA9;
        Mon, 15 Aug 2022 20:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AF3C433D6;
        Mon, 15 Aug 2022 20:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593971;
        bh=7tARl1TSUtB1EY1AcMUAeuoi5nZ03zGTLEJW5dprqRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAZ++Ns56R8X5/BFl89RKywzrcHgEWOAn1cWiPZIe6WiPFAhg2vSQVt0tttjss7/j
         3n1bYFnxmKdv56EBthkFuoLm2IAQgtvp2FN0R694lhNmqkkeUoKSJ9N7Vkl/Rz2Anb
         MkdQr4GAnSA3ZjQM/rEJLyQBH+mfguKMymTwk3Mk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1036/1095] s390/unwind: fix fgraph return address recovery
Date:   Mon, 15 Aug 2022 20:07:15 +0200
Message-Id: <20220815180511.945321111@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

[ Upstream commit ded466e1806686794b403ebf031133bbaca76bb2 ]

When HAVE_FUNCTION_GRAPH_RET_ADDR_PTR is defined, the return
address to the fgraph caller is recovered by tagging it along with the
stack pointer of ftrace stack. This makes the stack unwinding more
reliable.

When the fgraph return address is modified to return_to_handler,
ftrace_graph_ret_addr tries to restore it to the original
value using tagged stack pointer.

Fix this by passing tagged sp to ftrace_graph_ret_addr.

Fixes: d81675b60d09 ("s390/unwind: recover kretprobe modified return address in stacktrace")
Cc: <stable@vger.kernel.org> # 5.18
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/unwind.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/unwind.h b/arch/s390/include/asm/unwind.h
index 0bf06f1682d8..02462e7100c1 100644
--- a/arch/s390/include/asm/unwind.h
+++ b/arch/s390/include/asm/unwind.h
@@ -47,7 +47,7 @@ struct unwind_state {
 static inline unsigned long unwind_recover_ret_addr(struct unwind_state *state,
 						    unsigned long ip)
 {
-	ip = ftrace_graph_ret_addr(state->task, &state->graph_idx, ip, NULL);
+	ip = ftrace_graph_ret_addr(state->task, &state->graph_idx, ip, (void *)state->sp);
 	if (is_kretprobe_trampoline(ip))
 		ip = kretprobe_find_ret_addr(state->task, (void *)state->sp, &state->kr_cur);
 	return ip;
-- 
2.35.1



