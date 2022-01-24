Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1430A49A9D3
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323705AbiAYD3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349192AbiAXVFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:05:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E51C068095;
        Mon, 24 Jan 2022 12:04:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47A4AB810BD;
        Mon, 24 Jan 2022 20:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B043C340E5;
        Mon, 24 Jan 2022 20:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054690;
        bh=wDexgYPxIcnur2R9Xoptda8AzH+1e7S/lnUXV2G5T8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8Gt+/5H+srMlqfDqVng6zkDZ3tegF1h5D7ng1+IKyXBfsv6dc64Gn6q8NRL5jQaq
         XolpjB5KicjxezAPUq0wGbQx/LLpfKH0lZiEoBvVo11ch+JfHnTC4JlGHe0/6ksye9
         kyIKVkhx+VHgZ5DqUrsfKBciSMR2fWIotY+0jQ08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>,
        syzbot+3b6f9218b1301ddda3e2@syzkaller.appspotmail.com
Subject: [PATCH 5.10 472/563] ext4: make sure to reset inode lockdep class when quota enabling fails
Date:   Mon, 24 Jan 2022 19:43:57 +0100
Message-Id: <20220124184040.797286521@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 4013d47a5307fdb5c13370b5392498b00fedd274 upstream.

When we succeed in enabling some quota type but fail to enable another
one with quota feature, we correctly disable all enabled quota types.
However we forget to reset i_data_sem lockdep class. When the inode gets
freed and reused, it will inherit this lockdep class (i_data_sem is
initialized only when a slab is created) and thus eventually lockdep
barfs about possible deadlocks.

Reported-and-tested-by: syzbot+3b6f9218b1301ddda3e2@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20211007155336.12493-3-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6427,8 +6427,19 @@ static int ext4_enable_quotas(struct sup
 					"Failed to enable quota tracking "
 					"(type=%d, err=%d). Please run "
 					"e2fsck to fix.", type, err);
-				for (type--; type >= 0; type--)
+				for (type--; type >= 0; type--) {
+					struct inode *inode;
+
+					inode = sb_dqopt(sb)->files[type];
+					if (inode)
+						inode = igrab(inode);
 					dquot_quota_off(sb, type);
+					if (inode) {
+						lockdep_set_quota_inode(inode,
+							I_DATA_SEM_NORMAL);
+						iput(inode);
+					}
+				}
 
 				return err;
 			}


