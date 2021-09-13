Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0010409246
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244294AbhIMOKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344735AbhIMOHW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:07:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08C0661A83;
        Mon, 13 Sep 2021 13:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540440;
        bh=78ojPiQPyowEygpwF1GjuFOvhHMCaKV6fWIha8VPLXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3bjD6AhfPAHUwfamwKjeLLeivAA6BuzH9GwrMBPGQ/C9US/Vy4ipYG4p8koHTnG3
         Qy2F90kqfe1B3oUJyfzRjncwbqTKNjDBjI31WzPZzLNjdcnRnavvdi/nVW1ZnOUZtS
         r4JE0ycepLYWJ/D/Ra0xjUYjbFo8GbCbWo7vlMwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jose Blanquicet <josebl@microsoft.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 162/300] selftests/bpf: Fix bpf-iter-tcp4 test to print correctly the dest IP
Date:   Mon, 13 Sep 2021 15:13:43 +0200
Message-Id: <20210913131114.887886005@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Blanquicet <josebl@microsoft.com>

[ Upstream commit 277b134057036df8c657079ca92c3e5e7d10aeaf ]

Currently, this test is incorrectly printing the destination port in
place of the destination IP.

Fixes: 2767c97765cb ("selftests/bpf: Implement sample tcp/tcp6 bpf_iter programs")
Signed-off-by: Jose Blanquicet <josebl@microsoft.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20210805164044.527903-1-josebl@microsoft.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c b/tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c
index 54380c5e1069..aa96b604b2b3 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c
@@ -122,7 +122,7 @@ static int dump_tcp_sock(struct seq_file *seq, struct tcp_sock *tp,
 	}
 
 	BPF_SEQ_PRINTF(seq, "%4d: %08X:%04X %08X:%04X ",
-		       seq_num, src, srcp, destp, destp);
+		       seq_num, src, srcp, dest, destp);
 	BPF_SEQ_PRINTF(seq, "%02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d ",
 		       state,
 		       tp->write_seq - tp->snd_una, rx_queue,
-- 
2.30.2



