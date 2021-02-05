Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B63231143B
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhBEWCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:02:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232840AbhBEOyd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:54:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 139BF65048;
        Fri,  5 Feb 2021 14:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534324;
        bh=LL5abwxLlE5Zl9tvTdkf45Ng75eLP9spXen9DvmimIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtwdZiV8Ki4w3CtUneIam5Xb/ffdy8Z3Fy9/huDQfC0vakgqmb+SfuD24Vm8RA6c7
         /1xipsY8hKE+H7hf4a1JCV5YNcX5Y4aVjGPcEwfbOQrbPT2L81I9H0XPlFRQWSHZLz
         0lbeXH086gBsrET+uJL4j+M8s4mQUr5pn/erb0/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        ethanwu <ethanwu@synology.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 11/32] btrfs: backref, only search backref entries from leaves of the same root
Date:   Fri,  5 Feb 2021 15:07:26 +0100
Message-Id: <20210205140652.826044858@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ethanwu <ethanwu@synology.com>

commit cfc0eed0ec89db7c4a8d461174cabfaa4a0912c7 upstream.

We could have some nodes/leaves in subvolume whose owner are not the
that subvolume. In this way, when we resolve normal backrefs of that
subvolume, we should avoid collecting those references from these blocks.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: ethanwu <ethanwu@synology.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/backref.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -443,11 +443,14 @@ static int add_all_parents(struct btrfs_
 	 *    slot == nritems.
 	 * 2. We are searching for normal backref but bytenr of this leaf
 	 *    matches shared data backref
+	 * 3. The leaf owner is not equal to the root we are searching
+	 *
 	 * For these cases, go to the next leaf before we continue.
 	 */
 	eb = path->nodes[0];
 	if (path->slots[0] >= btrfs_header_nritems(eb) ||
-	    is_shared_data_backref(preftrees, eb->start)) {
+	    is_shared_data_backref(preftrees, eb->start) ||
+	    ref->root_id != btrfs_header_owner(eb)) {
 		if (time_seq == SEQ_LAST)
 			ret = btrfs_next_leaf(root, path);
 		else
@@ -466,9 +469,12 @@ static int add_all_parents(struct btrfs_
 
 		/*
 		 * We are searching for normal backref but bytenr of this leaf
-		 * matches shared data backref.
+		 * matches shared data backref, OR
+		 * the leaf owner is not equal to the root we are searching for
 		 */
-		if (slot == 0 && is_shared_data_backref(preftrees, eb->start)) {
+		if (slot == 0 &&
+		    (is_shared_data_backref(preftrees, eb->start) ||
+		     ref->root_id != btrfs_header_owner(eb))) {
 			if (time_seq == SEQ_LAST)
 				ret = btrfs_next_leaf(root, path);
 			else


