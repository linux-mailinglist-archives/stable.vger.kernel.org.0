Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63532499B14
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453714AbiAXVta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456651AbiAXVjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D752C0613BB;
        Mon, 24 Jan 2022 12:25:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DC6261507;
        Mon, 24 Jan 2022 20:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DCBC340E5;
        Mon, 24 Jan 2022 20:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055927;
        bh=l1GAvzEWVH6/hFQyYtoaHujoAr9JDdP8GbTGP8GHEJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLrs4lxjo5aSGHuht/keMoQn8ISZsCHMbel6DFDDhEggb0C41nD3J0ZLmkfF9dpzo
         +b5e0521kzZzKkQP4q1u8D51GJhvjiXsGbs8pr5Bh7DW3xhwmLR6AywmqmvlYaJ39T
         zqzs7f9vboJrwS0R4i1lC5TmWAF5azMBbb54entc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kris Van Hees <kris.van.hees@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 312/846] bpf: Fix verifier support for validation of async callbacks
Date:   Mon, 24 Jan 2022 19:37:09 +0100
Message-Id: <20220124184111.677299704@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kris Van Hees <kris.van.hees@oracle.com>

[ Upstream commit a5bebc4f00dee47113eed48098c68e88b5ba70e8 ]

Commit bfc6bb74e4f1 ("bpf: Implement verifier support for validation of async callbacks.")
added support for BPF_FUNC_timer_set_callback to
the __check_func_call() function.  The test in __check_func_call() is
flaweed because it can mis-interpret a regular BPF-to-BPF pseudo-call
as a BPF_FUNC_timer_set_callback callback call.

Consider the conditional in the code:

	if (insn->code == (BPF_JMP | BPF_CALL) &&
	    insn->imm == BPF_FUNC_timer_set_callback) {

The BPF_FUNC_timer_set_callback has value 170.  This means that if you
have a BPF program that contains a pseudo-call with an instruction delta
of 170, this conditional will be found to be true by the verifier, and
it will interpret the pseudo-call as a callback.  This leads to a mess
with the verification of the program because it makes the wrong
assumptions about the nature of this call.

Solution: include an explicit check to ensure that insn->src_reg == 0.
This ensures that calls cannot be mis-interpreted as an async callback
call.

Fixes: bfc6bb74e4f1 ("bpf: Implement verifier support for validation of async callbacks.")
Signed-off-by: Kris Van Hees <kris.van.hees@oracle.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220105210150.GH1559@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7be72682dfda0..94f7f6ac136fb 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5785,6 +5785,7 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 	}
 
 	if (insn->code == (BPF_JMP | BPF_CALL) &&
+	    insn->src_reg == 0 &&
 	    insn->imm == BPF_FUNC_timer_set_callback) {
 		struct bpf_verifier_state *async_cb;
 
-- 
2.34.1



