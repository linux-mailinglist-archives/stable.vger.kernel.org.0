Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B1F4521D8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352146AbhKPBHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:07:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245362AbhKOTUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EDD96345D;
        Mon, 15 Nov 2021 18:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001189;
        bh=IX7Mb4frK77nNjSxhNq8vL9MZWZSpqf1C4gwDF0pY9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NnABPzUmtOs4kbxXGZ0lrmMEC7NcQjO6kjh+a3Zu2xkOG8FyGd0trU9MRiVyt/CeN
         C48a838iFtUJ/ZAFkiOoZZ0yQ2qUwFrV7BspcxAL4uaZqPpx64WwoEfO0ZDmmrKKyf
         Hc693vLJmPbM1A7HciC8FK/ofqdXo7OQRoqzMx8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 062/917] btrfs: fix lost error handling when replaying directory deletes
Date:   Mon, 15 Nov 2021 17:52:37 +0100
Message-Id: <20211115165430.868228105@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
@@ -2500,7 +2500,9 @@ again:
 		else {
 			ret = find_dir_range(log, path, dirid, key_type,
 					     &range_start, &range_end);
-			if (ret != 0)
+			if (ret < 0)
+				goto out;
+			else if (ret > 0)
 				break;
 		}
 


