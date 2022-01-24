Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA5149A595
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371030AbiAYAGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2360379AbiAXXgk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:36:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921E9C0ADFD7;
        Mon, 24 Jan 2022 13:37:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BF4DB81188;
        Mon, 24 Jan 2022 21:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9303BC340E4;
        Mon, 24 Jan 2022 21:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060256;
        bh=0/1uQfnW40fQCtD/TrAwPiBVSZy/dooJp7W8kuvZi2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LTnhflvFVp5yUNAwUtJ3hmckzTjRuISdfT5/DOiE13nJy+R+uwzGcJRWJ4gGE8pKE
         SMsiLa92k4SgUD+FDrefAq9r7ozvSlGdqY9z0Ji5Zqny2SE0EcknGNG37gcpgMs/eH
         AdLZoeiNrKC2P6YKArIshDXXdxz3jEnzJ+yeuJGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>,
        syzbot+3b6f9218b1301ddda3e2@syzkaller.appspotmail.com
Subject: [PATCH 5.16 0889/1039] ext4: make sure to reset inode lockdep class when quota enabling fails
Date:   Mon, 24 Jan 2022 19:44:38 +0100
Message-Id: <20220124184155.174086253@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -6361,8 +6361,19 @@ int ext4_enable_quotas(struct super_bloc
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


