Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B641D24BC55
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgHTMoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:44:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729217AbgHTJpp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:45:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA2A922CF7;
        Thu, 20 Aug 2020 09:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916735;
        bh=huCiChlyQVRz46fCpLZMtoHb1q8AdA7xw0fOzvyU1vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1eHOYKEdIBlnsl/RxsJJWTFxHLBgFulWwT6kZWtZR7MKUbUyi7CwtZVFcaYjyWS/B
         uAstWPoP4WaGesCBuIBXOzp+lI+3l2+z+ItF2D5o0347VXUcYCPqhR6WZDyJlY6zNZ
         1dHBVHb/bQ/Xd0AN0/J0AbfB7gZHXDUIAmJcHZV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 028/152] btrfs: make sure SB_I_VERSION doesnt get unset by remount
Date:   Thu, 20 Aug 2020 11:19:55 +0200
Message-Id: <20200820091555.103552738@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
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
@@ -1852,6 +1852,12 @@ static int btrfs_remount(struct super_bl
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


