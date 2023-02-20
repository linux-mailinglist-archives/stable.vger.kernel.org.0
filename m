Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4DC69CE5F
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbjBTN7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbjBTN7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:59:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4527A1EBFA
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:58:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BE86B80D4D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22DFC433EF;
        Mon, 20 Feb 2023 13:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901515;
        bh=LjnptQC/m9gst/345v1qhBUFZbG3h7rSVOpc8+YXL8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1lW+j4ZtjTReX7x+qdt6LnLrd+/uoxmPSLAbn4Gtd1FgzyUcfpq7N5Q69FoNrt3QV
         pjQ801kmVtEtMolZlMOWFuZSy9EGUipI6x5Jb+rzz8vKG26PpIl+UwYAdgJdiniS8P
         uEBrZ0ZhOrqOj3VV8fdYBYkF3/2iZiL/6p6sC4Vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Seth Jenkins <sethjenkins@google.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Jann Horn <jannh@google.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 047/118] aio: fix mremap after fork null-deref
Date:   Mon, 20 Feb 2023 14:36:03 +0100
Message-Id: <20230220133602.319103879@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seth Jenkins <sethjenkins@google.com>

commit 81e9d6f8647650a7bead74c5f926e29970e834d1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/aio.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/aio.c
+++ b/fs/aio.c
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


