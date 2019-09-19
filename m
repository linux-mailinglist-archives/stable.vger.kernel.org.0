Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89076B874E
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405311AbfISWHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405308AbfISWHs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:07:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D44A218AF;
        Thu, 19 Sep 2019 22:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930868;
        bh=ZUPeU7rXEE9Ft3yii0aStiNyiPcuIWemP1F9qsfU3JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTOZQdlO3jfBC1kQVNpJCkwbl7Z5bwEoqWr1bN34O0Q/EkCT7zCGyJOKVWXZ9el1r
         PUEl4r7YJ9TZdhUUzmdr2GPky17Sos8GH4nusZkGTL/Hcn9CcRGgMiYjtu2U9SuZEH
         tUq3hcZsa8UywWKp8qHH0Cu+8yNtn5kaKZnPvlk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 044/124] selftests/bpf: fix "bind{4, 6} deny specific IP & port" on s390
Date:   Fri, 20 Sep 2019 00:02:12 +0200
Message-Id: <20190919214820.607902189@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 27df5c7068bf23cab282dc64b1c9894429b3b8a0 ]

"bind4 allow specific IP & port" and "bind6 deny specific IP & port"
fail on s390 because of endianness issue: the 4 IP address bytes are
loaded as a word and compared with a constant, but the value of this
constant should be different on big- and little- endian machines, which
is not the case right now.

Use __bpf_constant_ntohl to generate proper value based on machine
endianness.

Fixes: 1d436885b23b ("selftests/bpf: Selftest for sys_bind post-hooks.")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sock.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sock.c b/tools/testing/selftests/bpf/test_sock.c
index fb679ac3d4b07..0e66527334623 100644
--- a/tools/testing/selftests/bpf/test_sock.c
+++ b/tools/testing/selftests/bpf/test_sock.c
@@ -13,6 +13,7 @@
 #include <bpf/bpf.h>
 
 #include "cgroup_helpers.h"
+#include "bpf_endian.h"
 #include "bpf_rlimit.h"
 #include "bpf_util.h"
 
@@ -232,7 +233,8 @@ static struct sock_test tests[] = {
 			/* if (ip == expected && port == expected) */
 			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
 				    offsetof(struct bpf_sock, src_ip6[3])),
-			BPF_JMP_IMM(BPF_JNE, BPF_REG_7, 0x01000000, 4),
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_7,
+				    __bpf_constant_ntohl(0x00000001), 4),
 			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
 				    offsetof(struct bpf_sock, src_port)),
 			BPF_JMP_IMM(BPF_JNE, BPF_REG_7, 0x2001, 2),
@@ -261,7 +263,8 @@ static struct sock_test tests[] = {
 			/* if (ip == expected && port == expected) */
 			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
 				    offsetof(struct bpf_sock, src_ip4)),
-			BPF_JMP_IMM(BPF_JNE, BPF_REG_7, 0x0100007F, 4),
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_7,
+				    __bpf_constant_ntohl(0x7F000001), 4),
 			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
 				    offsetof(struct bpf_sock, src_port)),
 			BPF_JMP_IMM(BPF_JNE, BPF_REG_7, 0x1002, 2),
-- 
2.20.1



