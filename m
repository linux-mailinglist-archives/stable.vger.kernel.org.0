Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7E86CC39D
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbjC1Ozr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbjC1Ozq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:55:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB20ADBE6
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:55:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68ACCB81CAF
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC76C433D2;
        Tue, 28 Mar 2023 14:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015342;
        bh=m3fyD1fEDC2NFx3ydHpult4RRApW2FzYZKF5o+87yw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VpyBBwOVqGU1jwnwjjHRqMC02xW4SLpN+ZBtrjKAKQuMc/GeZwzAKt3qRXJx99sL7
         Iu0Gbp8BklUmLcfMjWgMTMUT4uI+GAcgG2fvS+OSR02aShf8HYPvM8CTk9Jio2t9m0
         a4exhOP7PbAo1rgwMq44cfq+yJN5pkUQAbdfpFjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Jihong <yangjihong1@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/224] perf/core: Fix perf_output_begin parameter is incorrectly invoked in perf_event_bpf_output
Date:   Tue, 28 Mar 2023 16:40:00 +0200
Message-Id: <20230328142617.396324310@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
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

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit eb81a2ed4f52be831c9fb879752d89645a312c13 ]

syzkaller reportes a KASAN issue with stack-out-of-bounds.
The call trace is as follows:
  dump_stack+0x9c/0xd3
  print_address_description.constprop.0+0x19/0x170
  __kasan_report.cold+0x6c/0x84
  kasan_report+0x3a/0x50
  __perf_event_header__init_id+0x34/0x290
  perf_event_header__init_id+0x48/0x60
  perf_output_begin+0x4a4/0x560
  perf_event_bpf_output+0x161/0x1e0
  perf_iterate_sb_cpu+0x29e/0x340
  perf_iterate_sb+0x4c/0xc0
  perf_event_bpf_event+0x194/0x2c0
  __bpf_prog_put.constprop.0+0x55/0xf0
  __cls_bpf_delete_prog+0xea/0x120 [cls_bpf]
  cls_bpf_delete_prog_work+0x1c/0x30 [cls_bpf]
  process_one_work+0x3c2/0x730
  worker_thread+0x93/0x650
  kthread+0x1b8/0x210
  ret_from_fork+0x1f/0x30

commit 267fb27352b6 ("perf: Reduce stack usage of perf_output_begin()")
use on-stack struct perf_sample_data of the caller function.

However, perf_event_bpf_output uses incorrect parameter to convert
small-sized data (struct perf_bpf_event) into large-sized data
(struct perf_sample_data), which causes memory overwriting occurs in
__perf_event_header__init_id.

Fixes: 267fb27352b6 ("perf: Reduce stack usage of perf_output_begin()")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20230314044735.56551-1-yangjihong1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 227ada7240295..6c4e78cd7a8b5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9009,7 +9009,7 @@ static void perf_event_bpf_output(struct perf_event *event, void *data)
 
 	perf_event_header__init_id(&bpf_event->event_id.header,
 				   &sample, event);
-	ret = perf_output_begin(&handle, data, event,
+	ret = perf_output_begin(&handle, &sample, event,
 				bpf_event->event_id.header.size);
 	if (ret)
 		return;
-- 
2.39.2



