Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943C329BDD5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801538AbgJ0QrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:47:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794937AbgJ0PO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:14:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDA4420657;
        Tue, 27 Oct 2020 15:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811667;
        bh=/VH/Uh4ppG8CqszpVW7ftboKw3ENRADID/FSq+mRDz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yC1S8QGCKxJN0jxzTa+CRdMmsKsCsIjsuwlfDtYetpGQay904hQ9070bQRRjDxYcP
         QYNQZ69mCRGxlncYjRjcNQIVAbTwSOuSpAl9QDnuKCyUiQFlpuIqcDTKDxhpCFdFHn
         BDvbKBuowKvZj0oV+3hvYYmvKxbRkKzDLdiLbdmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 574/633] selftests/bpf: Fix overflow tests to reflect iter size increase
Date:   Tue, 27 Oct 2020 14:55:17 +0100
Message-Id: <20201027135549.734594680@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit eb58bbf2e5c7917aa30bf8818761f26bbeeb2290 ]

bpf iter size increase to PAGE_SIZE << 3 means overflow tests assuming
page size need to be bumped also.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/1601292670-1616-7-git-send-email-alan.maguire@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index 87c29dde1cf96..669f195de2fa0 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -249,7 +249,7 @@ static void test_overflow(bool test_e2big_overflow, bool ret1)
 	struct bpf_map_info map_info = {};
 	struct bpf_iter_test_kern4 *skel;
 	struct bpf_link *link;
-	__u32 page_size;
+	__u32 iter_size;
 	char *buf;
 
 	skel = bpf_iter_test_kern4__open();
@@ -271,19 +271,19 @@ static void test_overflow(bool test_e2big_overflow, bool ret1)
 		  "map_creation failed: %s\n", strerror(errno)))
 		goto free_map1;
 
-	/* bpf_seq_printf kernel buffer is one page, so one map
+	/* bpf_seq_printf kernel buffer is 8 pages, so one map
 	 * bpf_seq_write will mostly fill it, and the other map
 	 * will partially fill and then trigger overflow and need
 	 * bpf_seq_read restart.
 	 */
-	page_size = sysconf(_SC_PAGE_SIZE);
+	iter_size = sysconf(_SC_PAGE_SIZE) << 3;
 
 	if (test_e2big_overflow) {
-		skel->rodata->print_len = (page_size + 8) / 8;
-		expected_read_len = 2 * (page_size + 8);
+		skel->rodata->print_len = (iter_size + 8) / 8;
+		expected_read_len = 2 * (iter_size + 8);
 	} else if (!ret1) {
-		skel->rodata->print_len = (page_size - 8) / 8;
-		expected_read_len = 2 * (page_size - 8);
+		skel->rodata->print_len = (iter_size - 8) / 8;
+		expected_read_len = 2 * (iter_size - 8);
 	} else {
 		skel->rodata->print_len = 1;
 		expected_read_len = 2 * 8;
-- 
2.25.1



