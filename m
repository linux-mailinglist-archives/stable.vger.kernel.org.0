Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53397409501
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344640AbhIMOgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346310AbhIMOco (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:32:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4CBC61246;
        Mon, 13 Sep 2021 13:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541143;
        bh=n/89U9uu0YfxCegmcuZSJMSCsWFpawDetI+hIPXWxx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0E3jxijkH/vXBRnFZZ9hpZqi1QYtorcskEC7S2P9yYULw35v4KZGHp8LH8Lh7jZIa
         XbjIobpKcmg2n7y4IYtExy0Dg/S8nG2U4mcmP5nLNGDKYmVKGkQS1DcZ4mpYm6pvES
         2dgRicC75ATrtTlo+Rv8wUbQ08WpZI6qBuZLpXtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jose Blanquicet <josebl@microsoft.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 181/334] selftests/bpf: Fix bpf-iter-tcp4 test to print correctly the dest IP
Date:   Mon, 13 Sep 2021 15:13:55 +0200
Message-Id: <20210913131119.469481052@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
index 2e4775c35414..92267abb462f 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c
@@ -121,7 +121,7 @@ static int dump_tcp_sock(struct seq_file *seq, struct tcp_sock *tp,
 	}
 
 	BPF_SEQ_PRINTF(seq, "%4d: %08X:%04X %08X:%04X ",
-		       seq_num, src, srcp, destp, destp);
+		       seq_num, src, srcp, dest, destp);
 	BPF_SEQ_PRINTF(seq, "%02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d ",
 		       state,
 		       tp->write_seq - tp->snd_una, rx_queue,
-- 
2.30.2



