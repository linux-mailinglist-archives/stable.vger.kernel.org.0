Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11BAF65009C
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiLRQRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbiLRQQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:16:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8233D10FEA;
        Sun, 18 Dec 2022 08:07:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F8B4B80B4D;
        Sun, 18 Dec 2022 16:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E946C433F0;
        Sun, 18 Dec 2022 16:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379619;
        bh=kIPkRcL7vg8/igWD/iLUOEIINTGgR0Al5u+fgeEOQ8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/edubL147UZj5uD1WIVqlxvEt1/XPuqcImJ7QCdiXI7G4S30sQO5fNkl2vTmwU0C
         sWizzcxutFX8FqUdp+PAFEn51KTqdCj9uVH7Jd7uXJZiZBQQUgMm/3SMbP2Kedavcy
         QdSCjm3GXx3oNvUUEE3Apdk69kxba78G3zr5uLuf3T9dBCyo/VYYZ4eGsVdECI49fc
         h4ZReaAaHt4LzkH2EZoJ48lQdXIzDP14mk53riqoWdSQTY3BCsxBPpgtxLaYgyUh8Z
         FRy5ATRAKXdaF+Xy1Wubzh30n+ry8c1V3uyQnlEjls06Mrw95KMmEi5T/A4jwa6MW1
         3add6Nib6eu3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 68/85] libbpf: Avoid enum forward-declarations in public API in C++ mode
Date:   Sun, 18 Dec 2022 11:01:25 -0500
Message-Id: <20221218160142.925394-68-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit b42693415b86f608049cf1b4870adc1dc65e58b0 ]

C++ enum forward declarations are fundamentally not compatible with pure
C enum definitions, and so libbpf's use of `enum bpf_stats_type;`
forward declaration in libbpf/bpf.h public API header is causing C++
compilation issues.

More details can be found in [0], but it comes down to C++ supporting
enum forward declaration only with explicitly specified backing type:

  enum bpf_stats_type: int;

In C (and I believe it's a GCC extension also), such forward declaration
is simply:

  enum bpf_stats_type;

Further, in Linux UAPI this enum is defined in pure C way:

enum bpf_stats_type { BPF_STATS_RUN_TIME = 0; }

And even though in both cases backing type is int, which can be
confirmed by looking at DWARF information, for C++ compiler actual enum
definition and forward declaration are incompatible.

To eliminate this problem, for C++ mode define input argument as int,
which makes enum unnecessary in libbpf public header. This solves the
issue and as demonstrated by next patch doesn't cause any unwanted
compiler warnings, at least with default warnings setting.

  [0] https://stackoverflow.com/questions/42766839/c11-enum-forward-causes-underlying-type-mismatch
  [1] Closes: https://github.com/libbpf/libbpf/issues/249

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20221130200013.2997831-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 9c50beabdd14..fddc05c667b5 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -393,8 +393,15 @@ LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf,
 				 __u32 *buf_len, __u32 *prog_id, __u32 *fd_type,
 				 __u64 *probe_offset, __u64 *probe_addr);
 
+#ifdef __cplusplus
+/* forward-declaring enums in C++ isn't compatible with pure C enums, so
+ * instead define bpf_enable_stats() as accepting int as an input
+ */
+LIBBPF_API int bpf_enable_stats(int type);
+#else
 enum bpf_stats_type; /* defined in up-to-date linux/bpf.h */
 LIBBPF_API int bpf_enable_stats(enum bpf_stats_type type);
+#endif
 
 struct bpf_prog_bind_opts {
 	size_t sz; /* size of this struct for forward/backward compatibility */
-- 
2.35.1

