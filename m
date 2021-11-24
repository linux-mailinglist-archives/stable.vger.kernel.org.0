Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB6B45BCFE
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343664AbhKXMeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:34:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244673AbhKXMc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:32:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F04F611C5;
        Wed, 24 Nov 2021 12:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756401;
        bh=ofFis8tbypFWQ+NVeEFdLnBQgIfNzMojlEJpiNDVXeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UBOybkZ2MszUT1mtKuC8jGIRrdFhUCMA2dGHFdgY9zS3qpDmsQYQa9ngfqfsLU9Ym
         46mkSl6kYgPyivDai7CKQd7VUo+Sh5gnSzqQbsZ2tK2pEokXGDJzNZo3Xv2K+f9a6R
         j315u5ybMvYjQdq+46WkluxLemA2aIhbSWz7yXxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 031/251] btrfs: fix lost error handling when replaying directory deletes
Date:   Wed, 24 Nov 2021 12:54:33 +0100
Message-Id: <20211124115711.321963280@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 10adb1152d957a4d570ad630f93a88bb961616c1 upstream.

At replay_dir_deletes(), if find_dir_range() returns an error we break out
of the main while loop and then assign a value of 0 (success) to the 'ret'
variable, resulting in completely ignoring that an error happened. Fix
that by jumping to the 'out' label when find_dir_range() returns an error
(negative value).

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2286,7 +2286,9 @@ again:
 		else {
 			ret = find_dir_range(log, path, dirid, key_type,
 					     &range_start, &range_end);
-			if (ret != 0)
+			if (ret < 0)
+				goto out;
+			else if (ret > 0)
 				break;
 		}
 


