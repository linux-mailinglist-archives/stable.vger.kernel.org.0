Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DC45AEB00
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238274AbiIFNuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239176AbiIFNtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:49:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273321DA60;
        Tue,  6 Sep 2022 06:39:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CFC68CE177D;
        Tue,  6 Sep 2022 13:38:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F190C433D6;
        Tue,  6 Sep 2022 13:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471494;
        bh=bOjPBm5qX5SICRTBurdgip+E5ccxw+hbLLzg/aua814=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1gQ1j1++CJGLV59fg489cgx2w6VXMH9F/0cE9aCuofeXEGequxqrFYZE0kslauRE
         C4m+TSLxhc6LLCLeISWHQqIATz70IaYTGPvK96T+Vifc3HS6S8SsRmQdssjpVbAOOB
         6tmqd1UBFUlUfz3F6QH4pndBe+u27glQ5/BP+UK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Carlos Llamas <cmllamas@google.com>, stable <stable@kernel.org>
Subject: [PATCH 5.15 046/107] binder: fix UAF of ref->proc caused by race condition
Date:   Tue,  6 Sep 2022 15:30:27 +0200
Message-Id: <20220906132823.783217015@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carlos Llamas <cmllamas@google.com>

commit a0e44c64b6061dda7e00b7c458e4523e2331b739 upstream.

A transaction of type BINDER_TYPE_WEAK_HANDLE can fail to increment the
reference for a node. In this case, the target proc normally releases
the failed reference upon close as expected. However, if the target is
dying in parallel the call will race with binder_deferred_release(), so
the target could have released all of its references by now leaving the
cleanup of the new failed reference unhandled.

The transaction then ends and the target proc gets released making the
ref->proc now a dangling pointer. Later on, ref->node is closed and we
attempt to take spin_lock(&ref->proc->inner_lock), which leads to the
use-after-free bug reported below. Let's fix this by cleaning up the
failed reference on the spot instead of relying on the target to do so.

  ==================================================================
  BUG: KASAN: use-after-free in _raw_spin_lock+0xa8/0x150
  Write of size 4 at addr ffff5ca207094238 by task kworker/1:0/590

  CPU: 1 PID: 590 Comm: kworker/1:0 Not tainted 5.19.0-rc8 #10
  Hardware name: linux,dummy-virt (DT)
  Workqueue: events binder_deferred_func
  Call trace:
   dump_backtrace.part.0+0x1d0/0x1e0
   show_stack+0x18/0x70
   dump_stack_lvl+0x68/0x84
   print_report+0x2e4/0x61c
   kasan_report+0xa4/0x110
   kasan_check_range+0xfc/0x1a4
   __kasan_check_write+0x3c/0x50
   _raw_spin_lock+0xa8/0x150
   binder_deferred_func+0x5e0/0x9b0
   process_one_work+0x38c/0x5f0
   worker_thread+0x9c/0x694
   kthread+0x188/0x190
   ret_from_fork+0x10/0x20

Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Cc: stable <stable@kernel.org> # 4.14+
Link: https://lore.kernel.org/r/20220801182511.3371447-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1358,6 +1358,18 @@ static int binder_inc_ref_for_node(struc
 	}
 	ret = binder_inc_ref_olocked(ref, strong, target_list);
 	*rdata = ref->data;
+	if (ret && ref == new_ref) {
+		/*
+		 * Cleanup the failed reference here as the target
+		 * could now be dead and have already released its
+		 * references by now. Calling on the new reference
+		 * with strong=0 and a tmp_refs will not decrement
+		 * the node. The new_ref gets kfree'd below.
+		 */
+		binder_cleanup_ref_olocked(new_ref);
+		ref = NULL;
+	}
+
 	binder_proc_unlock(proc);
 	if (new_ref && ref != new_ref)
 		/*


