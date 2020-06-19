Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6F3201279
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392896AbgFSPVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392892AbgFSPVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:21:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 574AC21548;
        Fri, 19 Jun 2020 15:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580103;
        bh=TZrUG0c+bqLjBayBmaG07PdziZ3fDMuG7ttxZs3ZcfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N70cSVpe4pEOxXAxPtRyTWd0sz2w9C1EUFCNHMnbYdSvI0g1PsO2SsmnO1PSqnGwu
         U4JMCJIIqiQoJUcmkIK+7D4+36QNQLqez75/n5z8UxXJHKM5086wVVA5ajEJBC65QX
         19g8KJAsXD70fAgJD5swe08YTGaqO4cW9dPWzJo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 124/376] selftests/bpf: Fix invalid memory reads in core_relo selftest
Date:   Fri, 19 Jun 2020 16:30:42 +0200
Message-Id: <20200619141716.205467075@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 13c908495e5d51718a6da84ae925fa2aac056380 ]

Another one found by AddressSanitizer. input_len is bigger than actually
initialized data size.

Fixes: c7566a69695c ("selftests/bpf: Add field existence CO-RE relocs tests")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200429012111.277390-8-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/core_reloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 31e177adbdf1..084ed26a7d78 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -392,7 +392,7 @@ static struct core_reloc_test_case test_cases[] = {
 		.input = STRUCT_TO_CHAR_PTR(core_reloc_existence___minimal) {
 			.a = 42,
 		},
-		.input_len = sizeof(struct core_reloc_existence),
+		.input_len = sizeof(struct core_reloc_existence___minimal),
 		.output = STRUCT_TO_CHAR_PTR(core_reloc_existence_output) {
 			.a_exists = 1,
 			.b_exists = 0,
-- 
2.25.1



