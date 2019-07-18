Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B14EC6C709
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390898AbfGRDJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390928AbfGRDJF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:09:05 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D6D621848;
        Thu, 18 Jul 2019 03:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419344;
        bh=L9W5DKIEML14IYhf2zmLw+iTZCNCqpb3B6/NohmN1YY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wc5rXqirqZpv81QaBB2mgF8/dq9gYR/gYr43yuY/y7zVDN0oyFHjYZsKXyc46c8OF
         w5OYx6XsKgtW8hrZe8PcyG5OU9A3CEDNHpn/FrdqclS6TzqG6NzjMOb/iuO4DwE6uL
         5G2sZyTo3ecWYqRKfY/C88KI814UmAjeJGe01gjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chang-Hsien Tsai <luke.tw@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 08/80] samples, bpf: fix to change the buffer size for read()
Date:   Thu, 18 Jul 2019 12:00:59 +0900
Message-Id: <20190718030059.512535171@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
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
index 2325d7ad76df..e8e8b756dc52 100644
--- a/samples/bpf/bpf_load.c
+++ b/samples/bpf/bpf_load.c
@@ -613,7 +613,7 @@ void read_trace_pipe(void)
 		static char buf[4096];
 		ssize_t sz;
 
-		sz = read(trace_fd, buf, sizeof(buf));
+		sz = read(trace_fd, buf, sizeof(buf) - 1);
 		if (sz > 0) {
 			buf[sz] = 0;
 			puts(buf);
-- 
2.20.1



