Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C288B12C7BD
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730992AbfL2RqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:46:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:55392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730793AbfL2RqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:46:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36A31207FF;
        Sun, 29 Dec 2019 17:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641559;
        bh=2xvGjflBVNDq5E1XdzK89Pin9Puce38Ph1IVVtxAnac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVDXyxqVXghHAlxHkmIpDcDZ+UC509dqeqVeLW53oo94wocj9xi0N0au6Jgr5FbBd
         /Xu46qu3U8AAKvjJ4Nawu0wnDKrNoqkXVhQKypc9RWucYIcXv4rp5iR33hMXwHuJ2o
         3QidNaPmPfZON6ffaHCopJJH1Wy1HEBnPWFvWdgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/434] selftests/bpf: Fix btf_dump padding test case
Date:   Sun, 29 Dec 2019 18:22:50 +0100
Message-Id: <20191229172709.457188361@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 76790c7c66ccc8695afc75e73f54c0ca86267ed2 ]

Existing padding test case for btf_dump has a good test that was
supposed to test padding generation at the end of a struct, but its
expected output was specified incorrectly. Fix this.

Fixes: 2d2a3ad872f8 ("selftests/bpf: add btf_dump BTF-to-C conversion tests")
Reported-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20191008231009.2991130-4-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/progs/btf_dump_test_case_padding.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
index 3a62119c7498..35c512818a56 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
@@ -62,6 +62,10 @@ struct padded_a_lot {
  *	long: 64;
  *	long: 64;
  *	int b;
+ *	long: 32;
+ *	long: 64;
+ *	long: 64;
+ *	long: 64;
  *};
  *
  */
@@ -95,7 +99,6 @@ struct zone_padding {
 struct zone {
 	int a;
 	short b;
-	short: 16;
 	struct zone_padding __pad__;
 };
 
-- 
2.20.1



