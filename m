Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778B62C0734
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732025AbgKWMi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:38:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732092AbgKWMi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:38:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 704E72076E;
        Mon, 23 Nov 2020 12:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135106;
        bh=ZvAH1k7Ouwyd3QMqedfB2CKV4/JJlmCX0kVnLt7Ih4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVO92ocuKYoJnESscS47n9IVSGfbhlILIEuF8prt9ryT1P690jhDSGsnLTvykDHn/
         9gUnd/zIm6DXvxt9d71W9faktHYGbYo7fTMHkAXTh4toBGPCEOSWIqRKZGb3Nvw7gg
         Ijhg/TcIQb5mnK7Yf+5Cn4m9tasq6pgSejJyCUp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/158] selftests/bpf: Fix error return code in run_getsockopt_test()
Date:   Mon, 23 Nov 2020 13:21:57 +0100
Message-Id: <20201123121824.226463079@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 2acc3c1bc8e98bc66b1badec42e9ea205b4fcdaa ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 65b4414a05eb ("selftests/bpf: add sockopt test that exercises BPF_F_ALLOW_MULTI")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20201116101633.64627-1-wanghai38@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sockopt_multi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_multi.c b/tools/testing/selftests/bpf/prog_tests/sockopt_multi.c
index 29188d6f5c8de..51fac975b3163 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt_multi.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt_multi.c
@@ -138,7 +138,8 @@ static int run_getsockopt_test(struct bpf_object *obj, int cg_parent,
 	 */
 
 	buf = 0x40;
-	if (setsockopt(sock_fd, SOL_IP, IP_TOS, &buf, 1) < 0) {
+	err = setsockopt(sock_fd, SOL_IP, IP_TOS, &buf, 1);
+	if (err < 0) {
 		log_err("Failed to call setsockopt(IP_TOS)");
 		goto detach;
 	}
-- 
2.27.0



