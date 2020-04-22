Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8EE1B41EF
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgDVK4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbgDVKGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:06:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 811512075A;
        Wed, 22 Apr 2020 10:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549960;
        bh=e66SOZrJj+tchAMkjoViTZCmh1xUJ9+TISSEaltwPyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQ5iCFGcSFb5JDKam5bNylZtFB3gyPGuo3U5CW1kVlBj4JxrPy+pwYvotk9gdrADb
         BcXbq6wmfaztBwbjmYJuHYA2kGBsBAxYcA6Ccm0SNwohY5Lo+Q2GVwUSyZHzW1q/Pl
         FuUyVjSAfDINFt8MTZEba9wSFTKD2Mh+ynglTZqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 077/125] btrfs: check commit root generation in should_ignore_root
Date:   Wed, 22 Apr 2020 11:56:34 +0200
Message-Id: <20200422095045.552660569@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 4d4225fc228e46948486d8b8207955f0c031b92e upstream.

Previously we would set the reloc root's last snapshot to transid - 1.
However there was a problem with doing this, and we changed it to
setting the last snapshot to the generation of the commit node of the fs
root.

This however broke should_ignore_root().  The assumption is that if we
are in a generation newer than when the reloc root was created, then we
would find the reloc root through normal backref lookups, and thus can
ignore any fs roots we find with an old enough reloc root.

Now that the last snapshot could be considerably further in the past
than before, we'd end up incorrectly ignoring an fs root.  Thus we'd
find no nodes for the bytenr we were searching for, and we'd fail to
relocate anything.  We'd loop through the relocate code again and see
that there were still used space in that block group, attempt to
relocate those bytenr's again, fail in the same way, and just loop like
this forever.  This is tricky in that we have to not modify the fs root
at all during this time, so we need to have a block group that has data
in this fs root that is not shared by any other root, which is why this
has been difficult to reproduce.

Fixes: 054570a1dc94 ("Btrfs: fix relocation incorrectly dropping data references")
CC: stable@vger.kernel.org # 4.9+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/relocation.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -537,8 +537,8 @@ static int should_ignore_root(struct btr
 	if (!reloc_root)
 		return 0;
 
-	if (btrfs_root_last_snapshot(&reloc_root->root_item) ==
-	    root->fs_info->running_transaction->transid - 1)
+	if (btrfs_header_generation(reloc_root->commit_root) ==
+	    root->fs_info->running_transaction->transid)
 		return 0;
 	/*
 	 * if there is reloc tree and it was created in previous


