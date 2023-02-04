Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDFDE68A7B1
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 02:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbjBDBxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 20:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjBDBxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 20:53:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75468C4;
        Fri,  3 Feb 2023 17:52:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0826462047;
        Sat,  4 Feb 2023 01:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5922BC433EF;
        Sat,  4 Feb 2023 01:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675475578;
        bh=jZPEzpMsNLkqXTbWV+cP2hzNkSJbFypcROIj/RM8maI=;
        h=Date:To:From:Subject:From;
        b=vbDnLX8Dk7p/MqYDjyIEiDHIfxKZJ4vKiwZTAWPsibrmOtE+5yBQAQgFyfIFWBpms
         ixJuprnS284pJtNsXF7FiKlReaYt9hAeM8x7GJxf3v2piz5aZ/slAyiptmVi78bCQl
         sMteiQbRLeaFh7564O/lMyPohQGbIl4yu32xTj5g=
Date:   Fri, 03 Feb 2023 17:52:57 -0800
To:     mm-commits@vger.kernel.org, xemul@parallels.com,
        viro@zeniv.linux.org.uk, stable@vger.kernel.org, jmoyer@redhat.com,
        jannh@google.com, bcrl@kvack.org, sethjenkins@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] aio-fix-mremap-after-fork-null-deref.patch removed from -mm tree
Message-Id: <20230204015258.5922BC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: aio: fix mremap after fork null-deref
has been removed from the -mm tree.  Its filename was
     aio-fix-mremap-after-fork-null-deref.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Seth Jenkins <sethjenkins@google.com>
Subject: aio: fix mremap after fork null-deref
Date: Tue, 31 Jan 2023 12:25:55 -0500

Commit e4a0d3e720e7 ("aio: Make it possible to remap aio ring") introduced
a null-deref if mremap is called on an old aio mapping after fork as
mm->ioctx_table will be set to NULL.

[jmoyer@redhat.com: fix 80 column issue]
Link: https://lkml.kernel.org/r/x49sffq4nvg.fsf@segfault.boston.devel.redhat.com
Fixes: e4a0d3e720e7 ("aio: Make it possible to remap aio ring")
Signed-off-by: Seth Jenkins <sethjenkins@google.com>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/aio.c~aio-fix-mremap-after-fork-null-deref
+++ a/fs/aio.c
@@ -361,6 +361,9 @@ static int aio_ring_mremap(struct vm_are
 	spin_lock(&mm->ioctx_lock);
 	rcu_read_lock();
 	table = rcu_dereference(mm->ioctx_table);
+	if (!table)
+		goto out_unlock;
+
 	for (i = 0; i < table->nr; i++) {
 		struct kioctx *ctx;
 
@@ -374,6 +377,7 @@ static int aio_ring_mremap(struct vm_are
 		}
 	}
 
+out_unlock:
 	rcu_read_unlock();
 	spin_unlock(&mm->ioctx_lock);
 	return res;
_

Patches currently in -mm which might be from sethjenkins@google.com are


