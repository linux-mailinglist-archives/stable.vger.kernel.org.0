Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E160622E55
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 15:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbiKIOtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 09:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbiKIOtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 09:49:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CABB1C10B
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 06:49:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BB9F61AA9
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 14:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3B4C433C1;
        Wed,  9 Nov 2022 14:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668005343;
        bh=wTUAKlTQa3n4ie4SNGxTrQEkGFFEnmGoUC7BteTRmUw=;
        h=Subject:To:From:Date:From;
        b=MNbVHkLOl2dKxDRMcUbl+iG3x2Tcgq8V2MpsWWEfPOaJ9FsHyxN8E1OTaQWV6rvot
         Q6puQlK+zC4q4Bj5yii7ypmxMz7ecdCacWe8jN2gV+OsaIEEE2n48TXVKDhcMbKndk
         DDSqKdUA6+nXGmRq3Dt61o5O4J8AwzE9MuWYjFlA=
Subject: patch "binder: validate alloc->mm in ->mmap() handler" added to char-misc-linus
To:     cmllamas@google.com, gregkh@linuxfoundation.org, jannh@google.com,
        stable@vger.kernel.org, tkjos@google.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Nov 2022 15:49:00 +0100
Message-ID: <166800534023179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    binder: validate alloc->mm in ->mmap() handler

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3ce00bb7e91cf57d723905371507af57182c37ef Mon Sep 17 00:00:00 2001
From: Carlos Llamas <cmllamas@google.com>
Date: Fri, 4 Nov 2022 23:12:35 +0000
Subject: binder: validate alloc->mm in ->mmap() handler

Since commit 1da52815d5f1 ("binder: fix alloc->vma_vm_mm null-ptr
dereference") binder caches a pointer to the current->mm during open().
This fixes a null-ptr dereference reported by syzkaller. Unfortunately,
it also opens the door for a process to update its mm after the open(),
(e.g. via execve) making the cached alloc->mm pointer invalid.

Things get worse when the process continues to mmap() a vma. From this
point forward, binder will attempt to find this vma using an obsolete
alloc->mm reference. Such as in binder_update_page_range(), where the
wrong vma is obtained via vma_lookup(), yet binder proceeds to happily
insert new pages into it.

To avoid this issue fail the ->mmap() callback if we detect a mismatch
between the vma->vm_mm and the original alloc->mm pointer. This prevents
alloc->vm_addr from getting set, so that any subsequent vma_lookup()
calls fail as expected.

Fixes: 1da52815d5f1 ("binder: fix alloc->vma_vm_mm null-ptr dereference")
Reported-by: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org> # 5.15+
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Acked-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20221104231235.348958-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 1c39cfce32fa..4ad42b0f75cd 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -739,6 +739,12 @@ int binder_alloc_mmap_handler(struct binder_alloc *alloc,
 	const char *failure_string;
 	struct binder_buffer *buffer;
 
+	if (unlikely(vma->vm_mm != alloc->mm)) {
+		ret = -EINVAL;
+		failure_string = "invalid vma->vm_mm";
+		goto err_invalid_mm;
+	}
+
 	mutex_lock(&binder_alloc_mmap_lock);
 	if (alloc->buffer_size) {
 		ret = -EBUSY;
@@ -785,6 +791,7 @@ int binder_alloc_mmap_handler(struct binder_alloc *alloc,
 	alloc->buffer_size = 0;
 err_already_mapped:
 	mutex_unlock(&binder_alloc_mmap_lock);
+err_invalid_mm:
 	binder_alloc_debug(BINDER_DEBUG_USER_ERROR,
 			   "%s: %d %lx-%lx %s failed %d\n", __func__,
 			   alloc->pid, vma->vm_start, vma->vm_end,
-- 
2.38.1


