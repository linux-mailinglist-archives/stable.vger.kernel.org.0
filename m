Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26FAE3AA17
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732454AbfFIQxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:53:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732469AbfFIQxq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:53:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB463205ED;
        Sun,  9 Jun 2019 16:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099225;
        bh=/WDg0odzFRg+uZtPg1a00/xxONvr3PqkxaGzqEVXKOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UKjbSWopvpuGUT6leWLCHAbcHRkANsZQNsYLPHiRV5ycZvZ21ksDEPkU8AiLJwh1p
         JkvCV9pRqSKNG5x+2vgvrPLJSfshYJYhO0s98HCeY4t8cyKgHTRoaOd++eZd6/Tt15
         Kc4gNM5QstBDKOVlZER8KtxNe0soV+PIGEw+yE9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Todd Kjos <tkjos@google.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.9 53/83] binder: replace "%p" with "%pK"
Date:   Sun,  9 Jun 2019 18:42:23 +0200
Message-Id: <20190609164132.460238457@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@android.com>

commit 8ca86f1639ec5890d400fff9211aca22d0a392eb upstream.

The format specifier "%p" can leak kernel addresses. Use
"%pK" instead. There were 4 remaining cases in binder.c.

Signed-off-by: Todd Kjos <tkjos@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1260,7 +1260,7 @@ static void binder_transaction_buffer_re
 	int debug_id = buffer->debug_id;
 
 	binder_debug(BINDER_DEBUG_TRANSACTION,
-		     "%d buffer release %d, size %zd-%zd, failed at %p\n",
+		     "%d buffer release %d, size %zd-%zd, failed at %pK\n",
 		     proc->pid, buffer->debug_id,
 		     buffer->data_size, buffer->offsets_size, failed_at);
 
@@ -2123,7 +2123,7 @@ static int binder_thread_write(struct bi
 				}
 			}
 			binder_debug(BINDER_DEBUG_DEAD_BINDER,
-				     "%d:%d BC_DEAD_BINDER_DONE %016llx found %p\n",
+				     "%d:%d BC_DEAD_BINDER_DONE %016llx found %pK\n",
 				     proc->pid, thread->pid, (u64)cookie,
 				     death);
 			if (death == NULL) {
@@ -3272,7 +3272,7 @@ static void print_binder_transaction(str
 				     struct binder_transaction *t)
 {
 	seq_printf(m,
-		   "%s %d: %p from %d:%d to %d:%d code %x flags %x pri %ld r%d",
+		   "%s %d: %pK from %d:%d to %d:%d code %x flags %x pri %ld r%d",
 		   prefix, t->debug_id, t,
 		   t->from ? t->from->proc->pid : 0,
 		   t->from ? t->from->pid : 0,
@@ -3286,7 +3286,7 @@ static void print_binder_transaction(str
 	if (t->buffer->target_node)
 		seq_printf(m, " node %d",
 			   t->buffer->target_node->debug_id);
-	seq_printf(m, " size %zd:%zd data %p\n",
+	seq_printf(m, " size %zd:%zd data %pK\n",
 		   t->buffer->data_size, t->buffer->offsets_size,
 		   t->buffer->data);
 }


