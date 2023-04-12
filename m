Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A4B6DEFB5
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbjDLIxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbjDLIxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:53:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D9993CB
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:52:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 419896317C
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58747C433EF;
        Wed, 12 Apr 2023 08:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289506;
        bh=X3v1Du2kXgEipHjKRqV75GcJkfM8lK6TZ4VZvLt08uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxtsD+Vpe/ITV8R1WF+CHmi8yC7ii2D2A/f+vKEOvzH8xqMbBPFqkuSMOt0TumVPC
         dlvhEkDmfe3Y+IDTE7Uy7tcZBhJvYo5uot2ZWcafe+TOHAaGXJ7j+KajHNy2Gr8hkD
         ilsCBUL2p/q9auVbmn1fUUOc+xf4hU0TFoxZeb9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+b08ebcc22f8f3e6be43a@syzkaller.appspotmail.com,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 086/173] nilfs2: fix potential UAF of struct nilfs_sc_info in nilfs_segctor_thread()
Date:   Wed, 12 Apr 2023 10:33:32 +0200
Message-Id: <20230412082841.526806213@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
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
@@ -2607,11 +2607,10 @@ static int nilfs_segctor_thread(void *ar
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
 


