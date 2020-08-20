Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0752D24B43F
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgHTKAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730475AbgHTKAf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:00:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B51920738;
        Thu, 20 Aug 2020 10:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917634;
        bh=DLL6QqiiFobXwMuulqKeu7vODSOep5OUkAO2XKz51y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EkAMTClO7zp4bTq6BedpY0YQQTMt30sSV7egMxysO1HxyJ4Q98AcUO+SPC3Avj7u+
         a35JruZfkT7QNQDDHyOfFPDsbJA871Z6KoSjmlirEbov2iGGwYr+0Vh3Hvvpk9g6fF
         9QaSP57UcAVrB12F32+IT3U/srbwjFzby93lLVUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Todd Kjos <tkjos@google.com>,
        Jann Horn <jannh@google.com>, Martijn Coenen <maco@android.com>
Subject: [PATCH 4.9 071/212] binder: Prevent context manager from incrementing ref 0
Date:   Thu, 20 Aug 2020 11:20:44 +0200
Message-Id: <20200820091605.949394523@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 4b836a1426cb0f1ef2a6e211d7e553221594f8fc upstream.

Binder is designed such that a binder_proc never has references to
itself. If this rule is violated, memory corruption can occur when a
process sends a transaction to itself; see e.g.
<https://syzkaller.appspot.com/bug?extid=09e05aba06723a94d43d>.

There is a remaining edgecase through which such a transaction-to-self
can still occur from the context of a task with BINDER_SET_CONTEXT_MGR
access:

 - task A opens /dev/binder twice, creating binder_proc instances P1
   and P2
 - P1 becomes context manager
 - P2 calls ACQUIRE on the magic handle 0, allocating index 0 in its
   handle table
 - P1 dies (by closing the /dev/binder fd and waiting a bit)
 - P2 becomes context manager
 - P2 calls ACQUIRE on the magic handle 0, allocating index 1 in its
   handle table
   [this triggers a warning: "binder: 1974:1974 tried to acquire
   reference to desc 0, got 1 instead"]
 - task B opens /dev/binder once, creating binder_proc instance P3
 - P3 calls P2 (via magic handle 0) with (void*)1 as argument (two-way
   transaction)
 - P2 receives the handle and uses it to call P3 (two-way transaction)
 - P3 calls P2 (via magic handle 0) (two-way transaction)
 - P2 calls P2 (via handle 1) (two-way transaction)

And then, if P2 does *NOT* accept the incoming transaction work, but
instead closes the binder fd, we get a crash.

Solve it by preventing the context manager from using ACQUIRE on ref 0.
There shouldn't be any legitimate reason for the context manager to do
that.

Additionally, print a warning if someone manages to find another way to
trigger a transaction-to-self bug in the future.

Cc: stable@vger.kernel.org
Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
Acked-by: Todd Kjos <tkjos@google.com>
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Martijn Coenen <maco@android.com>
Link: https://lore.kernel.org/r/20200727120424.1627555-1-jannh@google.com
[manual backport: remove fine-grained locking and error reporting that
                  don't exist in <=4.9]
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/android/binder.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1427,6 +1427,10 @@ static void binder_transaction(struct bi
 			return_error = BR_DEAD_REPLY;
 			goto err_dead_binder;
 		}
+		if (WARN_ON(proc == target_proc)) {
+			return_error = BR_FAILED_REPLY;
+			goto err_invalid_target_handle;
+		}
 		if (security_binder_transaction(proc->tsk,
 						target_proc->tsk) < 0) {
 			return_error = BR_FAILED_REPLY;
@@ -1830,6 +1834,11 @@ static int binder_thread_write(struct bi
 			ptr += sizeof(uint32_t);
 			if (target == 0 && binder_context_mgr_node &&
 			    (cmd == BC_INCREFS || cmd == BC_ACQUIRE)) {
+				if (binder_context_mgr_node->proc == proc) {
+					binder_user_error("%d:%d context manager tried to acquire desc 0\n",
+							  proc->pid, thread->pid);
+					return -EINVAL;
+				}
 				ref = binder_get_ref_for_node(proc,
 					       binder_context_mgr_node);
 				if (ref->desc != target) {


