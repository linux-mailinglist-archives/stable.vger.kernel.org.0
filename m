Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D567B6C176D
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbjCTPNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbjCTPN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:13:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C79672A0
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:08:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B02F8B80D34
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B4DC433EF;
        Mon, 20 Mar 2023 15:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324895;
        bh=HkMszIBiciwf2d4Lw0HrTjWlu/rJIyAuWzHz7NRO9PQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4W8waoOqCHNvP/MZd4iRiCV1y6VUwpsqAY7vfSp8GN1Zk9LjrW+x3Sb3lyRpjZbB
         vZ+r3fX5rQbVy4+ajIf9oZsLll2R3OiE+VVIXXJB9EU4Z6/C9RwoossIHlRml/mTM9
         FtKwwnYoo0yTCbVPLzgvOwGnGHFSMw/E8pLRVR/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Chen Zhongjin <chenzhongjin@huawei.com>
Subject: [PATCH 5.10 70/99] ftrace: Fix invalid address access in lookup_rec() when index is 0
Date:   Mon, 20 Mar 2023 15:54:48 +0100
Message-Id: <20230320145446.324161318@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
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

From: Chen Zhongjin <chenzhongjin@huawei.com>

commit ee92fa443358f4fc0017c1d0d325c27b37802504 upstream.

KASAN reported follow problem:

 BUG: KASAN: use-after-free in lookup_rec
 Read of size 8 at addr ffff000199270ff0 by task modprobe
 CPU: 2 Comm: modprobe
 Call trace:
  kasan_report
  __asan_load8
  lookup_rec
  ftrace_location
  arch_check_ftrace_location
  check_kprobe_address_safe
  register_kprobe

When checking pg->records[pg->index - 1].ip in lookup_rec(), it can get a
pg which is newly added to ftrace_pages_start in ftrace_process_locs().
Before the first pg->index++, index is 0 and accessing pg->records[-1].ip
will cause this problem.

Don't check the ip when pg->index is 0.

Link: https://lore.kernel.org/linux-trace-kernel/20230309080230.36064-1-chenzhongjin@huawei.com

Cc: stable@vger.kernel.org
Fixes: 9644302e3315 ("ftrace: Speed up search by skipping pages by address")
Suggested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1538,7 +1538,8 @@ static struct dyn_ftrace *lookup_rec(uns
 	key.flags = end;	/* overload flags, as it is unsigned long */
 
 	for (pg = ftrace_pages_start; pg; pg = pg->next) {
-		if (end < pg->records[0].ip ||
+		if (pg->index == 0 ||
+		    end < pg->records[0].ip ||
 		    start >= (pg->records[pg->index - 1].ip + MCOUNT_INSN_SIZE))
 			continue;
 		rec = bsearch(&key, pg->records, pg->index,


