Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48C6499BCB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1576527AbiAXVzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452859AbiAXVtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:49:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A98C061774;
        Mon, 24 Jan 2022 12:33:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4A576153A;
        Mon, 24 Jan 2022 20:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C4DC340E5;
        Mon, 24 Jan 2022 20:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056411;
        bh=Adkz8tW47vbwofh7NrAPeUglOkNTCxORjd0loYPv954=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wzgf5WcSzqXTaHsYDZlsfxt57K2S3ATp3FzBB9EYT8zgONXms9blxpdbxXEYgWDqW
         McoZvO8LNfLzr6JfPHHe+6YqEjeBo48Pwda8sGc/b81hufoAFuN2q+xrhuh5M4FaeO
         oFgdP8jjxFSfFltk1JD1o0qTEiodqfcB5Ivt3O3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Hengqi Chen <hengqi.chen@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 468/846] selftests/bpf: Fix bpf_object leak in skb_ctx selftest
Date:   Mon, 24 Jan 2022 19:39:45 +0100
Message-Id: <20220124184117.135796081@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 8c7a95520184b6677ca6075e12df9c208d57d088 ]

skb_ctx selftest didn't close bpf_object implicitly allocated by
bpf_prog_test_load() helper. Fix the problem by explicitly calling
bpf_object__close() at the end of the test.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Hengqi Chen <hengqi.chen@gmail.com>
Link: https://lore.kernel.org/bpf/20211107165521.9240-10-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
index fafeddaad6a99..23915be6172d6 100644
--- a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
+++ b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
@@ -105,4 +105,6 @@ void test_skb_ctx(void)
 		   "ctx_out_mark",
 		   "skb->mark == %u, expected %d\n",
 		   skb.mark, 10);
+
+	bpf_object__close(obj);
 }
-- 
2.34.1



