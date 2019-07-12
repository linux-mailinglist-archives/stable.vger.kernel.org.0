Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC2966CF8
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbfGLMZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:25:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727368AbfGLMZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:25:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5983821019;
        Fri, 12 Jul 2019 12:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934301;
        bh=EaKkSjxtQSGN5Zl5VRj13WaPEHAovzGIOX4xu5SmhOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxGjEDPbGm47UjId0uVoQfbRBPgr0uzQXxfuMSeSog8aVi6jqJQ4GaO8u3IbNZi6l
         68KqxV7SedQvneqUGVakzmhjsyUsTVLgA9cTMNXK/VV2vKDWcsDK7BUV94CWbXZk3n
         zHtEQYQ3i1BuPRfaJQMlzylrZh8LSMmz/K09yki8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chang-Hsien Tsai <luke.tw@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 011/138] samples, bpf: fix to change the buffer size for read()
Date:   Fri, 12 Jul 2019 14:17:55 +0200
Message-Id: <20190712121629.148244689@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f7c2d64bac1be2ff32f8e4f500c6e5429c1003e0 ]

If the trace for read is larger than 4096, the return
value sz will be 4096. This results in off-by-one error
on buf:

    static char buf[4096];
    ssize_t sz;

    sz = read(trace_fd, buf, sizeof(buf));
    if (sz > 0) {
        buf[sz] = 0;
        puts(buf);
    }

Signed-off-by: Chang-Hsien Tsai <luke.tw@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/bpf_load.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/bpf_load.c b/samples/bpf/bpf_load.c
index eae7b635343d..6e87cc831e84 100644
--- a/samples/bpf/bpf_load.c
+++ b/samples/bpf/bpf_load.c
@@ -678,7 +678,7 @@ void read_trace_pipe(void)
 		static char buf[4096];
 		ssize_t sz;
 
-		sz = read(trace_fd, buf, sizeof(buf));
+		sz = read(trace_fd, buf, sizeof(buf) - 1);
 		if (sz > 0) {
 			buf[sz] = 0;
 			puts(buf);
-- 
2.20.1



