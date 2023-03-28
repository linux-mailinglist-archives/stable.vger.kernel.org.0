Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBD26CC316
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbjC1OvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbjC1Oux (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:50:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D9AE075
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:50:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83418B81D70
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:50:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF06C433D2;
        Tue, 28 Mar 2023 14:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015027;
        bh=kd3I86PrIC7k51nBbmX2aqW4UrtqO59BZXYJM5ujk2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uAEBN6FkFtb3JljxSL0N2PhyltUelrZl2opebGaZyHC17VKhmN1dFsrGlFXhAcGK4
         6My0YIbMAs4kPXADEeOs9QpguxhqNH1sWgkAo69qmDcAC2zg0ycOuRUUAcJ8e3ZIuw
         U8XQmsedg4uWR7JUn9FkKWZt+UpcsnkDxnctmtsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lorenz Bauer <lmb@isovalent.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 140/240] selftests/bpf: check that modifier resolves after pointer
Date:   Tue, 28 Mar 2023 16:41:43 +0200
Message-Id: <20230328142625.579625167@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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
 tools/testing/selftests/bpf/prog_tests/btf.c | 28 ++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index de1b5b9eb93a8..d8d1292e73b53 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -879,6 +879,34 @@ static struct btf_raw_test raw_tests[] = {
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



