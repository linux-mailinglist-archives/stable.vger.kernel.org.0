Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9772E3E5E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502231AbgL1O1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:27:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:35088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502213AbgL1O1O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:27:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA53C221F0;
        Mon, 28 Dec 2020 14:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165594;
        bh=IYo9dDO2K3mUSRTp/Lolj/l9f38TYl0dyTsQTsF9z04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yF576i30Edtmw6+ucAOA9c2NfcjvD58zJpcCeQPlWGhtav7ym0YGhLVJTQAnrcUU6
         fy66q7DBRbLY8x+apTO2Qm46oPSd1ZqjX/hHj1G0en1xFBcZUGRZ3AThgR2Krr2DCb
         9ygW/trp5mhSchQlrN8KNwJZrzqzAVj044a8Dyi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 587/717] btrfs: do not shorten unpin len for caching block groups
Date:   Mon, 28 Dec 2020 13:49:45 +0100
Message-Id: <20201228125049.038838478@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 9076dbd5ee837c3882fc42891c14cecd0354a849 upstream.

While fixing up our ->last_byte_to_unpin locking I noticed that we will
shorten len based on ->last_byte_to_unpin if we're caching when we're
adding back the free space.  This is correct for the free space, as we
cannot unpin more than ->last_byte_to_unpin, however we use len to
adjust the ->bytes_pinned counters and such, which need to track the
actual pinned usage.  This could result in
WARN_ON(space_info->bytes_pinned) triggering at unmount time.

Fix this by using a local variable for the amount to add to free space
cache, and leave len untouched in this case.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2816,10 +2816,10 @@ static int unpin_extent_range(struct btr
 		len = cache->start + cache->length - start;
 		len = min(len, end + 1 - start);
 
-		if (start < cache->last_byte_to_unpin) {
-			len = min(len, cache->last_byte_to_unpin - start);
-			if (return_free_space)
-				btrfs_add_free_space(cache, start, len);
+		if (start < cache->last_byte_to_unpin && return_free_space) {
+			u64 add_len = min(len, cache->last_byte_to_unpin - start);
+
+			btrfs_add_free_space(cache, start, add_len);
 		}
 
 		start += len;


