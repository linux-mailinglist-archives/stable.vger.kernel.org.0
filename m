Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6656C07CA
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbjCTBBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbjCTBA2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:00:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF0922CAE;
        Sun, 19 Mar 2023 17:56:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E802B80D59;
        Mon, 20 Mar 2023 00:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F31C4339C;
        Mon, 20 Mar 2023 00:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273807;
        bh=gbU0/p+naJTF87VAq0Y+j/X26qPrBHaLhiOF58Btm+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sAjMJVWGC4HwqWtJsXPCWKtr8Ydwb/zdp6qvKNqRgyFev5cVByXfzME0JxOA7PHjA
         +WBIbMKjg7aG1qGgNZ/fgaKYzKFQc3nE2BBiXAyFr8i0VodJHRaOz9r6HyjbetsqUI
         F0Sa4ns++ea9q7Du8X0Vaxmjex4QayL9yvDki3zQVMQ7gSPaOZDkNtwmRXsvXEfj+G
         0/FUL/p/hL2P/l4BXw5mNPi9q8tg6JLWX24j7U8qzMpBpgg3DKYRBw29ajowEftjH6
         a21pceToSN2zITQU1tCYFov0qcIAHhcGEEtQvMw2RyQmHFe96n8CDdx6OH8KT6yMsG
         zjzK+X2r/EN3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenz Bauer <lorenz.bauer@isovalent.com>,
        Lorenz Bauer <lmb@isovalent.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, shuah@kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/12] selftests/bpf: check that modifier resolves after pointer
Date:   Sun, 19 Mar 2023 20:56:28 -0400
Message-Id: <20230320005636.1429242-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005636.1429242-1-sashal@kernel.org>
References: <20230320005636.1429242-1-sashal@kernel.org>
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

From: Lorenz Bauer <lorenz.bauer@isovalent.com>

[ Upstream commit dfdd608c3b365f0fd49d7e13911ebcde06b9865b ]

Add a regression test that ensures that a VAR pointing at a
modifier which follows a PTR (or STRUCT or ARRAY) is resolved
correctly by the datasec validator.

Signed-off-by: Lorenz Bauer <lmb@isovalent.com>
Link: https://lore.kernel.org/r/20230306112138.155352-3-lmb@isovalent.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_btf.c | 28 ++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_btf.c b/tools/testing/selftests/bpf/test_btf.c
index 996eca57bc977..f641eb292a885 100644
--- a/tools/testing/selftests/bpf/test_btf.c
+++ b/tools/testing/selftests/bpf/test_btf.c
@@ -920,6 +920,34 @@ static struct btf_raw_test raw_tests[] = {
 	.btf_load_err = true,
 	.err_str = "Invalid elem",
 },
+{
+	.descr = "var after datasec, ptr followed by modifier",
+	.raw_types = {
+		/* .bss section */				/* [1] */
+		BTF_TYPE_ENC(NAME_TBD, BTF_INFO_ENC(BTF_KIND_DATASEC, 0, 2),
+			sizeof(void*)+4),
+		BTF_VAR_SECINFO_ENC(4, 0, sizeof(void*)),
+		BTF_VAR_SECINFO_ENC(6, sizeof(void*), 4),
+		/* int */					/* [2] */
+		BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),
+		/* int* */					/* [3] */
+		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_PTR, 0, 0), 2),
+		BTF_VAR_ENC(NAME_TBD, 3, 0),			/* [4] */
+		/* const int */					/* [5] */
+		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_CONST, 0, 0), 2),
+		BTF_VAR_ENC(NAME_TBD, 5, 0),			/* [6] */
+		BTF_END_RAW,
+	},
+	.str_sec = "\0a\0b\0c\0",
+	.str_sec_size = sizeof("\0a\0b\0c\0"),
+	.map_type = BPF_MAP_TYPE_ARRAY,
+	.map_name = ".bss",
+	.key_size = sizeof(int),
+	.value_size = sizeof(void*)+4,
+	.key_type_id = 0,
+	.value_type_id = 1,
+	.max_entries = 1,
+},
 /* Test member exceeds the size of struct.
  *
  * struct A {
-- 
2.39.2

