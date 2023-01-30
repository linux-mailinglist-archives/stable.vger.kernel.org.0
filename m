Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9EF068119E
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237334AbjA3OPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237330AbjA3OPS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:15:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60693B67D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:15:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DD6561022
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF2DC433D2;
        Mon, 30 Jan 2023 14:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088110;
        bh=SFUeGrhlGwCqZj6iCEsVuoL5vHnQGn/pAym4rJEkuro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qR/Jr0CmiyDRF7uLykIb5ZvJuDURBlUp9ornxDQoLxdr3vh1WQp+FUBOUNG7/5QzD
         Hg+O0fJsYj4++33UYYR+OZlqpSf212XQ0lNxihrckcInuC4behmoAtJSo8V1+kGMac
         EBLKpaOjFT4k+28AhCfTvbMGWOPvDCRVp+CWKxqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/204] Revert "selftests/bpf: check null propagation only neither reg is PTR_TO_BTF_ID"
Date:   Mon, 30 Jan 2023 14:51:24 +0100
Message-Id: <20230130134321.712209527@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 95fc28a8e92169cff4b649ae9f4a209a783f2c91.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c |    9 --
 tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c |   42 ------------
 2 files changed, 51 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c
 delete mode 100644 tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c

--- a/tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c
+++ /dev/null
@@ -1,9 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include <test_progs.h>
-#include "jeq_infer_not_null_fail.skel.h"
-
-void test_jeq_infer_not_null(void)
-{
-	RUN_TESTS(jeq_infer_not_null_fail);
-}
--- a/tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c
+++ /dev/null
@@ -1,42 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include "vmlinux.h"
-#include <bpf/bpf_helpers.h>
-#include "bpf_misc.h"
-
-char _license[] SEC("license") = "GPL";
-
-struct {
-	__uint(type, BPF_MAP_TYPE_HASH);
-	__uint(max_entries, 1);
-	__type(key, u64);
-	__type(value, u64);
-} m_hash SEC(".maps");
-
-SEC("?raw_tp")
-__failure __msg("R8 invalid mem access 'map_value_or_null")
-int jeq_infer_not_null_ptr_to_btfid(void *ctx)
-{
-	struct bpf_map *map = (struct bpf_map *)&m_hash;
-	struct bpf_map *inner_map = map->inner_map_meta;
-	u64 key = 0, ret = 0, *val;
-
-	val = bpf_map_lookup_elem(map, &key);
-	/* Do not mark ptr as non-null if one of them is
-	 * PTR_TO_BTF_ID (R9), reject because of invalid
-	 * access to map value (R8).
-	 *
-	 * Here, we need to inline those insns to access
-	 * R8 directly, since compiler may use other reg
-	 * once it figures out val==inner_map.
-	 */
-	asm volatile("r8 = %[val];\n"
-		     "r9 = %[inner_map];\n"
-		     "if r8 != r9 goto +1;\n"
-		     "%[ret] = *(u64 *)(r8 +0);\n"
-		     : [ret] "+r"(ret)
-		     : [inner_map] "r"(inner_map), [val] "r"(val)
-		     : "r8", "r9");
-
-	return ret;
-}


