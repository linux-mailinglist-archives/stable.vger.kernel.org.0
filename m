Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83FFC6E618D
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjDRMZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbjDRMZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:25:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E72465BF
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:25:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DFAC63138
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56427C433D2;
        Tue, 18 Apr 2023 12:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820714;
        bh=qF+wvf3RMFVXybSK2SYLuf3gG4TGOEXnjTL7cDZtxjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nEaBkWR/amyTRroiBbz6IxtnfIJIQdeSuFL/InewPtiP94BWHZ2HXtGuNPwtAqpWj
         zTZgNYgq5zOV0ZDHBQ1+Qm29iEA7T1I4rMXZHWAmucCaTm2d5bdc+qZ4z1ocHHA46z
         XDV7zNC/sD/14mcbTCA1OTm/ERuQQqOFikNjmLLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+b08ebcc22f8f3e6be43a@syzkaller.appspotmail.com,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.14 11/37] nilfs2: fix potential UAF of struct nilfs_sc_info in nilfs_segctor_thread()
Date:   Tue, 18 Apr 2023 14:21:21 +0200
Message-Id: <20230418120255.069072515@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120254.687480980@linuxfoundation.org>
References: <20230418120254.687480980@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 6be49d100c22ffea3287a4b19d7639d259888e33 upstream.

The finalization of nilfs_segctor_thread() can race with
nilfs_segctor_kill_thread() which terminates that thread, potentially
causing a use-after-free BUG as KASAN detected.

At the end of nilfs_segctor_thread(), it assigns NULL to "sc_task" member
of "struct nilfs_sc_info" to indicate the thread has finished, and then
notifies nilfs_segctor_kill_thread() of this using waitqueue
"sc_wait_task" on the struct nilfs_sc_info.

However, here, immediately after the NULL assignment to "sc_task", it is
possible that nilfs_segctor_kill_thread() will detect it and return to
continue the deallocation, freeing the nilfs_sc_info structure before the
thread does the notification.

This fixes the issue by protecting the NULL assignment to "sc_task" and
its notification, with spinlock "sc_state_lock" of the struct
nilfs_sc_info.  Since nilfs_segctor_kill_thread() does a final check to
see if "sc_task" is NULL with "sc_state_lock" locked, this can eliminate
the race.

Link: https://lkml.kernel.org/r/20230327175318.8060-1-konishi.ryusuke@gmail.com
Reported-by: syzbot+b08ebcc22f8f3e6be43a@syzkaller.appspotmail.com
Link: https://lkml.kernel.org/r/00000000000000660d05f7dfa877@google.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/segment.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2623,11 +2623,10 @@ static int nilfs_segctor_thread(void *ar
 	goto loop;
 
  end_thread:
-	spin_unlock(&sci->sc_state_lock);
-
 	/* end sync. */
 	sci->sc_task = NULL;
 	wake_up(&sci->sc_wait_task); /* for nilfs_segctor_kill_thread() */
+	spin_unlock(&sci->sc_state_lock);
 	return 0;
 }
 


