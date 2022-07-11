Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E31B56FC1F
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbiGKJjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbiGKJjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:39:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A8488CC4;
        Mon, 11 Jul 2022 02:20:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42A9EB80DBA;
        Mon, 11 Jul 2022 09:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAF8C34115;
        Mon, 11 Jul 2022 09:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531203;
        bh=YCL1pHabrAZsQ+ypy3aShkbc+c0GHfrm4urN9vWFSIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oih/6MTOxrgR3j6Q8TuvyIv0LBattG8fTDiIeRBLgw4m/m0WSa3N2J/nkrepqN7Em
         LK4fVYBKImVUIRxNYIiPZR3sde/AjTxwDPiAJKTZDHOMeUFP7+GFKzkMTpaKP6A5e8
         1UsIouyGU4WBiv5/kRLKibeLOPyGdjqIwSQL8xsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po-Hsu Lin <po-hsu.lin@canonical.com>
Subject: [PATCH 5.15 003/230] Revert "selftests/bpf: Add test for bpf_timer overwriting crash"
Date:   Mon, 11 Jul 2022 11:04:19 +0200
Message-Id: <20220711090604.162280714@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

This reverts commit b0028e1cc1faf2e5d88ad4065590aca90d650182 which is
commit a7e75016a0753c24d6c995bc02501ae35368e333 upstream.

It will break the bpf self-tests build with:
progs/timer_crash.c:8:19: error: field has incomplete type 'struct bpf_timer'
        struct bpf_timer timer;
                         ^
/home/ubuntu/linux/tools/testing/selftests/bpf/tools/include/bpf/bpf_helper_defs.h:39:8:
note: forward declaration of 'struct bpf_timer'
struct bpf_timer;
       ^
1 error generated.

This test can only be built with 5.17 and newer kernels.

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/timer_crash.c |   32 -----------
 tools/testing/selftests/bpf/progs/timer_crash.c      |   54 -------------------
 2 files changed, 86 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/prog_tests/timer_crash.c
 delete mode 100644 tools/testing/selftests/bpf/progs/timer_crash.c

--- a/tools/testing/selftests/bpf/prog_tests/timer_crash.c
+++ /dev/null
@@ -1,32 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <test_progs.h>
-#include "timer_crash.skel.h"
-
-enum {
-	MODE_ARRAY,
-	MODE_HASH,
-};
-
-static void test_timer_crash_mode(int mode)
-{
-	struct timer_crash *skel;
-
-	skel = timer_crash__open_and_load();
-	if (!ASSERT_OK_PTR(skel, "timer_crash__open_and_load"))
-		return;
-	skel->bss->pid = getpid();
-	skel->bss->crash_map = mode;
-	if (!ASSERT_OK(timer_crash__attach(skel), "timer_crash__attach"))
-		goto end;
-	usleep(1);
-end:
-	timer_crash__destroy(skel);
-}
-
-void test_timer_crash(void)
-{
-	if (test__start_subtest("array"))
-		test_timer_crash_mode(MODE_ARRAY);
-	if (test__start_subtest("hash"))
-		test_timer_crash_mode(MODE_HASH);
-}
--- a/tools/testing/selftests/bpf/progs/timer_crash.c
+++ /dev/null
@@ -1,54 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include <vmlinux.h>
-#include <bpf/bpf_tracing.h>
-#include <bpf/bpf_helpers.h>
-
-struct map_elem {
-	struct bpf_timer timer;
-	struct bpf_spin_lock lock;
-};
-
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__uint(max_entries, 1);
-	__type(key, int);
-	__type(value, struct map_elem);
-} amap SEC(".maps");
-
-struct {
-	__uint(type, BPF_MAP_TYPE_HASH);
-	__uint(max_entries, 1);
-	__type(key, int);
-	__type(value, struct map_elem);
-} hmap SEC(".maps");
-
-int pid = 0;
-int crash_map = 0; /* 0 for amap, 1 for hmap */
-
-SEC("fentry/do_nanosleep")
-int sys_enter(void *ctx)
-{
-	struct map_elem *e, value = {};
-	void *map = crash_map ? (void *)&hmap : (void *)&amap;
-
-	if (bpf_get_current_task_btf()->tgid != pid)
-		return 0;
-
-	*(void **)&value = (void *)0xdeadcaf3;
-
-	bpf_map_update_elem(map, &(int){0}, &value, 0);
-	/* For array map, doing bpf_map_update_elem will do a
-	 * check_and_free_timer_in_array, which will trigger the crash if timer
-	 * pointer was overwritten, for hmap we need to use bpf_timer_cancel.
-	 */
-	if (crash_map == 1) {
-		e = bpf_map_lookup_elem(map, &(int){0});
-		if (!e)
-			return 0;
-		bpf_timer_cancel(&e->timer);
-	}
-	return 0;
-}
-
-char _license[] SEC("license") = "GPL";


