Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E4C6D2CE8
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbjDABoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbjDABn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:43:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FE123B5E;
        Fri, 31 Mar 2023 18:43:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F086662CEE;
        Sat,  1 Apr 2023 01:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A97C433D2;
        Sat,  1 Apr 2023 01:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313373;
        bh=JegotNx5fBXykk8QkNgylxdkaBH7T4nUuNR8kI4BsII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=raRDkaY4zQoWHLoI5oe7keHDPfdQij6NHAhcyU/QFdOYZVU4j9RKZreENoCY6VyJt
         R5NUVqHUoFooWDPo1tiLo+0vfkrn2z1adLeI/wrAx32DXCb9Cqk6ZOO5XcsyAJu6Q5
         GmM7Eh7ffB4c2Y26HqZZSR2U2FwwYDD4QegrgBvpfGI8EFBYkoXAIlYJ0W/CklVs3q
         unty1nDjtHbhq0Qzmx5zT1hkME7UL52ndJWSfW9MgR7Km3ksFVx2r/SId/YwuZimNL
         ncOXOufu/6i9YY2I8wSZT0cTCUaBnXszMEfz72b/wiz5uE0BIvkzQcrqDSyyj4lsi0
         BMvuS5UzsAWSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, andrii@kernel.org,
        daniel@iogearbox.net, shuah@kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 06/24] selftests/bpf: Fix progs/find_vma_fail1.c build error.
Date:   Fri, 31 Mar 2023 21:42:22 -0400
Message-Id: <20230401014242.3356780-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014242.3356780-1-sashal@kernel.org>
References: <20230401014242.3356780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 32513d40d908b267508d37994753d9bd1600914b ]

The commit 11e456cae91e ("selftests/bpf: Fix compilation errors: Assign a value to a constant")
fixed the issue cleanly in bpf-next.
This is an alternative fix in bpf tree to avoid merge conflict between bpf and bpf-next.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/find_vma_fail1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/progs/find_vma_fail1.c b/tools/testing/selftests/bpf/progs/find_vma_fail1.c
index b3b326b8e2d1c..6dab9cffda132 100644
--- a/tools/testing/selftests/bpf/progs/find_vma_fail1.c
+++ b/tools/testing/selftests/bpf/progs/find_vma_fail1.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2021 Facebook */
 #include "vmlinux.h"
 #include <bpf/bpf_helpers.h>
+#define vm_flags vm_start
 
 char _license[] SEC("license") = "GPL";
 
-- 
2.39.2

