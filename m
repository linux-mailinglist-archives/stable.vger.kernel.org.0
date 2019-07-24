Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0CA873E6C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390080AbfGXTkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390076AbfGXTkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:40:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F422F217D4;
        Wed, 24 Jul 2019 19:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997245;
        bh=sJxehLS+fkKkpj9Yb9H6zpCA9UHzzXe2pzM8y9oENow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z7FViWDNiyqZD93lQxV1BL8F5oNanHMLgZEL0I/uIbFu5ucfAH1jGGM4THM10Ytqc
         /bcWKh3TfSBL8fMyd0+1Ks9WO7+FBai0ONnjoGzPWJiKjThAnoGm5qfY8I946P0CYZ
         MVw2ccUZKfivEam0wXjLw0fw2x0vwWSn9mliBKJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.2 370/413] Btrfs: add missing inode version, ctime and mtime updates when punching hole
Date:   Wed, 24 Jul 2019 21:21:01 +0200
Message-Id: <20190724191801.788096540@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 179006688a7e888cbff39577189f2e034786d06a upstream.

If the range for which we are punching a hole covers only part of a page,
we end up updating the inode item but we skip the update of the inode's
iversion, mtime and ctime. Fix that by ensuring we update those properties
of the inode.

A patch for fstests test case generic/059 that tests this as been sent
along with this fix.

Fixes: 2aaa66558172b0 ("Btrfs: add hole punching")
Fixes: e8c1c76e804b18 ("Btrfs: add missing inode update when punching hole")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/file.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2721,6 +2721,11 @@ out_only_mutex:
 		 * for detecting, at fsync time, if the inode isn't yet in the
 		 * log tree or it's there but not up to date.
 		 */
+		struct timespec64 now = current_time(inode);
+
+		inode_inc_iversion(inode);
+		inode->i_mtime = now;
+		inode->i_ctime = now;
 		trans = btrfs_start_transaction(root, 1);
 		if (IS_ERR(trans)) {
 			err = PTR_ERR(trans);


