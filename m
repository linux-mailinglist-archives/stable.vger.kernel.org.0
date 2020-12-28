Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DBA2E3BF7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406659AbgL1N4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:56:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:58402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406637AbgL1N4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:56:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DA6620738;
        Mon, 28 Dec 2020 13:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163766;
        bh=j11AyNQYEBqi4t1kMqMzYg69n55eu3OiggZVou1LABU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U58wk77H26dBov8fnyhau9r8JagFFI8ZUlz1ebejkaybfak0ECH1Ksei/MqWoe9Hj
         +sZ8/vhSQuDCc7L1Rb9wfKhlH0yMvq0V6odctud9tbwMbsnPkTVVVrMVNgPPNoTxJ6
         B3bL+kNP64U3+nm/QmpT1t405fP0K4DBA8TXYhnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 372/453] btrfs: do not shorten unpin len for caching block groups
Date:   Mon, 28 Dec 2020 13:50:08 +0100
Message-Id: <20201228124955.105183249@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
@@ -2838,10 +2838,10 @@ static int unpin_extent_range(struct btr
 		len = cache->key.objectid + cache->key.offset - start;
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


