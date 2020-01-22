Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC41014561E
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730121AbgAVNU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:20:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:37414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbgAVNU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:20:56 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68B9F2468B;
        Wed, 22 Jan 2020 13:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699255;
        bh=Z5U8oa2rY/Qhnxybo2dbSelwKsx2b8hEe5G6JYAeth4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4Ndmqb6sfPL4zq2zIdRioeuPber4tf0/LVrjfO630KnR04vVovKqb1UdG2XK+pF0
         icNVP6ci3I4i9w6Z4xDZpzHeKB77hI0N+MqMAWgQhJk6ZKhKqDG6sb3BWH704uhG/y
         oy0CGT+LZ7+pR0BkF5Q/6CsRslb2fPSgVjKAcryA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Graham Cobb <g.btrfs@cobb.uk.net>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 089/222] Btrfs: always copy scrub arguments back to user space
Date:   Wed, 22 Jan 2020 10:27:55 +0100
Message-Id: <20200122092840.100648986@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 5afe6ce748c1ea99e0d648153c05075e1ab93afb upstream.

If scrub returns an error we are not copying back the scrub arguments
structure to user space. This prevents user space to know how much
progress scrub has done if an error happened - this includes -ECANCELED
which is returned when users ask for scrub to stop. A particular use
case, which is used in btrfs-progs, is to resume scrub after it is
canceled, in that case it relies on checking the progress from the scrub
arguments structure and then use that progress in a call to resume
scrub.

So fix this by always copying the scrub arguments structure to user
space, overwriting the value returned to user space with -EFAULT only if
copying the structure failed to let user space know that either that
copying did not happen, and therefore the structure is stale, or it
happened partially and the structure is probably not valid and corrupt
due to the partial copy.

Reported-by: Graham Cobb <g.btrfs@cobb.uk.net>
Link: https://lore.kernel.org/linux-btrfs/d0a97688-78be-08de-ca7d-bcb4c7fb397e@cobb.uk.net/
Fixes: 06fe39ab15a6a4 ("Btrfs: do not overwrite scrub error with fault error in scrub ioctl")
CC: stable@vger.kernel.org # 5.1+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Tested-by: Graham Cobb <g.btrfs@cobb.uk.net>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ioctl.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4254,7 +4254,19 @@ static long btrfs_ioctl_scrub(struct fil
 			      &sa->progress, sa->flags & BTRFS_SCRUB_READONLY,
 			      0);
 
-	if (ret == 0 && copy_to_user(arg, sa, sizeof(*sa)))
+	/*
+	 * Copy scrub args to user space even if btrfs_scrub_dev() returned an
+	 * error. This is important as it allows user space to know how much
+	 * progress scrub has done. For example, if scrub is canceled we get
+	 * -ECANCELED from btrfs_scrub_dev() and return that error back to user
+	 * space. Later user space can inspect the progress from the structure
+	 * btrfs_ioctl_scrub_args and resume scrub from where it left off
+	 * previously (btrfs-progs does this).
+	 * If we fail to copy the btrfs_ioctl_scrub_args structure to user space
+	 * then return -EFAULT to signal the structure was not copied or it may
+	 * be corrupt and unreliable due to a partial copy.
+	 */
+	if (copy_to_user(arg, sa, sizeof(*sa)))
 		ret = -EFAULT;
 
 	if (!(sa->flags & BTRFS_SCRUB_READONLY))


