Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0540D2570
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388359AbfJJJAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388690AbfJJInL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:43:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CFBB21BE5;
        Thu, 10 Oct 2019 08:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696991;
        bh=8rXf1rcCw3zLras7kS4IMtEFY7Dv0pAdekM63Zo4p1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAZozvlpAhRwNkOvmtAsfLrLIovV+7eCJFKd/ZBEQ6gIxfNK0p2pL6v1ShCdjGU1r
         zy8mZiMjK2eaXlKry8hNa1Njcx5vPuYzSA4/lgged12gJgdtFN4AbDBMyLgV7TYjqa
         sO2WozRPrfxiqak2PTHmBRhvaiUvWaAH+Q8ZftPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 125/148] selftests/bpf: adjust strobemeta loop to satisfy latest clang
Date:   Thu, 10 Oct 2019 10:36:26 +0200
Message-Id: <20191010083618.634149576@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 4670d68b9254710fdeaf794cad54d8b2c9929e0a ]

Some recent changes in latest Clang started causing the following
warning when unrolling strobemeta test case main loop:

  progs/strobemeta.h:416:2: warning: loop not unrolled: the optimizer was
  unable to perform the requested transformation; the transformation might
  be disabled or specified as part of an unsupported transformation
  ordering [-Wpass-failed=transform-warning]

This patch simplifies loop's exit condition to depend only on constant
max iteration number (STROBE_MAX_MAP_ENTRIES), while moving early
termination logic inside the loop body. The changes are equivalent from
program logic standpoint, but fixes the warning. It also appears to
improve generated BPF code, as it fixes previously failing non-unrolled
strobemeta test cases.

Cc: Alexei Starovoitov <ast@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/strobemeta.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/strobemeta.h b/tools/testing/selftests/bpf/progs/strobemeta.h
index 8a399bdfd9203..067eb625d01c5 100644
--- a/tools/testing/selftests/bpf/progs/strobemeta.h
+++ b/tools/testing/selftests/bpf/progs/strobemeta.h
@@ -413,7 +413,10 @@ static __always_inline void *read_map_var(struct strobemeta_cfg *cfg,
 #else
 #pragma unroll
 #endif
-	for (int i = 0; i < STROBE_MAX_MAP_ENTRIES && i < map.cnt; ++i) {
+	for (int i = 0; i < STROBE_MAX_MAP_ENTRIES; ++i) {
+		if (i >= map.cnt)
+			break;
+
 		descr->key_lens[i] = 0;
 		len = bpf_probe_read_str(payload, STROBE_MAX_STR_LEN,
 					 map.entries[i].key);
-- 
2.20.1



