Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6062F9E8A
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390782AbhARLmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:42:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:37346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390765AbhARLln (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0258223DB;
        Mon, 18 Jan 2021 11:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970063;
        bh=QF9KyWTlzPZlUEDOsKWiEx9GnmIsF7qWrKYJdL75d7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y15w0R266uoWkDxiRCDMe3y1rx/ueMb3fm7we4CHC0lKobXCC7slvLy9rdK8OI5Te
         /GgW2ThOTFMfyDNWcZHqFRVkLOWhtp41haQ8sJjh3JIPvsHFtc1klR0cL1tPREqWeD
         tld6niJEJQHPOFEeyok4KX4e2EQroNoFMhIXPW7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.10 021/152] ext4: fix wrong list_splice in ext4_fc_cleanup
Date:   Mon, 18 Jan 2021 12:33:16 +0100
Message-Id: <20210118113353.789656989@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daejun Park <daejun7.park@samsung.com>

commit 31e203e09f036f48e7c567c2d32df0196bbd303f upstream.

After full/fast commit, entries in staging queue are promoted to main
queue. In ext4_fs_cleanup function, it splice to staging queue to
staging queue.

Fixes: aa75f4d3daaeb ("ext4: main fast-commit commit path")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/20201230094851epcms2p6eeead8cc984379b37b2efd21af90fd1a@epcms2p6
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/fast_commit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1207,7 +1207,7 @@ static void ext4_fc_cleanup(journal_t *j
 	list_splice_init(&sbi->s_fc_dentry_q[FC_Q_STAGING],
 				&sbi->s_fc_dentry_q[FC_Q_MAIN]);
 	list_splice_init(&sbi->s_fc_q[FC_Q_STAGING],
-				&sbi->s_fc_q[FC_Q_STAGING]);
+				&sbi->s_fc_q[FC_Q_MAIN]);
 
 	ext4_clear_mount_flag(sb, EXT4_MF_FC_COMMITTING);
 	ext4_clear_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);


