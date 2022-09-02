Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B6D5AB0A2
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238252AbiIBMze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238279AbiIBMyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:54:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D83F995D;
        Fri,  2 Sep 2022 05:38:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E41C362211;
        Fri,  2 Sep 2022 12:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7240C433D6;
        Fri,  2 Sep 2022 12:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122277;
        bh=MSnkjPP/MYSfeJHpJPpx1Hxgi4ylFwUpQBUk8PBVVwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZs3ZK4tt5XHv76UEkywjCgAG4eMJHOhGGPnnpXouOkg5Uu5Oj/casmNbIuskZYM+
         eR0IT0C95xkV5VmBkmNwpdpnJaOALpPGWZeT2XCP8TK+NS3ysOwQ+gbTJG+ZiWaEWQ
         AVPlGWAjiJqCrurmpxS6b/V8NpWw0naU/p6vYoEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        syzbot+da54fa8d793ca89c741f@syzkaller.appspotmail.com,
        Todd Kjos <tkjos@google.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Hridya Valsaraju <hridya@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Martijn Coenen <maco@android.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 69/72] android: binder: fix lockdep check on clearing vma
Date:   Fri,  2 Sep 2022 14:19:45 +0200
Message-Id: <20220902121407.062516874@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
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

From: Liam Howlett <liam.howlett@oracle.com>

commit b0cab80ecd54ae3b2356bb081af0bffd538c8265 upstream.

When munmapping a vma, the mmap_lock can be degraded to a write before
calling close() on the file handle.  The binder close() function calls
binder_alloc_set_vma() to clear the vma address, which now has a lock dep
check for writing on the mmap_lock.  Change the lockdep check to ensure
the reading lock is held while clearing and keep the write check while
writing.

Link: https://lkml.kernel.org/r/20220627151857.2316964-1-Liam.Howlett@oracle.com
Fixes: 472a68df605b ("android: binder: stop saving a pointer to the VMA")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: syzbot+da54fa8d793ca89c741f@syzkaller.appspotmail.com
Acked-by: Todd Kjos <tkjos@google.com>
Cc: "Arve Hjønnevåg" <arve@android.com>
Cc: Christian Brauner (Microsoft) <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hridya Valsaraju <hridya@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Martijn Coenen <maco@android.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -315,12 +315,19 @@ static inline void binder_alloc_set_vma(
 {
 	unsigned long vm_start = 0;
 
+	/*
+	 * Allow clearing the vma with holding just the read lock to allow
+	 * munmapping downgrade of the write lock before freeing and closing the
+	 * file using binder_alloc_vma_close().
+	 */
 	if (vma) {
 		vm_start = vma->vm_start;
 		alloc->vma_vm_mm = vma->vm_mm;
+		mmap_assert_write_locked(alloc->vma_vm_mm);
+	} else {
+		mmap_assert_locked(alloc->vma_vm_mm);
 	}
 
-	mmap_assert_write_locked(alloc->vma_vm_mm);
 	alloc->vma_addr = vm_start;
 }
 


