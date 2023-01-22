Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAEA6676F41
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjAVPT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbjAVPTZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:19:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C6C21A36
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:19:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CDC960C48
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F551C433D2;
        Sun, 22 Jan 2023 15:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400763;
        bh=8ymtiD/WttM4af9U/UFTVDG5c91f5FOTuReGhFZh6+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uti5f6sEQftfOWLK6KkVjhonGu/jB2C1mGwEWhq5rGK9nwM05UguWwVEOknzcv/f4
         9LKUYfwKopqIHmhn9lXHUssImEsS6oXN2dHPnbm2BCxloF2GoA/2SJsaUI24ehS71H
         QgSOcIN5C5aWgsWoIlUfz4W9TmV09uGj4HJYDY3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Burn Alting <burn.alting@iinet.net.au>,
        Jiri Olsa <olsajiri@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Paul Moore <paul@paul-moore.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 070/117] bpf: restore the ebpf program ID for BPF_AUDIT_UNLOAD and PERF_BPF_EVENT_PROG_UNLOAD
Date:   Sun, 22 Jan 2023 16:04:20 +0100
Message-Id: <20230122150235.699429001@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

commit ef01f4e25c1760920e2c94f1c232350277ace69b upstream.

When changing the ebpf program put() routines to support being called
from within IRQ context the program ID was reset to zero prior to
calling the perf event and audit UNLOAD record generators, which
resulted in problems as the ebpf program ID was bogus (always zero).
This patch addresses this problem by removing an unnecessary call to
bpf_prog_free_id() in __bpf_prog_offload_destroy() and adjusting
__bpf_prog_put() to only call bpf_prog_free_id() after audit and perf
have finished their bpf program unload tasks in
bpf_prog_put_deferred().  For the record, no one can determine, or
remember, why it was necessary to free the program ID, and remove it
from the IDR, prior to executing bpf_prog_put_deferred();
regardless, both Stanislav and Alexei agree that the approach in this
patch should be safe.

It is worth noting that when moving the bpf_prog_free_id() call, the
do_idr_lock parameter was forced to true as the ebpf devs determined
this was the correct as the do_idr_lock should always be true.  The
do_idr_lock parameter will be removed in a follow-up patch, but it
was kept here to keep the patch small in an effort to ease any stable
backports.

I also modified the bpf_audit_prog() logic used to associate the
AUDIT_BPF record with other associated records, e.g. @ctx != NULL.
Instead of keying off the operation, it now keys off the execution
context, e.g. '!in_irg && !irqs_disabled()', which is much more
appropriate and should help better connect the UNLOAD operations with
the associated audit state (other audit records).

Cc: stable@vger.kernel.org
Fixes: d809e134be7a ("bpf: Prepare bpf_prog_put() to be called from irq context.")
Reported-by: Burn Alting <burn.alting@iinet.net.au>
Reported-by: Jiri Olsa <olsajiri@gmail.com>
Suggested-by: Stanislav Fomichev <sdf@google.com>
Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Acked-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20230106154400.74211-1-paul@paul-moore.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/offload.c |    3 ---
 kernel/bpf/syscall.c |    6 ++----
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -216,9 +216,6 @@ static void __bpf_prog_offload_destroy(s
 	if (offload->dev_state)
 		offload->offdev->ops->destroy(prog);
 
-	/* Make sure BPF_PROG_GET_NEXT_ID can't find this dead program */
-	bpf_prog_free_id(prog, true);
-
 	list_del_init(&offload->offloads);
 	kfree(offload);
 	prog->aux->offload = NULL;
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1695,7 +1695,7 @@ static void bpf_audit_prog(const struct
 		return;
 	if (audit_enabled == AUDIT_OFF)
 		return;
-	if (op == BPF_AUDIT_LOAD)
+	if (!in_irq() && !irqs_disabled())
 		ctx = audit_context();
 	ab = audit_log_start(ctx, GFP_ATOMIC, AUDIT_BPF);
 	if (unlikely(!ab))
@@ -1790,6 +1790,7 @@ static void bpf_prog_put_deferred(struct
 	prog = aux->prog;
 	perf_event_bpf_event(prog, PERF_BPF_EVENT_PROG_UNLOAD, 0);
 	bpf_audit_prog(prog, BPF_AUDIT_UNLOAD);
+	bpf_prog_free_id(prog, true);
 	__bpf_prog_put_noref(prog, true);
 }
 
@@ -1798,9 +1799,6 @@ static void __bpf_prog_put(struct bpf_pr
 	struct bpf_prog_aux *aux = prog->aux;
 
 	if (atomic64_dec_and_test(&aux->refcnt)) {
-		/* bpf_prog_free_id() must be called first */
-		bpf_prog_free_id(prog, do_idr_lock);
-
 		if (in_irq() || irqs_disabled()) {
 			INIT_WORK(&aux->work, bpf_prog_put_deferred);
 			schedule_work(&aux->work);


