Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF96579A09
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238393AbiGSMKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238681AbiGSMJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:09:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1869350724;
        Tue, 19 Jul 2022 05:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F048B81B1A;
        Tue, 19 Jul 2022 12:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CE1C341C6;
        Tue, 19 Jul 2022 12:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232147;
        bh=lXblbA7GxQskJy4CPyQoy0xDyO1DhX55N+0uuLRgM04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rlQ5kYGiD4muP1Ikl2RPBw7ITdBfRrbKhg8RrU2yWIVQgwiOB5wRLTAjiFgjh80JF
         72TJ/W02sJxTUTapuCQvnXzoDiQByJ9Wgwi+s6AUCUhyurdIroq4Y5uTKDq+Hw6ieY
         8x0EV3fT21kukr47Z4V/oD3/Yls7RAGGsLqTsFy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Zheng Yejian <zhengyejian1@huawei.com>
Subject: [PATCH 5.4 07/71] tracing/histograms: Fix memory leak problem
Date:   Tue, 19 Jul 2022 13:53:30 +0200
Message-Id: <20220719114553.014705161@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
References: <20220719114552.477018590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yejian <zhengyejian1@huawei.com>

commit 7edc3945bdce9c39198a10d6129377a5c53559c2 upstream.

This reverts commit 46bbe5c671e06f070428b9be142cc4ee5cedebac.

As commit 46bbe5c671e0 ("tracing: fix double free") said, the
"double free" problem reported by clang static analyzer is:
  > In parse_var_defs() if there is a problem allocating
  > var_defs.expr, the earlier var_defs.name is freed.
  > This free is duplicated by free_var_defs() which frees
  > the rest of the list.

However, if there is a problem allocating N-th var_defs.expr:
  + in parse_var_defs(), the freed 'earlier var_defs.name' is
    actually the N-th var_defs.name;
  + then in free_var_defs(), the names from 0th to (N-1)-th are freed;

                        IF ALLOCATING PROBLEM HAPPENED HERE!!! -+
                                                                 \
                                                                  |
          0th           1th                 (N-1)-th      N-th    V
          +-------------+-------------+-----+-------------+-----------
var_defs: | name | expr | name | expr | ... | name | expr | name | ///
          +-------------+-------------+-----+-------------+-----------

These two frees don't act on same name, so there was no "double free"
problem before. Conversely, after that commit, we get a "memory leak"
problem because the above "N-th var_defs.name" is not freed.

If enable CONFIG_DEBUG_KMEMLEAK and inject a fault at where the N-th
var_defs.expr allocated, then execute on shell like:
  $ echo 'hist:key=call_site:val=$v1,$v2:v1=bytes_req,v2=bytes_alloc' > \
/sys/kernel/debug/tracing/events/kmem/kmalloc/trigger

Then kmemleak reports:
  unreferenced object 0xffff8fb100ef3518 (size 8):
    comm "bash", pid 196, jiffies 4295681690 (age 28.538s)
    hex dump (first 8 bytes):
      76 31 00 00 b1 8f ff ff                          v1......
    backtrace:
      [<0000000038fe4895>] kstrdup+0x2d/0x60
      [<00000000c99c049a>] event_hist_trigger_parse+0x206f/0x20e0
      [<00000000ae70d2cc>] trigger_process_regex+0xc0/0x110
      [<0000000066737a4c>] event_trigger_write+0x75/0xd0
      [<000000007341e40c>] vfs_write+0xbb/0x2a0
      [<0000000087fde4c2>] ksys_write+0x59/0xd0
      [<00000000581e9cdf>] do_syscall_64+0x3a/0x80
      [<00000000cf3b065c>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Link: https://lkml.kernel.org/r/20220711014731.69520-1-zhengyejian1@huawei.com

Cc: stable@vger.kernel.org
Fixes: 46bbe5c671e0 ("tracing: fix double free")
Reported-by: Hulk Robot <hulkci@huawei.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -4832,6 +4832,8 @@ static int parse_var_defs(struct hist_tr
 
 			s = kstrdup(field_str, GFP_KERNEL);
 			if (!s) {
+				kfree(hist_data->attrs->var_defs.name[n_vars]);
+				hist_data->attrs->var_defs.name[n_vars] = NULL;
 				ret = -ENOMEM;
 				goto free;
 			}


