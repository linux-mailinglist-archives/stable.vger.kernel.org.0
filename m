Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 049879DF84
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbfH0HzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:55:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730203AbfH0Hy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:54:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A542206BF;
        Tue, 27 Aug 2019 07:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892497;
        bh=vTCvNG1ZV1DaV2Mn8Q8qtNA19FljW55xpo00S5DeUxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZaCPbbFDft1X7EuV0rWK02ddwUSL0KeS84GoDwlEvgbklKOkYEgIA63aLYohsrO+r
         nj+XG/xzHpgeADNvgwGwfu7Et3etBA856pudYXYsCXrtNVsh2sPsW3AHnv6+V+Tjin
         KuSngZ/VDIcUFMBAgxjsvCE/o5wwVy20Q4ePb+hM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Andrey Ignatov <rdna@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/98] selftests/bpf: fix sendmsg6_prog on s390
Date:   Tue, 27 Aug 2019 09:49:45 +0200
Message-Id: <20190827072718.496182542@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c8eee4135a456bc031d67cadc454e76880d1afd8 ]

"sendmsg6: rewrite IP & port (C)" fails on s390, because the code in
sendmsg_v6_prog() assumes that (ctx->user_ip6[0] & 0xFFFF) refers to
leading IPv6 address digits, which is not the case on big-endian
machines.

Since checking bitwise operations doesn't seem to be the point of the
test, replace two short comparisons with a single int comparison.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/sendmsg6_prog.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/sendmsg6_prog.c b/tools/testing/selftests/bpf/sendmsg6_prog.c
index 5aeaa284fc474..a680628204108 100644
--- a/tools/testing/selftests/bpf/sendmsg6_prog.c
+++ b/tools/testing/selftests/bpf/sendmsg6_prog.c
@@ -41,8 +41,7 @@ int sendmsg_v6_prog(struct bpf_sock_addr *ctx)
 	}
 
 	/* Rewrite destination. */
-	if ((ctx->user_ip6[0] & 0xFFFF) == bpf_htons(0xFACE) &&
-	     ctx->user_ip6[0] >> 16 == bpf_htons(0xB00C)) {
+	if (ctx->user_ip6[0] == bpf_htonl(0xFACEB00C)) {
 		ctx->user_ip6[0] = bpf_htonl(DST_REWRITE_IP6_0);
 		ctx->user_ip6[1] = bpf_htonl(DST_REWRITE_IP6_1);
 		ctx->user_ip6[2] = bpf_htonl(DST_REWRITE_IP6_2);
-- 
2.20.1



