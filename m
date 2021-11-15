Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A87450AD0
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236818AbhKOROz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:14:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236842AbhKORNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:13:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A890463243;
        Mon, 15 Nov 2021 17:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996227;
        bh=020s5IKOjZ+wxqrefLLexJY1JlketZFI0AtkhLIqvaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OtNyRbwnOrlIvJi8VBQaN+hkwpqZl0TWjQHPZS9GT1R+stFTEDxzbVbOvtraEM6ei
         Kpy0T1zGEFaHPh4iY9acuQEF2kayvmUoQZV2Ik4ZnwozZOuJn+vo4sZpk/RBAflBJt
         Lke3W83Q4CxPVbP5xpJW68+3OOwGsauY6HcK+lH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 061/355] btrfs: fix lost error handling when replaying directory deletes
Date:   Mon, 15 Nov 2021 17:59:45 +0100
Message-Id: <20211115165315.782196099@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
@@ -2490,7 +2490,9 @@ again:
 		else {
 			ret = find_dir_range(log, path, dirid, key_type,
 					     &range_start, &range_end);
-			if (ret != 0)
+			if (ret < 0)
+				goto out;
+			else if (ret > 0)
 				break;
 		}
 


