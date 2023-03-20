Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA7E6C19D2
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbjCTPio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbjCTPiV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:38:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFFE1E1E1
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:29:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 82D23CE12C5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3A2C433D2;
        Mon, 20 Mar 2023 15:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326183;
        bh=2H03kPlgVZ9UReKwuHr8cdjhGt7MIJ9YvOECSJbxdBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OK92DCjU5DJpBxBACugRN2XPeEXiXvA8hGQ9sw6VneeFrQ/RRkUaATRVpma03KN0P
         XJDcIc1vebQV0HlvNz49qqc1BxtgqKr0OsptmBDIaW7XCHGV2bCXxldaWhwMF8z9h7
         uU2R83Z/KuMMPlymvnTrKVAW5k2f1WHkrtkzf/P0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tero Kristo <tero.kristo@linux.intel.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.2 191/211] trace/hwlat: Do not wipe the contents of per-cpu thread data
Date:   Mon, 20 Mar 2023 15:55:26 +0100
Message-Id: <20230320145521.516810984@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tero Kristo <tero.kristo@linux.intel.com>

commit 4c42f5f0d1dd20bddd9f940beb1e6ccad60c4498 upstream.

Do not wipe the contents of the per-cpu kthread data when starting the
tracer, as this will completely forget about already running instances
and can later start new additional per-cpu threads.

Link: https://lore.kernel.org/all/20230302113654.2984709-1-tero.kristo@linux.intel.com/
Link: https://lkml.kernel.org/r/20230310100451.3948583-2-tero.kristo@linux.intel.com

Cc: stable@vger.kernel.org
Fixes: f46b16520a087 ("trace/hwlat: Implement the per-cpu mode")
Signed-off-by: Tero Kristo <tero.kristo@linux.intel.com>
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_hwlat.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -584,9 +584,6 @@ static int start_per_cpu_kthreads(struct
 	 */
 	cpumask_and(current_mask, cpu_online_mask, tr->tracing_cpumask);
 
-	for_each_online_cpu(cpu)
-		per_cpu(hwlat_per_cpu_data, cpu).kthread = NULL;
-
 	for_each_cpu(cpu, current_mask) {
 		retval = start_cpu_kthread(cpu);
 		if (retval)


