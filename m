Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A389272C68
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgIUQcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728316AbgIUQcD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:32:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4697E20757;
        Mon, 21 Sep 2020 16:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600705922;
        bh=IzsgTk2a0yzPVRGmFj4voj4B2GLluXvUHK4Yna+JArA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUoNlqZFMbs4Vlausk5l54IVKQwW1Lvn4astHTb6HxS8g6dvl06+/mQrKClviYIE/
         iJyAfQiaODDLxU3q1g6xL4IKgALwZUCFCKboBMVc0ZluB+FnVSNYbG6c8s2yMUe34B
         dWGOFLJjpsHmumomUzQu6PrFsvlmKlgUac6yyibM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, A L <mail@lechevalier.se>,
        Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.4 17/46] btrfs: fix wrong address when faulting in pages in the search ioctl
Date:   Mon, 21 Sep 2020 18:27:33 +0200
Message-Id: <20200921162034.130067558@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162033.346434578@linuxfoundation.org>
References: <20200921162033.346434578@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 1c78544eaa4660096aeb6a57ec82b42cdb3bfe5a upstream.

When faulting in the pages for the user supplied buffer for the search
ioctl, we are passing only the base address of the buffer to the function
fault_in_pages_writeable(). This means that after the first iteration of
the while loop that searches for leaves, when we have a non-zero offset,
stored in 'sk_offset', we try to fault in a wrong page range.

So fix this by adding the offset in 'sk_offset' to the base address of the
user supplied buffer when calling fault_in_pages_writeable().

Several users have reported that the applications compsize and bees have
started to operate incorrectly since commit a48b73eca4ceb9 ("btrfs: fix
potential deadlock in the search ioctl") was added to stable trees, and
these applications make heavy use of the search ioctls. This fixes their
issues.

Link: https://lore.kernel.org/linux-btrfs/632b888d-a3c3-b085-cdf5-f9bb61017d92@lechevalier.se/
Link: https://github.com/kilobyte/compsize/issues/34
Fixes: a48b73eca4ceb9 ("btrfs: fix potential deadlock in the search ioctl")
CC: stable@vger.kernel.org # 4.4+
Tested-by: A L <mail@lechevalier.se>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2129,7 +2129,8 @@ static noinline int search_ioctl(struct
 	key.offset = sk->min_offset;
 
 	while (1) {
-		ret = fault_in_pages_writeable(ubuf, *buf_size - sk_offset);
+		ret = fault_in_pages_writeable(ubuf + sk_offset,
+					       *buf_size - sk_offset);
 		if (ret)
 			break;
 


