Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3380D1AC322
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897735AbgDPNim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897704AbgDPNie (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:38:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49380221F4;
        Thu, 16 Apr 2020 13:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044313;
        bh=ZlFdhpBTO9U41EWXRCCid5BnZgyzC6sNTdyFY5aPz4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNchaN3QyuOQfCQ5Z9xgTGMb1neZ/KeyJ79IX/rzQ4MgeZHbSDTGH+0E/I0IiVxKG
         Talgwvxq3530NHK/mOH504TMajdSp9kXuwMKFBW6G1JQZk2PyO+aOtM5+V9b2YQr3/
         aDQy3NN9HRkjI+xS52qC7hJu1DD4O6Dr82KPS0ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.5 160/257] btrfs: reloc: clean dirty subvols if we fail to start a transaction
Date:   Thu, 16 Apr 2020 15:23:31 +0200
Message-Id: <20200416131346.581418690@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 6217b0fadd4473a16fabc6aecd7527a9f71af534 upstream.

If we do merge_reloc_roots() we could insert a few roots onto the dirty
subvol roots list, where we hold a ref on them.  If we fail to start the
transaction we need to run clean_dirty_subvols() in order to cleanup the
refs.

CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/relocation.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4221,10 +4221,10 @@ restart:
 		goto out_free;
 	}
 	btrfs_commit_transaction(trans);
+out_free:
 	ret = clean_dirty_subvols(rc);
 	if (ret < 0 && !err)
 		err = ret;
-out_free:
 	btrfs_free_block_rsv(fs_info, rc->block_rsv);
 	btrfs_free_path(path);
 	return err;
@@ -4622,10 +4622,10 @@ int btrfs_recover_relocation(struct btrf
 	trans = btrfs_join_transaction(rc->extent_root);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
-		goto out_free;
+		goto out_clean;
 	}
 	err = btrfs_commit_transaction(trans);
-
+out_clean:
 	ret = clean_dirty_subvols(rc);
 	if (ret < 0 && !err)
 		err = ret;


