Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9770732914C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243272AbhCAUXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:23:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:43790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242828AbhCAUQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:16:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1313653D8;
        Mon,  1 Mar 2021 18:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621761;
        bh=oP/TEkQjJlQW5YtBKQPtIzGa1Ly4p9XAKGyA8+DsPgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hyL0ePIcDy85ZnX+UxQgdADxof7DPBgKjeGTn4L4BarwfFYmjloyZlQK2BPU2pzzi
         2g8tvqJVTkxfkwqcFFGLWwNlScq9Z5oWAG899W76380vSh4WMOOrJWrAxfFOgLyF4j
         0wISec3Ik8VwaQGX9Mst+sXNcBOOVNq6XqL7Tbts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.11 635/775] btrfs: do not warn if we cant find the reloc root when looking up backref
Date:   Mon,  1 Mar 2021 17:13:23 +0100
Message-Id: <20210301161232.772477939@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit f78743fbdae1bb31bc9c9233c3590a5048782381 upstream.

The backref code is looking for a reloc_root that corresponds to the
given fs root.  However any number of things could have gone wrong while
initializing that reloc_root, like ENOMEM while trying to allocate the
root itself, or EIO while trying to write the root item.  This would
result in no corresponding reloc_root being in the reloc root cache, and
thus would return NULL when we do the find_reloc_root() call.

Because of this we do not want to WARN_ON().  This presumably was meant
to catch developer errors, cases where we messed up adding the reloc
root.  However we can easily hit this case with error injection, and
thus should not do a WARN_ON().

CC: stable@vger.kernel.org # 5.10+
Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/backref.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2617,7 +2617,7 @@ static int handle_direct_tree_backref(st
 		/* Only reloc backref cache cares about a specific root */
 		if (cache->is_reloc) {
 			root = find_reloc_root(cache->fs_info, cur->bytenr);
-			if (WARN_ON(!root))
+			if (!root)
 				return -ENOENT;
 			cur->root = root;
 		} else {


