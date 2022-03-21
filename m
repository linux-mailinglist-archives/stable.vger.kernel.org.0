Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E3C4E28F7
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348314AbiCUOBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349161AbiCUN73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:59:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA0B17E34;
        Mon, 21 Mar 2022 06:58:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 833786125C;
        Mon, 21 Mar 2022 13:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937CBC340E8;
        Mon, 21 Mar 2022 13:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871083;
        bh=JsBG2MyiRhsA2oGen2dAlVo6MAvoBKtGqss16qFVF4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YEKPWPwESqiCRGNiviQgHrfGtxs2lVfmjvMI0XJBf5M+5rxEfo1i9OkzhCyJ2wDiC
         Q51UFqcNez7U+9uW4uE6d3e29BHdSokqyNvHFVS3Q/YOd088rmOPiACEQgMPg0f37i
         dURGRkS/8r5HKx72DnpJdr63OtAFj+0yvtyhOyhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geliang Tang <geliang.tang@suse.com>,
        Tommi Rantala <tommi.t.rantala@nokia.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/17] Revert "selftests/bpf: Add test for bpf_timer overwriting crash"
Date:   Mon, 21 Mar 2022 14:52:53 +0100
Message-Id: <20220321133217.653517515@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133217.148831184@linuxfoundation.org>
References: <20220321133217.148831184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit dcf55b071de9231e197ba7b1a2d0a423e8d7d33a which is
commit a7e75016a0753c24d6c995bc02501ae35368e333 upstream.

It is reported to break the bpf self-tests.

Reported-by: Geliang Tang <geliang.tang@suse.com>
Reported-by: Tommi Rantala <tommi.t.rantala@nokia.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220209070324.1093182-3-memxor@gmail.com
Cc: Sasha Levin <sashal@kernel.org>
Link: https://lore.kernel.org/r/a0a7298ca5c64b3d0ecfcc8821c2de79186fa9f7.camel@nokia.com
Link: https://lore.kernel.org/r/HE1PR0402MB3497CB13A12C4D15D20A1FCCF8139@HE1PR0402MB3497.eurprd04.prod.outlook.com
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


