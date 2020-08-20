Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6A624BFC1
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbgHTNxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:53:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727062AbgHTJZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:25:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A91822CF6;
        Thu, 20 Aug 2020 09:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915508;
        bh=kNgCBFBfSxz7ugVSsubOOTo6lfh4ohoZlx1eQ7qlYBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q9fGYYNjwmjnGTY7df4M3URxXX6UbpaCYWMcVuKR0hwHuTlK3ZOuFPUglK66hie8k
         j66eFbe5REQ0pAmyLmapApju9LcGN8ErX8tKgbGOsoVFq5HXom2jk6kO4GRLvaeNyq
         jg+QQ1y4ySG2H54RCC1cK+QbCEcJJ1xPJdZg3PW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.8 039/232] btrfs: make sure SB_I_VERSION doesnt get unset by remount
Date:   Thu, 20 Aug 2020 11:18:10 +0200
Message-Id: <20200820091614.669649341@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit faa008899a4db21a2df99833cb4ff6fa67009a20 upstream.

There's some inconsistency around SB_I_VERSION handling with mount and
remount.  Since we don't really want it to be off ever just work around
this by making sure we don't get the flag cleared on remount.

There's a tiny cpu cost of setting the bit, otherwise all changes to
i_version also change some of the times (ctime/mtime) so the inode needs
to be synced. We wouldn't save anything by disabling it.

Reported-by: Eric Sandeen <sandeen@redhat.com>
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add perf impact analysis ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/super.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1897,6 +1897,12 @@ static int btrfs_remount(struct super_bl
 		set_bit(BTRFS_FS_OPEN, &fs_info->flags);
 	}
 out:
+	/*
+	 * We need to set SB_I_VERSION here otherwise it'll get cleared by VFS,
+	 * since the absence of the flag means it can be toggled off by remount.
+	 */
+	*flags |= SB_I_VERSION;
+
 	wake_up_process(fs_info->transaction_kthread);
 	btrfs_remount_cleanup(fs_info, old_opts);
 	return 0;


