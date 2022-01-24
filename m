Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0463D498E5D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346588AbiAXTku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:40:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59098 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345772AbiAXTiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:38:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD7FEB81215;
        Mon, 24 Jan 2022 19:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F416CC340E5;
        Mon, 24 Jan 2022 19:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053079;
        bh=xn5CIkjOdhzi0YaD3ET90nmLIPGwL+NI53JbBeeAdXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSSSPDOL8FymrBxVmc4QmIShf6VPzBMqI1zSMRBh7+9mT3E88SiLHwcygqKK/14zO
         NLV3p54TF/8WT6Nzf5QiyWmRuLORZ5ISUjlKIicq7uUKq4M0Qu0GOyrwXIyjLhU0+c
         05cxxAES99iy8wNsgdMIIBe6A1tyXlrXB8L3Jsp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>,
        syzbot+3b6f9218b1301ddda3e2@syzkaller.appspotmail.com
Subject: [PATCH 5.4 268/320] ext4: make sure to reset inode lockdep class when quota enabling fails
Date:   Mon, 24 Jan 2022 19:44:12 +0100
Message-Id: <20220124184003.098755253@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
@@ -5998,8 +5998,19 @@ static int ext4_enable_quotas(struct sup
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


