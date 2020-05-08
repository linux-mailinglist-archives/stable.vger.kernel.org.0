Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8626D1CAB1C
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgEHMj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:39:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbgEHMj4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96C0920731;
        Fri,  8 May 2020 12:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941596;
        bh=mxL4GtE1sRQmhqzBUuaGbL7A8/BDaEG/9CkUMtYn2cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=taPTNvj/0Vs8T11dt7FDMN9TLrukK4sRNQSy9Vh6/qaIWfgWCNH5cRVAA5SCVhX96
         NwwTZ6CmXNukdhnFSeVW1CQtNuMosWSQq4xBqj3KsOv/ZJdVI8d4NBy71AKMTAsAt7
         XnxnxYkMJ0vhhzL6K2t6WAAFpA/mAY9ZkKkaKfu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.4 094/312] btrfs: cleaner_kthread() doesnt need explicit freeze
Date:   Fri,  8 May 2020 14:31:25 +0200
Message-Id: <20200508123131.146903503@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

commit 838fe1887765f4cc679febea60d87d2a06bd300e upstream.

cleaner_kthread() is not marked freezable, and therefore calling
try_to_freeze() in its context is a pointless no-op.

In addition to that, as has been clearly demonstrated by 80ad623edd2d
("Revert "btrfs: clear PF_NOFREEZE in cleaner_kthread()"), it's perfectly
valid / legal for cleaner_kthread() to stay scheduled out in an arbitrary
place during suspend (in that particular example that was waiting for
reading of extent pages), so there is no need to leave any traces of
freezer in this kthread.

Fixes: 80ad623edd2d ("Revert "btrfs: clear PF_NOFREEZE in cleaner_kthread()")
Fixes: 696249132158 ("btrfs: clear PF_NOFREEZE in cleaner_kthread()")
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/disk-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1750,7 +1750,7 @@ static int cleaner_kthread(void *arg)
 		 */
 		btrfs_delete_unused_bgs(root->fs_info);
 sleep:
-		if (!try_to_freeze() && !again) {
+		if (!again) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (!kthread_should_stop())
 				schedule();


