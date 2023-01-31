Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BB7683A36
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 00:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjAaXGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 18:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjAaXGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 18:06:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E472946727;
        Tue, 31 Jan 2023 15:06:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F42D6173D;
        Tue, 31 Jan 2023 23:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98A2C433D2;
        Tue, 31 Jan 2023 23:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675206404;
        bh=xv0QVceRR/ZYreqhO38LCdq8D4iCdsXU2lOGetLMRjE=;
        h=Date:To:From:Subject:From;
        b=YDItXoaQkFoOvwnhx6fnaR70fvhEoWcEAbW4z+ngE9f4buKJgcbnal8y1henOJ5FE
         guExHFvAPHAxiAXZCiIdWD+JQjU8uIhizg+JUiKzMP68vC3BX6gQ5LaAFDRdvYa8cU
         VO9WD3w/ezWe2DkJomEnJgWtZYv0u9ixEe2g1ZOM=
Date:   Tue, 31 Jan 2023 15:06:44 -0800
To:     mm-commits@vger.kernel.org, xemul@parallels.com,
        viro@zeniv.linux.org.uk, stable@vger.kernel.org, jmoyer@redhat.com,
        jannh@google.com, bcrl@kvack.org, sethjenkins@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + aio-fix-mremap-after-fork-null-deref.patch added to mm-hotfixes-unstable branch
Message-Id: <20230131230644.D98A2C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: aio: fix mremap after fork null-deref
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     aio-fix-mremap-after-fork-null-deref.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/aio-fix-mremap-after-fork-null-deref.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

 fs/aio.c |    4 ++++
 1 file changed, 4 insertions(+)

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

aio-fix-mremap-after-fork-null-deref.patch

