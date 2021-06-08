Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8013A0392
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236694AbhFHTSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:18:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235387AbhFHTQr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:16:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9955061971;
        Tue,  8 Jun 2021 18:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178277;
        bh=fF353kvFhF5368MD0sfDHQiDuuySqJWma/bpoi601r8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=05rFv65FFdjmNEU/vRzS5wrPPmX2MsFgWpL9Zof4oeK3PcXwuENAdUNPvlu81D13D
         LKoUqzBTqjuyreI4Kl/za9YiK1I2axQBh2pPaZ09x1gfUIQMQIkhL+2/GkAl1DhFSv
         mBnABbig5erqX+GT2WM6LmVk8j/55XwsQ+ECq3bA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.12 142/161] btrfs: return errors from btrfs_del_csums in cleanup_ref_head
Date:   Tue,  8 Jun 2021 20:27:52 +0200
Message-Id: <20210608175950.251151064@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 856bd270dc4db209c779ce1e9555c7641ffbc88e upstream.

We are unconditionally returning 0 in cleanup_ref_head, despite the fact
that btrfs_del_csums could fail.  We need to return the error so the
transaction gets aborted properly, fix this by returning ret from
btrfs_del_csums in cleanup_ref_head.

Reviewed-by: Qu Wenruo <wqu@suse.com>
CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1868,7 +1868,7 @@ static int cleanup_ref_head(struct btrfs
 	trace_run_delayed_ref_head(fs_info, head, 0);
 	btrfs_delayed_ref_unlock(head);
 	btrfs_put_delayed_ref_head(head);
-	return 0;
+	return ret;
 }
 
 static struct btrfs_delayed_ref_head *btrfs_obtain_ref_head(


